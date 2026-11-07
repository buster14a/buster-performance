# check-input's outcome and its system headers, Buster #529

- **Compiler issue:** [#529](https://github.com/buster14a/buster/issues/529).
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`) with the CI's options:
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

## The issue's 9700X step at its close (`ci/`)

The issue was filed with #520's step at `1677a3b`: `check-input` took 81.2 ms of the 189.2 ms span. The step's
latest run on the reader's code is the PR job of buster#1646. That is run 42371769735, job 128403580154, on
`6d1f7cfc` merged into main. Its log, with GitHub's timestamps cut, is `ci/job-128403580154.log`.
- **`measure-compile --runs 11`** (its line 1058 on): `check-input` 47.340 ms (46.758 to 47.694) of the 126.558 ms
  span.
- **The base's and the head's objects** for the A/B, built from base `65268945` and the head, were compared with
  `cmp`. The step prints "the objects differ" only when they do, and it printed nothing.

## The system headers' cost to the reader (`raw/`, `scripts/`)

Issue #529's work item 2 asked to skip the system-header declarations nothing uses. These runs bound what that could
take off. They use one executable, buster#1646's head built with `BUSTER_HOST_ARCH=znver5` (`raw/identity.txt`). They
ran on the Ryzen 7 9700X (`benchpress`), CPU 2, each run under its own hold of the host's lock (`host.txt`).

**The units** (`scripts/sysdecl.sh`):
- **`sq.i`**: `sqlite3.c` preprocessed (`-E`) with the options above.
- **`sys.i`**: its system headers' lines alone (`scripts/sysfilter.py`). These are the lines under line markers with
  the system flag `3`, in order, with every line marker kept. It compiles as a unit of its own.
- **`empty.c`**: an empty file.

The inputs' SHA-256 are in `raw/inputs.sha`. Each unit ran under `measure-compile --runs 11`, and so did `sqlite3.c`
itself.

| unit | `check-input` | span |
| --- | ---: | ---: |
| `empty.c` | 0.018 ms | 0.312 ms |
| `sys.i`, the system headers' lines | 3.849 ms | 6.092 ms |
| `sq.i`, the whole unit preprocessed | 46.369 ms | 115.634 ms |
| `sqlite3.c` | 47.399 ms | 129.112 ms |

So all of the system headers' declarations cost the reader at most 3.8 ms, 8.1% of the stage.

**How many the unit names** (`scripts/unused.py`, `raw/unused.txt`). The system lines hold 2,683 declarations, and
the unit's own lines name 114 of them. The other 2,569 hold 93.7% of the system lines' tokens. The script counts a
declaration as used only when the unit's own lines spell one of its names. A declaration reached only through
another system declaration, such as a typedef's struct, therefore counts as unused, so the true share is lower.

**`-flazy-system-headers` today** (`scripts/lazy.sh`, `raw/measure-lazy.txt`). It skips only the system headers'
unreferenced bodies, not their declarations. With it, `check-input` took 73.013 ms against the default's 47.399 ms,
and the span 149.285 ms. Its plan rebuilds the unit's bindings first (buster#1364). Both modes' objects are the same
bytes (`raw/lazy-objects.sha`).

**`sq.i` and `sqlite3.c`.** The preprocessed unit's `check-program` took 24.737 ms against `sqlite3.c`'s 31.217 ms.
That stage is not #529's. buster#628's work in buster#1647 records that `sqlite3.c`'s default warnings replayed the
whole unit.
