# The walk in source order's plain and ignored visits, Buster #1671

- **Compiler issue:** [#1671](https://github.com/buster14a/buster/issues/1671), #529's follow-up.
- **Compiler PR:** [#1676](https://github.com/buster14a/buster/pull/1676).
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`) with the CI's options:
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

Sources:

| label | script label | revision | what |
| --- | --- | --- | --- |
| main | `mc` | `cb021b04a7c6d9748a52a4185c444f7721f7cb4d` | the base |
| head | `f2` | `430951501126247ac42e61170fdf25cc59c9c89b` | #1676's two commits: plain names' visits (`95b63188`) and ignored tokens' visits |

The executables' SHA-256 and revisions are in `raw/*/identity.txt` and `ab/inputs.sha`.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, perf 7.2.9 (`host.txt`).
- **Builds and profiles.** Each tree was built with `BUSTER_HOST_ARCH=znver5 ./build.sh`, then run under
  `measure-compile --runs 11` and `perf record -F 20000` of five compiles (`scripts/prof2.sh`, `raw/*/measure.txt` and
  `raw/*/symbol.txt`). Each step ran under its own hold of the lock.
- **The A/B** (`scripts/ab.sh`, driven by `scripts/run9.sh`):
  - **Rounds.** 8 interleaved rounds of `perf stat -r 3` of each executable, the order alternating by round.
  - **`measure-compile`.** Then `measure-compile --runs 11` each way, each with the other executable as its
    `--reference`.
  - **Lock receipts.** Every run held the lock on its own with a receipt (`ab/*.receipt`). All 18 have `held=1`, this
    record's owner line and `status=0`. They ran from 14:34 to 14:38 UTC on 7 November.
- **The visit counts** come from a probe that is not committed (`scripts/probe_visits.py`, which patches the source to
  print them). It was built off the host and run once on the same workload. They are counts, not timings.

## Results

### The walk's visits (the probe, at the head, `raw/probe.txt`)

| visit | count | at the head |
| --- | ---: | --- |
| a plain name: an identifier operand, marked for its syntax alone, of no syntax bit | 124,581 of 254,391 | the label's test and the name's step alone |
| a token an earlier step ignored, marked for its syntax alone, not a return's or a for's | 40,290 | passed over |
| another token marked for its syntax alone | 55,876 | the general visit |
| a visit with another mark's reason | 33,643 | the general visit |

Of the ignored tokens, 36,757 are a declaration's later specifiers. Every visit the general path still takes acts:
- declarations' starts at a specifier, 12,368;
- blocks, 12,470, and conditions, 11,258;
- casts, 8,910;
- returns, 5,266;
- scopes' ends, about 17,900;
- activations, about 11,100.

### Main against the head (`ab/`)

| measure | main | head | difference |
| --- | ---: | ---: | ---: |
| wall time (`task-clock`), median of 8 rounds | 122.510 ms | 121.830 ms | −0.56% (round by round, median −0.51%) |
| user cycles | 595.868 M | 592.436 M | −0.58% |
| user instructions | 1,320.752 M | 1,302.454 M | −1.39%, the same in every round |
| `measure-compile`'s wall time, as default against reference | 123.119 ms | 122.465 ms | |
| `check-input` | 47.115 ms | 46.908 ms | −0.21 ms |

**The objects.** Both executables' objects are the same bytes (`ab/objects.sha`), as are the per-build runs'.

**`check-input` across the runs:**
- **Main:** 47.127 and 47.115 ms.
- **The head:** 46.592 ms (`raw/head`) and 46.908 ms.

**By symbol** (`raw/*/symbol.txt`), `check_input_resolve_range` went from 5.58% to 4.60% of the cycles. Measured by
instructions, the head retires 18.3 M fewer per compile, about 110 a visit of the 164,871 the two paths take. Its
cycles fell by about a fifth of that: the tests it no longer makes were cheap and well predicted.
