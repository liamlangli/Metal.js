const device = create_device();
const queue = device.create_command_queue();

const buffer = device.create_buffer(36, ResourceStorageModeShared)
const data = new Float32Array([
    -0.5, -0.5, 0,
    0, 0.5, 0,
    0.5, -0.5, 0
]);
buffer.upload(data);

function tick(time: number, desc: RenderPassDescriptor) {
    // print(time)
}
request_swapchain_callback(tick);