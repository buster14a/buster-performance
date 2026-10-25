// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
int main(void)
{
    char directory[] = "/tmp/buster-180-oracle-XXXXXX";
    bool passed = x86_encoder_initialize() && mkdtemp(directory) != 0;
    if (passed)
    {
        passed = x86_target_test_gas(directory);
        passed &= rmdir(directory) == 0;
    }
    return passed ? 0 : 1;
}
