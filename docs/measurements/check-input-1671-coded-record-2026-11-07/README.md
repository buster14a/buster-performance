# The coded walk's flush records its nodes 16 at a time, Buster #1671

- **Compiler issue:** [#1671](https://github.com/buster14a/buster/issues/1671), the design in
  [comment 6710774694](https://github.com/buster14a/buster/issues/1671#issuecomment-6710774694).
- **Compiler branch:** `claude/1671-coded-record` (its PR links this record).
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`, `ab/record/inputs.sha`) with the CI's
  options: `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

Sources:

| label | revision | what |
| --- | --- | --- |
| `m1` | `73fcf006d` (`raw/m1/identity.txt` has it whole) | main, the base |
| `r1` | `c72eafc8dd918a3ca14537c7d350019795b6eeec` | the flush's vector path records its nodes as it writes them (`check_input_batch_record`) |

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, perf 7.2.9 (`host.txt`).
- **Builds and profiles.** Each tree was built with `BUSTER_HOST_ARCH=znver5 ./build.sh`, then run under
  `measure-compile --runs 11` (with `--time-stages`) and `perf record -F 20000` of five compiles (`scripts/prof.sh`).
- **The A/B** (`scripts/ab.sh`, driven by `scripts/run3.sh`): 8 interleaved rounds of `perf stat -r 3`, then
  `measure-compile --runs 11` each way. All 18 runs held the lock on their own with a receipt (`ab/record/*.receipt`),
  each with `held=1`, this record's owner line and `status=0`, at 18:19 and 18:20 UTC on 7 November.
  `scripts/summarize.py` gives `ab/record/summary.txt`.
- **Correctness** (`raw/local-checks.txt`), off the host on a cloud VM:
  - **Objects and diagnostics.** Main (`73fcf006`) and the head give the same object and diagnostics for `-c -g -Wall -Wextra` of
    sqlite 3.50.4's amalgamation on the vector and `--scalar` paths.
  - **The suites.** The head passes `test-checker` (8 parts), `test-checker-driver --executable ./build/compiler`
    (4 parts and `--lazy-system-headers`) and `test-checker-deferred`.
  - **An independent validation.** `scripts/probe_recorded.py` patches the head so that every graph is also validated
    and the recorded purity and counters compared with the validation's. On sqlite 3.50.4 the whole graph, 309,214
    nodes, compares equal.

## Results

### The builds' own profiles (`raw/*/symbol.txt`, `raw/*/measure.txt`)

| build | `check-input` | `expressions.actions` | shares of the compile's cycles |
| --- | ---: | ---: | --- |
| `m1` | 44.626 ms | 10.191 ms | `check_graph_record_nodes` 0.82%, `_flush` 0.77%, `_coded` 4.06%, `_coded_range` 1.28% |
| `r1` | 43.677 ms | 9.362 ms | `check_graph_record_nodes` below 0.1%, `_flush` 1.62%, `_coded` 3.99%, `_coded_range` 1.08% |

**Where the recording went.** The flush now holds it: the flush grew by 0.85% of the cycles as
`check_graph_record_nodes`' 0.82% went. The walk's other two symbols fell by 0.27%. These are shares of single
profiles; the A/B below is the measurement.

### Main against the head (`ab/record`)

| measure | main | head | difference |
| --- | ---: | ---: | ---: |
| wall time (`task-clock`), median of 8 rounds | 119.810 ms | 119.135 ms | −0.56% (round by round, median −0.55%, 8 of 8 lower) |
| user cycles | 582.419 M | 578.394 M | −0.69% |
| user instructions | 1,307.854 M | 1,298.923 M | −0.68% |
| `check-input`, `measure-compile` | 44.619 ms | 43.946 ms | −0.67 ms |
| `expressions.actions` | 10.269 ms | 9.546 ms | −0.72 ms |

**The objects.** Both executables' objects are the same bytes (`ab/record/objects.sha`).

### After #1692 merged (`ab/after-1692`, `raw/m2`, `raw/r2`)

#1692, which inlines the coded walk's actions, merged to main while this change was open. So the branch was merged with
main, as `r2` (`38152245a3de7bd58370703af35991f57899d6a8`), and measured again against that main, `m2`
(`219e7e9bd4ed2d13fd82e28f6c5b275474b25ecc`), the same way (`scripts/run4.sh`). All 18 runs have `held=1`,
this record's owner line and `status=0`. `r2` passes the same off-host checks (`raw/local-checks.txt`).

| measure | main | head | difference |
| --- | ---: | ---: | ---: |
| wall time (`task-clock`), median of 8 rounds | 119.460 ms | 118.450 ms | −0.85% (round by round, median −0.88%, 8 of 8 lower) |
| user cycles | 580.282 M | 575.560 M | −0.81% |
| user instructions | 1,288.534 M | 1,279.602 M | −0.69% |
| `check-input`, `measure-compile` | 43.966 ms | 43.183 ms | −0.78 ms |
| `expressions.actions` | 9.660 ms | 8.868 ms | −0.79 ms |

**The objects** are the same bytes (`ab/after-1692/objects.sha`). In the builds' own profiles,
`check_graph_record_nodes` goes from 1.03% of the cycles to below 0.1%, and the flush from 1.05% to 1.79%.

### A refinement that didn't pay (`ab/refined-*`, `raw/r3`)

In `r2`'s profile, the recording's gathers were most of the flush's samples:
- a leaf's type and overload head from its record;
- three operands' purity from `recorded_pure`.

`r3` (`65e6d83b901294b9e37033a5f79df472c6115fc0`, `scripts/run5.sh`) replaced them:
- **Leaves.** It kept a leaf's purity as a batch byte, written with the leaf.
- **Operands.** It took their purity lane by lane in node order, as the vector validator does.

It gives the same objects, passes the same checks, and its recording equals the validation on `sqlite3.c`
(`raw/local-checks.txt`). It was measured twice, every run with `held=1` and `status=0`:

| A/B | wall | user cycles | user instructions | `check-input`, each way |
| --- | ---: | ---: | ---: | --- |
| `m2` against `r3` | −0.68% (8 of 8) | −0.77% | −0.28% | 44.021 → 43.318 ms |
| `r2` against `r3` | −0.30% (5 of 8) | −0.27% | +0.41% | 43.122 / 43.113 ms |

Against `r2` it is no faster:
- **`check-input`** is the same both ways;
- **The rounds' cycles** overlap (573.8–579.9 M against 573.1–577.9 M);
- **The flush** fell from 1.79% to 1.31% of the cycles, but the removed gathers had overlapped with the flush's other work, and the loop added instructions.

So the branch reverted it, and the change is `r2`.
