# The declaration steps' frames without attributes, Buster #1671

- **Compiler issue:** [#1671](https://github.com/buster14a/buster/issues/1671).
- **Compiler PR:** [#1680](https://github.com/buster14a/buster/pull/1680).
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`) with the CI's options:
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

Sources:

| label | script label | revision | what |
| --- | --- | --- | --- |
| main | `m3` | `07b78e0f72b013caebcdf9be0621bac5d4cd823f` | the base, with #1676 |
| head | `d1` | `2021b8503e4e18c29001e1cd3e5c28dfcc89d233` | #1680: the attribute steps' early exits |

The executables' SHA-256 and revisions are in `raw/*/identity.txt` and `ab/inputs.sha`.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, perf 7.2.9 (`host.txt`).
- **Builds and profiles.** Each tree was built with `BUSTER_HOST_ARCH=znver5 ./build.sh`, then run under
  `measure-compile --runs 11` and `perf record -F 20000` of five compiles (`scripts/prof2.sh`).
- **The A/B** (`scripts/ab.sh`, driven by `scripts/run10.sh`): 8 interleaved rounds of `perf stat -r 3`, then
  `measure-compile --runs 11` each way. All 18 runs held the lock on their own with a receipt (`ab/*.receipt`), each
  with `held=1`, this record's owner line and `status=0`, at 15:57 and 15:58 UTC on 7 November.
- **The probes** (`scripts/probe_declarators.py` and the two described in `raw/probe-declarators.txt`) patch the source
  to sum `__rdtsc` deltas by class. They were built and run off the host, on a cloud VM, three times each. Their
  shares and counts are what the record uses; their values are not 9700X timings.

## Results

### Where the declaration steps' time goes (`raw/probe-declarators.txt`)

| declarator | count | TSC cycles per call (third run) |
| --- | ---: | ---: |
| a name | 5,431 | 196 |
| pointers and a name | 3,834 | 325 |
| empty or pointers alone, mostly casts' type names | 9,342 | 204 |
| a function's, with its parameters | 5,914 | 4,070 |
| an array's | 235 | 6,674 |
| attributed, other | 94 | |

**Function declarators.** These take about 80% of the declarators' time. Within them:
- **Attribute lists.** 1,895 of them are read, mostly glibc prototypes', at about 20% of the time.
- **Parameters' specifiers.** The 14,783 parameters' specifiers take about 11%.
- **Type warnings.** The 42,404 calls of `check_input_attribute_type_warnings` take about 10%.
- **The rest.** About 60% goes to each parameter's bookkeeping and the function type.

**Frames without attributes.** 40,403 of the 42,404 frames, the declarations' and the parameters', have no attribute
list. Their attribute steps cost about 70 TSC cycles each, the probe's own overhead included.

### Main against the head (`ab/`)

| measure | main | head | difference |
| --- | ---: | ---: | ---: |
| wall time (`task-clock`), median of 8 rounds | 121.740 ms | 121.490 ms | −0.21% (round by round, median −0.14%) |
| user cycles | 590.785 M | 589.415 M | −0.23% |
| user instructions | 1,304.696 M | 1,299.420 M | −0.40%, the same in every round |
| `check-input`, `measure-compile` as default | 46.614 ms | 46.388 ms | −0.23 ms |

**The objects.** Both executables' objects are the same bytes (`ab/objects.sha`).

**`check-input` in each build's own run:** 46.612 ms on main and 46.314 ms at the head.

**By symbol:**
- `check_input_declarator_step` went from 1.95% to 1.73% of the cycles;
- `check_input_declarator` went from 0.66% to 0.57%.
