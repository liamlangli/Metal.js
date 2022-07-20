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

// metal
declare interface StorageMode {}
declare const Shared: StorageMode;
declare const Managed: StorageMode;
declare const Private: StorageMode;
declare const Memoryless: StorageMode;

declare interface CPUCacheMode {}
declare const DefaultCacheMode: CPUCacheMode;
declare const WriteCombined: GPUCacheMode;

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

declare interface RenderPassDescriptor {}
declare interface ComputePassDescriptor {}

declare interface RenderCommandEncoder {
    label: string;

    set_viewport(x: number, y: number, width: number, height: number, near: number, far: number): void;
    set_cull_mode(mode: CullMode): void;
    set_front_facing(facing: Winding): void;
    set_render_pipeline_state(pipeline_state: PipelineState): void;
    set_depth_stencil_state(depth_stencil_state: DepthStencilState): void;

    push_debug_group(name: string): void;
    pop_debug_group(name: string): void;

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
    create_compute_command_encoder(compute_pass_descriptor: ComputePassDescriptor): ComputeCommandEncoder;
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
    make_function(name: string): GPUProgram;
}

declare interface PipelineColorAttachmentDescriptor {
    pixel_format: PixelFormat;
    blend_enable: boolean;
}

// this might be unnecessary requirement
declare interface VertexDescriptor {} 

declare interface PipelineDescriptor {
    label: string;
    vertex_function: GPUProgram;
    fragment_function: GPUProgram;
}

declare interface DepthStencilDescriptor {}

declare interface TextureDescriptor {}

declare interface PipelineState {}

declare interface DepthStencilState {}

declare interface Device {
    create_command_queue(): CommandQueue;
    create_buffer(size: number, options: ResourceOption): GPUBuffer;
    create_texture(descriptor: TextureDescriptor): GPUTexture;
    create_library_from_source(source: string): Library?;

    create_depth_stencil_state(descriptor: DepthStencilDescriptor): DepthStencilState?;
    create_pipeline_state(descriptor: PipelineDescriptor): PipelineState?;

    prefer_frame_per_second(fps: number): void;
}

declare function create_device(): Device;

declare interface Drawable {}
declare interface BackBuffer {
    render_pass_descriptor: RenderPassDescriptor;
    drawable: Drawable;
}

declare type TickFunc = (time: number, back_buffer: BackBuffer) => void;
declare function request_swapchain_callback(func: TickFunc): void;
declare function cancel_swapchain_callback(func: TickFunc): void;

// runtime
declare function println(fmt: any): void;