const device = create_device();
const queue = device.create_command_queue();

function tick(time: number, desc: RenderPassDescriptor) {
    // print(time)
    println(time);
}
request_swapchain_callback(tick);