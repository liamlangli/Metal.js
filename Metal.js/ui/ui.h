#pragma once

#include "ui_types.h"
#include "ui_buffer.h"

typedef struct ui_context_o {
    ui_primitive_layer_t layers[UI_MAX_PRIMITIVE_LAYERS];

    void *buffer;
    f32 *primitive_data;
    u32 *index_data;

    u64 primitive_data_size;
    u64 index_data_size;

    u32 primitive_offset;
    u32 index_offset;

    u32 last_primitive_offset;
    u32 last_index_offset;
} ui_context_o;

typedef struct ui_i {
    ui_context_o *(*create)(void);
    void (*destroy)(ui_context_o *context);
    void (*update)(ui_context_o *context);

    u32 (*fill_rect)(ui_context_o *context, rect_t rect, ui_style_t style);
    u32 (*fill_round_rect)(ui_context_o *context, rect_t rect, f32 radius, ui_style_t style);

    u32 (*stroke_rect)(ui_context_o *context, rect_t rect, ui_style_t style);
    u32 (*stroke_round_rect)(ui_context_o *context, rect_t rect, f32 radius, ui_style_t style);
} ui_i;

extern ui_i *ui_api;
