//
//  File.metal
//  union
//
//  Created by Lang on 2022/1/29.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

#define UI_PRIMITIVE_TYPE_RECTANGLE 1u
#define UI_PRIMITIVE_TYPE_RECTANGLE_TEXTURED 2u
#define UI_PRIMITIVE_TYPE_TRIANGLE 3u
#define UI_PRIMITIVE_TYPE_TRIANGLE_TEXTURED 4u
#define UI_PRIMITIVE_TYPE_TRIANGLE_DASHED 5u
#define UI_PRIMITIVE_TYPE_TILE 6u

typedef float f32;
typedef uint u32;

typedef struct {
    simd_float2 window_size;
} ui_uniform;

typedef struct {
    float4 rect;
    uchar4 color;
    u32 clip;
    u32 texture_id;
    u32 _place_holder_[2];
} ui_vertex_rect_t;

typedef struct {
    f32 x, y;
    f32 alpha;
    f32 dash_offset;
    uchar4 color;
    u32 clip;
    u32 texture_id;
    u32 _place_holder_;
} ui_vertex_triangle_t;

typedef struct {
    f32 x, y, w, h;
    f32 uv_x, uv_y, uv_w, uv_h;
} ui_vertex_tile_begin_t;

typedef struct {
    uchar4 color;
    u32 clip;
    u32 texture_id;
    u32 _place_holder_[5];
} ui_vertex_tile_end_t;

typedef union {
    ui_vertex_rect_t rect_vertex;
    ui_vertex_triangle_t triangle_vertex;
    ui_vertex_tile_begin_t tile_begin_vertex;
    ui_vertex_tile_end_t tile_end;
} ui_vertex_t;

typedef struct {
  float4 position [[position]];
  half4 color;
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

half4 color_convert(uchar4 color) {
    return half4((float)color.r / 255.0, (float)color.g / 255.0, (float)color.b / 255.0, (float)color.a / 255.0);
}

float4 rect_vertex(float4 r, uint corner_idx)
{
    return float4(r.x + ((corner_idx == 1u || corner_idx == 3u) ? r.z : 0.), r.y + ((corner_idx == 2u || corner_idx == 3u) ? r.w : 0.), 0., 1.);
}

vertex ui_vertex_out ui_vertex(ui_vertex_in in [[stage_in]],
                               constant ui_uniform &uniform [[buffer(1)]],
                               const device ui_vertex_t* vertex_buffer [[buffer(2)]])
{
    uint vertex_id = in.vertex_id;
    ui_vertex_out out;

    uint type = decode_primitive_type(vertex_id);
    uint ptr = decode_primitive_buffer_offset(vertex_id);
    float4 v = float4(0., 0., 0., 1.0);

    if (type == UI_PRIMITIVE_TYPE_RECTANGLE) {
        uint corner_id = decode_corner_idx(vertex_id);
        ui_vertex_rect_t vx = vertex_buffer[ptr].rect_vertex;
        out.color = color_convert(vx.color);
        v = rect_vertex(vx.rect, corner_id);
    } else if (type == UI_PRIMITIVE_TYPE_TRIANGLE) {
        ui_vertex_triangle_t vx = vertex_buffer[ptr].triangle_vertex;
        v.x = vx.x;
        v.y = vx.y;
        out.color = color_convert(vx.color);
        out.color.a *= vx.alpha;
    }

    out.position = v;
    out.position.xy = out.position.xy * 2.0 / uniform.window_size - 1.0;
    out.type = type;
    return out;
}

fragment half4 ui_fragment(ui_vertex_out in [[stage_in]],
                            texture2d<half> font_texture [[texture(0)]])
{
  return in.color;
}

