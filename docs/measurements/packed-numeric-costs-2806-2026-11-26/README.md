# Ryzen 7 9700X packed FMA and conversion costs

The [Benchpress job](https://github.com/buster14a/buster/actions/runs/45803041317/job/139850946925) measured all 40 register forms requested by [buster PR 3643](https://github.com/buster14a/buster/pull/3643). Each form yielded a complete cost row.

| Forms | Count | Latency, cycles | Reciprocal throughput, cycles per instruction |
| --- | ---: | ---: | ---: |
| Packed FMA | 10 | 4 | 0.5 |
| Packed signed and unsigned conversions | 30 | 3 | 0.5 |

The measurement executable uses main at `5ce76f08c` and the two measurement fixture files from PR head `3f48dfb75`. The job inserts 40 empty rows in its checkout, builds Release for `znver5` with official Clang 23.1.4, and runs `measure-x86-zen5 --missing --table` on CPU 2 under the runner's shared host lock. Each experiment uses seven passes, 10,000 iterations per pass and a 240-operation block. The compiler hash, source hashes and toolchain identity are in `identity.txt`. The raw output is in `measurement.txt`, and `cost-rows.txt` contains the 40 selected table rows.

This run establishes the instruction costs. The PR still needs a compiler build and correctness checks with those rows installed.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
