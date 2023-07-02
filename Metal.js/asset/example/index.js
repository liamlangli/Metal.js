"use strict";(()=>{var p=`
#include <metal_stdlib>
#include <simd/simd.h>

typedef struct
{
    float4 position [[position]];
} VertexOut;

vertex VertexOut base_vert(
    uint vertex_id [[vertex_id]],
    constant simd_float4 *in [[buffer(0)]])
{
    VertexOut out;
    out.position = float4(in[vertex_id].xyz, 1.0);
    return out;
}

fragment float4 base_frag(VertexOut in [[stage_in]])
{
    return float4(0.3, 0.4, 0.5, 1.0);
}
`;function u(){let r=create_device(),c=r.create_library_from_source(p),o=r.create_buffer(48,ResourceStorageModeShared),s=new Float32Array([.5,-.5,0,0,0,.5,0,0,-.5,-.5,0,0]);o.upload(s);let _,i;function d(f,n){let a=n.command_buffer,l=n.render_pass_descriptor,t=a.create_render_command_encoder(l);if(!_){let e=r.create_render_pipeline_descriptor();e.vertex_function=c.create_function("base_vert"),e.fragment_function=c.create_function("base_frag"),e.color_attachment_at(0).pixel_format=n.color_pixel_format,e.depth_attachment_pixel_format=n.depth_stencil_pixel_format,e.stencil_attachment_pixel_format=n.depth_stencil_pixel_format,_=r.create_render_pipeline_state(e)}if(!i){let e=r.create_depth_stencil_descriptor();e.depth_write=!0,e.compare_function=LessEqual,i=r.create_depth_stencil_state(e)}t.push_debug_group("render triangle"),t.set_cull_mode(Back),t.set_front_facing(CounterClockwise),t.set_render_pipeline_state(_),t.set_depth_stencil_state(i),t.set_vertex_buffer(o,0,0),t.draw_primitive(Triangle,0,3),t.pop_debug_group(),t.end_encoding(),a.present(n.drawable),a.commit()}request_swapchain_callback(d)}u();})();
