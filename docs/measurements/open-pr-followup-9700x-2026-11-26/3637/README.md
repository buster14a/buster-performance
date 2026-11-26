# Ryzen 7 9700X measurements for PR 3637

[PR 3637](https://github.com/buster14a/buster/pull/3637) at `03d4e4afd9fe9542482fcec2c1aab4d534a551c4` versus merge base `8e4d32879e17b7d9548cad54257a2f8461328366`.

Both revisions use `--tier0-inline-shapes -march=znver5` for the frozen SQLite speedtest1 mix1 workload and Lua 5.4.8. Seven alternating pairs ran at each linker padding, with matching SQLite verification hashes and matching outputs for all five Lua scripts. SQLite and Lua dispatch symbol line offsets matched at equal linker padding. The Lua total sums the five script medians.

| Text padding | SQLite user cycles, base → head | Lua user cycles, base → head |
| --- | ---: | ---: |
| 0 B | 1,048.41M → 1,051.36M (+0.28%) | 1,614.46M → 1,626.14M (+0.72%) |
| 16 B | 1,045.67M → 1,047.87M (+0.21%) | 1,612.21M → 1,610.70M (−0.09%) |
| 32 B | 1,035.14M → 1,035.49M (+0.03%) | 1,632.58M → 1,628.82M (−0.23%) |
| 48 B | 1,034.42M → 1,034.38M (≈0%) | 1,613.01M → 1,609.50M (−0.22%) |

SQLite retired roughly 4,429.4M user instructions per placement on both revisions. The Lua aggregate instruction change ranged from −0.13% to +0.06%.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
