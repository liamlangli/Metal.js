#pragma once

#include "ui_types.h"
#include <math.h>

static inline f32 fast_inv_sqrt(f32 n) {
    f32 half_n = n * 0.5f;
    i32 i = *(i32*)&n;
    i = 0x5f3759df - (i >> 1);
    n = *(f32*)&i;
    n = n * (1.5f - half_n * n * n);
    return n;
}

static inline float2_t float2_sub(float2_t a, float2_t b) {
    return (float2_t){a.x - b.x, a.y - b.y};
}

static inline float2_t float2_add(float2_t a, float2_t b) {
    return (float2_t){a.x + b.x, a.y + b.y};
}

static inline float2_t float2_mul(float2_t a, float b) {
    return (float2_t){a.x * b, a.y * b};
}

static inline float2_t float2_mul_another(float2_t a, float2_t b) {
    return (float2_t){a.x * b.x, a.y * b.y};
}

static inline float2_t float2_normalize(float2_t a) {
    float inv_sqrt = fast_inv_sqrt(a.x * a.x + a.y * a.y);
    return (float2_t){a.x * inv_sqrt, a.y * inv_sqrt};
}