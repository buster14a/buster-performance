# Ryzen 7 9700X measurements for PR 3653

[3653](https://github.com/buster14a/buster/pull/3653) at `32adb58bad4257b4dd2a0c3649f263ac0edc15a6` versus merge base `5ce76f08c3ce7ed298009437d699bbc9c90471a4`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.199 → 15.146 ms (-0.35%) | 75.6M → 75.4M (-0.26%) | Match |
| --no-direct | 112.029 → 112.179 ms (+0.13%) | 543.8M → 545.1M (+0.24%) | Match |

Five alternating runtime pairs per kernel and compiler tier, with 20 million iterations for MUL, flags and shift and one million for CPUID. The harness produced matching outputs on the two revisions. Both Tier 1 builds compiled eight functions with zero fallbacks.

| Kernel | Tier 0 user cycles, base → head | Tier 1 user cycles, base → head |
| --- | ---: | ---: |
| MUL | 60.20M → 60.20M (≈0%) | 50.20M → 34.10M (−32.08%) |
| Flags | 48.86M → 38.20M (−21.83%) | 43.24M → 36.74M (−15.04%) |
| Shift | 80.20M → 40.19M (−49.88%) | 80.20M → 20.30M (−74.69%) |
| CPUID | 139.15M → 133.38M (−4.15%) | 140.53M → 133.23M (−5.19%) |

The CPUID timing harness masks its results to the low bit. The output comparison covers the retained bits.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
