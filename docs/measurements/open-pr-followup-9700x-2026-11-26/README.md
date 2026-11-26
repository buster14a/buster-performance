# Ryzen 7 9700X follow-up for open Buster PRs

The Release compilers were built with Clang 23.1.4 for Zen 5. Compile and runtime measurements ran on Benchpress, pinned to CPU 2 under the shared host lock. Each PR record identifies the measured head and base, the frozen inputs and flags, and the results. The scripts are captured alongside the records and the per-PR archive contains the raw counter samples, identity, checksums, and logs.

The SQLite compile workload is the same frozen amalgamation for every row. The default path and selected second compiler mode each use 31 interleaved pairs. Wall times and counters are per-process medians. Focused fixture and runtime rows identify their individual sample counts.

---
Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
