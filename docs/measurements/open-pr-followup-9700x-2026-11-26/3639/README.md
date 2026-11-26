# Ryzen 7 9700X measurements for PR 3639

[3639](https://github.com/buster14a/buster/pull/3639) at `3ec965d8ffea57df950aef046457c20b0efbbf99` versus merge base `8e4d32879e17b7d9548cad54257a2f8461328366`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.276 → 15.251 ms (-0.16%) | 76.5M → 76.3M (-0.26%) | Match |
| Tier 1, -O2 -march=znver5 | 604.736 → 611.609 ms (+1.14%) | 3,252.8M → 3,290.4M (+1.16%) | Match |

This draft supplies instrumented compilers for #2610. The samples use `BUSTER_TIER1_EXPERIMENT=0` with origin-tag output disabled. They measure the disabled-instrumentation control on this SQLite input. The object hashes document the generated code comparison for each mode.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
