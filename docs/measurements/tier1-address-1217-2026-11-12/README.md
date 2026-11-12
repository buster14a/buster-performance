# Tier 1's address arithmetic against clang -O2 (#1217), 2026-11-12

This is the evidence for [buster#1217](https://github.com/buster14a/buster/issues/1217)'s acceptance and for [buster#2572](https://github.com/buster14a/buster/pull/2572). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01EgbxndCyWpFg1feNbcGfjY)).

It has three parts:
- dynamic instruction counts by callgrind, in a cloud container;
- run time on the Ryzen 7 9700X;
- compile time on the 9700X.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `33f3f442a1115ef969256ffef77c34af0c3799b9` | buster's main when the work began |
| head | `c5e6920b4f1f27ca1d9591a51216c32b58353c7d` | buster#2572: in-place adds, unread block entries, earlier blocks' addresses |

## Inputs

The inputs are #1189's ([`tier1-gap-1189-2026-11-03`](../tier1-gap-1189-2026-11-03/README.md)):
- the frozen `sqlite3.c` (SHA-256 `0a409f16…`), from `ci-corpora-preprocessor-391e729af658` by `tools/ci/fetch-corpus.sh`;
- SQLite's `test/speedtest1.c` at `ccc132c5` (`b5eaf4bb…`), with #136's flags and options;
- Lua 5.4.8's release (`4f18ddae…`) and the `cc3387f` record's five scripts.

`scripts/inputs.sha256` has their hashes.

The programs are built as `measure-tier1-programs` builds them (`scripts/build.sh`):
- Tier 1: `--tier1 -fno-asynchronous-unwind-tables`, at the default target (no `-march`). speedtest1 is one unity translation unit, and Lua is one command of its 33 sources.
- clang -O2: an object of each of `sqlite3.c` and `speedtest1.c`, then a link.

## 1. Dynamic instruction counts

**Host.** A cloud container: an Intel Xeon with AVX-512 under KVM, Ubuntu, clang 23.1.6, valgrind 3.22.0, GNU objdump 2.42. Each compiler was built there natively (Release, `BUSTER_DEBUG_INFO=0`).

**Compilers' SHA-256:**
- main: `3204419c…`;
- head: `43156396…`, built from `c5e6920b`'s tree.

The measured head programs came from the same production sources before the commit added its tests and documentation (compiler `12b0ae9c…`). The final compiler's speedtest1 and Lua executables are byte-identical to them.

**Counting.** `scripts/count.sh` runs each program once under callgrind (`--dump-instr=yes`):
- speedtest1 from a fresh database in `/dev/shm`;
- each Lua script from the scripts' directory.

#1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (SHA-256 `81856ce1…`, last changed at buster-performance `6508e5bf`) then joins the counts with `objdump -d --no-show-raw-insn`'s disassembly, as `GAP_INSTRUCTIONS=1 gap count DIS CG OBJECT BASE`:
- Tier 1's executables are object `???` at base `0x108000`;
- clang's are their own path at base 0.

`#check unmatched` was at most 4,454 instructions of a run.

**Classifying.** `scripts/acc.sh` sums gap's per-instruction (`#ins`) rows:
- **non-frame `lea`:** gap's type `lea`, an operand not based on `rsp`. Neither side makes `rbp` a frame pointer, as #1189's record shows;
- **frame `lea`:** type `lea_stack`;
- **power-of-two `imul`:** an `imul` whose immediate is a power of two.

`scripts/self.sh` splits the `lea`s by shape. `scripts/deadlea.py` estimates statically which `rip`- and `rsp`-based `lea`s are overwritten before any read (analysis only).

**Checks.** `counts/*/check-*.txt` has each run's exit status and speedtest1's verification hash, `1248168 a7fa3957…` by every build. Every Lua script's output was the same by every build.

**Retained.** `counts.tar.zst` holds each run's TSV: gap's per-function rows, with only the `lea`, `lea_stack` and `imul` instruction rows (the executables and their full disassemblies would carry SQLite's and Lua's code). `counts/*/instructions-*.txt` has each whole process's count.

### Results

| | main | head | clang -O2 | head / -O2 |
| --- | ---: | ---: | ---: | ---: |
| speedtest1, non-frame `lea` | 182.2 M | 123.7 M | 88.8 M | 1.39 |
| Lua's scripts, non-frame `lea` | 311.5 M | 216.7 M | 148.8 M | 1.46 |
| speedtest1, `imul` by a power of two | 2.1 M | 2.1 M | 0 | |
| Lua's scripts, `imul` by a power of two | 0 | 0 | 0 | |
| speedtest1, frame `lea` | 60.2 M | 55.6 M | 7.0 M | |
| Lua's scripts, frame `lea` | 112.0 M | 89.3 M | 4.0 M | |
| speedtest1, whole process | 3,258.8 M | 3,249.8 M | 2,028.9 M | 1.60 |
| Lua's scripts, whole process | 6,069.3 M | 5,970.7 M | 4,207.4 M | 1.42 |

**Against #1189's record.** clang -O2's non-frame `lea`s are its corrected figures exactly, and its whole processes nearly so (2,028.9 M; 4,207.4 M against 4,208.1 M).

**The non-frame `lea`s by shape** (`scripts/self.sh`, main / head / clang -O2, M):

| Shape | speedtest1 | Lua's scripts |
| --- | --- | --- |
| `lea c(%r),%r`, in place | 57.4 / 0 / 0.4 | 52.3 / 0 / 0 |
| base + displacement | 41.4 / 40.9 / 23.4 | 101.0 / 96.4 / 73.8 |
| `rip`-relative | 60.0 / 59.1 / 34.3 | 68.8 / 68.8 / 16.6 |
| scaled index (2, 4, 8) | 1.2 / 0.9 / 14.8 | 11.7 / 11.7 / 19.7 |
| base + index | 22.1 / 22.8 / 15.9 | 77.7 / 39.9 / 38.7 |

**What remains:**
- **`disptab`.** Of Lua's `rip`-relative `lea`s, 55.1 M are `luaV_execute`'s `disptab` at every dispatch; clang has 7.6 M ([buster#2574](https://github.com/buster14a/buster/issues/2574)).
- **Globals.** Of speedtest1's, about 15 M address globals that clang reads through a `rip`-relative operand ([buster#2573](https://github.com/buster14a/buster/issues/2573)).
- **`sqlite3BtreeIndexMoveto`.** Its two `imul $2`s run 1,037,030 times each.

**Noise.** Lua seeds its string hash from `time()` and code addresses. `luaH_getshortstr`'s count therefore moves by a few million between builds and runs: 6.5 M on `closures.lua` between two builds whose code differed only in `lea`/`add` forms.

## 2. Run time on the 9700X

`scripts/run1217.sh` ran on benchpress under its lock: each step and each run is one hold, every run pinned to CPU 2.

**Builds.**
- Each compiler is built in a tree of its own at its commit, by `./build.sh` with `BUSTER_DEBUG_INFO=0`, at the host's native target (znver5).
- Lua's 33 objects come from each compiler's `--tier1 -c`.
- The objects are linked by `cc` in six orders (`9700x/orders.txt`): order 0 is the usual one, and the others are `shuf`'s with fixed seeds, the same orders for both builds.
- speedtest1 is built as above, so it has a single layout.

**Checks before any timing.**
- Every Lua executable printed clang -O0's output for every script.
- Both speedtest1 builds gave the verification hash.

**Timing.** Eleven rounds. In each, every order's two Lua builds ran all five scripts, and speedtest1's two builds ran once. The builds' order rotated by round and order. Each run is one `perf stat` of task-clock, user cycles and user instructions (`9700x/runs.txt`); `scripts/analyze.py` makes `9700x/analysis.md`.

### Lua's five scripts over six layouts

Each layout's medians, summed over the scripts:

| Metric | head / base, mean over the layouts | 95% interval over the layouts |
| --- | ---: | ---: |
| time (task-clock) | 0.9927 | 0.9847 to 1.0008 |
| user cycles | 0.9926 | 0.9839 to 1.0013 |
| user instructions | 0.9821 | 0.9818 to 0.9823 |

By layout, the time ratios are:
- 0.9864, 0.9901, 0.9867, 0.9932, 1.0074, 0.9925.

By script, the medians of the layouts' medians are:
- `calls` 0.9824, `tables` 1.0132, `strings` 0.9862, `arithmetic` 0.9710, `closures` 0.9939.

The head is faster in five of the six layouts. Its gain, 0.7%, is within the layouts' spread: the interval includes no change.

### speedtest1

One layout, eleven pairs.

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time (task-clock), ms | 226.76 | 226.42 | 0.9985 | 0.9996 (0.9745 to 1.0176) |
| user cycles, M | 937.62 | 936.69 | 0.9990 | 0.9990 (0.9933 to 1.0201) |
| user instructions, M | 3,208.32 | 3,199.34 | 0.9972 | 0.9972 |

run1217.sh kept speedtest1's database on `/home`. That is encrypted and was 99% full, so the journal's syncs made speedtest1's wall time about 2.2 s for every build, clang's included: see `9700x/measure-tier1-programs-home.log`. Its task-clock and user counters above are the process's own. `scripts/rerun1217.sh` measured speedtest1 again with its files in `/tmp` (tmpfs), as the 9700X job keeps them, and then ran `measure-tier1-programs` there (below).

### speedtest1 with its files in `/tmp`

`scripts/rerun1217.sh` ran the same two executables after the compile-time runs: one warm-up pair, then 11 pairs, alternating, one lock hold each, CPU 2. The data is `9700x/st-tmp-runs.txt`, analyzed in `9700x/analysis-st-tmp.md`.

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time (task-clock), ms | 185.30 | 185.12 | 0.9990 | 0.9995 (0.9915 to 1.0186) |
| user cycles, M | 931.98 | 930.36 | 0.9983 | 0.9981 (0.9927 to 1.0088) |
| user instructions, M | 3,208.31 | 3,199.33 | 0.9972 | 0.9972 |

### Against clang -O2

`measure-tier1-programs` ran by the head with `--directory /tmp`, as the 9700X job's step runs it (`9700x/measure-tier1-programs-tmp.log`). It used clang 23.1.1 and no tcc, with 11 rounds and a warm-up, every output checked first.

| Program | Tier 0 | `--tier1` | clang -O0 | clang -O2 | `--tier1` / clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: |
| speedtest1, ms | 253.5 | 185.8 | 296.4 | 130.1 | 1.43 |
| speedtest1, user cycles, M | 1,309.2 | 936.3 | 1,541.3 | 629.5 | 1.49 |
| speedtest1, instructions, M | 5,673.5 | 3,199.3 | 3,921.8 | 2,009.9 | 1.59 |
| Lua's five scripts, ms | 336.7 | 224.7 | 374.3 | 165.7 | 1.36 |
| Lua's five scripts, user cycles, M | 1,850.1 | 1,227.5 | 2,046.7 | 900.7 | 1.36 |
| Lua's five scripts, instructions, M | 10,776.6 | 6,007.1 | 8,331.9 | 4,284.9 | 1.40 |

#1189's record, at `730eea0a` on 2026-11-03, had `--tier1` at 1.60× clang -O2's time on speedtest1 and 1.56× on Lua's scripts. That difference is everything merged since, not this change alone. The first run's `measure-tier1-programs-home.log` used `/home`, whose syncs made speedtest1 take about 2.2 s by every build. Its user counters agree with these.

## 3. Compile time on the 9700X

### The first attempt

`scripts/compile1217.sh` timed `--tier1 -c` of the frozen sqlite3.c (with speedtest1's flags) and `--tier1` of Lua's 33 sources into an executable, by main's and the head's compilers. It used 11 rounds, one warm-up each, CPU 2, one hold per run, writing to `/home`. That disk was 100% full at times during the run, and some writes failed:
- sqlite3.c's rounds 5, 6 and 11 are missing from `9700x/compile-runs.txt`, and rounds 7 to 10 have no counters;
- one Lua run has no counters;
- its log lost a line, and `lua outputs CHANGED` is the Lua executable written over a failed run.

Its complete pairs already showed the head's cost:
- sqlite3.c: 5,267.0 M to 5,352.0 M user instructions (+1.6%), about +1.7% in time;
- Lua: +0.35% in instructions.

### Where the cost was

`compile-callgrind/` holds callgrind's counts of `--tier1 -c sqlite3.c` (whole-process instructions in `totals.tsv`, per-function self-cost differences in `delta-base-*.tsv`). They come from baseline-ISA builds (`BUSTER_HOST_ARCH=x86-64`), since valgrind can't run the native AVX-512 build. Each ran with `ulimit -v 67108864`, so that each arena reserves a 128th of that, which valgrind accepts.

| Compiler | Instructions | Against main |
| --- | ---: | ---: |
| main | 15,736.4 M | |
| head `c5e6920b` | 15,818.4 M | +82.0 M |
| with the fix (`871285fd`'s sources) | 15,758.5 M | +22.0 M |

**The cause.** At the head, `tier1_cfg_interval_entry` cost 96.8 M, against −24.0 M in `tier1_cfg_allocate_impl`, where the plain lookup it replaced ran before. It searched each live value's fragment twice at every block entry, and was outlined whole.

**The fix,** [buster `871285fd`](https://github.com/buster14a/buster/commit/871285fdf9bcf9a2fc976d8f9b9e40aa44cc9671):
- the entry lookup searches once and keeps only the cheap test inline;
- the sinkable marks became two OR-ed bits per node in the plan's existing use count.

**What's left** of the +22.0 M: selection's marks 13.2 M, the CFG's entry test 5.6 M, emission 1.9 M and the longer address walks 1.4 M. The object file is byte-identical across every version of the fix, as are speedtest1's and Lua's executables.

### Measured again

`scripts/compile2.sh` repeated the measurement with every output and `perf`'s report in `/tmp`, for three compilers: main, the head and the fix (`HEAD2=871285fd`, built in its own tree on benchpress, then removed). It ran 11 rounds after one warm-up of each, with the three in rotating order, one hold per run, CPU 2. All 72 runs counted, and every output was the same in every round (`9700x/compile2-runs.txt`, `compile2.log`).

| Compile | main | head / main | fix / main | fix's paired ratios, median (range) |
| --- | ---: | ---: | ---: | ---: |
| sqlite3.c, time | 423.29 ms | 1.0174 | 1.0000 | 1.0006 (0.9965 to 1.0024) |
| sqlite3.c, user cycles | 2,249.55 M | 1.0184 | 1.0001 | 1.0001 (0.9972 to 1.0024) |
| sqlite3.c, user instructions | 5,267.00 M | 1.0161 | 1.0040 | 1.0040 |
| Lua, time | 169.64 ms | 1.0111 | 1.0025 | 1.0027 (1.0018 to 1.0044) |
| Lua, user cycles | 832.05 M | 1.0121 | 1.0028 | 1.0033 (1.0015 to 1.0041) |
| Lua, user instructions | 2,022.00 M | 1.0059 | 1.0017 | 1.0017 |

**What reached main.** [buster#2572](https://github.com/buster14a/buster/pull/2572) merged at `c5e6920b`, before `871285fd` reached it. The fix follows in a pull request of its own.

## Reproducing

**The counts.** With a scratch directory `S` that holds:
- `corpus/sqlite/sqlite3.c`;
- `inputs/speedtest1.c`, `inputs/lua-5.4.8` and the five scripts;
- `gap`, built from `tier1-gap-1189-2026-11-03/tools/gap.c` by `cc -O2`.

Then, for each compiler and clang (this record's runs had `S=/home/user/work1217`):
- `scripts/build.sh COMPILER OUT t1`, or `scripts/build.sh - OUT clang2`;
- `scripts/count.sh OUT t1` or `scripts/count.sh OUT clang2`;
- then `scripts/acc.sh` over a program's TSVs.

**The 9700X runs.** `BASE=... HEAD=... scripts/run1217.sh`, then `scripts/compile1217.sh`, `scripts/rerun1217.sh` and `HEAD2=... scripts/compile2.sh`, each in `~/buster-fast-bench/1217-claude` with `inputs/` beside them. After `rerun1217.sh`, both compilers were kept as `bin/compiler-base` and `bin/compiler-head`, and the trees removed, since `/home` was full.

**The compile-time profiles.** `ulimit -v 67108864; valgrind --tool=callgrind COMPILER --tier1 -fno-asynchronous-unwind-tables FLAGS -I SQLITE -c -o OUT sqlite3.c`, with each compiler built by `BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh`. Then `callgrind_annotate --inclusive=no`.

**Lock messages.** These logs are the scripts' own lines. No lock-waiting message (another session's command) is published: the logs were checked for them.
