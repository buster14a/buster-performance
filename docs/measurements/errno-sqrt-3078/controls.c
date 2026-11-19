// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.

double sign64(double x, double y) { return __builtin_copysign(x, y); }
float sign32(float x, float y) { return __builtin_copysignf(x, y); }
double floor64(double x) { return __builtin_floor(x); }
float floor32(float x) { return __builtin_floorf(x); }
double ceil64(double x) { return __builtin_ceil(x); }
float ceil32(float x) { return __builtin_ceilf(x); }
double trunc64(double x) { return __builtin_trunc(x); }
float trunc32(float x) { return __builtin_truncf(x); }
double near64(double x) { return __builtin_nearbyint(x); }
float near32(float x) { return __builtin_nearbyintf(x); }
double rint64(double x) { return __builtin_rint(x); }
float rint32(float x) { return __builtin_rintf(x); }
