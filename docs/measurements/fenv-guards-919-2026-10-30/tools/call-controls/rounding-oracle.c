// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// External runtime oracle; compile with Clang and link with -lm.
#include <fenv.h>
#pragma STDC FENV_ACCESS ON

int set_rounding_upward(void)
{
    return fesetround(FE_UPWARD);
}
int set_rounding_nearest(void)
{
    return fesetround(FE_TONEAREST);
}
int clear_exceptions(void)
{
    return feclearexcept(FE_ALL_EXCEPT);
}
int inexact_exception(void)
{
    return (fetestexcept(FE_INEXACT) & FE_INEXACT) != 0;
}
