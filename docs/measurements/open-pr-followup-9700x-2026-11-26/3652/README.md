# Ryzen 7 9700X measurements for PR 3652

[PR 3652](https://github.com/buster14a/buster/pull/3652) at `2146c7d31183844e6caaa0ab106c9a7eb4b65170` versus merge base `5ce76f08c3ce7ed298009437d699bbc9c90471a4`.

The PR compiled all 14 functions in the full directive-placement fixture with verified Tier 1, zero fallbacks and no assembly helper symbols. The resulting object had 2,541 text bytes. Five samples of one million calls to the fixture entry point each matched the Clang oracle. Median cost was 804.98M user cycles, 3,548.24M user instructions, and 145.38 ms task-clock.

The base failed to compile the full fixture because it rejected an explicit RSP input in a directive-bearing template. A second attempt omitted that test, and the base then rejected the vector operand in a directive-bearing template. The head compiled that reduced fixture and matched the corresponding Clang oracle in all five samples, at 749.76M median user cycles. Both runs give absolute head costs for their respective inputs.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
