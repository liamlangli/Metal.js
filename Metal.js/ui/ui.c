#include "ui.h"
#include "ui_buffer.h"

#include <stdlib.h>
#include <string.h>

enum {
    PRIMITIVE_BUFFER_SIZE_MAIN_LAYER = 65536, // 64K
    PRIMITIVE_BUFFER_SIZE_SUB_LAYER = 16384, // 16K
    PRIMITIVE_BUFFER_SIZE_LAST_LAYER = 4096, // 4K
    PRIMITIVE_BUFFER_INDEX_CHUNK_STRIDE = 16,
};

static ui_context_o *ui_create_context(void) {
    printf("ui context init\n");
    ui_context_o *context = malloc(sizeof(ui_context_o));

    u64 primitive_buffer_size = (PRIMITIVE_BUFFER_SIZE_MAIN_LAYER + PRIMITIVE_BUFFER_SIZE_SUB_LAYER + PRIMITIVE_BUFFER_SIZE_LAST_LAYER) * 4;
    void *buffer = malloc(primitive_buffer_size * (PRIMITIVE_BUFFER_INDEX_CHUNK_STRIDE + 1));
    
    context->primitive_data_size = primitive_buffer_size;
    context->index_data_size = primitive_buffer_size * PRIMITIVE_BUFFER_INDEX_CHUNK_STRIDE;

    f32 *primitive_data = (f32*)buffer;
    u32 *index_data = (u32*)buffer + PRIMITIVE_BUFFER_SIZE_MAIN_LAYER + PRIMITIVE_BUFFER_SIZE_SUB_LAYER + PRIMITIVE_BUFFER_SIZE_LAST_LAYER;
    context->layers[0].primitive_data = primitive_data;
    context->layers[1].primitive_data = primitive_data + PRIMITIVE_BUFFER_SIZE_MAIN_LAYER;
    context->layers[2].primitive_data = primitive_data + PRIMITIVE_BUFFER_SIZE_MAIN_LAYER + PRIMITIVE_BUFFER_SIZE_SUB_LAYER;

    context->layers[0].index_data = (u32*)index_data;
    context->layers[1].index_data = (u32*)(index_data + PRIMITIVE_BUFFER_SIZE_MAIN_LAYER * PRIMITIVE_BUFFER_INDEX_CHUNK_STRIDE);
    context->layers[2].index_data = (u32*)(index_data + (PRIMITIVE_BUFFER_SIZE_MAIN_LAYER + PRIMITIVE_BUFFER_SIZE_SUB_LAYER) * PRIMITIVE_BUFFER_INDEX_CHUNK_STRIDE);

    context->primitive_data = primitive_data;
    context->index_data = index_data;

    return context;
}

static void ui_destroy_context(ui_context_o *context) {
    printf("ui context destroy\n");
    free(context->buffer);
    free(context);
}

static void ui_update_context(ui_context_o *context) {

    context->last_primitive_offset = context->primitive_offset;
    context->last_index_offset = context->index_offset;

    u32 primitive_offset = context->layers[0].primitive_offset;
    u32 index_offset = context->layers[0].index_offset;
    if (context->layers[1].index_offset > 0) {
        ui_primitive_layer_t *main_layer = &context->layers[0];
        ui_primitive_layer_t *curr_layer = &context->layers[1];
        memcpy(main_layer->primitive_data + main_layer->primitive_offset, curr_layer->primitive_data, curr_layer->primitive_offset * sizeof(f32));
        memcpy(main_layer->index_data + main_layer->index_offset, curr_layer->index_data, curr_layer->index_offset * sizeof(u32));
        primitive_offset += curr_layer->primitive_offset;
        index_offset += curr_layer->index_offset;
    }

    if (context->layers[2].index_offset > 0) {
        ui_primitive_layer_t *main_layer = &context->layers[0];
        ui_primitive_layer_t *curr_layer = &context->layers[2];
        memcpy(main_layer->primitive_data + main_layer->primitive_offset, curr_layer->primitive_data, curr_layer->primitive_offset * sizeof(f32));
        memcpy(main_layer->index_data + main_layer->index_offset, curr_layer->index_data, curr_layer->index_offset * sizeof(u32));
        primitive_offset += curr_layer->primitive_offset;
        index_offset += curr_layer->index_offset;
    }

    context->index_offset = index_offset;
    context->primitive_offset = primitive_offset;
}

static ui_i ui = {
    .create = &ui_create_context,
    .destroy = &ui_destroy_context,
    .update = &ui_update_context,
};

ui_i *ui_api = &ui;
