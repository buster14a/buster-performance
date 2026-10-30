# SSA on real and generated C, Buster #134

Compiler branch: `claude/solve-134-bf1918` of buster14a/buster, for
[this claim on #134](https://github.com/buster14a/buster/issues/134#issuecomment-6525332011).

The branch adds `test-ssa-source`, #134's acceptance on C programs. Each
function `-c` compiles is promoted by both of `ssa_ir.c`'s paths with `ssa_verify`'s
checks, and each program with a `main` runs in its three IR forms (every local in
memory and each path's SSA), which must agree and give the expected output.
`benchmark-ir-source` also reports each promotion path's phis.

This record holds:

- the acceptance runs on the 9700X: c-testsuite's subset, the frozen
  `sqlite3.c` and musl's units, 48 generated programs, and the tests the change
  touches;
- #134's third "Done when" item, cycles per IR instruction for each path with
  each path's phis on `sqlite3.c`'s functions, measured main against head;
- the runs on a Zen 4 laptop the 9700X didn't repeat: Lua 5.4.8, 1,000
  generated programs and four mutants of the compiler that the command must
  reject.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on
the 9700X with a `COMMIT` file added. `logs/9700x/manifest-*.sha256` lists every
file's SHA-256 as the host had it after the runs. Both lists match `git archive`
of each commit file for file, but `COMMIT`:

- **main:** `caef4ea2cd1f47311842b2c1a4f87e55f14c29ea` (810 files);
- **head:** `12bf987ae3514fe2dcdc4170e937590b8b62b949` (812 files), the branch
  after merging that main.

Host (`logs/9700x/host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang
23.1.1, CPU 2's governor and energy preference `performance`. Builds:
`BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh`, both 34.7 s, the backend's unit,
which compiles the new command, 30.1 s against 29.9 s
(`logs/9700x/build-*.log`). `logs/9700x/executables.sha256` gives the
executables' SHA-256.

Inputs (`logs/9700x/inputs.sha256`): the frozen corpora that
`tools/ci/fetch-corpus.sh` fetches and verifies (manifest
`391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd`); SQLite's
`sqlite3.c`, SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`,
with the 9700X job's options (its pinned predefines and headers,
`-std=gnu17 -march=znver5`); and c-testsuite at
`5c7275656d751de0e68b2d340a95b5681858ed07`.

`scripts/queue134.sh` ran every step, each build, test and benchmark run in a
separate hold of the host's lock (`exclusive.sh`). The tests ran on CPUs 0 to 7
and the benchmark pinned to CPU 2. The lock's waiting messages are left out of
the logs: only the lines `build.sh`, the compiler and the script print are kept,
by an allowlist of their shapes. The script's step timer needed `bc`, which the
host lacks, so the logs give no step times.

## Acceptance on the 9700X

| Run (`logs/9700x/`) | Result |
| --- | --- |
| `ssa-source-subset`: c-testsuite's 220 programs | 430 functions, 140 / 140 phis, 220 of 220 programs as expected in all three forms |
| `ssa-source-sqlite`: frozen `sqlite3.c` | 2,602 functions, 598,425 IR instructions, 6,097 / 6,097 phis, no failure |
| `ssa-source-musl`: musl's 1,355 units (305 left out by name) | 1,918 functions, 2,777 / 2,777 phis, no failure |
| `ssa-source-generated`: 48 generated programs (seed 134) | 288 functions, 36,381 / 36,381 phis, 48 of 48 programs as clang's build |
| `test-ssa`, `test-ssa-ir`, `test-ir-interpreter`, `test-interpreter`, `test-interpreter-native`, `test-interpreter-link`, `test-ir-lowering` | 2,871, 3,730, 819, 662, 42, 33 and 757,450 checks, none failed |
| `test-ir-source` on c-testsuite's subset and `sqlite3.c` | every function lowered, agreeing and promoted |
| `call-graph` (`./build.sh check-call-graph`) | 41 units, 0 cycles but the 3 allowed, 0 split variables |

## Promotion on `sqlite3.c`'s functions

`benchmark-ir-source` with the job's options, `taskset -c 2`. Six rounds alternate
which tree runs first (`bench-R-TREE.log`). Each run reports 21-pass medians over
the 2,602 functions: 396,928 typed entries and 598,425 lowered IR instructions.
Below are the medians of the six runs' medians, with their ranges:

| Variant | main ns/entry | head ns/entry | change | main cycles/IR instruction | head cycles/IR instruction | phis |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `promote` (vector path) | 141.10 (141.00–141.22) | 141.32 (141.25–141.69) | +0.16% | 518.67 | 519.50 | 6,097 |
| `promote-scalar` | 141.49 (141.39–141.57) | 141.04 (140.85–141.30) | −0.32% | 520.12 | 518.50 | 6,097 |
| `lower` | 46.05 | 46.13 | +0.17% | 169.23 | 169.57 | |
| `lower-scalar` | 46.88 | 46.81 | −0.15% | 172.32 | 172.10 | |
| `verify` | 22.12 | 22.11 | −0.05% | 81.33 | 81.16 | |
| `verify-scalar` | 20.84 | 20.94 | +0.48% | 76.64 | 76.88 | |

User instructions per typed entry: `promote` 2,167.90 on main against 2,167.97
on head (+0.003%), and `promote-scalar` 2,236.75 against 2,236.80: the
promotion's two new tests of its verifier argument, null for both. The time
changes are within the rounds' spread. The lowering and the verifiers are unchanged code, so their
±0.5% bound the placements' effect. The phis are head's report, which
`benchmark-ir-source` gains here, and main's promotions make the same IR
(493,552 promoted instructions on both).

After 200 ms of scalar work before each pass (`--only promote --after-scalar 200`,
`bench-after-R-TREE.log`, three rounds): `promote` took 140.93, 141.17 and 141.23
ns per entry on main, against 140.84, 141.16 and 141.31 on head.

A promotion here is the whole of `ssa_ir_promote`: the input's verification,
CFG and classification, the shared dominance analysis, construction and
cleanup, the IR's rebuild, and both IR verifiers on the output. The two paths
make the same phis on every function of the corpora (`test-ssa-source`'s totals).
Both constructors' results go through the same trivial-phi and redundant-cycle
cleanup.

## Local runs (`logs/local/`)

A Zen 4 laptop (Ryzen 9 7940HS), clang 23.1.4, a build of the branch shortly
before its first commit `1070b96a`, which differs from it only in failure
messages and bounds checks that passing runs don't reach:

| Run | Result |
| --- | --- |
| `subset2`: c-testsuite's subset | as on the 9700X |
| `sqlite`, `musl` | as on the 9700X |
| `lua`: Lua 5.4.8's 32 files but `lua.c` and `luac.c` (`-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`) | 1,059 functions, 1,126 / 1,126 phis, no failure |
| `gen1000`: 1,000 generated programs (seed 7) | 6,000 functions, 27,737,466 IR instructions, 835,918 / 835,918 phis, 1,000 of 1,000 programs as clang's build |

Mutants (`scripts/mutants.sh`, `scripts/mutants2.sh`): each a copy of the tree with one
defect, built and run on 16 generated programs (seed 3) and c-testsuite's subset
without 8 queens, where `test-ssa-source` must fail:

| Defect | Caught by |
| --- | --- |
| phi operands written in reverse order (`ssa_ir_fill`) | the IR's dominance checks: 94 of 96 generated functions, 46 of c-testsuite's |
| the scalar constructor ignores a second write to a local in one block | `ssa_verify`'s "read is not the current local value": 39 and 35 functions |
| the same, with `ssa_verify` disabled too | the runs, whose scalar form's output or status differs from the memory form's: 16 of 16 programs, 27 of c-testsuite's |
| an unsigned `>>` lowered as an arithmetic shift (`ir_lower.c`) | the expected output (the three forms agree): 4 of 16 programs, 1 of c-testsuite's |

## Limitations

- The benchmark times the default (production) promotions only. `test-ssa-source`'s
  verified promotion, which takes the vector constructor past #787's cutover and
  runs `ssa_verify`, is a test and isn't timed.
- Interpreter steps (`test-ssa-source`'s `steps=` columns) count IR instructions
  and phis the interpreter executed: a measure of the forms' work, not a time.
- The comparison with Tier 1's compiled code, #134's remaining item, isn't here:
  Tier 1 doesn't compile general CFGs and phis yet (#138).
