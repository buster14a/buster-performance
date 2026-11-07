# Tier 1 scheduling on Zen 5: run time against compile time (2026-11-07)

The evidence for [buster#172](https://github.com/buster14a/buster/issues/172): whether scheduling Tier 1's code
pays on the Ryzen 7 9700X, after register allocation (`--tier1-schedule=post`) and before selection
(`--tier1-schedule=pre`). By Claude, at David's request ([the session](https://claude.ai/code/session_01NNmNQv7fsoBhfDEj53FCG7)).
Buster's [`docs/tier1-scheduling.md`](https://github.com/buster14a/buster/blob/claude/dazzling-dijkstra-bvs874/docs/tier1-scheduling.md)
has the variants' design, the tables and the decision; this record holds what made them.

**Result:** neither variant pays. `post` leaves both programs' run times unchanged within noise (speedtest1 +0.19%,
Lua's five scripts +0.18% [−0.01, +0.37] over eight link orders) and adds 3% to 6% to the compiles. `pre` takes 1.9%
[1.5, 2.3] off Lua's scripts over eight link orders, nothing measurable off speedtest1 (+0.6% in its one layout), and
adds 4% to 7% to the compiles.

## Host, compiler and inputs

- **Host:** `benchpress`, the Ryzen 7 9700X, Linux 6.18.50-2-lts. Every step under `~/buster-fast-bench/exclusive.sh`,
  each step taking the lock on its own; every timing pinned to CPU 2 (`taskset -c 2`).
- **Compiler:** Buster's tree `54489389612e10875c9f7a4221e8ebe027cec932`: `main` `53854a7c` with the branch's commits
  `07a751dc` (the variants) and `99b77890` (the harnesses' `--variant`), applied there by `git am` as `bddb7def` and
  `d46a37b6` (`9700x/runs/commit.txt`; same tree). The branch's later commits change no generated code (docs, a test,
  the preallocation pass's name and its `--verify` copy). Built by `./build.sh` with `BUSTER_HOST_ARCH=znver5
  BUSTER_DEBUG_INFO=0` (`9700x/runs/build.txt`; the executable's SHA-256 in `9700x/runs/compiler.sha256`), with the
  host's clang 23.1.1, which also builds the clang -O0/-O2 references and links the relinked Lua executables.
- **Inputs**, #1189's:
  - the frozen `sqlite3.c`, SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, the 9700X's
    `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite`;
  - SQLite 3.53.2's `test/speedtest1.c` at `ccc132c5`, `b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675`,
    with #136's flags and options and `speedtest1-unity.c` as `measure-tier1-programs` writes it;
  - Lua 5.4.8 (`lua-5.4.8.tar.gz`, `4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae`) and the
    `cc3387f` record's five scripts, from `tier1-reciprocal-141-2026-11-01/9700x/lua` here.

## Method

`tools/run.sh` (its last two steps rerun by `tools/compile-pre.sh`: `run.sh` stopped after measuring Lua's `post`
compile, before writing that step's status line) and `tools/layouts.sh`; their logs are `9700x/run-*.log`.

1. **Correctness and counts** (`9700x/runs/report-*.txt`): speedtest1 and Lua compiled with `--tier1
   -fno-asynchronous-unwind-tables --tier1-report --verify --tier1-schedule=none|post|pre`, which checks every scheduled
   block against its scalar reference (`tier1_schedule_verify`, `tier1_schedule_ir_verify`) and every frame against the
   emission's verifier; `size` of each executable. `test-tier1-schedule` passes (`9700x/runs/test-tier1-schedule.txt`).
2. **Run time, one layout** (`9700x/runs/programs-{1,2,3}.txt`): three processes of `measure-tier1-programs --runs 21
   --variant --tier1-schedule=post --variant --tier1-schedule=pre`, each with Tier 0, `--tier1`, clang -O0 and -O2
   and the two variants. Every build gives speedtest1's verification hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`,
   and every script's output by every build is clang -O0's. `tools/paired.c` (`cc -O2 -o paired paired.c`; `./paired tier1
   variant1 programs-*.txt`) pairs each round's variant run with its `--tier1` run of the same program: `9700x/paired-post.txt`
   and `9700x/paired-pre.txt` give each process's median ratio, and over the 63 rounds the median and the 2.5th and
   97.5th percentiles of the per-round ratios (a spread of single rounds, not an interval of the median).
3. **Run time, eight layouts of Lua** (`9700x/layouts/`), as Buster's `docs/commands/profiling.md` asks for a change
   that moves code: Lua's 33 units compiled once by each variant (`-c`), linked by clang in the Makefile's order and seven
   permutations from fixed seeds, the same for every variant (`order-*.txt`, recorded before any timing; the objects' and
   executables' hashes in `binaries.sha256`). All 24 executables print `lua-none-0`'s output for every script
   (`check.txt`). Then `time-runs --runs 11 --warmups 1` of each script over the 24 executables (`time-*.txt`).
   `tools/layouts.c` (`cc -O2 -o layouts layouts.c -lm`; `./layouts none pre time-*.txt`) gives, per script and for
   their sum, the mean over the orders of the paired log ratios of the medians, with a 95% Student's t interval over the
   eight independent orders, and the range (`9700x/layouts-post.txt`, `9700x/layouts-pre.txt`).
4. **Compile time** (`9700x/runs/compile-*.txt`): `measure-compile --runs 11 --variant --tier1-schedule=V` of speedtest1's
   `-c` compile and of Lua's whole command, each against the same compiler without the option.

## Results

What moved:

| | `--tier1` | `post` | `pre` |
| --- | ---: | ---: | ---: |
| speedtest1: records | 310,550 | 310,550, 48,581 moved in 30,666 blocks | 311,481 (248,675 IR instructions moved) |
| speedtest1: spill stores / reloads, edge moves | 13,928 / 17,232, 46,804 | the same | 13,919 / 17,404, 46,753 |
| speedtest1: text bytes | 1,328,967 | 1,328,967 | 1,331,895 |
| Lua: records | 61,486 | 61,486, 9,724 moved in 6,042 blocks | 61,468 (46,842 IR instructions moved) |
| Lua: spill stores / reloads, edge moves | 889 / 1,018, 4,499 | the same | 884 / 1,021, 4,450 |
| Lua: text bytes | 257,028 | 257,028 | 255,044 |

Run time against `--tier1`, user cycles:

| | `post` | `pre` |
| --- | ---: | ---: |
| speedtest1, one layout, median of 63 paired rounds | 1.0019 | 1.0063 |
| Lua's scripts, one layout, median of 63 paired rounds | 0.9968 | 0.9852 |
| Lua's scripts, eight layouts, mean [95%] | +0.18% [−0.01, +0.37] | −1.90% [−2.26, −1.53] |
| — calls | −0.02% [−0.95, +0.92] | −1.36% [−2.18, −0.54] |
| — tables | −0.36% [−0.85, +0.14] | −2.04% [−3.28, −0.78] |
| — strings | +0.31% [−0.01, +0.63] | +0.54% [+0.26, +0.82] |
| — arithmetic | +0.79% [+0.54, +1.04] | +0.08% [−1.32, +1.51] |
| — closures | +0.09% [−0.38, +0.57] | −5.27% [−6.71, −3.82] |

speedtest1 ran `pre`'s 0.41% more instructions (3,576.4 M against 3,561.7 M); Lua's scripts about as many (0.1% more;
Lua's string hashes are seeded per process, so its counts vary a little from run to run). `post` permutes records
inside blocks only, so its executables keep every function's and block's size and place, and its one-layout figures
need no other layout. `pre` changes sizes; speedtest1 is one translation unit, whose function order no link changes
and Buster's driver refuses `-ffunction-sections`, so its `pre` figure is a single layout's.

Compile time, medians of 11 on CPU 2:

| | `--tier1` | `post` | `pre` |
| --- | ---: | ---: | ---: |
| speedtest1 `-c` | 426.7 ms (426.2 in `pre`'s run) | 450.0 ms (+5.5%) | 456.2 ms (+7.0%) |
| Lua, 33 units linked | 158.1 ms (158.5) | 162.7 ms (+2.9%) | 164.7 ms (+3.9%) |

## Limits

- Zen 5 only, as the variants' weights are (the measured `x86_zen5.c` rows, class weights elsewhere): another core
  needs its own model and measurement.
- speedtest1's `pre` comparison is one layout; #1450 measured layout alone moving Lua by up to 1.5%.
- The relinked Lua executables are linked by clang from separate objects, unlike `measure-tier1-programs`' one-command
  builds; single scripts differ between the two (`arithmetic` by `pre`: −3.7% in every one-layout process, +0.1% over
  the eight orders), the sums agree.
