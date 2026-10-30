// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#pragma STDC FENV_ACCESS OFF
double invalid(double x)
{
    return x + (int*)0;
}
