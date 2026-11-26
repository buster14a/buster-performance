# Ryzen 7 9700X measurements for PR 3650

[3650](https://github.com/buster14a/buster/pull/3650) at `48bb25c4267da0b7652392b606fdfb92f326c03b` versus merge base `8e4d32879e17b7d9548cad54257a2f8461328366`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.315 → 15.246 ms (-0.45%) | 76.6M → 76.3M (-0.39%) | Match |
| --no-direct | 112.350 → 112.523 ms (+0.15%) | 548.2M → 547.8M (-0.07%) | Match |

Single native `test-calling-convention` samples passed on both revisions. The base passed 807,342 counted checks at 161.42 ms task-clock and 835.68M user cycles. The head passed 808,879 checks at 161.10 ms and 833.23M user cycles. The head included 55,063 builtin-row and 4,398 fixture checks, up from 54,133 and 3,791. The two test counts differ.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
