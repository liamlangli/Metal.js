#pragma once

#include "ui_types.h"

typedef struct ui_api {
    void (*create_ui_context)(void);
} ui_api;

ui_api* create_ui_context(void);
