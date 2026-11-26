# Memory value numbering compile cost on the Ryzen 7 9700X

[PR 3622](https://github.com/buster14a/buster/pull/3622) head `e5cff9f6` compared with merge base `8e4d3287`. Both compilers were built as Release for `znver5) using official Clang 23.1.4. The frozen SQLite amalgamation was compiled with `--tier1-passes=+memory` on CPU 2 under the shared Benchpress lock. The 21 interleaved runs completed successfully. The compilers emitted byte-identical objects.

| Median | Base | Head |
| --- | ---: | ---: |
| Wall ms | 625.605 | 624.340 |
| User cycles, M | 3,367.4 | 3,360.3 |
| User instructions, M | 7,648.3 | 7,649.9 |

Wall time and user cycles moved by about −0.2%. `compile.txt` contains the full interleaved record.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
