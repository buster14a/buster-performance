# The coded walk's actions inlined into its chunk's loop, Buster #1671

- **Compiler issue:** [#1671](https://github.com/buster14a/buster/issues/1671), the study in
  [comment 6710430485](https://github.com/buster14a/buster/issues/1671#issuecomment-6710430485).
- **Compiler branch:** `claude/1671-coded-inline` (its PR links this record).
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`, `ab/*/inputs.sha`) with the CI's options:
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

Sources:

| label | revision | what |
| --- | --- | --- |
| `m0` | `1c96661319d907b1deef73115e7690beece3f8ed` | main, the base |
| `i1` | `f38f912cac5c803b7975252caaafeedc430aa41e` | the coded walk's action (`check_input_expression_coded`) always inlined into the untimed loop |
| `i2` | `6c1b3ac83772d295a07f36b443a4d44431cee4d1` | `i1`, and the identifier's, literal's and terminator's actions always inlined |

The executables' SHA-256 and revisions are in `raw/*/identity.txt` and `ab/*/inputs.sha`.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, perf 7.2.9 (`host.txt`).
- **Builds and profiles.** Each tree was built with `BUSTER_HOST_ARCH=znver5 ./build.sh` (debug information on), then
  run under `measure-compile --runs 11` (with `--time-stages`) and `perf record -F 20000` of five compiles
  (`scripts/prof.sh`). `raw/m0` keeps main's profile by symbol, by source line for the coded walk's functions
  (`srcline-*.txt`) and annotated by instruction (`annotate-*.txt`).
- **The A/Bs** (`scripts/ab.sh`, driven by `scripts/run1.sh` and `scripts/run2.sh`): 8 interleaved rounds of
  `perf stat -r 3`, then `measure-compile --runs 11` each way. Every run held the lock on its own with a receipt
  (`ab/*/*.receipt`): all 36 have `held=1`, this record's owner line and `status=0`, between 17:14 and 17:31 UTC on
  7 November. `scripts/summarize.py` gives `ab/*/summary.txt`.
- **The probe** (`scripts/probe_coded.py`) patches the source to count the walk's actions by class, its splices'
  values, its flushes by cause and its visits by role, and to sum `__rdtsc` deltas of each. It was built and run off the
  host, on a cloud VM, on sqlite 3.50.4's amalgamation (`raw/probe/`). Its counts are what the record uses. Its times
  are not: the VM took 6,821 page faults in the walk, which put the flush at 36% of the actions there, against 0.8% of
  the compile on the 9700X.
- **Correctness** (`raw/local-checks.txt`), off the host: main and both heads give the same object and diagnostics for
  `-c -g -Wall -Wextra` of sqlite 3.50.4's amalgamation on the vector and `--scalar` paths, and both heads pass
  `test-checker` (8 parts), `test-checker-driver --executable ./build/compiler` (4 parts and
  `--lazy-system-headers`) and `test-checker-deferred`.

## Results

### What the walk does (`raw/probe/probe-run3.txt`)

- **451,790 actions** over 695,362 postorder positions, making **316,456 nodes**. 229,679 actions splice no values.
- **By class:** identifiers 95,402; lists 74,297; terminators 54,508; literals 44,184; binaries 42,766; members 32,076;
  separators 25,008; groups 21,674; calls 13,399; conditions 11,258; casts 8,924; prefixes 8,440; subscripts 7,005;
  returns 4,234; initializers 3,997; scalar 2,658; postfixes 2,065; strings 1,890; ternaries 663.
- **Flushes:** 3,592 before a visit (226,578 nodes), 87 of a full batch (88,659 nodes), 1 at the end (51 nodes).

### Where main's cycles go (`raw/m0`)

Shares of the whole compile's cycles, by source line grouped by part:

| part | share |
| --- | ---: |
| each action's call frame: the call site, the prologue and epilogue, the switch and the spills | about 2.3% |
| the preparation: the compaction's gather 0.47%, the identifiers' gathers about 1.1%, the literals about 0.8% | about 2.4% |
| `check_graph_record_nodes` | 0.78% |
| the flush's writes and gathers | about 0.6% |
| the batch's adds | 0.57% |
| the value splice | 0.56% |
| each class action's own body | 0.17% at most |

**The call frame in the annotation.** `annotate-range.txt` shows each action called with four arguments pushed on the
stack after a `vzeroupper`. That sequence is about 60% of `check_input_expressions_coded_range`'s samples.

### The builds' own profiles (`raw/*/symbol.txt`, `raw/*/measure.txt`)

| build | `check-input` | `expressions.actions` | the coded walk's symbols |
| --- | ---: | ---: | --- |
| `m0` | 46.251 ms | 10.005 ms | `_coded` 3.73%, `_coded_range` 1.26% |
| `i1` | 45.840 ms | 9.579 ms | `_coded_range` 2.83%, and clang now calls `_identifier` 0.72%, `_literal` 0.43%, `_terminator` 0.21% |
| `i2` | 45.712 ms | 9.437 ms | `_coded_range` 4.27% |

### Main against the heads (`ab/`)

| measure | `m0` | `i1` | difference | `m0` | `i2` | difference |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| wall time (`task-clock`), median of 8 rounds | 121.935 ms | 121.530 ms | −0.33% | 121.810 ms | 120.990 ms | −0.67% |
| round by round, median | | | −0.35%, 7 of 8 lower | | | −0.71%, 8 of 8 lower |
| user cycles | 591.404 M | 589.945 M | −0.25% | 591.072 M | 586.604 M | −0.76% |
| user instructions | 1,298.686 M | 1,283.071 M | −1.20% | 1,298.686 M | 1,278.616 M | −1.55% |
| `check-input`, `measure-compile` | 46.425 ms | 45.693 ms | −0.73 ms | 46.480 ms | 45.673 ms | −0.81 ms |
| `expressions.actions` | 10.060 ms | 9.566 ms | −0.49 ms | 10.075 ms | 9.436 ms | −0.64 ms |

**The objects.** All four executables' objects are the same bytes (`ab/*/objects.sha`).
