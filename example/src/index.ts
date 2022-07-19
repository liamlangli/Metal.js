const device = create_device();
const queue = device.create_command_queue();

function tick(time: number, desc: RenderPassDescriptor) {
    // print(time)
}
request_swapchain_callback(tick);
println(Float32Array);
const buffer = new Float32Array(128);
buffer[0] = 12.9;
buffer[128] = 32.2;
println(buffer);