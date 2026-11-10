# Parallel native generation (#2058): 9700X build-time A/B, 2026-11-10

Build times of buster with the two longest units' native code generated in parallel parts
(buster#2058), against the same tree generated whole, on the Ryzen 7 9700X (`benchpress`). It
also covers PR #2056's own review A/B (base `39506e86` against `fa6254e0`). This record contains
the measurements only; the design is in buster's `docs/commands/build.md`, "Parallel native
generation".

## Trees

Each measured tree is a `git worktree` of buster at the named commit. The parallel-generation trees
had the branch's commits applied with `git am`, so their commit ids differ from the session's; the
tree hashes (`trees-and-binaries.txt`) identify them. Only the final version is published: buster
branch `claude/build-parallel-native-2058` at
[`23ef5fb3`](https://github.com/buster14a/buster/commit/23ef5fb34f612384b2c47138d3ba8847e6b92cf6).
That is the measured `split5-d35d3d1e` tree rebased onto main `5b194875` (#2056 merged with
#2059). It differs from the measured tree only in #2059's eight CI and documentation files, none
of them a build input. The intermediate versions' ids (`600292da`, `5ba4c141`, `b9e947dd`) name
unpublished commits.

| Directory | Contents | Tree |
|---|---|---|
| `base-39506e86` | main before #2056 | — |
| `head-fa6254e0` | #2056's head before its review fixes | — |
| `head2-cd920bf1` | #2056's merged head | — |
| `split-600292da` | first version: 8 parts, forward-moved boundaries | `48ec0037` |
| `split3-5ba4c141` | 14 balanced parts with the symbol fix | `4a8842af` |
| `split4-b9e947dd` / `split4p8-b9e947dd` | explicit-only dependencies, 14 and 8 parts | `53149bbf` (+ part count) |
| `split5-d35d3d1e` | the final branch on `cd920bf1`: 8 parts | `d35ec047` |

## Method

- Every run is one `./build.sh` (Release, `-march=native`, `-g`, `build.sh`'s default jobs: 8, one per physical core), timed inside the host lock by `scripts/runN.sh` under `~/buster-fast-bench/exclusive.sh`, one hold per build. The queue scripts (`scripts/queue*.sh`) alternate the sides' order in each round.
- **Clean** means `rm -rf build` and then the build, configure included.
- **Edit** cases in queues 2 to 5 append an emitted function (`__attribute__((used)) static int buster_ab_probe…`) to the named file in an up-to-date tree, the same edit on both sides. Queue 1 (#2056's review) only touched the file.
- Each result line is `case tree round wall user system rc=`, from bash's `time` (seconds), followed by `build.sh`'s summary.
- The runtime check is the compiler's own `time-runs`, pinned to CPU 2: `-c sqlite3.c` and `-fsyntax-only main_unit_checker.c`, in a Williams order.

## Host

`host.txt`: Linux 6.18.50-2-lts, clang/LLD 23.1.1, CMake 4.4.4, Ninja 1.13.2, 15 online CPUs (CPU 10 offline), 64 GB.

## Results (medians of 3)

Final branch (`split5-d35d3d1e`) against #2056's merged head (`head2-cd920bf1`), `results5.txt`, with ranges:

| Case | #2056 (`cd920bf1`) wall | Parallel parts wall | Speedup | #2056 CPU | Parallel parts CPU |
|---|---:|---:|---:|---:|---:|
| Clean build | 100.3 s (100.1–100.6) | 72.8 s (72.6–73.1) | **1.38×** | 421 s | 466 s |
| Edit `main.c` (all eleven units) | 96.2 s (96.2–97.0) | 69.0 s (69.0–69.1) | **1.39×** | 292 s | 334 s |
| Edit `c_check_input.c` (checker) | 90.5 s (90.5–90.7) | 62.7 s (62.6–62.7) | **1.44×** | 91 s | 117 s |
| Edit `tier0.c` (checker, backend) | 93.0 s (92.9–93.6) | 66.0 s (65.9–66.1) | **1.41×** | 173 s | 216 s |

Earlier queues, same host: `results2.txt` (first version against `fa6254e0`: clean 73.6 s against 100.4 s), `results3.txt` (14 parts: clean 75.2 s), `results4.txt` (explicit-only dependencies: 14 parts 74.0 s, 8 parts 73.1 s), and `results.txt` (#2056's review: `39506e86` against `fa6254e0`). Runtime: `runtime/runtime3-time-runs.txt` (14 parts, pristine: −0.13% `-c sqlite3.c`, −0.21% `-fsyntax-only`) and `runtime/runtime-time-runs.txt` (first version: +0.02%, +0.33%).

## Code identity

`identity.txt` compares the final pristine executables `compare/head2-pristine` and `compare/split5-pristine` (znver5, 8 parts, SHA-256 in `trees-and-binaries.txt`): `.rodata` 256 bytes longer, `.eh_frame` 16. Every function symbol has the same address and size, and the `.text` instruction streams are identical. They differ only in RIP-relative displacements to moved `.rodata`, in two immediates holding `.eh_frame`'s address, and in the padding between parts (`int3` instead of `nop`).

## Limitations

- **Lock receipts:** the scripts didn't record the holder line for each run. The runs went through `exclusive.sh`, whose owner file showed them while they ran, but this record holds no per-run receipt.
- **The edits accumulate:** each round appended another function, so the head tree in queues 2 to 4 also carried the earlier queues' probes. Queues 3b and 5 restored both trees (`git checkout -- src`) before their pristine builds.
- **One lost line:** queue 2's first head clean build lost its result line, because its run script was replaced mid-run. Its `.time` file (`logs/2-fresh-head-fa6254e0-1.time`, 100.490 s) keeps the value.
- **Queue 4 was stopped early:** it was drained after its clean builds by replacing `run4.sh` with a no-op (atomic rename). Its rebuild cases weren't measured.
