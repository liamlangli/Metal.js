// create device & 
const device = create_device();
const queue = device.create_command_queue();
// const library = device.create_library_from_source(shader_source);

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

const shader_source = `
#include <metal_stdlib>
#include <simd/simd.h>

typedef struct
{
    float4 position [[position]];
} VertexOut;

vertex ColorInOut base_vert(simd_float3 in [[stage_in]])
{
    VertexOut out;
    float4 position = float4(in.position, 1.0);
    return out;
}

fragment float4 base_frag(VertexOut in [[stage_in]])
{
    return float4(0.3, 0.4, 0.5, 1.0);
}
`