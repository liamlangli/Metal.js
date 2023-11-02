declare type TickFunc = (time: number, back_buffer: any) => void;
declare function metal_create_device(): any;
declare function metal_request_swapchain_callback(tick: TickFunc): void;
declare function metal_cancel_swapchain_callback(tick: TickFunc): void;
