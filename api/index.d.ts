
// metal

declare interface StorageMode {}
declare const Shared: StorageMode;
declare const Managed: StorageMode;
declare const Private: StorageMode;
declare const Memoryless: StorageMode;

declare interface CPUCacheMode {};
declare const DefaultCacheMode: CPUCacheMode;
declare const WriteCombined: GPUCacheMode;

declare interface HazardTrackingMode {};
declare const DefaultHazardTrackingMode : HazardTrackingMode;
declare const Untracked: HazardTrackingMode;
declare const Tracked: HazardTrackingMode;

declare interface ResourceOption {};
declare const ResourceStorageModeShared: ResourceOption;
declare const ResourceStorageModeManaged: ResourceOption;
declare const ResourceStorageModePrivate: ResourceOption;
declare const ResourceStorageModeMemoryLess: ResourceOption;

declare const ResourceTrackingModeDefault: ResourceOption;
declare const ResourceTrackingModeUntracked: ResourceOption;
declare const ResourceTrackingModeTracked: ResourceOption;

declare const ResourceCPUCacheModeDefault: ResourceOption;
declare const ResourceCPUCacheModeWriteCombined: ResourceOption;

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

declare interface RenderPassDescriptor {}
declare interface ComputePassDescriptor {}

declare interface RenderCommandEncoder {}
declare interface ComputeCommandEncoder {}

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

declare interface Device {
    create_command_queue(): CommandQueue;
    create_buffer(size: number, options: ResourceOption): GPUBuffer;

    prefer_frame_per_second(fps: number): void;
}

declare function create_device(): Device;

declare type TickFunc = (time: number, render_pass_descriptor: RenderPassDescriptor) => void;
declare function request_swapchain_callback(func: TickFunc): void;
declare function cancel_swapchain_callback(func: TickFunc): void;

// runtime
declare function println(fmt: any): void;