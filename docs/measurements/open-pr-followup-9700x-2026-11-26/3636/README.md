# Ryzen 7 9700X measurements for PR 3636

[3636](https://github.com/buster14a/buster/pull/3636) at `77607826575680271bac679655a274b9da0522ea` versus merge base `8e4d32879e17b7d9548cad54257a2f8461328366`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.304 → 15.247 ms (-0.37%) | 76.5M → 76.3M (-0.26%) | Match |
| --no-direct | 112.583 → 112.654 ms (+0.06%) | 546.0M → 545.3M (-0.13%) | Match |

A single native `test-checker-driver --missing-variable-only --in-process` run passed 1,822 checks and all 27 diagnostic fixtures, with zero differences from the Clang reference. The sample took 741.03 ms task-clock and 1,956.08M user cycles, including the reference child processes.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
