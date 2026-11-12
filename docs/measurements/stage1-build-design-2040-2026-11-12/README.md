# The stage 1 build: where its time goes and what each lever buys (2026-11-12)

The measurements behind buster's design for a faster stage 1 build (the compiler as clang builds it through
`./build.sh`): the edit loop and the clean build as they are, the optimizer's time by function, and each lever with its
measured effect and cost. They size a design; they qualify no change. The design is buster's
`docs/stage1-build-design.md`; the work is part of [buster#2040](https://github.com/buster14a/buster/issues/2040).

- **Source:** buster `c5f0efb20199618a542f0d8de61951916c15d76c` (main on 12 November), in clean clones of this
  record's own: `src` (unchanged), `part` (with `prototype/presplit.patch`), `cfg` (unchanged, for the other
  configurations and the second round of today's scenarios) and `o1` (its build description says `-O1` where main's
  says `-O3`, `raw/logs/o1.patch`).
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50-2-lts, Arch's clang and LLD 23.1.1, CMake 4.4.4, Ninja 1.13.2,
  15 CPUs online (CPU 10 offline), 64 GB, the `performance` governor (`raw/host.txt`).
- **The lock:** every build, compile, comparison and test run was its own hold of the 9700X's lock
  (`scripts/lock.sh`), and wrote the lock's owner line as it started (`raw/**/*.holder.txt`). Other sessions shared
  the host between the holds.
- **What ran:** `raw/queue/done.txt` has every run from 12:30 UTC on, in order, with its start, end and status
  (`scripts/master.sh` took them from a list, one hold each; `scripts/tasks.txt` is that list as it was run). The
  first runs, from 11:23, were `scripts/queue-base.sh`'s.
