
// metal

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

declare interface Device {
    create_command_queue(): CommandQueue;
    prefer_frame_per_second(fps: number): void;
}

declare function create_device(): Device;

declare type TickFunc = (time: number, render_pass_descriptor: RenderPassDescriptor) => void;
declare function request_swapchain_callback(func: TickFunc): void;
declare function cancel_swapchain_callback(func: TickFunc): void;

// runtime
declare function println(fmt: any): void;