# Tier 1's literal pool on the compiler's own lexer (buster#2744)

14 and 15 November 2026. [buster14a/buster#2794](https://github.com/buster14a/buster/pull/2794), #2744's step 2: a
Tier 1 vector constant that no broadcast makes is one rip-relative load of a literal in the unit's `.rodata.cst16`,
`.cst32` or `.cst64` pool, instead of its words stored below rsp and a load no store forwards to. Against buster main
`1935a91fbd07b6fec0f6d651c9649bb7f9ef4d3a`; the branch's measured head is `5e33fe81db6ca38fe2683208976177c7843dc342`
(its later commits, `747b169` and `2b3c5c4`, change comments and Tier 0's window path alone). And step 3's first
piece, measured and not proposed: splats as memory broadcasts of 4- and 8-byte literals (`step3.patch`,
`step3-broadcasts-605badc.patch`).

## Every instruction counted

`c_tokenize` of the lexer program on the 1344 record's 9,076-byte file (`mid200.c` in
[`tier1-vector-lexer-breakdown-1344-2026-11-14`](../tier1-vector-lexer-breakdown-1344-2026-11-14)), one call,
single-stepped with that record's `stephist.c` in the session's virtual machine (no counters there); classified by its
`annotate.py` and `runs.py` (`results/mid200-*.summary.txt`, `.runs.txt`, `.hist`). The programs are
`measure-tier1-rows --lexer`'s builds at `-march=native` on the VM's AVX-512 host.

| Build | instructions | per byte | immediate stores below rsp | stack-built vectors' loads | literal loads |
| --- | ---: | ---: | ---: | ---: | ---: |
| clang -O2 | 27,785 | 3.06 | | | |
| `--tier1`, main `1935a91` | 112,174 | 12.36 | 28,458 | 4,906 | 0 |
| `--tier1`, step 2 (`5e33fe8`) | 92,357 | 10.18 | 8,641 | 3,154 | 1,752 |
| `--tier1`, step 3 (broadcasts) | 89,427 | 9.85 | 8,641 | 3,154 | 1,752 |

Every immediate store below rsp left after step 2 is a zero fill (`runs.py`: runs of eight quadword zeros before a
vector or an object's write, an initializer's clear, #2745's kind); none is a constant. Step 3 removes the 2,930
`mov r11, imm` of the splats, each broadcast now reading its literal. The lexer unit's object by `-march=znver5`: 9,545
immediate stores below rsp on main, 0 on step 2; Tier 1's records 76,411 and 66,866.

## On the 9700X

`9700x/`: buster `build.sh --config Release` with `BUSTER_DEBUG_INFO=0` for main, step 2 and step 3 (`step3.patch`
applied to step 2), every run on CPU 2 under the machine's lock (`exclusive.sh`). Linux 6.18.50, clang 23.1.1, the
`performance` governor (`results/host.txt`); compilers' and programs' hashes in `results/*.sha256`.

### `c_tokenize`

`run.sh` built the compilers and ran `measure-tier1-rows --lexer mid.c` with main as `--base` (`results/rows.log`: every
build's output the same, the lexer's corpus check and tokens); `run4.sh` built the step 2 and step 3 lexers by one
command each, then ran five rounds, one hold each (`round.sh`), every program on the file (`mid.c`, 46,679 bytes) and
on `src` (the head's tree, 57.8 MB), in an order rotated each round. The medians of the five rounds' medians (each
the program's 21 passes), min to max, cycles and instructions per byte by the program's own counters:

| Build | file: cycles/B | instructions/B | `src`: cycles/B | instructions/B |
| --- | ---: | ---: | ---: | ---: |
| `--tier1`, main | 8.078 (8.078 to 8.118) | 12.445 | 8.475 (8.469 to 8.502) | 12.904 |
| `--tier1`, step 2, the harness's build | 3.576 (3.561 to 3.579) | 10.283 | 4.020 (3.975 to 4.028) | 10.760 |
| `--tier1`, step 2, built as step 3 is | 3.572 (3.569 to 3.606) | 10.283 | 3.980 (3.977 to 4.190) | 10.760 |
| `--tier1`, step 3 | 3.525 (3.519 to 3.535) | 9.963 | 3.983 (3.971 to 4.005) | 10.438 |
| clang -O2 | 0.655 (0.646 to 0.660) | 2.954 | 0.852 (0.845 to 0.854) | 3.006 |

- **Step 2:** 2.26 times as fast as main on the file and 2.11 to 2.13 on the tree, with 17% fewer instructions: IPC
  1.54 to 2.89 on the file. A stack-built constant cost its load's wait for its stores far more than its
  instructions. `c_tokenize_scalar`, which has no vector constants, is the same by every Tier 1 build (11.81 to 11.85
  cycles/B, 44.771 instructions/B). In the harness the whole lexer program took 0.739 of main's user cycles.
- **Step 3:** 3.0% fewer instructions than step 2; 1.3% fewer cycles on the file (the ranges apart), none on the tree
  (3.980 and 3.983). The two builds of step 2, the same compiler and source by two commands, differ by 1.0% on the
  tree, so step 3's cycles are inside what a build's placement moves. Its six Zen 5 rows (below) are measured; it isn't
  proposed with step 2.
- The outputs of step 2's two builds and step 3's agree on both inputs (`run4.log`).

### The Zen 5 rows step 3 needs

`measure-x86-zen5 --missing --table` by step 3's compiler (`results/zen5-table.txt`): `vpbroadcastd` and `vpbroadcastq`
of a memory operand at 16, 32 and 64 bytes, each 1 op, latency 4.5 cycles (1152), throughput 0.5 (128), as a
vector load's row; the register forms step 1 uses, `vpbroadcastq zmm, r64`, are 2 ops, latency 4.5, throughput 1.

```
X(VPBROADCASTD_X_XM32, MEMORY, 1152, 128, 256, U, 1152, 256, 0, 0x66, 0x11, 0x08)
```

and the same for `_Y_XM32`, `_Z_XM32`, `VPBROADCASTQ_X_XM64`, `_Y_XM64` and `_Z_XM64`.

### Compile time

`time-runs` under `ab` (`results/ab-*.log`): main, step 2 and main again, three fresh copies each, three runs a copy,
one hold a round, three rounds (two runs and two copies for `--tier1` of SQLite). Medians against main:

| Command | wall | user cycles | instructions | main again: wall, cycles |
| --- | --- | --- | ---: | --- |
| `-c sqlite3.c`, Tier 0 | −0.07%, −0.20%, −0.13% | −0.06%, −0.15%, +0.07% | +0.014% | +0.22%, +0.15%, +0.11%; +0.27%, +0.28%, +0.34% |
| `-c sqlite3.c`, `--tier1` | +0.06%, +0.26%, +0.30% | +0.04%, +0.27%, +0.26% | +0.011% | −0.01%, +0.11%, +0.05%; +0.05%, +0.10%, −0.01% |
| the lexer's unit, `--tier1 -march=znver5` | +12.09%, +11.14%, +10.67% (see below) | +0.32%, +0.21%, −0.06% | −0.157% | +0.28%, +0.09%, −0.10%; +0.30%, +0.05%, −0.10% |

The SQLite file is the frozen corpus's, with its pinned predefines and headers.

- **Tier 0:** flat in time. Its instructions: +0.18 M (+0.014%) at `5e33fe8`, of which the window path's copy of each
  body's literals (a call for every Tier 0 body, which has none) was about 20 K: at `2b3c5c4`, which checks the count
  first (`run5.sh`, `results/ab-sqlite-head4.log`, one round), +0.16 M (+0.012%), user cycles −0.27% against main
  where main again gives −0.22%. The rest isn't attributed: `EmittedCode`'s two new fields, copied and cleared per
  body, and the binary's layout are the candidates.
- **`--tier1` of SQLite:** 0.26% more user cycles in two rounds of three, 0.011% more instructions.
- **The lexer's unit's wall time** is not its compile: user and system time are main's, but 20 of 27 runs of step 2
  waited 9 to 32 ms off the CPU (in steps), main's never. The object writer writes an existing output file in place and
  truncates it only when it was longer (`object_write_file`); every build of the A/B writes the same `out-lexer.o` on
  `/home`, btrfs; step 2's object is 807 KB and main's 862 KB, so a step 2 run after a main run shrinks the file and
  waits for btrfs's truncation, and main's runs only grow it. Not the exit helper: `ab-lexer-no-exit-helper.log`, with
  `BUSTER_EXIT_HELPER=0`, gives the same (+10.68% and +10.77%, 14 of 18 runs waiting), and `strace -f -c` shows the
  same calls by both (one `clone3`, 17 `munmap`, 40 `madvise`; no futex or sleep), a single run of each 179.4 and
  179.7 ms elapsed (`results/perf-*.txt`). With the output on tmpfs (`run6.sh`, `results/ab-lexer-head4-tmpfs.log`,
  `2b3c5c4` against main, two rounds) no run waits (idle 1.1 to 1.2 ms on average by every build), and the compile is
  +0.35% and +0.15% in wall time, +0.38% and +0.12% in user cycles, where main again gives −0.22% and −0.19%, −0.11%
  and −0.07%; on btrfs again (`run5.sh`, `results/ab-lexer-head4.log`) `2b3c5c4` waits in 7 of 9 runs, +11.48%.

## Method

```sh
# In the VM (buster, this branch built Develop; main's compiler built the same):
./build/compiler measure-tier1-rows --clang "$(command -v clang)" --base MAIN/compiler --lexer mid.c --keep --uncounted --directory DIR
taskset -c 1 ./stephist --entry "$(nm DIR/lexer-tier1 | grep ' t c_tokenize$' | cut -d' ' -f1)" --calls 1 --output mid200.hist -- DIR/lexer-tier1 mid200.c
python3 annotate.py DIR/lexer-tier1 mid200.hist; python3 annotate.py DIR/lexer-tier1 mid200.hist dump > d; python3 runs.py d
# On the 9700X: 9700x/run.sh, then run4.sh (the rounds, the rows and the A/Bs), diag.sh (the counts and the A/B
# without the exit helper), run5.sh (2b3c5c4's A/Bs) and run6.sh (the lexer's A/B with its output on tmpfs).
```

`run.sh`'s pinned runs held the lock once each and waited behind other sessions; its `timeout` wrapped the lock's
wait, so its first file run timed out unrun (`lexer-base-mid-1.log`). `run4.sh` replaced them with a hold a round.

## Files

- `9700x/`: the scripts (`run.sh`, `run4.sh`, `round.sh`, `drive.sh`, `diag.sh`, `counts.sh`, `run5.sh`, `run6.sh`),
  their logs, and
  `results/`: the rounds' logs (`rN-PROGRAM-INPUT.log`), the harness's `rows.log`, the A/Bs, the Zen 5 table, the
  `strace` and `perf stat` counts, the hashes and `host.txt`.
- `results/`: the VM's single-stepped counts and their classifications.
- `step3.patch` (in `9700x/`): step 3's code as measured, on step 2's head; `step3-broadcasts-605badc.patch`: the same
  with its tests, documentation and measured rows, on `747b169`.
