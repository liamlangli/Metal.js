Metal.js
--------

> Metal Javascript Runtime export

### API snippet
```typescript
// render a simple object might like this

// create device & command queue & shader library
const device = create_device();
const queue = device.create_command_queue();
const library = device.create_library_from_source(shader_source);

// prepare buffer
const buffer_data = new Float32Array([
    -0.5, -0.5, 0,
    0, 0.5, 0,
    0.5, -0.5, 0
]);

const pso = device.create_pipeline_state_object({
    vertex: library.make_function('base_vert'),
    fragment: library.make_function('base_frag')
});

request_swapchain_callback(tick, 3); // 3 means triple buffering
function tick(time, render_pass_desc) {
    const encoder = queue.create_render_encoder();
    encoder.set_clear_color(0.3, 0.4, 0.5, 1.0);
    encoder.set_pipeline_state_object(pso);
    encoder.set_model_render_command(model, PRIMITIVE.TRIANGLES);
    encoder.commit();
}


```