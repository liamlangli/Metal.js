import { Float3 } from "../math/simd";
import { CIE_2_DEG_COLOR_MATCHING_FUNCTIONS, IRRADIANCE_TEXTURE_HEIGHT, IRRADIANCE_TEXTURE_WIDTH, MAX_LUMINOUS_EFFICACY, SCATTERING_TEXTURE_MU_SIZE, SCATTERING_TEXTURE_MU_S_SIZE, SCATTERING_TEXTURE_NU_SIZE, SCATTERING_TEXTURE_R_SIZE, TRANSMITTANCE_TEXTURE_HEIGHT, TRANSMITTANCE_TEXTURE_WIDTH, XYZ_TO_SRGB } from "./constants";
import { definitions_shader } from "./definitions";
import { functions_shader } from "./functions";

const kLambdaR = 680;
const kLambdaG = 550;
const kLambdaB = 440;

const kLambdaMin = 360;
const kLambdaMax = 830;

class DensityProfileLayer {
    width: number;
    exp_term: number;
    exp_scale: number;
    linear_term: number;
    constant_term: number;

    constructor(
        width?: number,
        exp_term?: number,
        exp_scale?: number,
        linear_term?: number,
        constant_term?: number)
    {
        this.width = width ?? 0;
        this.exp_term = exp_term ?? 0;
        this.exp_scale = exp_scale ?? 0;
        this.linear_term = linear_term ?? 0;
        this.constant_term = constant_term ?? 0;
    }
}

export class Model {
    num_precomputed_wavelengths: number = 0;
    combine_scattering_textures: boolean = true;
    half_precision: boolean = false;
    rgb_format_supported: boolean = true;

    transmittance_texture_: GPUTexture
    scattering_texture_: GPUTexture;
    optional_single_mie_scattering_texture_: GPUTexture;
    irradiance_texture_: GPUTexture;

    constructor(
        wavelengths: number [],
        solar_irradiance: number [],
    
        sun_angular_radius: number,
        bottom_radius: number,
        top_radius: number,
    
        rayleigh_density: DensityProfileLayer[],
        rayleigh_scattering: number[],
    
        mie_density: DensityProfileLayer[],
        mie_scattering: number[],
        mie_extinction: number[],
    
        mie_phase_function_g: number,
    
        absorption_density: DensityProfileLayer[],
        absorption_extinction: number[],
        ground_albedo: number[],
    
        max_sun_zenith_angle: number,
        length_unit_in_meters: number,
    
        num_precomputed_wavelengths: number,
        combine_scattering_textures: boolean,
        half_precision: boolean,
    ) {
        this.num_precomputed_wavelengths = num_precomputed_wavelengths;
        this.half_precision = half_precision;

        function to_string(v: number[], lambdas: Float3, scale: number) {
            const r = interpolate(wavelengths, v, lambdas.elements[0]) * scale;
            const g = interpolate(wavelengths, v, lambdas.elements[1]) * scale;
            const b = interpolate(wavelengths, v, lambdas.elements[2]) * scale;
            return `float3(${r}, ${g}, ${b})`
        }

        function density_layer(layer: DensityProfileLayer) {
            return "DensityProfileLayer(" +
                `${layer.width / length_unit_in_meters},` +
                `${layer.exp_term},` +
                `${layer.exp_scale * length_unit_in_meters},`+
                `${layer.linear_term * length_unit_in_meters},` +
                `${layer.constant_term})`;
        }

        function density_profile(layers: DensityProfileLayer[]) {
            const layer_count = 2;
            while (layers.length < layer_count) {
                layers.push(new DensityProfileLayer());
            }
            let result = `DensityProfile(DensityProfileLayer[${layer_count}](`;
            for (let i = 0; i < layer_count; ++i) {
                result += density_layer(layers[i]);
                result += i < layer_count - 1 ? "," : "))";
            }
            return result;
        }

        const precompute_illuminance = num_precomputed_wavelengths > 3;
        // let sky_k_r, sky_k_g, sky_k_b;
        let sky_k = new Float3();
        if (precompute_illuminance) {
            sky_k.set(MAX_LUMINOUS_EFFICACY, MAX_LUMINOUS_EFFICACY, MAX_LUMINOUS_EFFICACY);
        } else {
            ComputeSpectralRadianceToLuminanceFactors(wavelengths, solar_irradiance, -3, sky_k);
        }

        let sun_k = new Float3();
        ComputeSpectralRadianceToLuminanceFactors(wavelengths, solar_irradiance, 0, sun_k)

        function shader_header_factory(lambdas: Float3) {
            return  "#define IN(x) const in x\n" +
                    "#define OUT(x) out x\n" +
                    "#define TEMPLATE(x)\n" +
                    "#define TEMPLATE_ARGUMENT(x)\n" +
                    "#define assert(x)\n"+
                    "const int TRANSMITTANCE_TEXTURE_WIDTH = " +
                    `${TRANSMITTANCE_TEXTURE_WIDTH}\n` +
                    "const int TRANSMITTANCE_TEXTURE_HEIGHT = " +
                    `${TRANSMITTANCE_TEXTURE_HEIGHT}\n` +
                    "const int SCATTERING_TEXTURE_R_SIZE = " +
                    `${SCATTERING_TEXTURE_R_SIZE}\n` +
                    "const int SCATTERING_TEXTURE_MU_SIZE = " +
                    `${SCATTERING_TEXTURE_MU_SIZE}\n` +
                    "const int SCATTERING_TEXTURE_MU_S_SIZE = " +
                    `${SCATTERING_TEXTURE_MU_S_SIZE}\n` +
                    "const int SCATTERING_TEXTURE_NU_SIZE = " +
                    `${SCATTERING_TEXTURE_NU_SIZE}\n` +
                    "const int IRRADIANCE_TEXTURE_WIDTH = " +
                    `${IRRADIANCE_TEXTURE_WIDTH}\n` +
                    "const int IRRADIANCE_TEXTURE_HEIGHT = " +
                    `${IRRADIANCE_TEXTURE_HEIGHT}\n` +
                    (combine_scattering_textures ? "#define COMBINED_SCATTERING_TEXTURES\n" : "") +
                    definitions_shader +
                    "const AtmosphereParameters ATMOSPHERE = AtmosphereParameters(\n" +
                    to_string(solar_irradiance, lambdas, 1.0) + ",\n" +
                    `${sun_angular_radius}\n`+
                    `${bottom_radius / length_unit_in_meters }\n` +
                    `${top_radius / length_unit_in_meters}\n` +
                    density_profile(rayleigh_density) + ",\n" +
                    to_string(
                        rayleigh_scattering, lambdas, length_unit_in_meters) + ",\n" +
                    density_profile(mie_density) + ",\n" +
                    to_string(mie_scattering, lambdas, length_unit_in_meters) + ",\n" +
                    to_string(mie_extinction, lambdas, length_unit_in_meters) + ",\n" +
                    `${mie_phase_function_g}\n` +
                    density_profile(absorption_density) + ",\n" +
                    to_string(
                        absorption_extinction, lambdas, length_unit_in_meters) + ",\n" +
                    to_string(ground_albedo, lambdas, 1.0) + ",\n" +
                    `${Math.cos(max_sun_zenith_angle)}\n` +
                    "const vec3 SKY_SPECTRAL_RADIANCE_TO_LUMINANCE = float3(" +
                        `${sky_k.x}` + "," +
                        `${sky_k.y}` + "," +
                        `${sky_k.z}` + ");\n" +
                    "const vec3 SUN_SPECTRAL_RADIANCE_TO_LUMINANCE = float3(" +
                        `${sun_k.x}` + "," +
                        `${sun_k.y}` + "," +
                        `${sun_k.z}` + ");\n" +
                    functions_shader;
        }
    }
}

