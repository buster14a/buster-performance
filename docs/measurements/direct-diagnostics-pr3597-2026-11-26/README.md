# Current-head direct diagnostics on the Ryzen 7 9700X

[PR 3597](https://github.com/buster14a/buster/pull/3597) at `dc5a2c04` compared with its merge base `74eacd47`. Both compilers used official Clang 23.1.4, Release, and `BUSTER_HOST_ARCH=znver5`. The repository's `measure-compile` recorded 41 interleaved runs of default `-c` on the frozen SQLite amalgamation. The runs were pinned to CPU 2 under the shared Benchpress lock.

| Median | Base | Head |
| --- | ---: | ---: |
| Wall ms | 15.170 | 16.551 |
| User cycles, M | 75.5 | 83.7 |
| User instructions, M | 195.8 | 218.8 |
| Minor faults | 352 | 357 |

Wall time rose 9.10%. The result measures the current PR tree after the [earlier round 17](https://github.com/buster14a/buster-performance/tree/db4e6cf0b4344ba82883914996afb4039b366a03/docs/measurements/direct-diagnostics-3577-2026-11-25/round17). Output hashes and the full per-run observations are included.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
