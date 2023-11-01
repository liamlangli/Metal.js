declare type TickFunc = (time: number, back_buffer: any) => void;
declare function create_device(): any;
declare function request_swapchain_callback(tick: TickFunc): void;
declare function cancel_swapchain_callback(): void;
