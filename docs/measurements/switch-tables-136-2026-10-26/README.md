# Switch jump tables (#136), 2026-10-26

For [buster14a/buster#136](https://github.com/buster14a/buster/issues/136)'s item 7: `switch` dispatched through a jump
table where clang -O0 builds one. buster14a/buster's branch `claude/136-switch-jump-tables`, against main at
`e04462c1`, on the 9700X (Ryzen 7 9700X, Zen 5). Every run held the shared lock (`~/buster-fast-bench/exclusive.sh`)
and was pinned to CPU 2.

## Source and inputs

- **The trees,** each synced with `git archive` (`build.sh`, `src`, `tests`) into an emptied directory and built with
  `BUSTER_DEBUG_INFO=0 ./build.sh` under the lock (`jt-ab.sh`, `jt-head.sh`); the manifests list every file:
  - **main** at `e04462c1` (`manifest-e04462c1.sha256`), the tree [#514's record](../backend-source-136-2026-10-26/README.md)
    built;
  - **the branch** at `1e2bcae3` (`manifest-1e2bcae3.sha256`), the tables' rule, dispatch and emission;
  - **the switched tree:** the branch at `b538fbaa` with one line more, a measurement switch that isn't in the
    repository (`switched.diff`, `manifest-switched.sha256`). `BUSTER_NO_JUMP_TABLES` in the environment leaves the
    lowering's room for tables at 0, so that tables on and off run one executable, one placement of its code.
    `b538fbaa` gives each table's dispatch its switch statement's line for `-g`, which `-c` without `-g` doesn't use;
  - **the head** at `63a212fb` (`manifest-63a212fb.sha256`): `-c`'s object leaves the tables' and their labels'
    symbols out of its symbol table (`ObjectOptions.temporary_symbols`), as an assembler leaves clang's `.LJTI` and
    `.LBB` labels, and relocates through their sections' symbols.
- **SQLite:** 3.53.2's amalgamation (`sqlite3.c` and `shell.c`), from
  `~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite`, the [SQLite record](../sqlite-136-2026-10-26/README.md)'s
  copy, with the host's headers.
- **The shell's workload:** that record's `work.sql` (its sha256 in `identities.txt`). It inserts 300,000 rows in a
  recursive CTE, then indexes, aggregates, self-joins, updates, deletes, sorts and groups them.
- **`identities.txt`:** the host, the toolchain, and the sha256 of main's, the branch's and the switched executables, of
  the inputs and of the shells; the shells' outputs' md5. The head's executable's sha256 is in `head/measure.log`.

## Commands

- **`jt-proc.sh`:** `perf stat -r 11 -x, -e instructions:u,cycles:u ./build/compiler -c -I$Q -o ... $Q/sqlite3.c`, main's
  tree and the branch's in turn, two rounds, each its own hold of the lock (`main/perf-*.log`, `branch/perf-*.log`).
  Then each tree's shell, built outside the lock: its `-c` objects of `sqlite3.c` and `shell.c`, linked by `cc` with
  `-lm -lpthread -ldl`. Then nine rounds of the shells running `work.sql` on `:memory:`, both in each round's hold of
  the lock, the first of them alternating by round (`run.times`, microseconds), and the two outputs compared.
  `measure.log` is its report up to the shells' sizes; the local ssh session that printed it ended before the rounds,
  which `run.times` holds.
- **`jt-proc2.sh`:** the front end's control. `perf stat` as above of `-fsyntax-only` of `sqlite3.c`, which
  preprocesses, parses and checks the file but never reaches the lowering, two rounds (`main/syntax-*.log`,
  `branch/syntax-*.log`, `control.log`).
- **`jt-toggle-all.sh`** and **`jt-toggle.sh`:** the switched tree's build, then `perf stat -r 11` of `-c` with the
  tables off and on in turn, two rounds, each its own hold (`switched/toggle-*.log`, `switched/measure.log`), and each
  mode's object compared with main's and the branch's.
- **`jt-profile.sh`:** `perf record -e cycles:u -c 100003` of five `-c` runs per mode, each mode its own hold, and
  `perf report` by symbol (`switched/profile-*.txt`).
- **`jt-interleave.sh`:** both modes in one hold of about 12 s, eight rounds of a `perf stat -r 3` of each, the first
  alternating by round (`switched/interleave.log`: round, mode, instructions, cycles).
- **`jt-gather.sh`:** `identities.txt` and `objects.txt` (`size -A` of main's and the branch's `sqlite3.o`, the
  branch's tables' and labels' symbols counted, `.rela.rodata`'s count), in one hold.
- **`jt-head.sh`:** the head's build, then `-c` of `sqlite3.c` by main's executable and the head's interleaved in one
  hold, eight rounds as `jt-interleave.sh`'s; then, in one more hold, the head's object's `.text` and `.rodata` against
  the branch's (`objcopy -O binary`), its sizes, symbols and `.rela.rodata`, and its shell running `work.sql` once
  (`head/measure.log`).
- **`jt-controls.sh`:** two controls, each in one hold, eight rounds the same way: `-fsyntax-only` of `sqlite3.c`, head
  against main, and `-c`, head against the branch (`head/controls.log`: what, round, tree, instructions, cycles).
- **`jt-matrix.sh`:** the four executables in one hold of about 20 s: main, the switched one with the tables off and
  on, and the head, six rounds of a `perf stat -r 3` of each, the order rotated by round (`head/matrix.log`).

The logs keep perf's counter lines and the scripts' own; the lock's waiting messages, which name other sessions'
commands and private links, are left out.

## Results

### The shell

The shell built from the branch's objects runs `work.sql` in **662.0 ms**, median of 9 (657.7 to 673.3), against
main's **767.9 ms** (764.6 to 771.9): **13.8% less time**. Both print the same output (md5
`d080c12b7025e25108257c688dbe71c3`, the clang -O0 shell's in the SQLite record).

### The objects

`size -A` of each `-c` of `sqlite3.c` (`objects.txt`): the branch's `.text` is **1,246,564** bytes against main's
1,258,500 (**−11,936**), and its `.rodata` 31,792 against 20,688 (**+11,104**: the tables' 2,776 entries of 4 bytes).
53 switches get tables, whose entries are `.rela.rodata`'s 2,776 `R_X86_64_PC32` relocations. The branch's object
also held 53 `.Lbuster_switch_N` and 1,105 `.Lbuster_case_N` local symbols, which the head leaves out (below).

### -c of sqlite3.c, main against the branch

| Run | Instructions | Cycles | ms per run |
| --- | ---: | ---: | ---: |
| main, round 1 | 2,288,013,026 | 893,233,793 | 189.96 |
| branch, round 1 | 2,287,910,766 | 896,787,269 | 191.22 |
| main, round 2 | 2,288,012,948 | 892,950,940 | 190.63 |
| branch, round 2 | 2,287,910,764 | 897,869,707 | 191.34 |

The milliseconds are perf's enabled time per run. The branch runs 102,260 fewer user instructions (−0.0045%) and
0.40% and 0.55% more cycles. The two executables' code differs beyond the tables: with the tables off, the switched
executable below writes main's object byte for byte in 530,995 fewer instructions than main's, as clang compiles the
changed units otherwise. So this compares placements as well as work; the next two sections tell them apart.

### The control: -fsyntax-only

| Run | Instructions | Cycles | ms per run |
| --- | ---: | ---: | ---: |
| main, round 1 | 1,684,264,399 | 679,085,551 | 147.51 |
| branch, round 1 | 1,684,264,278 | 677,484,090 | 146.75 |
| main, round 2 | 1,684,264,272 | 680,344,429 | 147.11 |
| branch, round 2 | 1,684,264,271 | 680,542,263 | 147.13 |

The front end runs the same instructions on both executables, within 121, and cycles within the rounds' spread
(−0.24% and +0.03%).

### One executable, tables on and off

With the tables off, the switched executable writes **main's object byte for byte**, and with them on **the branch's
object byte for byte** (`switched/measure.log`).

| Run | Instructions | Cycles | ms per run |
| --- | ---: | ---: | ---: |
| off, round 1 | 2,287,482,031 | 893,872,461 | 191.40 |
| on, round 1 | 2,287,913,275 | 896,839,878 | 191.78 |
| off, round 2 | 2,287,482,095 | 893,678,634 | 190.56 |
| on, round 2 | 2,287,913,219 | 893,579,956 | 192.22 |

The tables add **431,124 to 431,244 instructions (+0.019%)** in every pair of runs. Their cycles were +0.33% in one
round and −0.01% in the other, so the rounds' holds of the lock drift by more than the tables cost. Interleaved in
one hold (`switched/interleave.log`), eight rounds of three runs per mode: tables on take a median of **895.36 M**
cycles against **894.49 M** off (**+0.10%**), the rounds' paired differences −0.39% to +0.37%. The profiles put 11 of the
tables-on mode's 45,814 samples (0.02%) in `check_lower_switch_table`; their other differences, up to 6% in front-end
functions the tables don't run, are the two holds' drift.

### The head

The head's object (`head/measure.log`) has **the branch's `.text` and `.rodata` byte for byte**, none of the lowering's
symbols (4,710 symbols against the branch's 5,868) and `.rela.rodata`'s 2,776 entries, and the shell built from its
objects prints main's output.

Interleaved against main in one hold, eight rounds: **+195,979 instructions (+0.009%)**, and cycles' paired
differences of **+0.11% to +1.54%** (medians 899.03 M against 893.65 M, +0.74% paired). The controls, interleaved the
same way (`head/controls.log`):

- **`-fsyntax-only`, head against main:** +1,080 instructions, cycles −0.40% to +0.51% (+0.18% median): the front
  end, which reaches neither the lowering nor the object's symbols, as before;
- **`-c`, head against the branch:** +298,165 instructions (+0.013%), the object writer's work on the temporaries,
  and cycles −0.25% to +1.29% (+0.18% median).

And the four executables in one hold (`head/matrix.log`), each against the one before it:

| Executable | Cycles, median | Paired differences | Instructions |
| --- | ---: | --- | ---: |
| main | 892.56 M | | 2,288,013,014 to 030 |
| switched, tables off | 899.05 M | +0.73% (+0.19% to +2.18%) | −530,922 |
| switched, tables on | 900.47 M | +0.07% (−2.14% to +0.96%) | +431,144 |
| head | 896.40 M | −0.21% (−0.64% to +0.02%) | +295,736 |

The switched executable with the tables off does main's work and writes main's object, in fewer instructions, and
takes **0.73% more cycles** than main's in every round: another compile of the same code costs that much, by where
clang places it. The head is +0.48% against main there (−0.28% to +1.03%), within that, where the tables' own work is
+0.019% instructions and +0.07% to +0.10% cycles, and the temporaries' +0.013% instructions.

## Limitations

- One machine and one corpus file for the compile's cost; one workload, ours, for the generated code's (SQLite's
  speedtest1 is [#516's record](../speedtest1-136-2026-10-26/README.md), to measure again with the tables).
- The shells' runs are one process each, their start and exit included; `run.times` holds every run.
- `jt-proc.sh` built the shells outside the lock, a few seconds of compiling and linking between its holds.
- The cycles' differences under 0.4% between holds of the lock are drift, not the trees' (the control and the
  switched executable's rounds show it), and two compiles of the same work differ by up to 0.7% in one hold (the
  matrix); the interleaved runs on one executable and the instructions are the measures to read.
