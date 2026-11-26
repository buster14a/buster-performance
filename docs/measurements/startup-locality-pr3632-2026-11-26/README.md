# Compiler startup locality on the Ryzen 7 9700X

The [Benchpress job](https://github.com/buster14a/buster/actions/runs/45804061307/job/139854533635) compared [PR 3632](https://github.com/buster14a/buster/pull/3632) at `170b82de` with merge base `8e4d3287`. Both compilers were built as Release for `znver5` with official Clang 23.1.4. Each workload used 41 interleaved runs on CPU 2 under the shared host lock. The base and head emitted byte-identical object files for all four workload and mode pairs.

| Workload | Median wall ms, base → head | Median minor faults, base → head |
| --- | ---: | ---: |
| Single-function C input, default | 0.261 → 0.319 | 182 → 210 |
| Single-function C input, `--no-direct` | 0.494 → 0.457 | 279 → 248 |
| Frozen SQLite, default | 15.260 → 15.249 | 351 → 341 |
| Frozen SQLite, `--no-direct` | 112.713 → 112.708 | 4,870 → 4,823 |

SQLite wall time moved by less than 0.1% in both modes. The tiny workload's direct and full paths moved in opposite directions. These are whole-process wall times and fault counts. The full per-run observations, including user cycles and instructions, are in the four paired logs. Executable file-backed collapse requires a separate mapping observation.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
