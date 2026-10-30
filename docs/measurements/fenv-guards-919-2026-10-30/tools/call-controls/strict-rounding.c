// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Link this checked object with rounding-oracle.c compiled by external Clang.
#pragma STDC FENV_ACCESS ON
int set_rounding_upward(void);
int set_rounding_nearest(void);
int clear_exceptions(void);
int inexact_exception(void);
int main(void)
{
    if (set_rounding_upward() != 0 || clear_exceptions() != 0)
    {
        return 10;
    }
    double above = 1.0 + 0x1p-53;
    int raised = inexact_exception();
    if (set_rounding_nearest() != 0)
    {
        return 11;
    }
    double ordinary;
    {
#pragma STDC FENV_ACCESS OFF
        ordinary = 1.0 + 0x1p-53;
    }
    return !(above > 1.0 && raised && ordinary == 1.0);
}
