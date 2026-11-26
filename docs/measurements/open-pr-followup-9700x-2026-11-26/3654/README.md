# Ryzen 7 9700X measurements for PR 3654

[3654](https://github.com/buster14a/buster/pull/3654) at `424417e5c33d0aa9c671ec0e530a75f2c6529cf5` versus merge base `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.233 → 15.179 ms (-0.35%) | 75.7M → 75.6M (-0.13%) | Match |
| --no-direct | 112.607 → 112.631 ms (+0.02%) | 547.5M → 546.9M (-0.11%) | Match |

The base and head each passed 90,698 checks in one native `test-checker --part 6/8` sample. Task-clock was 35.277 s on the base and 35.203 s on the head, and user cycles were 168.814B and 168.582B.

The head's black-box runtime fixture contract passed all 128 checks. Its one sample took 10.969 s of task-clock and 32.653B user cycles, including child compilers and the private fixture trees.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
