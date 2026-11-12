# Tier 1's truth values, stored constants, identities and computed-goto dispatch (#2554)

Measured 2026-11-12 for [buster#2554](https://github.com/buster14a/buster/issues/2554) by one agent session (lock
owner `claude-2554`), on the Ryzen 7 9700X (`benchpress`), every build, compile and timed run inside its own hold of
`~/buster-fast-bench/exclusive.sh`, the workloads pinned to CPU 2, in a directory of its own
(`~/buster-fast-bench/2554-claude/`). The counts come from callgrind in the session's cloud container, run on the
9700X's own executables through the 9700X's own loader and C library, as #138's record ran them.

The work is the branch `claude/cool-gauss-t84hk1` of buster: five commits on main `624f1be4`, each measured as a
build of its own.

| Build | Commit | What it adds |
| --- | --- | --- |
| `main` | `624f1be4da6d8a557d3212b09f3ac7ba71e0a995` | the base |
| `identity` | `a9cd6f49e21be3c5ba01096c1747521163b9f6a8` | identities forwarded by the optimizer (`x >> 0`, `x * 1`, ...) |
| `store` | `cdf8fcf23bc419492c8595e32d8a3c307ac4bbdf` | a stored constant as the store's immediate |
| `dispatch` | `6ddf69beaf399e5b0c771e8a9077726d0ae49eb0` | a jump to a computed goto's dispatch block takes a copy of its indirect jump |
| `head` | `564ad3ab9a35ce3462533536907d8f1730890549` | truth values' blocks threaded into their predecessors, and the tests and docs |
| `head2` | `b46a110c88de558773e66af41e4b00584a67a97a` | `head` with the threading's escape scan's vector path: the same code, its own compile time |

`head` and `head2` compile speedtest1 and Lua into the same code: their objects' `.text` is the same bytes
(`9700x/results/head*-builds.sha256` differ only by the unity file's path, which each object's file symbol names), so
the timed runs and the counts of `head` are `head2`'s too, and `head2` (the branch's head before main was merged)
has its own compile time, verification and profile. A first head, `bc04331e5e8c506d6baf3512adcba4302f691a3f`, built a
CFG for every function with a loop and ran a second round of the threading wherever the first changed something; its
compile time (+0.78% cycles on speedtest1's `--tier1 -c`) and profile led to `head`, and its data are in
`9700x/results-first-head`.

`head` and the first head were amended before the branch was pushed, so their commits exist nowhere else: each is the
pushed `head2` with `scripts/head-from-head2.patch` or `scripts/first-head-from-head2.patch` applied (`git diff` of
`ir_thread.c` alone). Each tree is `git archive` of its commit, sent by tar (`src-NAME.commit` in `9700x/builds`); `main-kinds` and
`head-kinds` are main's and head's trees with #138's record's `kinds-instrumentation.patch` (#1189's origin tags),
built with `BUSTER_TIER1_MEASURE_KINDS`, whose executables' `.text` is the timed builds' byte for byte
(`9700x/results/kinds-*/identity-programs.txt`).

## What is here

| Path | Contents |
| --- | --- |
| `scripts/` | every script that ran: `host.sh`, `build.sh`, `programs.sh` (the placements), `oracle.sh` (clang -O2's Lua and the scripts' expected outputs), `runs.sh` (the timed runs), `compile.sh` (compile time), `verify.sh` (`--verify`'s certification), `profile.sh` (perf's cycles by symbol), `test.sh` (`head2`'s tests on the 9700X, its escape scan's vector path), `kinds-build.sh` and `kinds.sh` (the tagged builds), `cg9.sh` and `count9.sh` (callgrind and the counts, in the container), `tables.sh`, `lock.sh`, `tools/proto_table.py` (#138's record's) and `tools/compile_table.py` |
| `9700x/` | the 9700X's `results/`: `host.txt` (host, governor, tools, every compiler's and input's SHA-256), `holders.txt` (the lock's holder line at each run), placements' digests and `--tier1-report`s, `checks.txt`, `runs.tsv`, `compile*.tsv`, `verify-*`, `profile-*`, `test-head2.txt` and the tagged builds' identities; `builds/` the builds' logs and commits; `results-first-head/` the first head's. The lock's own messages, which name other sessions, are left out (their wrapper logs are not here) |
| `callgrind/NAME/` | each build's callgrind runs (`runs.txt`: instructions, speedtest1's verification hash, each script's output's MD5), its executables' digests, and `patterns.py`'s counts: `*.patterns` without origin tags, `*-tagged.patterns` with them (main and head, whose `*.kinds.gz` are the tags) |
| `tables/` | the tables below, as the scripts print them |

