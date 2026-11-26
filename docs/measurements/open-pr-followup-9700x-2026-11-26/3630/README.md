# Ryzen 7 9700X measurements for PR 3630

[3630](https://github.com/buster14a/buster/pull/3630) at `4e89739c94b77a76ccedf3c064f2ac4fbc455910` versus merge base `8e4d32879e17b7d9548cad54257a2f8461328366`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.268 → 15.246 ms (-0.14%) | 76.6M → 76.5M (-0.13%) | Match |
| Tier 1, -O2 -march=znver5 | 604.656 → 606.044 ms (+0.23%) | 3,253.7M → 3,261.7M (+0.25%) | Differ |

The runtime pairs use Tier 1 on the frozen SQLite speedtest1 mix1 workload and five scripts run with Lua 5.4.8. Seven alternating pairs ran at each linker padding. SQLite verification digests and all five Lua script outputs matched. The Lua total sums the five script medians.

| Text padding | SQLite user cycles, base → head | Lua user cycles, base → head |
| --- | ---: | ---: |
| 0 B | 674.36M → 673.02M (−0.20%) | 990.83M → 989.88M (−0.10%) |
| 16 B | 675.85M → 669.89M (−0.88%) | 964.57M → 970.96M (+0.66%) |
| 32 B | 679.37M → 676.41M (−0.44%) | 978.80M → 978.55M (−0.03%) |
| 48 B | 676.69M → 671.71M (−0.74%) | 970.54M → 968.78M (−0.18%) |

SQLite retired 0.024% more instructions at each padding, and its dispatch symbol moved by 16 bytes modulo a 64-byte line at equal linker padding. Lua's dispatch symbol retained the same line offsets and aggregate instructions varied between −0.06% and +0.04%. These measurements cover the draft's folded-frame recipe fix at the pinned revision.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
