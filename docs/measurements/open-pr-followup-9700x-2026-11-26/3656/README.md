# Ryzen 7 9700X measurements for PR 3656

[3656](https://github.com/buster14a/buster/pull/3656) at `b5173a16957f9ff2afff543e869816027a9640aa` versus merge base `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 16.196 → 16.137 ms (-0.36%) | 76.2M → 76.3M (+0.13%) | Match |
| Tier 1, -O2 -march=znver5 | 605.097 → 601.015 ms (-0.67%) | 3,256.0M → 3,233.3M (-0.70%) | Differ |

Five alternating compile pairs per fixture size with strict Tier 1 and machine verification. At 64 scopes, both builds passed. The head used 13.01M vs 16.56M median user cycles (−21.41%) and 42.05M vs 59.51M user instructions (−29.35%).

At 1,536 scopes, the base failed all five runs with an emission resource failure at CFG allocation. The head passed all five without fallback at a median 261.63M user cycles and 56.25 ms of task-clock. The successful Tier 1 report recorded a 40-byte frame, zero spill slots, and one certified function.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
