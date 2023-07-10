#include "ui_buffer.h"

#include <string.h>

static u32 ui_primitive_layer_write_vertex(ui_primitive_layer_t *layer, ui_vertex_t vertex) {
    u32 offset = layer->primitive_offset;
    memcpy(layer->primitive_data + layer->primitive_offset, &vertex, sizeof(ui_vertex_t));
    layer->primitive_offset += 2; // 8 byte aligned
    return offset;
}