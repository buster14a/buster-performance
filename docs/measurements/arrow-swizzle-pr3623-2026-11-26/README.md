# Arrow swizzle compile measurement on the Ryzen 7 9700X

[PR 3623](https://github.com/buster14a/buster/pull/3623) at `9fb162a9` compared with merge base `8e4d3287`. Both Release builds target `znver5` and use official Clang 23.1.4. The frozen SQLite amalgamation's default `-c` was measured for 41 interleaved runs on CPU 2 under the shared Benchpress lock.

| Median | Base | Head |
| --- | ---: | ---: |
| Wall ms | 15.318 | 15.272 |
| User cycles | 76,478,207 | 76,374,406 |
| User instructions | 196,847,334 | 196,847,591 |
| Minor faults | 349 | 347 |

The default compile moved −0.30% in wall time and −0.14% in user cycles, with +257 retired instructions. The workload covers the whole compile and does not isolate checker arrow lookups. The per-run observations are in `sqlite.txt`.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
