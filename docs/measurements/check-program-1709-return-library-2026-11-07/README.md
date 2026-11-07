# check-program's library-noreturn answers by name, Buster #1709

- **Compiler issue:** [#1709](https://github.com/buster14a/buster/issues/1709), found while working on #1671.
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (3.53.2, SHA-256 `0a409f16…`) with the CI's options:
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.
- **Byte-for-byte workload:** sqlite 3.50.4's amalgamation (`sqlite-amalgamation-3500400.zip`, SHA-256
  `1d3049dd0f830a025a53105fc79fd2ab9431aea99e137809d064d8ee8356b032`, from sqlite.org), `-c -g -Wall -Wextra`.

Sources:

| label | revision | what |
| --- | --- | --- |
| main | `829eb71a7caf3d7191ef34c91f321fc11814e046` | the base |
| memo | `2bd94224e083175129d6bd14493d503b2301b005` | the first commit: a byte per interned name, filled by the first search for that name |
| final | `56143cc3a127c973cc96684d0d8f4666dca0b59d` | the branch's head: the 16 catalogue names with `r` interned once per program; no call searches |

The executables' SHA-256 and revisions are in `raw/*/identity.txt` and `ab*/inputs.sha`.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, perf 7.2.9 (`host.txt`).
- **Builds and profiles** (`scripts/prof.sh`): `BUSTER_HOST_ARCH=znver5 ./build.sh`, `measure-compile --runs 11` and
  `perf record -F 20000` of five compiles (`raw/*/measure.txt`, `raw/*/symbol.txt`).
- **Byte-for-byte** (`scripts/same.sh`): main's and the branch's executables, on the vector path and with `--scalar`;
  `cmp` of the objects and of standard error (`same/`, `same-memo/`).
- **Suites** (`scripts/suites.sh`): `test-checker --seed 133`, `test-checker-driver --executable`, `test-checker-asm`,
  `test-check-lanes`, `test-check-units`, `test-check-debug --cross-check`, `test-checker-deferred`, `test-builtins`
  (`suites/status.txt`, `suites-memo/status.txt`).
- **The A/B** (`scripts/ab.sh`): 8 interleaved rounds of `perf stat -r 3`, alternating order, then `measure-compile
  --runs 11` each way with the other as `--reference`; `scripts/summarize.py` gives `ab*/summary.txt`.
- **Lock receipts.** Every build, test and measured run held the lock on its own (`exclusive.sh`, owner
  `claude-1709`). Each A/B's 18 receipts have `held=1` and `status=0`. `scripts/run.sh` and `scripts/run2.sh` drove the
  two series.
- **The probe** (`scripts/probe_searches.py`, not committed in the compiler) counted, off the host, at the memo
  commit, the calls that reach the test and the searches they made (`raw/probe.txt`). Counts, not timings.

## Results

### Calls and searches (`raw/probe.txt`)

| workload | calls reaching the test | searches, main | memo | final |
| --- | ---: | ---: | ---: | ---: |
| frozen `sqlite3.c` `-c` | 13,142 | 13,142 | 2,182 | 0 (16 `intern_find`s) |
| sqlite 3.50.4 `-c -g -Wall -Wextra` | 13,035 | 13,035 | 2,119 | 0 (16 `intern_find`s) |

### Profile (`raw/*/symbol.txt`, share of the compile's cycles)

| symbol | main | memo | final |
| --- | ---: | ---: | ---: |
| `builtin_intrinsic_lookup` | 1.00% | inlined into the next row | absent |
| `check_program_return_library` | — | 0.34% | — |
| `check_program_return_facts` | 1.30% | 1.62% | 1.79% |
| `check_program_return_call` | 0.08% | — | 0.11% |
| sum | 2.38% | 1.96% | 1.90% |

### Main against final (`ab/`)

| measure | main | final | difference |
| --- | ---: | ---: | ---: |
| wall time (`task-clock`), median of 8 rounds | 118.620 ms | 117.420 ms | −1.01%, lower in 8 of 8 rounds |
| user cycles | 576.707 M | 569.578 M | −1.24%, lower in 8 of 8 |
| user instructions | 1,279.591 M | 1,272.399 M | −0.56%, lower in 8 of 8 |
| `measure-compile`'s `check-program` | 24.625 ms | 23.601 ms | −1.02 ms |

Main against memo (`ab-memo/`): wall −0.78% (7 of 8 rounds), user cycles −0.79%, user instructions −0.49%.

### Correctness

- The frozen corpus's objects are the same bytes for all three (`raw/*/object.sha`, `ab*/objects.sha`).
- sqlite 3.50.4's `-c -g -Wall -Wextra`: objects and diagnostics are the same bytes as main's on the vector path and
  with `--scalar`, for memo and final (`same*/cmp.txt`, `same*/sha.txt`).
- All eight suites exit 0 for both (`suites*/status.txt`).
