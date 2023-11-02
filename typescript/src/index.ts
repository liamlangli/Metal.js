// typescript
type TypedArray =
Uint8ClampedArray |
Uint8Array |
Int8Array |
Uint16Array |
Int16Array |
Uint32Array |
Int32Array |
Float32Array |
Float64Array |
BigInt64Array;

export interface Color {
    r: number;
    g: number;
    b: number;
    a: number;
}

// metal
export interface StorageMode {}
export const Shared: StorageMode = 0;
export const Managed: StorageMode = 1;
export const Private: StorageMode = 2;
export const Memoryless: StorageMode = 3;

export interface CPUCacheMode {}
export const DefaultCacheMode: CPUCacheMode = 0;
export const WriteCombined: CPUCacheMode = 1;

export interface HazardTrackingMode {}
export const DefaultHazardTrackingMode : HazardTrackingMode = 0;
export const Untracked: HazardTrackingMode = 1;
export const Tracked: HazardTrackingMode = 2;

export const ResourceCPUCacheModeShift = 0;
export const ResourceStorageModeShift = 4;
export const ResourceHazardTrackingModeShift = 8;

export interface ResourceOption {}
export const ResourceStorageModeShared: ResourceOption = (Shared as number) << ResourceStorageModeShift;
export const ResourceStorageModeManaged: ResourceOption = (Managed as number) << ResourceStorageModeShift;
export const ResourceStorageModePrivate: ResourceOption = (Private as number) << ResourceStorageModeShift;
export const ResourceStorageModeMemoryLess: ResourceOption = (Memoryless as number) << ResourceStorageModeShift;

export const ResourceTrackingModeDefault: ResourceOption = (DefaultHazardTrackingMode as number) << ResourceHazardTrackingModeShift;
export const ResourceTrackingModeUntracked: ResourceOption = (Untracked as number) << ResourceHazardTrackingModeShift;
export const ResourceTrackingModeTracked: ResourceOption = (Tracked as number) << ResourceHazardTrackingModeShift;

export const ResourceCPUCacheModeDefault: ResourceOption = (DefaultCacheMode as number) << ResourceCPUCacheModeShift;
export const ResourceCPUCacheModeWriteCombined: ResourceOption = (WriteCombined as number) << ResourceCPUCacheModeShift;

export interface TextureType {}
export const Texture1D: TextureType = 0;
export const Texture1DArray: TextureType = 1;
export const Texture2D: TextureType = 2;
export const Texture2DArray: TextureType = 3;
export const Texture2DMultisample: TextureType = 4;
export const TextureCube: TextureType = 5;
export const TextureCubeArray: TextureType = 6;
export const Texture3D: TextureType = 7;
export const Texture2DMultisampleArray: TextureType = 8;
export const TextureBuffer: TextureType = 9;

export interface TextureUsage {}
export const Unknown: TextureUsage = 0;
export const ShaderRead: TextureUsage = 1;
export const ShaderWrite: TextureUsage = 2;
export const ShaderTarget: TextureUsage = 4;
export const PixelFormatView: TextureUsage = 8;

export interface PixelFormat {}
export const A8Unorm: PixelFormat = 1;
export const R8Unorm: PixelFormat = 10;
export const R8Unorm_sRGB: PixelFormat = 11;
export const R8Snorm: PixelFormat = 12;
export const R8Uint: PixelFormat = 13;
export const R8Sint: PixelFormat = 14;
export const R16Unorm: PixelFormat = 20;
export const R16Snorm: PixelFormat = 22;
export const R16Uint: PixelFormat = 23;
export const R16SInt: PixelFormat = 24;
export const R16Float: PixelFormat = 25;
export const RG8Unorm: PixelFormat = 30;
export const RG8Unorm_sRGB: PixelFormat = 31;
export const RG8Snorm: PixelFormat = 32;
export const RG8Uint: PixelFormat = 33;
export const RG8Sint: PixelFormat = 34;

