// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// kernel.c: Tier 1's scalar saxpy, compiled by the compiler under test (--tier1 -march=znver5), called by caller.c.
void saxpy(float* y, const float* x, float k, int n)
{
    for (int i = 0; i < n; i += 1)
    {
        y[i] = k * x[i] + y[i];
    }
}
