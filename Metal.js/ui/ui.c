#include "ui.h"

static void ui_create_context(void) {
    printf("ui context init\n");
}

static ui_api ui = {
    .create_ui_context = &ui_create_context
};

ui_api* create_ui_context(void) {
    return &ui;
}
