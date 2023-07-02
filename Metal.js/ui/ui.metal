//
//  File.metal
//  union
//
//  Created by Lang on 2022/1/29.
//

#include <metal_stdlib>
#include <simd/simd.h>

typedef struct {
    simd_float2 window_size;
} UIUniform;

#define PRIMITIVE_TYPE_TRIANGLE 1u
#define PRIMITIVE_TYPE_TRIANGLE_TEXTURED 2u
#define PRIMITIVE_TYPE_RECTANGLE 3u
#define PRIMITIVE_TYPE_RECTANGLE_TEXTURED  4u
#define PRIMITIVE_TYPE_TRIANGLE_SCREEN 7u
#define PRIMITIVE_TYPE_TRIANGLE_ICON 8u
#define PRIMITIVE_TYPE_TRIANGLE_ATLAS 9u
#define PRIMITIVE_TYPE_GLYPH_COLORED 31u
#define PRIMITIVE_TYPE_GLYPH 32u
#define PRIMITIVE_TYPE_GLYPH_CODE 33u

using namespace metal;

typedef struct {
  float4 position [[position]];
  float4 color;
  float2 uv;
  uint type;
} ui_vertex_out;

typedef struct {
  uint vertex_id [[attribute(0)]];
} ui_vertex_in;

uint decode_primitive_type(int vertex_id)
{
    return (vertex_id >> 26) & 0x3f;
}

uint decode_primitive_buffer_offset(uint vertex_id)
{
    return vertex_id & 0xffffffu;
}

uint decode_corner_idx(uint vertex_id)
{
    return (vertex_id >> 24) & 0x3u;
}

float4 rect_vertex(float4 r, uint corner_idx)
{
    return float4(r.x + ((corner_idx == 1u || corner_idx == 3u) ? r.z : 0.), r.y + ((corner_idx == 2u || corner_idx == 3u) ? r.w : 0.), 0., 1.);
}

vertex ui_vertex_out ui_vertex(ui_vertex_in in [[stage_in]],
                               constant UIUniform &uniform [[buffer(1)]],
                               const device simd_float4* primitive_buffer [[buffer(2)]],
                               const device simd_uint4* primitive_uint_buffer [[buffer(3)]])
{
  uint vertex_id = in.vertex_id;
  ui_vertex_out out;
  
  uint type = decode_primitive_type(vertex_id);
  uint ptr = decode_primitive_buffer_offset(vertex_id);
  float4 v = float4(0., 0., 0., 1.0);
  
  if (type == PRIMITIVE_TYPE_RECTANGLE) {
    uint corner_id = decode_corner_idx(vertex_id);
    float4 primitive_data = primitive_buffer[ptr];
    out.color = primitive_buffer[ptr + 1];
    v = rect_vertex(primitive_data, corner_id);
  } else if (type == PRIMITIVE_TYPE_TRIANGLE) {
    float4 triangle_data = primitive_buffer[ptr];
    uint rect_offet = primitive_uint_buffer[ptr].z;
    float4 primitive_data = primitive_buffer[rect_offet + 1];
    v.xy = triangle_data.xy;
    out.color.xyz = primitive_data.xyz;
    out.color.a = triangle_data.w;
  }

  out.position = v;
  out.position.xy = out.position.xy * 2.0 / uniform.window_size - 1.0;
  out.type = type;
  
  return out;
}

fragment float4 ui_fragment(ui_vertex_out in [[stage_in]],
                            texture2d<half> font_texture [[texture(0)]])
{
  return in.color;
}

