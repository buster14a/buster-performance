# What remains of check-input after the coded walk's cuts, Buster #1671

- **Compiler issue:** [#1671](https://github.com/buster14a/buster/issues/1671), comments
  [6712447466](https://github.com/buster14a/buster/issues/1671#issuecomment-6712447466) (the study) and
  [6712543319](https://github.com/buster14a/buster/issues/1671#issuecomment-6712543319) (the declarations).
- **No compiler change came of this record.** It holds a study of `check-input` at main `829eb71a`, which found no
  remaining part worth more than about 0.3 ms by local changes, and four measured attempts, none of which paid.
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`) with the CI's options:
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

Sources:

| label | revision | what |
| --- | --- | --- |
| `m3` | `829eb71a7caf3d7191ef34c91f321fc11814e046` | main, the base |
| `c1` | `933073d855ee71a06f4b8606f4e4a6920101f78e` | the coded walk's rare class actions (call, string, return, initializer, ternary) `noinline` |
| `l1` | `b397952bb83eb5685b85f223d9bea87496c0c27d` | the walk in source order's label marks a line of 64 at a time, the parents' roles and kinds gathered |
| `l2` | `38004ba823c04f5da4d056eb3993671b8bbaeb36` | the label marks made before the walk, without gathers |

The executables' SHA-256 and revisions are in `raw/*/identity.txt` and `ab/*/inputs.sha`.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, perf 7.2.9 (`host.txt`).
- **Builds and profiles.** Each build was made with `BUSTER_HOST_ARCH=znver5 ./build.sh`, then run under
  `measure-compile --runs 11` and `perf record -F 20000` of five compiles (`scripts/prof.sh`, driven by `run6.sh` to
  `run9.sh`).
- **Line profiles.** `raw/m3/resolve-srcline.txt` and `raw/m3/coded-srcline.txt` are main's profile by line for the
  walk in source order and for the coded walk.
- **The expressions' walk by class.** `raw/m3/classes.txt` is `benchmark-checker-bindings --passes 9`
  (`scripts/classes.sh`), with #1038's numbering by passes.
- **The A/Bs** (`scripts/ab.sh`): 8 interleaved rounds of `perf stat -r 3`, then `measure-compile --runs 11` each way.
  All 54 runs held the lock on their own with a receipt (`ab/*/*.receipt`), each with `held=1`, this record's owner line
  and `status=0`. `scripts/summarize.py` gives `ab/*/summary.txt`.
- **The probes** (`scripts/probe_*.py`) patch the source to count, and to sum `__rdtsc` deltas. They were built and run
  off the host, on a cloud VM, on sqlite 3.50.4's amalgamation (`raw/probes/`). Their counts are what the record uses,
  and their ticks only as shares. `scripts/callers.sh`'s call-graph recording on the 9700X didn't unwind, so the
  lookup's callers come from `probe_lookup.py`.
- **Correctness of the label marks' two versions** (`raw/local-checks.txt`), off the host:
  - Both give main's objects and diagnostics on both paths.
  - Both pass the checker suites, `l2` after a fix of its scratch handling.
  - `l1`'s twin test in `test-checker` fails when its vector path is broken on purpose.

## Results

### Where main's cycles go (`raw/m3`)

`check-input` is 43.15 ms. In shares of the whole compile's cycles:

| part | share |
| --- | ---: |
| the coded walk: its loop's spills 0.83%, the flush's recording 0.72%, the value splice 0.69%, the dispatch 0.68%, byte gathers 0.57%, the compaction 0.47%, the batch's adds 0.42% | about 6% |
| the walk in source order, its own lines (none above 0.27%) | 4.30% |
| the declaration steps (`check_input_declarator_step` 1.76%, `check_input_declaration` 1.53%, `check_input_specifiers` 1.15%, `check_input_declarator` 0.44%) | about 4.9% |
| `check_input_run`, the binding answers, the warning graph, the intrinsics' setup, `check_input_bind` (none above 0.11% a line) | 0.4–1.0% each |

`builtin_intrinsic_lookup` is 0.95%. All 13,142 of its calls come from check-program's `check_program_return_call`
(`raw/probes/lookup-callers.txt`). That is outside check-input, and a separate task.

### The probes (`raw/probes`)

- **The walk in source order by path.** Plain names are 124,581 visits and about 17% of its ticks; ignored tokens are
  40,290 visits and about 3%; general visits are 89,519 and about 80%, with the declaration steps they start.
- **The declarations.** File-scope ones are 6,776 at about 5,200 ticks each, 70% of the steps' ticks; block-scope ones
  are 8,929 at about 1,560.
- **The specifiers.** Of the 42,308 calls, 40,820 repeat an earlier call's tokens exactly, from 1,488 distinct
  sequences. 15,839 calls are one typedef name, 16,457 one keyword and 10,012 longer.

### The expressions' walk by class and #1038's numbering (`raw/m3/classes.txt`)

- **The class actions** are 1 to 12 ns a token, about 3.4 ms in all, below the timer's resolution per class.
- **The numbering by passes**, one of the stages a graph by passes needs, takes 3.21 ms for 323,623 nodes (9.9 ns a
  node).

So a graph built by passes would spend on its numbering alone what the actions it replaces cost.

### The attempts (`ab/`)

| A/B | wall | user cycles | user instructions | `check-input`, each way |
| --- | ---: | ---: | ---: | --- |
| `m3` against `c1` | −0.08% (3 of 8 lower) | +0.02% | +0.00% | 43.177 / 43.232 ms |
| `m3` against `l1` | +0.29% (1 of 8 lower) | +0.28% | −0.24% | 43.107 / 43.316 ms |
| `m3` against `l2` | −0.13% (6 of 8 lower) | −0.03% | −0.43% | 43.083 / 42.872 ms |

- **`c1`.** Its user instructions are identical to the instruction: clang had already kept those actions out of line.
- **`l1`.** Its marks by line cost 0.82% of the cycles (`raw/l1/symbol.txt`), about 430 cycles a line. That is more than
  the per-visit tests they replaced, which were about 0.45%.
- **`l2`.** Its pre-pass costs 0.12%. It removes 5.5 M instructions but no cycles: the per-visit tests were cheap and
  well predicted.

All objects are the same bytes (`ab/*/objects.sha`).
