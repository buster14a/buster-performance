# Ryzen 7 9700X measurements for PR 3655

[3655](https://github.com/buster14a/buster/pull/3655) at `954a7c01f46bfa0f71111a7a526704ac5d4bb6a0` versus merge base `5ce76f08c3ce7ed298009437d699bbc9c90471a4`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.281 → 15.217 ms (-0.42%) | 75.5M → 75.1M (-0.53%) | Match |
| --no-direct | 112.402 → 112.568 ms (+0.15%) | 543.9M → 544.5M (+0.11%) | Match |

Single native correctness samples on the exact head passed all 126 `format_matches` checks (146.16 ms task-clock, 419.91M user cycles) and all 60 invalid-record checks (67.70 ms task-clock, 208.71M user cycles). The in-process Buster checker used Clang child processes as its reference. The separate hosted vector and integration qualification jobs were still failing when this measurement was published. [Hosted run](https://github.com/buster14a/buster/actions/runs/45798171048)

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
