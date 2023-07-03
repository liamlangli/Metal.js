// typescript
declare type TypedArray =
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

declare interface Color {
    r: number;
    g: number;
    b: number;
    a: number;
}

// metal
declare interface StorageMode {}
declare const Shared: StorageMode;
declare const Managed: StorageMode;
declare const Private: StorageMode;
declare const Memoryless: StorageMode;

declare interface CPUCacheMode {}
declare const DefaultCacheMode: CPUCacheMode;
declare const WriteCombined: CPUCacheMode;

declare interface HazardTrackingMode {}
declare const DefaultHazardTrackingMode : HazardTrackingMode;
declare const Untracked: HazardTrackingMode;
declare const Tracked: HazardTrackingMode;

declare interface ResourceOption {}
declare const ResourceStorageModeShared: ResourceOption;
declare const ResourceStorageModeManaged: ResourceOption;
declare const ResourceStorageModePrivate: ResourceOption;
declare const ResourceStorageModeMemoryLess: ResourceOption;

declare const ResourceTrackingModeDefault: ResourceOption;
declare const ResourceTrackingModeUntracked: ResourceOption;
declare const ResourceTrackingModeTracked: ResourceOption;

declare const ResourceCPUCacheModeDefault: ResourceOption;
declare const ResourceCPUCacheModeWriteCombined: ResourceOption;

declare interface TextureType {}
declare const Texture1D: TextureType;
declare const Texture1DArray: TextureType;
declare const Texture2D: TextureType;
declare const Texture2DArray: TextureType;
declare const Texture2DMultisample: TextureType;
declare const TextureCube: TextureType;
declare const TextureCubeArray: TextureType;
declare const Texture3D: TextureType;
declare const Texture2DMultisampleArray: TextureType;
declare const TextureBuffer: TextureType;

declare interface TextureUsage {}
declare const Unknown: TextureUsage;
declare const ShaderRead: TextureUsage;
declare const ShaderWrite: TextureUsage;
declare const ShaderTarget: TextureUsage;
declare const PixelFormatView: TextureUsage;

declare interface PixelFormat {}
declare const A8Unorm: PixelFormat;
declare const R8Unorm: PixelFormat;
declare const R8Unorm_sRGB: PixelFormat;
declare const R8Snorm: PixelFormat;
declare const R8Uint: PixelFormat;
declare const R8Sint: PixelFormat;
declare const R16Unorm: PixelFormat;
declare const R16Snorm: PixelFormat;
declare const R16Uint: PixelFormat;
declare const R16SInt: PixelFormat;
declare const R16Float: PixelFormat;
declare const RG8Unorm: PixelFormat;
declare const RG8Unorm_sRGB: PixelFormat;
declare const RG8Snorm: PixelFormat;
declare const RG8Uint: PixelFormat;
declare const RG8Sint: PixelFormat;

declare const B5G6R5Unorm: PixelFormat;
declare const A1BGR5Unorm: PixelFormat;
declare const ABGR4Unorm: PixelFormat;
declare const BGR5A1Unorm: PixelFormat;

declare const R32Uint: PixelFormat;
declare const R32Sint: PixelFormat;
declare const R32Float: PixelFormat;
declare const RG16Unorm: PixelFormat;
declare const RG16Snorm: PixelFormat;
declare const RG16Uint: PixelFormat;
declare const RG16SInt: PixelFormat;
declare const RG16Float: PixelFormat;

declare const RGBA8Unorm: PixelFormat;
declare const RGBA8Unorm_sRGB: PixelFormat;
declare const RGBA8Snorm: PixelFormat;
declare const RGBA8Uint: PixelFormat;
declare const RGBA8Sint: PixelFormat;
declare const BGRA8Unorm: PixelFormat;
declare const BGRA8Unorm_sRGB: PixelFormat;

declare const RGB10A2Unorm: PixelFormat;
declare const RGB10A2Uint: PixelFormat;

declare const RG11B10Float: PixelFormat;
declare const RGB9E5Float: PixelFormat;
declare const BGR10A2Unorm: PixelFormat;

declare const RG32Uint: PixelFormat;
declare const RG32Sint: PixelFormat;
declare const RG32Float: PixelFormat;

declare const RGBA16Unorm: PixelFormat;
declare const RGBA16Snorm: PixelFormat;
declare const RGBA16Uint: PixelFormat;
declare const RGBA16Sint: PixelFormat;
declare const RGBA16Float: PixelFormat;

declare const BGR10_XR: PixelFormat;
declare const RGB10_XR_sRGB: PixelFormat;

declare const RGBA32Uint: PixelFormat;
declare const RGBA32Sint: PixelFormat;
declare const RGBA32Float: PixelFormat;

// depth format
declare interface DepthStencilFormat extends PixelFormat {}
declare const Depth16Unorm: DepthStencilFormat;
declare const Depth32Float: DepthStencilFormat;
declare const Stencil8: DepthStencilFormat;
declare const Depth32Float_Stencil8: DepthStencilFormat;
declare const X32_Stencil8: DepthStencilFormat;
declare const X24_Stencil8: DepthStencilFormat;

// TODO: compressed format declare

declare interface DepthCompareFunction {}
declare const Never: DepthCompareFunction;
declare const Less: DepthCompareFunction;
declare const Equal: DepthCompareFunction;
declare const LessEqual: DepthCompareFunction;
declare const Greater: DepthCompareFunction;
declare const NotEqual: DepthCompareFunction;
declare const GreaterEqual: DepthCompareFunction;
declare const Always: DepthCompareFunction;

declare interface CullMode {}
declare const NoneCull: CullMode;
declare const Front: CullMode;
declare const Back: CullMode;

declare interface Winding {}
declare const Clockwise: Winding;
declare const CounterClockwise: Winding;

