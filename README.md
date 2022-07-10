Metal.js
--------

> Export Metal api to v8 virtual machine and use js to manipulate native Metal API.

### API snippet
```typescript
// render a simple object might like this
const device = await create_device();
const queue = device.create_command_queue();
const library = await create_library('/path/to/kernel.metallib');
const model = await model_load('/path/to/model.model');

const pso = device.create_pipeline_state_object({
    vertex: library.get('vertex_stage'),
    fragment: library.get('fragment_stage')
});

request_swapchain_callback(tick, 3); // 3 means triple buffering
function tick(time, swap_index) {
    const encoder = queue.create_render_encoder();
    encoder.set_clear_color(0.3, 0.4, 0.5, 1.0);
    encoder.set_pipeline_state_object(pso);
    encoder.set_model_render_command(model, PRIMITIVE.TRIANGLES);
    encoder.commit();
}

```