- **Another session's stray process** ran on the host, outside the lock, until 13:51:28 UTC
  ([buster#2555](https://github.com/buster14a/buster/issues/2555)). Section 12 says which figures were measured
  beside it, which were measured again, and which are kept. From 14:23 UTC `scripts/run.sh` records the host's
  busiest processes before and after each build (`raw/logs/*.ps.txt`).

## 1. Today's build, by scenario

`scripts/run.sh` runs one `./build.sh` (Release, `-g`, eight jobs) after one change and records its wall and CPU time
(bash's `time`) and the lines Ninja's log gained, which are the commands that reran. A **clean** build starts from
`rm -rf build` and configures. An **edit** appends an emitted function that returns a new string literal to the named
file, so the code of every unit that reads the file changes; the header's goes before its closing `#endif`.
`tools/scenario_table.py` reduces a round's results and logs to a table: `tables/scenarios-recheck.tsv` (the rows
without `part-`: the second round, 14:23 to 14:38, on the clear host, in `cfg`) and `tables/scenarios-base.tsv` (the
first round, 11:23 to 12:36, beside the stray process, in `src`).

| Scenario | Clear host: wall, CPU | Commands rerun (count; summed time) | Beside the stray process: runs, median, CPU |
| --- | --- | --- | --- |
| Clean build | 83.1 s, 83.1 s; 500 s | 69: 43 compiles 370.9 s (the longest 67.2 s), 2 splits 6.6 s, 18 parts 104.8 s (10.3 s), 2 joins 0.7 s, link 0.1 s, bake 0.5 s | 86.2, 92.3, 87.9 (the clone's first: 88.0); 87.9 s; 534 s |
| Nothing changed | 0.03 s | none | 0.04, 0.03 |
| `c_check_input.c` (the checker's unit) | 72.6 s; 135 s | 14: 1 compile 56.8 s, split 4.3 s, 9 parts 63.4 s (10.3 s), join, link, bake | 72.6, 73.2, 72.5; 72.6 s; 137 s |
| `differential.c` (the backend's unit alone) | 46.5 s; 86 s | 14: 1 compile 35.9 s, split 2.2 s, 9 parts 40.8 s (7.5 s) | 46.7, 47.5; 88 s |
| `tier0.c` (the checker's and the backend's units, two benchmarks) | 75.9 s; 246 s | 28: 4 compiles 117.9 s (60.1 s), 2 splits 6.6 s, 18 parts 105.1 s | 76.6, 76.9; 250 s |
| `c_parser_impl.c` (the front end's unit, one benchmark) | 26.0 s; 36 s | 4: 2 compiles 35.1 s (25.3 s), link, bake | 26.0, 26.1; 36 s |
| `c_checker_driver_test.c` (a test of the checker's unit) | 72.5 s; 135 s | 14 | 72.4, 72.9; 137 s |
| `c_checker_test.c` (a shared test root: three units) | 75.7 s; 236 s | 27: 3 compiles 108.4 s, 2 splits, 18 parts 105.2 s | 76.6, 76.6; 243 s |
| `host_isa.h` (a header 42 of the 43 units read) | 83.0 s; 499 s | 66: 42 compiles and what follows them | 90.7, 84.6; 532 s |

The clear clean build's 69 commands are 485 s of work: the eleven `main.c` units' compiles 248.9 s, the 32 units of
their own 122.0 s, the 18 parts 104.8 s, the splits 6.6 s, the joins 0.7 s and the rest 2.0 s. On eight jobs that is
at least 60.6 s. Its last command ends at 82.7 s because the checker's unit's chain is that long: its compile 67.2 s
(under the other seven jobs; 56.6 s alone), its split until 71.4 s, its parts until 81.7 s, the join, the link and the
bake.

- The clear `header` run's result line is missing from `raw/results/recheck.txt`: `run.sh` was replaced while that
  build ran, which ended the script after the build. Its time is `raw/logs/recheck-header-1.time` (82.985 s, 488.4 s
  user, 10.7 s system) and its count of commands the first round's.
- In the first round Ninja compacted its log during two runs, so `header` 1 and `frontend` 2 kept their times and not
  their commands (`run.sh` compares the log's lines since then).

## 2. The optimizer's time, by function

`scripts/compile.sh src UNIT trace` is the build's own compile of a unit with `-ftime-trace
-ftime-trace-granularity=10`, alone on CPU 2 (`raw/results/compile/UNIT-trace.json.gz`). `tools/function_files.c`
maps every function clang emitted to the file its definition is in, from the unit's unoptimized bitcode (the same
command with `-Xclang -disable-llvm-passes`), and `tools/trace_functions.py` gives every event's own time (its
duration less its children's) to the function its detail names, or else to the nearest enclosing event that names one.
A function is the tests' when its file's name matches the earlier record's rule (`_test`, `test_`, `_tests`, `fuzz`).
`tables/UNIT.trace.txt` has each summary; `tables/UNIT.trace.functions.tsv.gz` every function.

| Unit (its traced compile) | Front end | Optimizer | Product functions | Test functions | Benchmark | No function |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `main_unit_checker` (to bitcode, 58.9 s; 56.6 s untraced) | 6.58 s | 52.03 s | 42.59 s (81.9%) | 1.34 s (2.6%) | 0.58 s | 7.52 s (14.5%) |
| `main_unit_backend` (to bitcode, 37.4 s; 35.9 s) | 3.96 s | 33.30 s | 14.20 s (42.6%) | 14.93 s (44.8%) | 0.52 s | 3.66 s (11.0%) |
| `main_unit_frontend` (to its object, 26.0 s; 24.9 s) | 3.02 s | 11.61 s | 5.69 s (49.0%) | 4.81 s (41.4%) | 0.30 s | 0.81 s (7.0%) |
| `c_parser_benchmark` (to its object, 9.6 s; 9.4 s) | 0.75 s | 4.71 s | 4.18 s (88.7%) | 0 | 0.23 s | 0.31 s |
| `tier1_select_benchmark` (to its object, 12.3 s) | 2.22 s | 5.11 s | 4.76 s (93.2%) | 0 | 0.09 s | 0.26 s |

- The checker's unit's tests are 2.6% because main.c already compiles them between `#pragma clang optimize off` and
  `on` (#681): about 1,400 of the unit's functions are `optnone` before any pass runs.
- The front end's unit's trace also has its code generation, 11.28 s: test functions 5.88 s (52.2%), product
  functions 4.85 s (43.0%). The two benchmark units': 4.11 s and 4.90 s, of which the product's functions (their own
  copies of them) are 91.1% and 96.0%.
- In the checker's unit, the functions' optimizer time is spread: a quarter in 50 functions, half in 320, three
  quarters in 1,264 and nine tenths in 2,847 of 9,990. The largest is `tier1_select_cover_munch`, 0.77 s (1.5%); by
  file, `c_check_input.c`, 2.60 s (5.0%). By pass: InstCombine 9.2 s, GVN 4.7 s, the inliner itself 3.0 s, writing
  the bitcode 2.7 s.
- **What the product needs of each unit** (`tools/reach.py`: the functions reached from the unit's external
  definitions without entering a test, benchmark or measurement file; `raw/results/maps/UNIT.reach.txt`), in
  unoptimized instructions:

  | Unit | Functions | The product's | Test files' | Product files' that only tests, benchmarks or measurements reach | Benchmark files' |
  | --- | ---: | ---: | ---: | ---: | ---: |
  | `main_unit_checker` | 9,990 | 75.9% (8,135) | 21.4% (1,535) | 1.7% (248) | 1.0% (65) |
  | `main_unit_backend` | 4,983 | 10.5% (661) | 47.1% (1,824) | 40.3% (2,391) | 2.0% (101) |
  | `main_unit_frontend` | 2,569 | 47.0% (1,338) | 37.6% (717) | 13.7% (479) | 1.7% (30) |

  The backend's unit is its tests' unit: nine tenths of what it compiles, its own copies of the code-generation files
  included, is reached only from tests. The compile path's copies are the checker's unit's.

## 3. The prototype: the optimizer in parts

`prototype/presplit.c` (derived from buster's `tools/codegen/split.c`) and `prototype/presplit_shim.cpp` partition a
unit's module before LLVM's optimizer; `prototype/presplit.patch` (against `c5f0efb2`) makes `./build.sh` use it:
`BUSTER_PRESPLIT="PARTS ANCHOR IMPORT [UNIT_FLAG...]"` turns it on for all eleven `main.c` units and the eight
benchmark units whose compile takes more than about nine seconds (the checker's unit PARTS parts, the backend's two
thirds, the front end's a third, the others a sixth), `BUSTER_PRESPLIT_SPLIT` gives the splitter further arguments
(`--by-file`, `--lean-imports`, `--cohere CAP`) and `BUSTER_PRESPLIT_FLAGS` gives every part's job further arguments
(or, with the prototype off, every `main.c` unit's compile). `presplit.c`'s first comment has the rules. It is a
measurement prototype: its checks are that the compilers it builds pass the tests of section 6 and write `sqlite3.c`'s
object as Release's does, and section 3.2.

The patch changed twice during the campaign (`raw/queue/done.txt` has the lines that applied each): the parts' debug
information lists were pruned (13:02), and functions whose inline assembly has text were pinned to the first part
(13:40), after `p48-i300`, `p48-i300-fc` and `p48-i1000-fc` failed to link with `undefined symbol:
x86_semantics_test_return` (their first runs, `rc=1` in `raw/results/variants.txt`; the second runs are the valid
ones). `prototype/presplit.patch` is the last.

### 3.1 Build scenarios

`scripts/run.sh` as in section 1, in the `part` clone. Three recipes:

| Recipe | Environment | Debug information |
| --- | --- | --- |
| `-g` as today | `BUSTER_PRESPLIT="48 24 100"` | DWARF 5, full |
| line tables | `BUSTER_PRESPLIT="48 24 100 -gdwarf-4 -gline-tables-only"`, `BUSTER_PRESPLIT_SPLIT="--by-file --lean-imports --cohere 150000"` | DWARF 4, line tables |
| none | `BUSTER_DEBUG_INFO=0 BUSTER_PRESPLIT="48 24 100"` | none |

Wall seconds (and CPU seconds), all on the clear host:

| Scenario | Today | `-g` as today | Line tables | None |
| --- | --- | --- | --- | --- |
| Clean build | 83.1 (500) | 59.3 (497) | 54.6, 54.7, 54.7 (444) | 46.3, 46.2 (385) |
| `c_check_input.c`, a function appended | 72.6 (135) | 27.3 (141) | 19.2, 16.7 (34) | 9.6, 10.1, 10.1 (26) |
| `c_check_input.c`, a function before its first line | | | 17.0, 17.0 (42) | 9.6 (25) |
| `differential.c` | 46.5 (86) | 10.7 (24) | 6.9 (15) | |
| `tier0.c` | 75.9 (246) | 33.2 (250) | 15.8 (54) | 10.0 (43) |
| `c_parser_impl.c` | 26.0 (36) | 8.1 (42) | 4.9 (12) | 3.9 (9) |
| `c_checker_driver_test.c` | 72.5 (135) | 19.6 (75) | 12.3 (29) | 9.6 (25) |
| `c_checker_test.c` | 75.7 (236) | 25.1 (141) | 12.3 (47) | |
| `host_isa.h` | 83.0 (499) | 22.2 (203) | 16.7 (153) | 17.0 (154) |
| `host_isa.h`'s time alone changed (`touch`) | | | 14.2 (132) | |
| Clean, 15 jobs | | 52.1 (730) | | |
| The eleven `main.c` units alone | 79.2 (366) | 44.6 (363) | 40.0 (324) | 34.9 (278) |
| ... with the tests unoptimized (section 4) | | | 35.7 (291) | |
| ... and 15 jobs | | | 33.4 (405) | |
| ... with `-O1` in the parts' jobs (`BUSTER_PRESPLIT_FLAGS="-O1"`) | | | | 25.6 (207) |
| The 32 other units, the link and the bake, after that | 21.7 (120) | | | 13.2 (104) |
| Clean, the tests unoptimized | 80.8 (441) | 54.9 (463) | | |

The commands of the edit of `c_check_input.c`, from the tables (count; summed seconds, the longest):

| Recipe | Front end (the unit) | Split | Parts | Join | Link, bake |
| --- | --- | --- | --- | --- | --- |
| `-g` as today | 7.2 | 4.1 | 49; 105.6, 5.4 (14.5 s of wall on eight jobs) | 0.9 | 0.1, 0.5 |
| Line tables, appended | 6.6 | 3.5 | 1; 5.4 | 0.8 | 0.1, 0.3 |
| Line tables, before the first line | 6.6 | 3.5 | 5 or 6; 13.3, 5.6 | 0.8 | 0.1, 0.3 |
| None | 5.4 | 2.3 | 1; 0.7 to 1.3 | 0.8 | 0.1, 0.3 |

- The tables: `tables/scenarios-recheck.tsv` (its `part-*` rows: `-g` as today, 14:55 to 15:02),
  `tables/scenarios-part-g1.tsv` and `tables/scenarios-part-g0.tsv` (13:55 to 14:03),
  `tables/scenarios-design.tsv` (14:51 to 15:12: `units`, `units-optnone`, `units-optnone-j15`, `units-o1-g0`,
  `g1-clean`, `g1-touch`, the parity pair and section 8's `whole-g1` pair), each with the commands that reran by
  kind, their summed time and the longest. `tables/scenarios-part.tsv` is the first round of the `-g` recipe
  (12:44 to 13:40, beside the stray process): clean 64.1 s and 64.4 s (532 s), checker 28.2 s and 28.1 s, `tier0.c`
  35.3 s, `c_parser_impl.c` 8.4 s, header 24.6 s, 15 jobs 56.6 s (747 s), the eleven units alone 48.4 s, on 15 jobs
  40.1 s, and with the tests unoptimized on 15 jobs 36.5 s.
- With `-g` as today an edit changes every part whose debug information mentions the file (DWARF 5 holds each file's
  MD5): 49 of the checker's unit's 49 for `c_check_input.c`, 17 for `c_checker_driver_test.c`, 5 of the backend's
  unit's 33 for `differential.c`.
- A `units` row builds the eleven `main.c` units' objects alone (`--target` each): no benchmark unit, no link, no
  bake (0.4 s). `run.sh` can't name its Ninja log with those arguments, so these rows have times and no commands. The
  `rest` row then builds what is left.
- `g1-touch` changes `host_isa.h`'s time alone after `g1-clean`: 42 units' compiles (89.0 s summed, the 24 units that
  aren't split among them) and 19 splits (15.7 s) run again, and no part's job does.

### 3.2 Incremental equals clean

In the line-table round, after its eleven edits (`raw/logs/part-g1-*.log`), `clean-after-edits` removed `build` and
built the edited sources again: its executable's SHA-256 is the incrementally built one's
(`raw/logs/part-g1-checker-top-2.sha256` and `raw/logs/part-g1-clean-after-edits-1.sha256`, both `e13658a5b6b3...`).

### 3.3 Variants, and the compiler's speed

Each variant is a clean build with `./build.sh shifts` (the executable and four placements of the checker's unit: 0,
1088, 2112 and 3136 bytes), `tables/scenarios-variants.tsv`. `scripts/ab.sh` then compares them as the 9700X workflow
compares a pull request with its base: `time-runs` on CPU 2 over the four placements of each build, two fresh copies
of each (`--copies 2`), five runs each, so 40 runs a build; the baseline's own executables again (`base-again`) are
the floor. `tables/ab.tsv` is `tools/ab_table.py`'s reduction of `raw/results/ab/*.txt` (medians, the range over the
placements, the pairs by placement).

| Variant | `BUSTER_PRESPLIT` | `BUSTER_PRESPLIT_SPLIT` |
| --- | --- | --- |
| `p48-i0` | `48 24 0` | |
| `p48-i100` | `48 24 100` | |
| `p48-i100-c` | `48 24 100` | `--cohere 150000` |
| `p48-i100-fc` | `48 24 100` | `--by-file --cohere 150000` |
| `p48-i300` | `48 24 300` | |
| `p48-i300-fc` | `48 24 300` | `--by-file --cohere 150000` |
| `p48-i1000-fc` | `48 24 1000` | `--by-file --cohere 150000` |
| `whole-optnone` | off | (`BUSTER_PRESPLIT_FLAGS="-mllvm -forceattrs-csv-path=scratch/all.tests.csv"`: section 4) |

User cycles against `base` (`-c` of the frozen `sqlite3.c`, 40 runs a build, `sqlite-2`; `-fsyntax-only` of the
checker's unit, 12 runs a build without copies, `syntax-1`), and the variant's build with its placements (wall, CPU;
all beside the stray process, where today's plain clean build read 87.9 s and 534 s):

| Build | `sqlite3.c`: cycles | range over placements | instructions | checker's unit: cycles | range | instructions | Build |
| --- | ---: | --- | ---: | ---: | --- | ---: | --- |
| `base-again` | +0.02% | -0.24% to +0.48% | +0.00% | -0.03% | -0.55% to +0.26% | -0.00% | |
| `p48-i0` | +29.27% | +28.89% to +29.84% | +34.59% | +35.71% | +35.38% to +36.01% | +36.16% | 54.3 s, 449 s |
| `p48-i100` | +3.32% | +2.91% to +3.89% | +4.81% | +3.01% | +2.82% to +3.58% | +5.23% | 65.0 s, 537 s |
| `p48-i100-c` | +2.65% | +2.31% to +2.96% | +4.27% | +2.77% | +2.27% to +3.19% | +4.45% | 71.1 s, 564 s |
| `p48-i100-fc` | +1.13% | +0.99% to +1.48% | +2.26% | +1.87% | +1.38% to +2.39% | +2.87% | 71.3 s, 568 s |
| `p48-i300` | +0.74% | +0.34% to +1.21% | +1.11% | +0.73% | +0.45% to +0.97% | +1.25% | 81.3 s, 670 s |
| `p48-i300-fc` | +0.12% | -0.16% to +0.68% | +0.22% | +0.14% | -0.12% to +1.07% | +0.27% | 84.5 s, 664 s |
| `p48-i1000-fc` | +0.42% | +0.22% to +0.86% | +0.67% | +0.21% | -0.12% to +0.71% | +0.83% | 106.3 s, 858 s |
| `whole-optnone` | +0.11% | -0.38% to +0.85% | +0.00% | -0.06% | -0.41% to +0.30% | +0.00% | 87.7 s, 474 s |

`sqlite-1` (13:23, six builds) agrees: `p48-i100` +3.03%, `p48-i100-fc` +1.15%, `p48-i0` +29.30%, `whole-optnone`
-0.01%, `base-again` -0.13%. The base runs `-c sqlite3.c` in 600 million user cycles, 1,347.47 million instructions
and 124.1 ms. By placement pairs `p48-i300-fc` is +0.18%, +0.35%, +0.18% and +0.05% (`base-again`: +0.48%, -0.18%,
-0.10%, +0.23%): inside the floor, and with 0.22% more instructions a cost of that size is likely real.

On the clear host (`tables/scenarios-recheck.tsv`, `tables/scenarios-design.tsv`; plain clean builds without the
placements): `p48-i100`'s recipe 59.3 s and 497 s; `p48-i300-fc`'s (`parity-clean`) 77.5 s and 619 s, and its edit of
`c_check_input.c` (`parity-checker`) 35.8 s: front end 7.1 s, split 4.5 s, 47 parts 144.9 s (the longest 17.7 s).

### 3.4 What an edit dirties: counts on the development machine

Not timings, and not the 9700X: a cloud container with clang 23.1.6, counting which parts' bitcode files change.

- `scripts/stability.sh` (`raw/stability/`): the checker's unit in 25 parts before and after a function is added to
  `c_check_input.c` at its end, in its middle and before its first line, by debug information. With `--by-file
  --lean-imports --cohere 150000`: no debug information 1, 1 and 1 of 25; line tables (DWARF 4) 1, 4 and 5; `-g`
  (DWARF 5) 25, 25 and 25. With content-defined chunks alone: no debug information 1, 1 and 1; line tables 1, 24 and
  24.
- `scripts/replay.sh` and `scripts/replay-commits.sh` (`raw/replay/`): the last commits to `src/` through the split
  (the checker's unit, 49 parts, `--anchor 24 --import 100 --cohere 150000`; `g1` adds `--by-file --lean-imports` and
  line tables), each against its parent: parts whose bitcode changed. The 24 single commits, without debug
  information: 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 7, 15, 31 and 46 (`commits.tsv`: the
  commit, its files, the parts, the changed parts' bytes, all parts' bytes, the diffstat). The last 13 merges against
  their first parents (`replay.tsv`): a median of 13 without debug information, 12 with line tables.

## 4. The tests' own functions unoptimized

`tools/reach.py` writes, for a unit, the functions of its test files as a list clang's
`-mllvm -forceattrs-csv-path=FILE` reads (`NAME,optnone` and `NAME,noinline`; `raw/results/maps/UNIT.tests.csv`);
`scratch/all.tests.csv` is the three largest units' lists together (`scripts/prepare-maps.sh`). A function is a test's
by its file's name, as in section 2.

- **One unit's compile**, alone on CPU 2 (`scripts/compile.sh src UNIT tests-optnone` against `plain`;
  `raw/results/compile.txt`): the checker's 55.5 s against 56.6 s, the backend's 20.9 s against 35.9 s, the front
  end's 15.2 s against 24.9 s.
- **Today's build with the list:** `whole-optnone-2`, a plain clean build at 14:22 on the clear host: 80.8 s and
  441 s of CPU, against 83.1 s and 500 s. Its result line is missing from `variants.txt` for section 1's reason; its
  time is `raw/logs/variants-whole-optnone-2-1.time`. (`whole-optnone`, with the placements, beside the stray
  process: 87.7 s, 474 s.)
- **With the parts:** section 3.1's rows.
- **The compiler's speed:** section 3.3's `whole-optnone` rows.
- **The tests' run time:** section 6.
- **The code** (`tools/object_functions.c` hashes every function's machine code in a unit's object, relocations by
  the symbol they name and not its address; `tools/compare_functions.py` compares two builds;
  `tables/code-whole-optnone.txt`, from `raw/results/maps/UNIT.base-v2.code.tsv` and `UNIT.whole-optnone-v2.code.tsv`):

  | Unit | Product functions emitted in both | The same bytes | Other bytes | Emitted with the list only |
  | --- | ---: | ---: | ---: | ---: |
  | `main_unit_checker` | 3,182 | 2,978 | 204 | 37 |
  | `main_unit_backend` | 783 | 524 | 259 | 325 |
  | `main_unit_frontend` | 492 | 211 | 281 | 139 |

  The `.code.tsv` files without `-v2` came from an earlier `object_functions` that hashed section-relative references
  by their offsets and overstated the differences; they are kept and not used.
- The logs of builds with the list held a warning for every listed name a module doesn't define (1.9 million lines in
  `clean-optnone`'s); `raw/logs` keeps those eight logs without those lines, with their count as each log's last
  line.

## 5. Benchmark and tool objects

- **The eleven units alone, and the rest** in today's structure (`tables/scenarios-configs.tsv`, 14:08): 79.2 s and
  366 s of CPU (the checker's unit 63.8 s under load); then the 32 others, the link and the bake 21.7 s and 120 s
  (`tier1_select_benchmark.c` 12.8 s, `c_parser_benchmark.c` 11.8 s, `c_preprocessor_benchmark.c` 9.8 s).
- **With the parts:** section 3.1's rows.
- **What the units compile** (`scripts/maps-all.sh`, `tools/duplication.py`, `tables/duplication.txt`): every unit's
  unoptimized bitcode (the 43 front ends took 11.3 s on eight jobs and 48 s of CPU, with their maps), each function by
  name, file and line. The eleven `main.c` units emit 25,961 definitions (5.56 million unoptimized instructions), of
  16,951 distinct (4.22 million): 24.1% of the instructions are further copies; a product function is emitted 1.53
  times on average. The 32 units of their own emit 12,583 definitions (1.81 million instructions) of 5,025 distinct,
  and 94.5% of their instructions are functions a `main.c` unit also compiles; their benchmark files' own code is
  95,843 instructions. All 43: 7.37 million instructions emitted, 4.32 million distinct, 41.4% further copies.
  `maps-all.sh`'s per-unit time column is left out: the host has no `bc`.
- **The inventory:** no line of buster's `tools/ci/correctness.tests` at `c5f0efb2` runs a `benchmark-*` command.

## 6. The tests' run time

`scripts/tests.sh NAME EXECUTABLE` runs the 21 commands of `scripts/tests.list` once (the self-host gate's fourteen
smoke commands and seven heavier ones of the correctness inventory that need no frozen input and no other compiler),
from the `src` clone, each command's wall time to `raw/results/tests/NAME.tsv`; `tables/tests.tsv` is
`tools/tests_table.py`'s table, a row a command.

| Executable | The 21 commands | Against Release | When |
| --- | ---: | ---: | --- |
| Release (`release-2`) | 43.7 s | | 14:48, clear |
| Release (`release`) | 44.0 s | | 13:23, beside the stray process |
| The tests unoptimized (`whole-optnone-2`; `whole-optnone`) | 45.7 s; 46.0 s | +4.6%; +4.5% | 14:49; 13:24 |
| Parts, the 100 limit, by file, single callers (`p48-i100-fc-2`; `p48-i100-fc`) | 44.0 s; 44.2 s | +0.7%; +0.5% | 14:50; 13:26 |
| `-O1`, no debug information (`o1`) | 44.6 s | +2% | 14:16 |
| Debug (`debug`) | 85.6 s | 1.96 times | 14:17 and 14:20 |
| The checker's unit self-built, default tier (`hybrid-checker-t0`) | 54.2 s | 1.24 times | 14:04 |
| The checker's unit self-built, Tier 1 (`hybrid-checker-t1`) | 50.4 s | 1.15 times | 14:40 |
| Every unit self-built, default tier (`stage2-t0`) | 129.9 s | 2.97 times | 14:43 |
| Every unit self-built, Tier 1 (`stage2-t1`) | 90.4 s | 2.07 times | 14:41 |

- Every command passed in every run but one: `stage2-t1`'s `test-tier0` ended with `test-tier0: 14561628 checks, 1824
  failed` (`raw/results/tests/stage2-t1.15.log`): 228 of 1,430 checks of `unsigned floating` and 1,596 of 4,374 of
  `unsigned floating limits`, lines such as `unsigned floating: from double, vector path, rounding to nearest: value 0
  raised flags 0x00, C's conversion 0x01`. `stage2-t0` passes that command, and both hybrids do.
- With the tests unoptimized: `test-x86-encoder` 1.88 s to 2.29 s, `test-refinement src` 2.05 s to 2.88 s,
  `test-tier0` 2.30 s to 2.84 s; `test-checker --seed 133 --part 6/8` 26.69 s to 26.77 s.
- The hybrids: `test-checker`'s part 33.8 s and 31.2 s against 26.7 s, `test-check-units` 5.8 s and 4.7 s against
  2.6 s.

## 7. The front end

`scripts/compile.sh src main_unit_checker VARIANT`, alone on CPU 2 (`raw/results/compile.txt`):

| Variant | Wall | |
| --- | ---: | --- |
| `plain` | 56.6 s | the build's command: to optimized bitcode |
| `trace` | 58.9 s | with `-ftime-trace` |
| `unoptimized` | 7.17 s | `-Xclang -disable-llvm-passes -emit-llvm`, with `-g`: 58.7 MB of bitcode |
| `syntax` | 2.21 s | `-fsyntax-only -w` |
| `declarations` | 0.93 s | `-fsyntax-only -w -Xclang -skip-function-bodies` |

In the builds, the checker's unit's front end to unoptimized bitcode took 7.2 s with `-g`, 6.6 s with line tables and
5.4 s without debug information, and the splitter 4.1 s, 3.5 s and 2.3 s (section 3.1). In the unit, 3,813 of 9,990
functions are referred to from a function of another of its 653 files (37,735 caller and callee pairs, 21,911 across
files; `raw/results/maps/main_unit_checker.edges.tsv.gz`, `tools/function_files.c`'s second output), 870 of its 8,390
product functions from a test's or a benchmark's function, and 21 test functions from a product function.

## 8. Other configurations

`tables/scenarios-configs.tsv` and `tables/scenarios-design.tsv`; all on the clear host.

| Configuration | Clean build (CPU) | Edit of `c_check_input.c` (CPU) | How |
| --- | --- | --- | --- |
| Release | 83.1 s (500 s) | 72.6 s (135 s) | section 1 |
| Release, line tables in the `main.c` units | 72.0 s (403 s) | 63.7 s (107 s) | `BUSTER_PRESPLIT="" BUSTER_PRESPLIT_FLAGS="-gline-tables-only"` in `part` |
| Release, no debug information | 66.5 s (373 s) | 59.3 s (96 s) | `BUSTER_DEBUG_INFO=0` in `cfg` |
| `-O1`, no debug information | 43.1 s (248 s) | 38.4 s (66 s) | `BUSTER_DEBUG_INFO=0` in `o1` |
| Debug | 13.5 s (73 s) | 11.7 s (12 s) | `--config Debug` in `cfg` |

- **The checker's unit's commands** in those edits: Release 56.8 s, split 4.3 s, nine parts 63.4 s; line tables
  53.4 s, 2.8 s, 44.2 s; no debug information 51.0 s, 1.8 s, 37.9 s; `-O1` 31.8 s, 1.6 s, 28.1 s; Debug 9.7 s and a
  bake of 1.9 s.
- **The compilers' speed** (`scripts/config-speed.sh`: `time-runs` on CPU 2, one placement, against the `src` clone's
  Release executable; `raw/results/config-speed-sqlite.txt`, seven runs, and `config-speed-syntax.txt`, five): `-O1`
  +6.38% user cycles on `-c sqlite3.c` (wall +4.96%) and +6.85% on `-fsyntax-only` of the checker's unit (+6.34%);
  Debug +295% (+255%) and +242% (+222%).
- **Their tests:** section 6.
- **Is less debug information the same code?** Not established on the host: `raw/results/identity-whole-g1.txt`
  compares the `src` clone's linked executable with the line-table build's, and every loaded section differs
  (`.text` 35,510,239 against 35,510,431 bytes), but the two builds also differ in their tree and its configuration
  (`src` was configured for the placements), so that comparison decides nothing. On the development machine (clang
  23.1.6; `scripts/identity-local.sh`, `raw/identity/local-frontend-unit.txt`) the front end's unit compiled by the
  build's command with `-g`, with `-gline-tables-only` added and without `-g`: `.text` is 2,078,218 bytes with `-g`
  and 2,078,282 bytes, the same bytes, with line tables and with none; `.rodata`, `.data` and `.data.rel.ro` are the
  same in all three. So full debug information changes that unit's code a little.

## 9. The compiler building itself

`scripts/selfbuild.sh` (`raw/results/self/`): stage 1 is the `src` clone's Release compiler; the units' options are
the build's (`./build.sh print-compile-flags` without debug information) less `-O3`, `-Wall` and `-Werror`, as
buster's `tools/ci/selfhost.c` takes them.

| Step | Default tier | Tier 1 (`--tier1`) |
| --- | --- | --- |
| All 43 units, eight at once (`compile-TIER-j8.txt`) | 5.05 s wall, 35.5 s of CPU | 6.03 s, 56.4 s |
| The longest units in that step | the checker's 3.05 s, the front end's 2.49 s, the backend's 2.26 s | |
| The checker's unit alone, its default lanes (`units.txt`) | 1.75 s wall, 1.99 s of CPU | |
| The link of all (`links.txt`: the build's own link command with every object replaced) | 0.07 s | 0.06 s |
| The link with the checker's unit's object alone replaced (the hybrid) | 0.07 s | 0.07 s |
| `-c sqlite3.c`, seven runs on CPU 2 (`speed.txt`): stage 1 127.5 ms, 606 million user cycles | 1,047.9 ms (+722%), 5,708 million (+842%) | 595.3 ms (+367%), 3,201 million (+428%) |
| ... by the hybrid | 694.4 ms (+445%), 3,754 million (+520%) | 436.4 ms (+242%), 2,325 million (+284%) |

All five executables write the same `sqlite3.o` (`speed-objects.txt`: `5c6e1e7ba14b5e6d...`). The executables aren't
baked (stage 1's linked file is the one compared). Their tests: section 6.

## 10. CI's clang

The official LLVM 23.1.4 release that buster's CI stages on the host
(`~/.cache/buster/benchpress-clang/efdd1dbd...`, `tools/ci/setup-benchpress.sh`): nothing was fetched or built for
this record. Its `clang` is statically linked and has a `.bolt.org.text` section.

- **One compile**, alone on CPU 2 (`scripts/compile.sh src UNIT official` against `plain`): the checker's unit 45.4 s
  against 56.6 s, the backend's 28.2 s against 35.9 s, the front end's 20.6 s against 24.9 s, `c_parser_benchmark.c`
  7.7 s against 9.4 s.
- **The tree as staged, first on `PATH`** with CI's `BUSTER_CLANG_RESOURCE_DIR` and `LD_LIBRARY_PATH`
  (`tables/scenarios-configs.tsv`'s `official-clean` and `official-checker`, in `cfg`): the configure step prints
  `parallel native generation is off: no llvm-nm 23.1.4, llvm-objcopy 23.1.4, LLVM libraries llvm-config can link,
  shared or static` (`raw/logs/configs-official-clean-1.log`), the units compile whole, and a clean build takes 97.1 s
  (376 s of CPU; the checker's unit 96.7 s) and an edit of `c_check_input.c` 87.8 s.
- **A mixed toolchain** (`tables/scenarios-official.tsv`, in `part`): `prototype/mixed.py` changes the clone's
  `cmake/BusterCodegen.cmake` so that, with `BUSTER_2040_MIXED` set, `llvm-config`, `clang++`, `llvm-nm`,
  `llvm-objcopy` and `llvm-readobj` are the host's (`/usr/bin`, 23.1.1) and pass the version check on their major and
  minor version. clang 23.1.4 then compiles every unit and every part, and the splitter is built against the host's
  LLVM. `raw/logs/mixed-probe.log` is the configure step saying `parallel native generation: 1`.

  | Scenario | Host's clang | CI's clang, mixed |
  | --- | --- | --- |
  | Today's structure, clean | 83.1 s (500 s) | 68.9 s (423 s) |
  | Today's structure, `c_check_input.c` | 72.6 s | 59.7 s: the unit 45.1 s, split 4.3 s, nine parts 57.5 s |
  | Parts with line tables, clean | 54.7 s (444 s) | 44.3 s (365 s) |
  | ... `c_check_input.c` | 16.7 s | 15.0 s (3 parts) |
  | ... `differential.c` | 6.9 s | 5.8 s |
  | ... `tier0.c` | 15.8 s | 13.6 s |
  | ... `c_parser_impl.c` | 4.9 s | 3.9 s |
  | ... `c_checker_driver_test.c` | 12.3 s | 10.7 s |
  | ... `c_checker_test.c` | 12.3 s | 10.7 s |
  | ... `host_isa.h` | 16.7 s | 14.1 s |
  | ... the eleven units alone, the tests unoptimized | 35.7 s (291 s) | 29.3 s (240 s) |
  | ... and 15 jobs | 33.4 s (405 s) | 27.4 s (313 s) |

## 11. The files

- `scripts/`: `lock.sh` (the lock, with this campaign's owner, title and link), `master.sh` and `tasks.txt` (the runs
  in order), `run.sh` (a scenario's build), `compile.sh` and `unit_command.py` (one unit's compile with one change),
  `ab.sh` and `config-speed.sh` (`time-runs`), `tests.sh` and `tests.list`, `selfbuild.sh`, `maps.sh`,
  `maps-all.sh`, `prepare-maps.sh`, `code.sh`, `build-tools.sh`, `text-identity.sh`; the first round's
  `queue-*.sh` and `stop-base.sh`; and the development machine's `stability.sh`, `replay.sh`, `replay-commits.sh` and
  `identity-local.sh`, which hold that machine's paths.
- `tools/`: `function_files.c` (bitcode to functions and references), `trace_functions.py`, `reach.py`,
  `object_functions.c`, `compare_functions.py`, `duplication.py`, and the reducers `scenario_table.py`, `ab_table.py`
  and `tests_table.py`.
- `prototype/`: `presplit.c`, `presplit_shim.cpp`, `presplit.patch`, `mixed.py`.
- `tables/`: the reductions named above.
- `raw/`: `host.txt`; `queue/done.txt`; `results/` (each round's result lines, `compile/`, `ab/`, `tests/`, `self/`,
  `maps/`, `maps-all/`, the identity and speed files); `logs/` (every build's log, time, holder line, Ninja log lines
  and executable's SHA-256); `stability/`, `replay/` and `identity/` (the development machine's counts).

## 12. The stray process, and what was measured beside it

Until 13:51:28 UTC another session's test program looped at 100% of a CPU on the host, outside the lock
(buster#2555). What that means here:

- **Measured again on the clear host, and used:** today's scenarios (section 1), the parts with `-g` as today and on
  15 jobs (section 3.1), the tests' run time of Release, of the unoptimized tests and of the parts (section 6), today's
  build with the tests unoptimized (section 4). Beside the process a clean build read about 5% more wall time and 7%
  more CPU (87.9 s and 534 s against 83.1 s and 500 s; the parts 64.1 s and 532 s against 59.3 s and 497 s); the edits
  of one unit, one clang process at a time on an otherwise idle host, read the same (72.6 s both times); the tests
  within 0.7%.
- **Measured after it ended, once:** the parts with line tables and without debug information (13:55 to 14:03), the
  other configurations, the self-build, CI's clang, the design's rows, every `plain`, `official`, `tests-optnone`,
  `syntax` and `declarations` compile.
- **Measured beside it and kept:** the traces (12:38 to 12:45; each is one process pinned to CPU 2, whose wall time
  is its user and system time to 0.1 s, so it didn't share the CPU); the comparisons of section 3.3 (pinned to CPU 2,
  medians of 12 to 40 runs, user cycles and instructions; `syntax-1` ran from 13:50:31 to 13:54:48, across the
  process's end); the variants' build times in section 3.3's last column, which are for comparing the variants with
  each other and are marked there.

## 13. Limits

- One to three builds a scenario; a build's time is one sample where the tables show one.
- One source revision, one host, one clang (and CI's for section 10). The parts were measured at one count (48 for
  the checker's unit).
- Sections 3.4 and the second half of section 8's last bullet are counts on another machine with another clang
  (23.1.6), not the 9700X.
- The compiler's speed was compared on two workloads, not the 9700X workflow's whole measure.
- The `units` rows leave out the link and the bake (0.4 s) and have no command lists.
- Not measured: hosted runners; the parts' memory; the build directory's size; a clang trained on buster's units.