declare interface DepthClipMode {}
declare const DepthClip: DepthClipMode;
declare const DepthClamp: DepthClipMode;

declare interface PrimitiveType {}
declare const Point: PrimitiveType;
declare const Line: PrimitiveType;
declare const LineStrip: PrimitiveType;
declare const Triangle: PrimitiveType;
declare const TriangleStripe: PrimitiveType;

declare interface IndexType {}
declare const Uint16Index: IndexType;
declare const Uint32Index: IndexType;

declare interface LoadAction {}
declare interface StoreAction {}
declare const DontCare: LoadAction & StoreAction;
declare const Load: LoadAction;
declare const Clear: LoadAction;
declare const Store: StoreAction;
declare const MultisampleResolve: StoreAction;
declare const StoreAndMultisampleResolve: StoreAction;
declare const StoreUnknown: StoreAction;
declare const CustomSampleDepthStore: StoreAction;

declare interface BlendFactor {}
declare const Zero: BlendFactor;
declare const One: BlendFactor;

declare const SrcColor: BlendFactor;
declare const OneMinusSrcColor: BlendFactor;
declare const SrcAlpha: BlendFactor;
declare const OneMinusSrcAlpha: BlendFactor;

declare const DstColor: BlendFactor;
declare const OneMinusDstColor: BlendFactor;
declare const DstAlpha: BlendFactor;
declare const OneMinusDstAlpha: BlendFactor;

declare const SrcAlphaSaturated: BlendFactor;

declare const BlendColor: BlendFactor;
declare const OneMinusBlendColor: BlendFactor;
declare const BlendAlpha: BlendFactor;
declare const OneMinusBlendAlpha: BlendFactor;

declare interface BlendOperation {}
declare const Add: BlendOperation;
declare const Subtract: BlendOperation;
declare const ReverseSubtract: BlendOperation;
declare const Min: BlendOperation;
declare const Max: BlendOperation;

declare interface DispatchType {}
declare const Serial: DispatchType;
declare const Concurrent: DispatchType;

declare interface RenderCommandEncoder {
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

declare interface ComputeCommandEncoder {
    label: string;
}

declare interface CommandBuffer {
    create_render_command_encoder(render_pass_descriptor: RenderPassDescriptor): RenderCommandEncoder;
    // create_compute_command_encoder(): ComputeCommandEncoder;

    present(drawable: Drawable): void;
    commit(): void;
}

declare interface CommandQueue {
    create_command_buffer(): CommandBuffer;
}

declare interface GPUBuffer {
    upload(data: TypedArray): void;
}

declare interface GPUProgram {}

declare interface GPUTexture {
    upload(data: TypedArray): void;
}

declare interface Library {
    create_function(name: string): GPUProgram;
}

declare interface RenderPassAttachmentDescriptor {
    texture: GPUTexture;
    level: number;
    slice: number;
    load_action: LoadAction;
    store_action: StoreAction;
}

declare interface RenderPassColorAttachmentDescriptor extends RenderPassAttachmentDescriptor {
    clear_color: Color;
}

declare interface RenderPassDepthAttachmentDescriptor extends RenderPassAttachmentDescriptor {
    clear_depth: number;
}

declare interface RenderPassStencilAttachmentDescriptor extends RenderPassAttachmentDescriptor {
    clear_stencil: number;
}

declare interface RenderPassDescriptor {
    color_attachment_at(index: number): RenderPassColorAttachmentDescriptor;
    depth_attachment: RenderPassDepthAttachmentDescriptor;
    stencil_attachment: RenderPassStencilAttachmentDescriptor;
}

declare interface CounterSampleBuffer {
    label: string;
    sample_count: number;
}

declare interface ComputePassSampleBufferAttachmentDescriptor {
    sample_buffer: CounterSampleBuffer;
    encoder_sample_start_index: number;
    encoder_sample_end_index: number;
}

declare interface ComputePassDescriptor {
    dispatch_type: DispatchType;
    get_sample_buffer_attachment_at(index: number): ComputePassSampleBufferAttachmentDescriptor;
}

declare interface ComputePipelineDescriptor {
    label: string;
    compute_function: GPUProgram;
    // thread_group_size_is_multiple_of_thread_execution_width: boolean;
    // max_total_threads_per_thread_group: number;
}

// this might be unnecessary requirement
declare interface VertexDescriptor {} 

declare interface RenderPipelineColorAttachmentDescriptor {
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

declare interface ComputePipelineDescriptor {}

declare interface  RenderPipelineDescriptor {
    label: string;

    sample_count: number;
    vertex_function: GPUProgram;
    fragment_function: GPUProgram;

    color_attachment_at(index: number): RenderPipelineColorAttachmentDescriptor;
    depth_attachment_pixel_format: DepthStencilFormat;
    stencil_attachment_pixel_format: DepthStencilFormat
}

declare interface DepthStencilDescriptor {
    depth_write: boolean;
    compare_function: DepthCompareFunction;
}

declare interface TextureDescriptor {
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

declare interface RenderPipelineState {}
declare interface ComputePipelineState {}
declare interface DepthStencilState {}

declare interface Device {
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

declare function create_device(): Device;

declare interface Drawable {}
declare interface BackBuffer {
    render_pass_descriptor: RenderPassDescriptor;
    drawable: Drawable;
    command_buffer: CommandBuffer;
    color_pixel_format: PixelFormat;
    depth_stencil_pixel_format: DepthStencilFormat;
}

declare type TickFunc = (time: number, back_buffer: BackBuffer) => void;
declare function request_swapchain_callback(func: TickFunc): void;
declare function cancel_swapchain_callback(func: TickFunc): void;

// runtime
declare function println(fmt: any): void;