export const B5G6R5Unorm: PixelFormat = 40;
export const A1BGR5Unorm: PixelFormat = 41;
export const ABGR4Unorm: PixelFormat = 42;
export const BGR5A1Unorm: PixelFormat = 43;

export const R32Uint: PixelFormat = 53;
export const R32Sint: PixelFormat = 54;
export const R32Float: PixelFormat = 55;
export const RG16Unorm: PixelFormat = 60;
export const RG16Snorm: PixelFormat = 62;
export const RG16Uint: PixelFormat = 63;
export const RG16SInt: PixelFormat = 64;
export const RG16Float: PixelFormat = 65;

export const RGBA8Unorm: PixelFormat = 70;
export const RGBA8Unorm_sRGB: PixelFormat = 71;
export const RGBA8Snorm: PixelFormat = 72;
export const RGBA8Uint: PixelFormat = 73;
export const RGBA8Sint: PixelFormat = 74;
export const BGRA8Unorm: PixelFormat = 80;
export const BGRA8Unorm_sRGB: PixelFormat = 81;

export const RGB10A2Unorm: PixelFormat = 90;
export const RGB10A2Uint: PixelFormat = 91;

export const RG11B10Float: PixelFormat = 92;
export const RGB9E5Float: PixelFormat = 93;
export const BGR10A2Unorm: PixelFormat = 94;

export const RG32Uint: PixelFormat = 103;
export const RG32Sint: PixelFormat = 104;
export const RG32Float: PixelFormat = 105;

export const RGBA16Unorm: PixelFormat = 110;
export const RGBA16Snorm: PixelFormat = 112;
export const RGBA16Uint: PixelFormat = 113;
export const RGBA16Sint: PixelFormat = 114;
export const RGBA16Float: PixelFormat = 115;

export const BGR10_XR: PixelFormat = 554;
export const RGB10_XR_sRGB: PixelFormat = 555;

export const RGBA32Uint: PixelFormat = 123;
export const RGBA32Sint: PixelFormat = 124;
export const RGBA32Float: PixelFormat = 125;

// depth format
export interface DepthStencilFormat extends PixelFormat {}
export const Depth16Unorm: DepthStencilFormat = 250;
export const Depth32Float: DepthStencilFormat = 252;
export const Stencil8: DepthStencilFormat = 253;
export const Depth32Float_Stencil8: DepthStencilFormat = 260;
export const X32_Stencil8: DepthStencilFormat = 260;

// TODO: compressed format export

export interface DepthCompareFunction {}
export const Never: DepthCompareFunction = 0;
export const Less: DepthCompareFunction = 1;
export const Equal: DepthCompareFunction = 2;
export const LessEqual: DepthCompareFunction = 3;
export const Greater: DepthCompareFunction = 4;
export const NotEqual: DepthCompareFunction = 5;
export const GreaterEqual: DepthCompareFunction = 6;
export const Always: DepthCompareFunction = 7;

export interface CullMode {}
export const NoneCull: CullMode = 0;
export const Front: CullMode = 1;
export const Back: CullMode = 2;

export interface Winding {}
export const Clockwise: Winding = 0;
export const CounterClockwise: Winding = 1;

export interface DepthClipMode {}
export const DepthClip: DepthClipMode = 0;
export const DepthClamp: DepthClipMode = 1;

export interface PrimitiveType {}
export const Point: PrimitiveType = 0;
export const Line: PrimitiveType = 1;
export const LineStrip: PrimitiveType = 2;
export const Triangle: PrimitiveType = 3;
export const TriangleStripe: PrimitiveType = 4;

export interface IndexType {}
export const Uint16Index: IndexType = 0;
export const Uint32Index: IndexType = 1;

export interface LoadAction {}
export interface StoreAction {}
export const DontCare: LoadAction & StoreAction = 0;
export const Load: LoadAction = 1;
export const Clear: LoadAction = 2;
export const Store: StoreAction = 1;
export const MultisampleResolve: StoreAction = 2;
export const StoreAndMultisampleResolve: StoreAction = 3;
export const StoreUnknown: StoreAction = 4;
export const CustomSampleDepthStore: StoreAction = 5;