The inputs are #138's record's: the frozen `sqlite3.c` (the host's corpus copy), SQLite 3.53.2's `test/speedtest1.c`,
Lua 5.4.8's release and the five scripts of the `cc3387f` record, each by its SHA-256 (`9700x/host.txt`).

## The patterns (#138's record's `scripts/tools/patterns.py`)

Callgrind's exact counts of the programs' own code, speedtest1 with #136's options and Lua's five scripts summed,
joined to the disassembly by #1189's `gap.c` (`GAP_INSTRUCTIONS=1`) with the tagged builds' origin tags
(`callgrind/{main,head}/*-tagged.patterns`). Each count is the instructions a fix would remove, as the issue counts
them.

| Pattern | speedtest1, main | head | Lua, main | head |
| --- | ---: | ---: | ---: | ---: |
| a constant made, then tested and branched on | 51.5 M | 5.3 M | 69.6 M | 23.2 M |
| `setcc` in one block, `test` and branch on it in the next | 22.4 M | 1.8 M | 65.9 M | 14.3 M |
| a jump to a jump | 0.47 M | 0.52 M | 55.1 M | 0.01 M |
| a shift by zero | 0.17 M | 0 | 56.4 M | 0 |
| a constant put in a register for the next instruction's store | 31.4 M | 2.8 M | 37.2 M | 0.1 M |
| the program's own instructions | 3,077.1 M | 2,878.2 M | 5,483.4 M | 5,134.9 M |

Every build's speedtest1 gives the verification hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`, and
every build's scripts print clang -O2's output (`9700x/checks.txt`, `callgrind/*/runs.txt`).

By commit, the program's own instructions (`callgrind/NAME/*.patterns`' totals, without tags):

| Build | speedtest1 | step | Lua | step |
| --- | ---: | ---: | ---: | ---: |
| `main` | 3,077.06 M | | 5,483.41 M | |
| `identity` | 3,076.59 M | -0.47 M | 5,418.59 M | -64.82 M |
| `store` | 3,046.75 M | -29.84 M | 5,383.60 M | -34.99 M |
| `dispatch` | 3,046.75 M | 0 | 5,335.66 M | -47.94 M |
| `head` | 2,878.21 M | -168.54 M | 5,134.90 M | -200.76 M |

- speedtest1 has no computed goto (its dispatches are switch tables), so the dispatch copy leaves it unchanged.
- The jumps to a jump left on speedtest1 rose by 0.06 M, in `sqlite3VdbeExec`, whose blocks the threading moved.
- What is left of the truth values on Lua is mostly `luaV_execute`'s arithmetic: `tonumberns`'s `?:` leaves a block
  whose phis are the converted number as well as the truth value, and the number is read after the test, which the
  threading doesn't follow (it would need the successor to merge the number again).

## Run times over placements (`9700x/results/runs.tsv`, `tables/runs.txt`)

