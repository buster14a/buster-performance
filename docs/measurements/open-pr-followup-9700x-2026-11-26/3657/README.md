# Ryzen 7 9700X measurements for PR 3657

[3657](https://github.com/buster14a/buster/pull/3657) at `b256b16e2918c801f53b287b58c95d13f0214c1b` versus merge base `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.239 → 15.172 ms (-0.44%) | 75.5M → 75.3M (-0.26%) | Match |
| --no-direct | 112.511 → 112.441 ms (-0.06%) | 546.3M → 545.7M (-0.11%) | Match |

One native `tests/ci/nightly-observe.sh` run passed 429 optimized checks and 429 ASan/UBSan checks, plus the mocked API collector and workflow fixtures. The whole command took 6.933 s task-clock and 33.861B user cycles, including native C compilation and child processes. GCC 16.2.1 built the observer test binaries. Benchpress used its libarchive tools for the test fixture ZIP files. The fixtures ran against the mocked API.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
