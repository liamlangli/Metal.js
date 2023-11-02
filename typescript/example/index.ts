
import { Back, BackBuffer, CounterClockwise, DepthStencilState, LessEqual, MetalScriptDevice, RenderPipelineState, ResourceStorageModeShared, Triangle } from "../src";

const shader_source: string = `
#include <metal_stdlib>
#include <simd/simd.h>

typedef struct
{
    float4 position [[position]];
} VertexOut;

vertex VertexOut base_vert(
    uint vertex_id [[vertex_id]],
    constant simd_float4 *in [[buffer(0)]])
{
    VertexOut out;
    out.position = float4(in[vertex_id].xyz, 1.0);
    return out;
}

fragment float4 base_frag(VertexOut in [[stage_in]])
{
    return float4(0.3, 0.4, 0.5, 1.0);
}
`
function main() {
    const device = metal_create_device() as MetalScriptDevice;
    const library = device.create_library_from_source(shader_source)!;
    const buffer = device.create_buffer(48, ResourceStorageModeShared)
    const data = new Float32Array([
        0.5, -0.5, 0, 0,
        0, 0.5, 0, 0,
        -0.5, -0.5, 0, 0,
    ]);
    buffer.upload(data);

    let pipeline_state: RenderPipelineState;
    let depth_stencil_state: DepthStencilState;

    function tick(time: number, back_buffer: BackBuffer) {
        // print(time)
        const command_buffer = back_buffer.command_buffer;
        const desc = back_buffer.render_pass_descriptor;
        const encoder = command_buffer.create_render_command_encoder(desc);

        if (!pipeline_state) {
            const pipeline_desc = device.create_render_pipeline_descriptor();
            pipeline_desc.vertex_function = library.create_function('base_vert');
            pipeline_desc.fragment_function = library.create_function('base_frag');
            pipeline_desc.color_attachment_at(0).pixel_format = back_buffer.color_pixel_format;
            pipeline_desc.depth_attachment_pixel_format = back_buffer.depth_stencil_pixel_format;
            pipeline_desc.stencil_attachment_pixel_format = back_buffer.depth_stencil_pixel_format;
            pipeline_state = device.create_render_pipeline_state(pipeline_desc)!;
        }

        if (!depth_stencil_state) {
            const depth_stencil_desc = device.create_depth_stencil_descriptor();
            depth_stencil_desc.depth_write = true;
            depth_stencil_desc.compare_function = LessEqual;
            depth_stencil_state = device.create_depth_stencil_state(depth_stencil_desc)!;
        }

        // push debug scope
        encoder.push_debug_group("render triangle");

        encoder.set_cull_mode(Back);
        encoder.set_front_facing(CounterClockwise);
        encoder.set_render_pipeline_state(pipeline_state);
        encoder.set_depth_stencil_state(depth_stencil_state);

        encoder.set_vertex_buffer(buffer, 0, 0);
        encoder.draw_primitive(Triangle, 0, 3);

        encoder.pop_debug_group();
        encoder.end_encoding();

        command_buffer.present(back_buffer.drawable);
        command_buffer.commit();
    }
    metal_request_swapchain_callback(tick);
}

main();