export interface BlendFactor {}
export const Zero: BlendFactor = 0;
export const One: BlendFactor = 1;

export const SrcColor: BlendFactor = 2;
export const OneMinusSrcColor: BlendFactor = 3;
export const SrcAlpha: BlendFactor = 4;
export const OneMinusSrcAlpha: BlendFactor = 5;

export const DstColor: BlendFactor = 6;
export const OneMinusDstColor: BlendFactor = 7;
export const DstAlpha: BlendFactor = 8;
export const OneMinusDstAlpha: BlendFactor = 9;

export const SrcAlphaSaturated: BlendFactor = 10;

export const BlendColor: BlendFactor = 11;
export const OneMinusBlendColor: BlendFactor = 12;
export const BlendAlpha: BlendFactor = 13;
export const OneMinusBlendAlpha: BlendFactor = 14;

export interface BlendOperation {}
export const Add: BlendOperation = 0;
export const Subtract: BlendOperation = 1;
export const ReverseSubtract: BlendOperation = 2;
export const Min: BlendOperation = 3;
export const Max: BlendOperation = 4;

export interface DispatchType {}
export const Serial: DispatchType = 0;
export const Concurrent: DispatchType = 1;

export interface RenderCommandEncoder {
    label: string;

    set_viewport(x: number, y: number, width: number, height: number, near: number, far: number): void;
    set_cull_mode(mode: CullMode): void;
    set_depth_clip_mode(mode: DepthClipMode): void;
    set_front_facing(facing: Winding): void;
    set_render_pipeline_state(pipeline_state: RenderPipelineState): void;
    set_depth_stencil_state(depth_stencil_state: DepthStencilState): void;

    push_debug_group(name: string): void;
    pop_debug_group(): void;

    set_vertex_buffer(buffer: GPUBuffer, offset: number, index: number): void;
    set_vertex_texture(texture: GPUTexture, index: number): void;
    set_fragment_buffer(buffer: GPUBuffer, offset: number, index: number): void;
    set_fragment_texture(texture: GPUTexture, index: number): void;

    draw_primitive(type: PrimitiveType, start: number, count: number): void;
    draw_primitive(type: PrimitiveType, start: number, count: number, instance_count: number): void;
    draw_primitive_indexed(type: PrimitiveType, index_count: number, index_type: IndexType, buffer: GPUBuffer, buffer_offset: number): void;
    draw_primitive_indexed(type: PrimitiveType, index_count: number, index_type: IndexType, buffer: GPUBuffer, buffer_offset: number, instance_count: number): void;

    // TODO indirect buffer draw
    end_encoding(): void;
}

export interface ComputeCommandEncoder {
    label: string;
}

export interface CommandBuffer {
    create_render_command_encoder(render_pass_descriptor: RenderPassDescriptor): RenderCommandEncoder;
    // create_compute_command_encoder(): ComputeCommandEncoder;

    present(drawable: Drawable): void;
    commit(): void;
}

export interface CommandQueue {
    create_command_buffer(): CommandBuffer;
}

export interface GPUBuffer {
    upload(data: TypedArray): void;
}

export interface GPUProgram {}

export interface GPUTexture {
    upload(data: TypedArray): void;
}

export interface Library {
    create_function(name: string): GPUProgram;
}

export interface RenderPassAttachmentDescriptor {
    texture: GPUTexture;
    level: number;
    slice: number;
    load_action: LoadAction;
    store_action: StoreAction;
}

export interface RenderPassColorAttachmentDescriptor extends RenderPassAttachmentDescriptor {
    clear_color: Color;
}

export interface RenderPassDepthAttachmentDescriptor extends RenderPassAttachmentDescriptor {
    clear_depth: number;
}

