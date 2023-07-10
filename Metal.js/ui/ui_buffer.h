#pragma once

#include "ui_types.h"

enum {  UI_MAX_PRIMITIVE_LAYERS = 3 };

enum ui_corner {
    TOP_LEFT = 0 << 24,
    TOP_RIGHT = 1 << 24,
    BOTTOM_LEFT = 2 << 24,
    BOTTOM_RIGHT = 3 << 24,
};

enum ui_primitive_type {
    UI_PRIMITIVE_TYPE_RECTANGLE = 1 << 26,
    UI_PRIMITIVE_TYPE_RECTANGLE_TEXTURED = 2 << 26,
    UI_PRIMITIVE_TYPE_TRIANGLE = 3 << 26,
    UI_PRIMITIVE_TYPE_TRIANGLE_TEXTURED = 4 << 26,
    UI_PRIMITIVE_TYPE_TRIANGLE_DASHED = 5 << 26,
    UI_PRIMITIVE_TYPE_TILE = 6 << 26,
};

typedef struct ui_vertex_rect_t {
    float2_t point;
    f32 w, h;
    color_srgb_t color;
    u32 clip;
    u32 texture_id;
    u32 _place_holder_[2];
} ui_vertex_rect_t;

typedef struct ui_vertex_triangle_t {
    float2_t point;
    f32 alpha;
    f32 dash_offset;
    color_srgb_t color;
    u32 clip;
    u32 texture_id;
    u32 _place_holder_;
} ui_vertex_triangle_t;

typedef struct ui_vertex_tile_begin_t {
    f32 x, y, w, h;
    f32 uv_x, uv_y, uv_w, uv_h;
} ui_vertex_tile_begin_t;

typedef struct ui_vertex_tile_end_t {
    color_srgb_t color;
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

typedef struct ui_primitive_layer_t {
    f32 *primitive_data;
    u32 *index_data;

    u32 primitive_offset;
    u32 index_offset;
} ui_primitive_layer_t;

static u32 ui_primitive_layer_write_vertex(ui_primitive_layer_t *layer, ui_vertex_t *vertex);

static u32 ui_primitive_layer_write_index(ui_primitive_layer_t *layer, u32 index);

static inline u32 ui_encode_vertex_id(u32 primitive_type, u32 corner, u32 offset) {
    return (primitive_type | corner | (offset >> 2));
}

static inline u32 ui_decode_primitive_type(u32 id) {
    return (id >> 26) & 0x3f;
}

static inline u32 ui_decode_corner_id(u32 id) {
    return (id >> 24) & 0x3;
}

static inline u32 ui_decode_vertex_offset(u32 id) {
    return (id & 0xffffff) << 2;
}