`runs.sh 11 main identity store dispatch head`, in one hold of the lock: every build's executables checked first
(speedtest1's hash at its eight placements, 40 lines with the one hash, and each script's output in its four link
orders against clang -O2's, 100 "same" lines, in `checks.txt`), then one untimed warm-up and 11 rounds, every placement's builds back to back in an
order alternating by round and placement, each run under `perf stat` pinned to CPU 2. speedtest1 is one object linked
after 0, 528, ..., 3,696 bytes of nops (eight placements), Lua an object per unit linked in four rotations of its unit
list, as #138's record placed them; `tools/proto_table.py` gives 100 ln(variant / base) of user cycles with a 95%
interval over the placements' means (the one to quote) and over all pairs. All 1,540 timed runs exited 0.

Against main:

| Build | speedtest1 cycles | 95% over placements | faster at | Lua cycles | 95% over placements | faster at |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `identity` | -0.03 | -0.95 to +0.88 | 4 of 8 | -0.95 | -3.24 to +1.34 | 3 of 4 |
| `store` | +0.19 | -0.47 to +0.84 | 3 of 8 | -1.76 | -5.06 to +1.53 | 3 of 4 |
| `dispatch` | +0.36 | -0.32 to +1.04 | 2 of 8 | -5.27 | -8.68 to -1.86 | 4 of 4 |
| `head` | **-4.44** | -5.16 to -3.73 | 8 of 8 | **-8.61** | -10.43 to -6.79 | 4 of 4 |

Each step against the build before it:

| Step | speedtest1 cycles | 95% over placements | faster at | Lua cycles | 95% over placements | faster at |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| identities (`identity` / `main`) | -0.03 | -0.95 to +0.88 | 4 of 8 | -0.95 | -3.24 to +1.34 | 3 of 4 |
| stored constants (`store` / `identity`) | +0.22 | -0.43 to +0.87 | 2 of 8 | -0.81 | -2.02 to +0.39 | 3 of 4 |
| dispatch copies (`dispatch` / `store`) | +0.17 | -0.29 to +0.63 | 3 of 8 | -3.51 | -7.49 to +0.48 | 4 of 4 |
| threading (`head` / `dispatch`) | **-4.80** | -5.38 to -4.22 | 8 of 8 | **-3.34** | -6.19 to -0.49 | 4 of 4 |

- Medians over all placements and rounds: speedtest1 932.0 M user cycles by main, 890.8 M by head (185.2 ms and
  177.9 ms); Lua's five scripts 1,224.8 M and 1,122.4 M (224.0 ms and 205.7 ms).
- The two steps that change control flow, the dispatch copies and the threading, are faster at every placement of
  the program they change. speedtest1 has no computed goto, and its dispatch step is placement noise around zero.
- Lua has only four placements, so its intervals over placements are wide; its intervals over pairs are in
  `tables/runs.txt`.

## Compile time (`9700x/results/compile*.tsv`, `tables/compile.txt`)

`compile.sh 11 main head2`: each build's `--tier1 -c` of speedtest1's unity file and of `lvm.c`, and its default
`-c` of the unity file, under `perf stat` on CPU 2, one warm-up and 11 rounds alternating the builds' order.

| Input | Mode | main | head2 | cycles, 100 ln(head2 / main) | 95% |
| --- | --- | ---: | ---: | ---: | ---: |
| speedtest1 | `--tier1` | 399.5 ms, 2,117.4 M cycles | 400.0 ms, 2,121.0 M cycles | +0.18 | +0.05 to +0.30 |
| `lvm.c` | `--tier1` | 26.2 ms, 110.7 M cycles | 26.3 ms, 111.1 M cycles | +0.46 | +0.30 to +0.63 |
| speedtest1 | default | 127.1 ms, 620.4 M cycles | 126.8 ms, 618.5 M cycles | -0.29 | -0.44 to -0.14 |

- The default `-c` writes the same object by both builds (`compile-objects.sha256`): its difference is noise.
- `--tier1` runs 2.6% fewer instructions on speedtest1 (4,771.1 M against 4,897.5 M) but 0.2% more cycles. perf's
  profile (`profile-*.txt`, five runs each) gives the threading pass (`ir_thread_round`) 1.7% of head2's cycles; the
  rest of the pipeline has less to do. In the first head the pass was 2.2%: a third of it the scan of every operand
  for the candidates' values' uses and a third the rewrite. `head` builds no CFG for a function whose only candidates
  are loops' headers and runs a second round only where the first left a candidate to it (+0.43% on speedtest1,
  `compile-head.tsv`), and `head2` gives that scan a vector path, 16 instructions at a time.

## Certification and tests

- `verify.sh`: `--tier1 --verify` certifies the same functions by main and head2: speedtest1 2,187 certified and 74
  uncertified, Lua 865 and 46 (`verify-*.txt`). The computed goto's function is uncertified by main too.
- `test.sh head2` on the 9700X (the vector paths): `test-ir-optimize` (271,490 checks), `test-tier1-select`,
  `test-tier1-emit`, `test-tier1-pipeline --cross-check` and the #2554 and #1218 driver regressions, all passing
  (`test-head2.txt`).

## Limits

- The counts are callgrind's of placement 0's executables; each program's code is the same at every placement.
- Lua's own instruction total moves by a few M between runs: its string hash is seeded by the time and by addresses.
- The timed runs are 11 rounds of 8 and 4 placements in one hold of the lock; a placement's rounds are not
  independent draws of a layout, which is why the intervals over placements are the ones quoted.
