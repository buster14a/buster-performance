# Opus 1.5.2 with all 27 compiler changes

The main and integrated compilers each built the complete portable (137 objects) and dispatched (152 objects) Opus libraries for x86-64-v3 and znver5. Each target used distinct base and candidate archives. Across seven audio profiles, their encoded packets were identical and their decoded audio samples matched exactly, including packet loss. All [30 upstream API, extension, padding, encoding and decoding checks](official-results.tsv) passed using the x86-64-v3 libraries.

The local Ryzen 9 7940HS ran the generated programs. Each of 112 target-specific encoder cells and 112 decoder cells used four entry placements, two library configurations, seven audio profiles and seven post-warm-up pairs. This produced 3,584 timed processes with an output hash verified on every run. All 112 encoder comparisons retired fewer instructions. The cycle comparison was favorable in 73 of 112.

| Target | Operation | Counter | Lower medians | Range across medians |
|---|---|---|---:|---:|
| x86-64-v3 | encode | instructions:u | 56 of 56 | -2.637% to -0.600% |
| x86-64-v3 | encode | cycles:u | 38 of 56 | -3.912% to +1.174% |
| x86-64-v3 | decode | instructions:u | 56 of 56 | -0.415% to -0.001% |
| x86-64-v3 | decode | cycles:u | 30 of 56 | -1.289% to +1.474% |
| znver5 | encode | instructions:u | 56 of 56 | -2.637% to -0.600% |
| znver5 | encode | cycles:u | 35 of 56 | -5.003% to +0.826% |
| znver5 | decode | instructions:u | 40 of 56 | -0.415% to +0.000% |
| znver5 | decode | cycles:u | 25 of 56 | -1.043% to +1.294% |

[Object text sizes](library-sizes.tsv), [x86-64-v3 results](x86-64-v3/), [znver5 results](znver5/) and [reproduction harness](harness/). The common reference for packet and audio comparisons used the Clang x86-64-v3 library. The Clang znver5 binary selected a VEX VPDPWSSD instruction unavailable on the local host. Its [diagnostic](clang-zen5-local.log) is retained; both Buster target builds executed locally.
