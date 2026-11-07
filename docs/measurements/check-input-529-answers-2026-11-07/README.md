# check-input's binding answers and deprecated marks, Buster #529 and #1489

- **Compiler issues:** [#529](https://github.com/buster14a/buster/issues/529) and
  [#1489](https://github.com/buster14a/buster/issues/1489).
- **Compiler PRs:**
  - [#1642](https://github.com/buster14a/buster/pull/1642), merged as `0d00a1cb` before it was measured;
  - [#1646](https://github.com/buster14a/buster/pull/1646), its follow-up.
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`) with the CI's options:
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

Sources:

| label | script label | revision | what |
| --- | --- | --- | --- |
| main | `m2` | `53854a7c2e5f9b2d48d73c967329597650943a42` | the base |
| d05ff565 | `b2` | `d05ff56599634d9adb7f09dbad0d156828bcc83d` | #1642's first two commits: the deprecated marks gathered only where a filter passes, and the unused-declaration facts visit only the declare events |
| 13e88387 | `b3` | `13e8838711f7e2c084d8c971888a172e5c767e17` | its third: the binding answers' lists of uses and declarations built once |
| 1642 | `b4` | `9ce56d36fc392ee3d7535f2845bdb46d60e4dd8e` | #1642's code as merged: after `13e88387` come `c81dcdee` (the answers loop visits only the listed uses), `d3221341` (the deprecated filter tests the declarations before any gather) and `9ce56d36` (a branch-free splice in the expressions' walk) |
| head | `b5` | `6d1f7cfc8cc97fa372bc15bca1e5e8d7fc2a7093` | #1646's head: #1642's code with its review notes applied and `9ce56d36`'s splice reverted |

The executables' SHA-256 and revisions are in `raw/*/identity.txt`, and the A/B's in `ab/*/inputs.sha`.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, perf 7.2.9 (`host.txt`).
- **Builds.** Each tree was built with `BUSTER_HOST_ARCH=znver5 ./build.sh` (debug information on), under the host's
  lock for the build alone (`scripts/prof2.sh`).

**Per-build runs** (`scripts/prof2.sh`; each step under its own hold of the lock):
- `measure-compile --runs 11`, giving `raw/*/measure.txt`.
- `perf record -F 20000` of five compiles, giving `raw/*/symbol.txt`, by symbol.

**Profiles** of main and the head:
- **Samples.** `perf script -F ip,sym,symoff,dso` of the same data, giving `profile/*-samples.txt`.
- **Main's branch misses.** `perf record -e branch-misses:u -c 2000` of five compiles (`scripts/misses.sh`).
- **Inlined frames.** The samples were mapped to their inlined frames and lines with `llvm-symbolizer --inlining`,
  off the host, on the executables copied from it (`scripts/sym.py`; `scripts/symm.py` for the misses). This gives
  `profile/*-breakdown.txt`.
- **Shares.** These are of all of the five compiles' samples in `samples.txt`, kernel ones included. They differ
  slightly from `symbol.txt`'s.

**The A/B** (`scripts/ab.sh`, driven by `scripts/run6.sh` and `scripts/run7.sh`):
- **Rounds.** 8 interleaved rounds of `perf stat -r 3` of each executable, the order alternating by round. Then
  `measure-compile --runs 11` each way, each with the other executable as its `--reference`.
- **Lock receipts.** Every run takes the lock on its own and writes, inside the hold, a receipt (`ab/*/*.receipt`):
  the time, `BUSTER_9700X_HELD` and the owner file, then the run's status. All 38 receipts have `held=1`, this
  record's owner line and `status=0`.
- **When they ran.**
  - `ab/main-vs-1642`: 11:18 to 12:05 UTC on 7 November, between other sessions' and CI's holds.
  - `ab/main-vs-head`: 12:24 to 12:26 UTC.
  - `ab/1642-vs-head` ran `measure-compile` alone, at 12:31 UTC.

## Results

### Where check-input went at main (`profile/main-53854a7c-*-breakdown.txt`)

`check-input` took 48.164 ms of the 129.883 ms span (`raw/main/measure.txt`). By symbol (`raw/main/symbol.txt`):

| symbol | cycles |
| --- | ---: |
| `check_input_resolve_range` | 5.17% |
| `check_input_expression_coded` | 3.77% |
| `check_input_declarator_step`, `_declaration`, `_specifiers`, `_declarator` | 4.99% together |
| `check_input_expressions_coded_range`, `_expression_literals`, `_flush`, `_identifiers`, `_classes` | 3.89% together |
| `check_input_binding_answers` | 1.16% |
| `check_input_run` | 1.02% |
| `check_input_deprecated_marked` | 0.73% |
| `check_input_binding_answer` | 0.66% |

Within `check_input_binding_answers`, `check_input_unused_events` was 0.65% of the samples.
- **Branch misses.** The expressions' coded walk had 5.58% of the compile's misses and `check_input_binding_answers`
  3.91%. `check_input_resolve_range` had 2.5%.
- **The walks.** The two walks' cost is spread over their lines, and their branch misses don't account for it.

### Each step of #1642, by one `measure-compile` each (`raw/*/measure.txt`)

| build | `check-input` | `expressions.actions` | span |
| --- | ---: | ---: | ---: |
| main | 48.164 ms | 10.034 ms | 129.883 ms |
| d05ff565 | 47.780 ms | 10.178 ms | 129.479 ms |
| 13e88387 | 47.471 ms | 10.020 ms | 128.892 ms |
| 1642 | 47.315 ms | 10.388 ms | 128.725 ms |
| head | 47.312 ms | 10.112 ms | 128.984 ms |

`9ce56d36`'s branch-free splice put the walk's actions about 0.37 ms above the builds without it. Every A/B below
agrees, so the head reverts it.

### Main against #1642's code (`ab/main-vs-1642`)

| measure | main | 1642 | difference |
| --- | ---: | ---: | ---: |
| wall time (`task-clock`), median of 8 rounds | 130.580 ms | 129.000 ms | −1.21% (round by round, median −1.22%) |
| user cycles | 632.684 M | 624.880 M | −1.23% |
| user instructions | 1,402.433 M | 1,410.587 M | +0.58% |
| `measure-compile`'s wall time, as default against reference | 131.057 ms | 129.766 ms | |
| `check-input` | 48.200 ms | 47.464 ms | −0.74 ms |
| `expressions.actions` | 9.968 ms | 10.436 ms | +0.47 ms |

### Main against the head (`ab/main-vs-head`)

| measure | main | head | difference |
| --- | ---: | ---: | ---: |
| wall time (`task-clock`), median of 8 rounds | 130.585 ms | 128.685 ms | −1.45% (round by round, median −1.51%) |
| user cycles | 633.126 M | 623.186 M | −1.57% |
| user instructions | 1,402.433 M | 1,399.712 M | −0.19% |
| `measure-compile`'s wall time, as default against reference | 131.443 ms | 129.260 ms | |
| `check-input` | 48.072 ms | 47.120 ms | −0.95 ms |
| `expressions.actions` | 9.955 ms | 10.157 ms | |
| minor faults | 6,368 | 6,351 | −17 |

- **`measure-compile` against each other.** The head against main was −2.248 ms apart, and main against the head
  +1.960 ms.
- **The objects.** Both builds' objects are the same bytes (`ab/*/objects.sha`, SHA-256 `68189b29…`), as are the
  per-build runs' (`raw/*/object.sha`).
- **`wait4` peak.** It was 275,004 KiB for the head in both of this A/B's `measure-compile` runs, against main's
  272,272 KiB. In the head's own run (`raw/head/measure.txt`) it was 272,316 KiB.
- **`expressions.actions`.** The head's values are 10.157 ms (whose range reaches 12.076 ms), 10.112 ms
  (`raw/head`) and 10.019 ms (`ab/1642-vs-head`). Main's are 9.955 ms, 9.968 ms and 10.034 ms.

### #1642's code against the head (`ab/1642-vs-head`, `measure-compile` alone)

| as default | default | reference | apart | default's `expressions.actions` | default's `check-input` |
| --- | ---: | ---: | ---: | ---: | ---: |
| head | 128.943 ms | 129.926 ms | −0.983 ms | 10.019 ms | 46.924 ms |
| 1642 | 129.767 ms | 129.426 ms | +0.341 ms | 10.411 ms | 47.361 ms |

### The head by symbol (`raw/head/symbol.txt`)

| symbol | main | head |
| --- | ---: | ---: |
| `check_input_binding_answers` | 1.16% | 0.87% |
| `check_input_binding_answer` | 0.66% | 0.58% |
| `check_input_deprecated_marked` | 0.73% | 0.27% |
| `check_input_resolve_range` | 5.17% | 5.17% |
| `check_input_expression_coded` | 3.77% | 3.80% |

By inlined frame (`profile/head-6d1f7cfc-cycles-breakdown.txt`, shares of all samples), against main's:

| where | main | head |
| --- | ---: | ---: |
| `check_input_binding_answers` | 1.26% | 0.91% |
| · `check_input_unused_events` | 0.65% | 0.47% |
| `check_input_binding_answer` | 0.70% | 0.58% |
| `check_input_deprecated_marked` | 0.69% | 0.27% |
| `check_input_resolve_range` | 4.95% | 4.92% |
| `check_input_expression_coded` | 3.76% | 3.80% |
