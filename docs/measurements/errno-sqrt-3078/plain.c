// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.

extern double sqrt(double);
extern float sqrtf(float);

double root64(double x) { return sqrt(x); }
float root32(float x) { return sqrtf(x); }
