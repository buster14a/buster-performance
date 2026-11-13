# Sanitizer builds' native code in parts (#2639): 9700X, 2026-11-13

Build times of buster's sanitizer builds (`BUSTER_SANITIZER=address|thread|memory`,
`BUSTER_SANITIZER_OPTIMIZATION=3`) whole, as main builds them, and with the checker's and backend's native code
generated in parallel parts, as Release's is (buster#2639), on the Ryzen 7 9700X (`benchpress`). The design is in
buster's `docs/commands/build.md`, "Parallel native generation", "In sanitizer builds"; this record holds the
measurements, the scripts that took them and the checker unit's profile.

## Trees

| Directory on benchpress | Commit | Role |
|---|---|---|
| `~/buster-fast-bench/2639-claude/src` | main `26f0bb0e` | the whole builds (`base-*`, `trace-*`, `hosted-base-*`, `hosted4-base-*`, `cores4-base-*`, `release-g0-main`) |
| `~/buster-fast-bench/2639-claude/split` | `0a7d9450` | the first split builds (`split-*`) and their comparison (`identity-*`) |
| the same worktree | `0f0a468d` | `release-g0-split`, `hosted-split-*`, `hosted4-split-*`, `cores4-split-*`, `final-split-*`, `final-identity-*`, `final-sections` |

`0a7d9450` is the branch's first commit; `132a7f7a` changed no behavior (a loop's exit, comments); `954db1d5` kept
the parts' merge flags where the final link merges them, after `identity-*` found the split executables 548 KB
larger; `0f0a468d` made the comdat restorer sort its signatures (its 4.0 s of the ASan join, `startup-timing`).

## Method

- Every run is one hold of the host lock through `~/buster-fast-bench/exclusive.sh`, by the scripts in
  `9700x/scripts/` (`queue*.sh` ran them one after another, a hold each). Each run's directory has the lock's
  receipt (`exclusive.stderr`: the holder it waited for, `exclusive.sh`'s busy-process lines, none here, and the
  exit), and `before.txt` and `after.txt` (load and the busiest processes). `queue5c.sh` was stopped after its first
  run (`cores4-base-x86-64-memory`); `queue5d.sh` ran the rest.
- **Clean builds** (`build-clean.sh`): `rm -rf build/cmake/native-SANITIZER-O3`, then
  `BUSTER_HOST_ARCH=native BUSTER_SANITIZER=SANITIZER BUSTER_SANITIZER_OPTIMIZATION=3 ./build.sh`: Release,
  `build.sh`'s default 8 jobs, wild linking. `time.txt` is bash's `time`; `steps.txt` each Ninja step's duration,
  start and end, from `ninja_log` (`ninja-units.sh`); `memory.txt` the memory in use (MemTotal - MemAvailable) each
  second and `memory-peak.txt` its peak (the later runs). `base-memory` also set `BUSTER_DEBUG_INFO=1`, as the issue's
  command did; it changes no sanitizer build (below).
- **Traces** (`trace-unit.sh`): the checker unit's compile command from the whole tree's compile database, alone,
  pinned to CPU 2, with `-ftime-trace -ftime-trace-granularity=500 -ftime-report`. `summary.txt` is
  `trace-summary.py`'s reading of `trace.json.xz`.