function interpolate(wavelengths: number[], wavelength_function: number[], wavelength: number): number {
    if (wavelength < wavelengths[0]) {
        return wavelength_function[0]
    }

    for (let i = 0, l = wavelengths.length - 1;i < l; ++i) {
        if (wavelength < wavelengths[i + 1]) {
            const u = (wavelength - wavelengths[i]) / (wavelengths[i + 1] - wavelengths[i]);
            return wavelength_function[i] * (1 - u) + wavelength_function[i + 1] * u;
        }
    }
    return wavelength_function[wavelength_function.length - 1];
}

function CieColorMatchingFunctionTableValue(wavelength: number, column: number): number {
    if (wavelength <= kLambdaMin || wavelength >= kLambdaMax) {
        return 0.;
    }

    let u = (wavelength - kLambdaMin) / 5;
    const row = Math.floor(u);

    u -= row;
    return CIE_2_DEG_COLOR_MATCHING_FUNCTIONS[4 * row + column] * (1 - u) + 
        CIE_2_DEG_COLOR_MATCHING_FUNCTIONS[4 * (row + 1) + column] * u;
}

function ComputeSpectralRadianceToLuminanceFactors(
    wavelengths: number[],
    solar_irradiance: number[],
    lambda_power: number,
    k: Float3): void
{
    k.set(0, 0, 0);
    const solar_r = interpolate(wavelengths, solar_irradiance, kLambdaR);
    const solar_g = interpolate(wavelengths, solar_irradiance, kLambdaG);
    const solar_b = interpolate(wavelengths, solar_irradiance, kLambdaB);

    let dlambda = 1;
    for (let lambda = kLambdaMin; lambda < kLambdaMax; lambda += dlambda) {
        const x_bar = CieColorMatchingFunctionTableValue(lambda, 1);
        const y_bar = CieColorMatchingFunctionTableValue(lambda, 2);
        const z_bar = CieColorMatchingFunctionTableValue(lambda, 3);

        const r_bar = XYZ_TO_SRGB[0] * x_bar + XYZ_TO_SRGB[1] * y_bar + XYZ_TO_SRGB[2] * z_bar;
        const g_bar = XYZ_TO_SRGB[3] * x_bar + XYZ_TO_SRGB[4] * y_bar + XYZ_TO_SRGB[5] * z_bar;
        const b_bar = XYZ_TO_SRGB[6] * x_bar + XYZ_TO_SRGB[7] * y_bar + XYZ_TO_SRGB[8] * z_bar;

        const irradiance = interpolate(wavelengths, solar_irradiance, lambda);
        k.x += r_bar * irradiance / solar_r * Math.pow(lambda / kLambdaR, lambda_power);
        k.y += g_bar * irradiance / solar_g * Math.pow(lambda / kLambdaG, lambda_power);
        k.z += b_bar * irradiance / solar_b * Math.pow(lambda / kLambdaB, lambda_power);
    }

    k.x *= MAX_LUMINOUS_EFFICACY * dlambda;
    k.y *= MAX_LUMINOUS_EFFICACY * dlambda;
    k.z *= MAX_LUMINOUS_EFFICACY * dlambda;
}