export interface RenderPassStencilAttachmentDescriptor extends RenderPassAttachmentDescriptor {
    clear_stencil: number;
}

export interface RenderPassDescriptor {
    color_attachment_at(index: number): RenderPassColorAttachmentDescriptor;
    depth_attachment: RenderPassDepthAttachmentDescriptor;
    stencil_attachment: RenderPassStencilAttachmentDescriptor;
}

export interface CounterSampleBuffer {
    label: string;
    sample_count: number;
}

export interface ComputePassSampleBufferAttachmentDescriptor {
    sample_buffer: CounterSampleBuffer;
    encoder_sample_start_index: number;
    encoder_sample_end_index: number;
}

export interface ComputePassDescriptor {
    dispatch_type: DispatchType;
    get_sample_buffer_attachment_at(index: number): ComputePassSampleBufferAttachmentDescriptor;
}

export interface ComputePipelineDescriptor {
    label: string;
    compute_function: GPUProgram;
    // thread_group_size_is_multiple_of_thread_execution_width: boolean;
    // max_total_threads_per_thread_group: number;
}

// this might be unnecessary requirement
export interface VertexDescriptor {}

export interface RenderPipelineColorAttachmentDescriptor {
    pixel_format: PixelFormat;
    blend_enable: boolean;

    src_rgb_blend_factor: BlendFactor;
    src_alpha_blend_factor: BlendFactor;

    dst_rgb_blend_factor: BlendFactor;
    dst_alpha_blend_factor: BlendFactor;

    rgb_blend_operation: BlendOperation;
    alpha_blend_operation: BlendOperation;

    // color_write: boolean; // is color mask int metal
}

export interface ComputePipelineDescriptor {}

export interface  RenderPipelineDescriptor {
    label: string;

    sample_count: number;
    vertex_function: GPUProgram;
    fragment_function: GPUProgram;

    color_attachment_at(index: number): RenderPipelineColorAttachmentDescriptor;
    depth_attachment_pixel_format: DepthStencilFormat;
    stencil_attachment_pixel_format: DepthStencilFormat
}

export interface DepthStencilDescriptor {
    depth_write: boolean;
    compare_function: DepthCompareFunction;
}

export interface TextureDescriptor {
    type: TextureType;
    pixel_format: PixelFormat;
    width: number;
    height: number;
    depth: number;
    mipmap_level_count: number;
    sample_count: number;
    array_length: number;

    options: ResourceOption;
    cpu_cache_mode: CPUCacheMode;
    storage_mode: StorageMode;
    hazard_tracking_mode: HazardTrackingMode;

    usage: TextureUsage;
    allow_gpu_optimized_contents: boolean;
}

export interface RenderPipelineState {}
export interface ComputePipelineState {}
export interface DepthStencilState {}

export interface MetalScriptDevice {
    create_command_queue(): CommandQueue;
    create_buffer(size: number, options: ResourceOption): GPUBuffer;
    create_texture(descriptor: TextureDescriptor): GPUTexture;
    create_library_from_source(source: string): Library | null;

    create_render_pipeline_state(descriptor: RenderPipelineDescriptor): RenderPipelineState | null;
    create_depth_stencil_state(descriptor: DepthStencilDescriptor): DepthStencilState | null;
    // create_compute_pipeline_state(descriptor: ComputePipelineDescriptor): ComputePipelineState | null;

    create_texture_descriptor(): TextureDescriptor;
    create_render_pipeline_descriptor(): RenderPipelineDescriptor;
    create_depth_stencil_descriptor(): DepthStencilDescriptor;
    // create_compute_pipeline_descriptor(): RenderPipelineDescriptor;

    // prefer_frame_per_second(fps: number): void;
}

export interface Drawable {}
export interface BackBuffer {
    render_pass_descriptor: RenderPassDescriptor;
    drawable: Drawable;
    command_buffer: CommandBuffer;
    color_pixel_format: PixelFormat;
    depth_stencil_pixel_format: DepthStencilFormat;
}