- **Hosted-shaped builds** (`hosted-build.sh`): the merge queue's hosted runner is an AMD EPYC 9V45 (Zen 5) with 4
  vCPUs as 2 cores of 2 threads, where `build.sh` runs 2 jobs (job 131922187378's host report, below). These builds
  are pinned to the 9700X's cores 4 and 5, both threads (`taskset -c 4,12,5,13`), so `build.sh` and the splitter see
  the same shape.
- **Identity** (`identity.sh`, `functions-delta.py`): each sanitizer's whole and split executables' function
  symbols (address, size, name) and `.text` instructions, without addresses, symbol names and RIP-relative
  displacements, as the Release record `build-parallel-native-2026-11-10` compared them.

## Host

`9700x/host.txt`: Linux 6.18.50-2-lts, clang, LLD and LLVM 23.1.1, CMake 4.4.4, Ninja 1.13.2, 15 online CPUs (CPU 10
offline), 64 GB.

## Results

### The 9700X's 8 jobs (clean builds)

| Sanitizer | Whole (`base-*`, main) | Parts, first (`split-*`, `0a7d9450`) | Parts, final (`final-split-*`, `0f0a468d`) |
|---|---:|---:|---:|
| memory | 346.5 s (user 1194.8 s) | 193.5 s (1348.0 s) | **188.7 s** (1346.2 s) |
| address | 282.7 s (1041.6 s) | 206.5 s (1146.4 s) | **199.6 s** (1129.3 s) |
| thread | 117.4 s (432.8 s) | 81.6 s (472.7 s) | **81.5 s** (471.1 s) |

The longest unit, the checker's, whole and as the parts' chain in the final builds (`final-split-*/ninja_log`:
its bitcode compile, the split, its longest part, the join):

| Sanitizer | Whole | Bitcode + split + longest part + join |
|---|---:|---:|
| memory | 345.7 s | 130.5 + 11.4 + 45.2 + 0.7, done at 187.8 s |
| address | 281.3 s | 162.4 + 9.0 + 24.7 + 1.8, done at 197.9 s |
| thread | 116.7 s | 66.5 + 3.4 + 10.4 + 0.3, done at 80.5 s |

The first ASan join took 7.2 s: `startup-timing/join-steps.txt` timed its steps, 4.0 s of them the comdat restorer's
lookups (`0f0a468d` sorts them), 0.7 s `readelf` of the data part's 157,920 sections and 1.0 s of `BusterCodegenMerge`'s
loop over them (`merge-timing/flags-timing.txt`; a link that merges, wild's, skips both since `954db1d5`). Peak memory
over the build's start (`memory-peak.txt`): 17.9 GB for MSan and 15.1 GB for ASan, at the checker's split (a child per
part), 4.2 GB for TSan.

### The hosted runner's shape

The merge queue's runners are AMD EPYC 9V45s (Zen 5) with 4 vCPUs as 2 cores of 2 threads and 16 GB (job
131922187378's host report: `cpu 0's core's threads: 0-1`). `tools/ci/hosted-product.sh` builds the rows' products
with `./build.sh --config Release --jobs "$(nproc)"`, 4 jobs; plain `build.sh` there would run 2.

| Shape | Build | Whole (main) | Parts (`0f0a468d`) |
|---|---|---:|---:|
| 2 cores of 2 threads, 4 jobs (CI's) | x86-64 MSan | 314.8 s (user 851.5 s) | **258.2 s** (999.7 s), -18% |
| | vector ASan | 365.3 s (1315.7 s) | 367.1 s (1382.0 s), +0.5% |
| 2 cores of 2 threads, 2 jobs (`build.sh`'s default) | x86-64 MSan | 312.7 s (619.2 s) | 324.5 s (649.7 s), +3.8% |
| | vector ASan | 437.3 s (863.0 s) | 447.5 s (893.8 s), +2.3% |
| 4 cores of 1 thread, 4 jobs | x86-64 MSan | 266.9 s (658.6 s) | **186.5 s** (715.0 s), -30% |

With 2 jobs on 2 cores the build is bound by its work (user time over 2 is its wall time), which the parts raise by 5%
to 10%; with 4 the x86-64 MSan build is bound by the checker's compile, which hyper-threading slows (261.4 s with 2
jobs, 314.2 s with 4) and the parts shorten. The vector ASan build stays bound by its work: its benchmark units, which
no test runs, are 29% of its units' compile time (387.4 of 1324.0 s with 4 jobs; 1% in the x86-64 builds, whose scalar
host leaves their kernels out). Peaks over the start stayed under 8.6 GB.

### The checker unit alone (`trace-*`)

On CPU 2, `-ftime-report`'s "Clang time report" (seconds):

| Sanitizer | Whole | Front end and IR generation | Optimizer | Code generation |
|---|---:|---:|---:|---:|
| memory | 318.0 | 6.8 | 86.5 | 224.6 (71%) |
| address | 253.0 | 8.7 | 113.3 | 131.0 (52%) |
| thread | 112.0 | 6.6 | 50.6 | 54.9 (49%) |

The sanitizer passes themselves: MemorySanitizerPass 2.0 s, AddressSanitizerPass 2.9 s, ThreadSanitizerPass 0.4 s.
MSan's code generation: the greedy register allocator 50.2 s, instruction selection 34.2 s, `Live DEBUG_VALUE
analysis` 30.3 s (the line tables'; 16.9 s for ASan, 6.0 s for TSan). No function dominates (`summary.txt`: the
costliest, `tier1_emit_cfg_records`, 6.1 s of MSan's), and parsing every definition takes 2 s.

### Identity

`identity-*` compared the first split executables (`0a7d9450`) with the whole ones: every function symbol in the
same order with the same size (`functions-delta.txt`), the `.text` instruction streams the same but for the padding
between parts (`int3` for `nop`), and every function moved by one amount, 561,152 bytes (MSan) and 548,864 (ASan):
`sections/size-differences.txt` has `.rodata` 546,656 to 565,004 bytes larger, the strings of the split units that
other units repeat, which the join had kept from wild's merge. `954db1d5` keeps the parts' merge flags for a link that
merges; `final-identity-*` compares the final executables.

`final-identity-*` compares the final executables (`0f0a468d`): every function symbol in the same order with the same
size, each moved by one amount, -65,536 bytes (MSan), -49,152 (ASan) and -45,056 (TSan), with `.rodata` 66,360,
49,704 and 45,632 bytes shorter: the relocatable link merges the parts' identical constants, which the single
object's link kept apart. The `.text` instructions are the same but for the padding between parts and, in ASan's
fixed-address executable, the absolute addresses of the moved data (`mov $0xcecc560` for `mov $0xced8560`, 0xc000
apart).

### Release

`release-g0-main` and `release-g0-split`: `BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0 ./build.sh`, main and
`0f0a468d`: the same executable, SHA-256 `2ef8f43a3a0e944df52fcac959f1c1be1b731944bd5277ccbd9bfc3d22fffbc4`, 69.5 s both.

### Debug information and the post-link step

`BUSTER_DEBUG_INFO` changes no sanitizer build: `./build.sh print-compile-flags` gives the same flags with 0 and 1
(`-gline-tables-only` either way) and the tree is the same (`native-SANITIZER-O3`). The post-link step, the bake
(ASan's fixed-address executable alone) and the canary check, took 0.4 to 1.0 s (`steps.txt`'s `compiler`); 4.4 s in
`split-memory` was not the executables' start: `startup-timing/startup.txt` has `bake-tables` at 0.13 s and
`test-baked-tables` at 0.37 s for both, five rounds each.

## Limitations

- **One build each.** Every configuration was built once (the split ones twice, at two commits); the rounds would take
  hours of the shared lock. The differences reported are many times the first and final split builds' spread (0.1 to
  7 s).
- **The hosted shape is the 9700X's.** Its cores clock higher than the EPYC 9V45's (the runner's x86-64 MSan build, 4
  jobs, took 405.1 s against the 4-job shape's 314.8 s), but the shape, the microarchitecture and the job counts are
  the runner's.
- **The sanitizer rows' tests** didn't run here: the merge queue's candidate of buster#2647 runs every row.
- **`base-memory`** ran an earlier `build-clean.sh` (with `BUSTER_DEBUG_INFO=1` and no memory sampler); the other
  baselines and splits the version here.
