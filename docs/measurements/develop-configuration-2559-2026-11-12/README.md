# The Develop configuration's gates (2026-11-12)

The measurements and checks behind buster's Develop configuration, steps 1 to 4 of the design in buster's
`docs/stage1-build-design.md` ([buster#2559](https://github.com/buster14a/buster/issues/2559); the pull request is
[buster#2595](https://github.com/buster14a/buster/pull/2595)). Develop compiles each `main.c` unit to bitcode before
LLVM's optimizer, splits it with `tools/codegen/presplit.c`, optimizes and generates each part in a job of its own,
marks the tests' own functions `optnone`, and leaves 27 benchmark units out of its executable. Each section says which
gate of the issue it answers. The design's own measurements are the earlier record
[stage1-build-design-2040-2026-11-12](../stage1-build-design-2040-2026-11-12/).

- **Sources:** buster `d3799e4a` (the pull request's first commit) and `5f6f8d96` (its head when measured, which keeps
  `c_preprocessor_benchmark.c` in Develop, below), against `main` at `b2a477bc`. Between them only the harness
  (`tools/ci/build_regression.c`) and the list of benchmark units Develop leaves out changed: the units' code, the
  splitter and the parts are the same.
- **The 9700X** (`benchpress`, `raw/9700x/host.txt`): Linux 6.18.50-2-lts, the host's clang and LLD 23.1.1, CMake 4.4.4,
  Ninja 1.13.2, GCC 16.2.1, the `performance` governor; the build's default of eight jobs. Every build, test,
  comparison and inventory shard was its own hold of the 9700X's lock (`scripts/9700x/lock.sh`, each run under
  `timeout 1200`), and records the holder's line (`*.holder.txt`). Other sessions and CI took the lock between holds.
- **The development container** (the `local` files): a 4-CPU cloud container, Ubuntu's clang 23.1.6, CMake 3.28.3,
  Ninja 1.11.1. Its times are not the 9700X's; it served the identity, determinism and splitter-balance checks.
- **What was removed:** `exclusive.sh`'s lock-wait messages (a holder's line and its title and link), which name other
  sessions' work: 3 blocks in the kept logs. The queues' own logs, which held nothing else, aren't kept.

## 1. Build scenarios on the 9700X

`scripts/9700x/run.sh` is the earlier record's `run.sh` (one timed `./build.sh` a hold: its edit, then the build, the
lines Ninja's log gained, the executable's SHA-256, the busiest processes before and after), with a `cleanconfig` edit
that cleans one configuration of the tree. An edit appends an emitted `__attribute__((used)) static` function that
returns a new string literal (`append`), puts it before the file's first line (`prepend`), or before a header's closing
`#endif` (`guarded`). `scripts/9700x/queue.sh` ran the series at `d3799e4a`, `scripts/9700x/queue-head.sh` the clean
builds and the checker's edit again at `5f6f8d96` (`raw/9700x/results/develop.txt`, `head.txt`, `release.txt`;
`raw/9700x/logs/`).

| Scenario | Develop | Part jobs | Gate | Release at the same commit |
| --- | ---: | ---: | ---: | ---: |
| Clean build (`rm -rf build`, configures too), at `5f6f8d96` | **33.8, 33.8, 34.1 s** (265 s of CPU) | all 171 | 60, 45, 40 s | 84.3 s (494 s; one configuration of a configured tree) |
| Clean build at `d3799e4a` (`c_preprocessor_benchmark.c` left out) | 32.7, 32.8, 32.8 s (257 s) | all 171 | | |
| Nothing changed | **0.04 s** (0.03 at `d3799e4a`) | 0 | 0.1 s | 0.03 s |
| `c_check_input.c`, a function appended | **13.5, 13.6, 13.6 s** (`5f6f8d96`); 13.6, 13.7, 13.6 s (`d3799e4a`) | 1 | 20 s | 73.7 s |
| `c_check_input.c`, a function before its first line | 15.4 s | 7 | | |
| `differential.c` (the backend's unit) | 7.3 s | 1 | | |
| `tier0.c` (the checker's and the backend's units) | 14.9 s | 2 | | |
| `c_parser_impl.c` (the front end's unit) | 4.9 s | 1 | | |
| `c_checker_driver_test.c` (a test of the checker's unit) | 13.7 s | 1 | | |
| `c_checker_test.c` (a test root three units read) | 12.1 s | 3 | | |
| `host_isa.h`, a `used` function before `#endif` (every unit emits it) | 14.1 s | 11 | | |
| `host_isa.h`'s time alone | 11.7 s | 0 | | |

- The part jobs are the build log's `Optimizing and generating` lines (`logs/*.log`); `edges` in the results files
  counts the lines Ninja's log gained, which a split's outputs add one each.
- In the clean build, the checker's unit's front end takes 9.0 s and `c_preprocessor_benchmark.c`, which Develop now
  builds (below), 10 s; the build is bound by its work on eight jobs (265 s of CPU).
- Release's rows are a check that the tree's Release is today's: its clean build of one configuration 84.3 s and its
  edit 73.7 s (the earlier record's 83.1 s and 72.6 s at `c5f0efb2`).

## 2. Determinism

After the series of section 1 (twelve builds, eleven edits), `clean-after-edits` removed `build` and built the same
sources again: its executable's SHA-256 is the incremental one's (`logs/develop-header-touch-1.sha256`,
`logs/develop-clean-after-edits-1.sha256`, `logs/develop-nothing-2.sha256`: `f7059e6a6cb8...`).

On the development container, `scripts/local/series.sh` ran the same kind of series (nine edits) through `./build.sh
--config Develop` and then a clean build: the same SHA-256 (`raw/local/series.txt`, `8abe6cdcf853...`). Its first
attempt appended plain external functions, which two units that read one file define twice (a duplicate symbol in any
configuration), so the probes are `used` statics, as the record's were.

## 3. Release and Debug are unchanged

On the development container, at one path (`/home/user/buster`): clean builds of `main` (`b2a477bc`) and of the branch
give the same Release and Debug executables (`raw/local/identity.txt`: `3653be3da48d...` and `a2561942c824...`), and so
does the branch's incremental build over `main`'s tree (Release re-split once, as its splitter's executable changed,
and every part came out the same). `scripts/local/ninja_cmds.py` extracts every unit's compile statement and flags,
the link and the post-link step from Ninja's per-configuration files: Release's and Debug's are the same on `main` and
on the branch (`raw/local/commands.txt`; 65 statements each). An earlier version of the branch added an empty element
to the post-link step's list of objects in Release; that version was not kept.

## 4. Develop's executable writes Release's outputs

`scripts/9700x/objects.sh` runs both executables on the same inputs (`raw/9700x/results/objects.txt`): the frozen
`sqlite3.c`'s `-c` at the default tier and at Tier 1 and its `-E`, and each of the eleven `main.c` units' `-c` and `-E`
with the build's flags (less `-g`, `-O3`, `-Wall` and `-Werror`, as the self-host gate takes them). All 25 outputs are
the same bytes, with the same exit status; `sqlite3.c`'s object is `5c6e1e7ba14b...`, as in the earlier record.
buster's `build_regression --develop-only` compares `-c` of `tools/ci/build_regression.c` at both tiers too.

## 5. The correctness inventory on Develop's executable

`scripts/9700x/inventory.sh` runs `tools/ci/correctness.tests` as the 9700X job's native correctness does, in a clone of
its own (`ci`): CI's staged Clang 23.1.4 first on `PATH` (`tools/ci/setup-benchpress.sh`), `BUSTER_HOST_ARCH=znver5`,
`BUSTER_DEBUG_INFO=0`, the frozen corpus, c-testsuite, SQLite, the pragma oracle and the predefines, and the oracle
cache in `use`. Develop built in parts with that toolchain too (`inventory/prepare.log`: `in parts: TRUE`, a clean
Develop build in 26.0 s). The inventory ran as 8 shards (`parallel --shard K/8` with the vector row's costs), each its
own hold.

- **At `5f6f8d96`** (`raw/9700x/results/inventory/`): all 139 commands pass. Shards 4 and 5 first failed three commands
  (`inventory/first/`): `test-preprocessor --compare-clang --report` and `test-checker-corpus --report` open their
  reports with `fopen(..., "wx")`, so a second run of the inventory in one tree refuses the first run's
  `build/oracle-*.tsv` and `build/checker-sqlite.tsv` (`scripts/9700x/repro.sh` shows it with Release's executable
  too). `scripts/9700x/rerun-shards.sh` removed those reports and ran the two shards again: 58 passed.
- **At `d3799e4a`** (`raw/9700x/results/inventory-d3799e4/`): 137 passed, 2 failed, both fixed in the pull request:
  - *Check unity fixture ownership*: the 9700X's GCC 16.2 rejected the harness's new `snprintf` with
    `-Wformat-truncation` before any check ran. With the fix, `scripts/9700x/ownership.sh` passed on Develop's tree
    (`ownership.log`: "Develop ownership: 595 active fixture/support paths ... across 11 unity units").
  - *Test the preprocessor's cases against clang (part 1 of 4)*: its location-option checks run `benchmark-preprocessor`
    as a child process, which Develop then left out. `c_preprocessor_benchmark.c` stays in Develop since `5f6f8d96`;
    no other test runs a left-out unit's command (a search of the sources for `"benchmark-` in test files).

## 6. The tests' run time

`scripts/9700x/tests.sh` is the earlier record's: the 21 commands of `scripts/9700x/tests.list` once each, from the
`src` clone, by Release's and Develop's executables of `d3799e4a`, alternated (`raw/9700x/results/tests/`).

| | Release | Develop | |
| --- | ---: | ---: | ---: |
| The 21 commands, two runs | 43.4 s, 43.2 s | 47.3 s, 47.3 s | **+9.2%** (gate: 10%) |

The commands whose own tests lost `-O3` pay: `test-x86-encoder` 1.88 s to 2.59 s, `test-refinement src` 2.08 s to
2.96 s, `test-tier0` 2.29 s to 3.01 s, `test-x86-semantics` 0.43 s to 1.07 s, `test-lexer` 3.09 s to 3.46 s;
`test-checker`'s part (26.2 s) and `test-check-units` didn't move. The design's +4.6% marked the three largest units'
tests alone; Develop marks every unit's, the driver's and the x86 unit's among them.

## 7. The compile path's speed

`scripts/9700x/config-speed.sh` (the earlier record's): `time-runs` on CPU 2, one placement of each executable
(`raw/9700x/results/config-speed-*.txt`):

| Workload | Release | Develop | User cycles |
| --- | ---: | ---: | ---: |
| `-c` of the frozen `sqlite3.c`, 7 runs | 601.4 M cycles, 124.2 ms | 612.8 M, 126.5 ms | +1.90% |
| `-fsyntax-only` of the checker's unit, 5 runs | 7,931.6 M, 1,588.9 ms | 8,083.3 M, 1,612.0 ms | +1.91% |

The design measured +1.1% and +1.9% over four placements for its prototype; one placement can't tell differences
under about a percent.

## 8. The splitter, on the development container

`scripts/local/stability.sh` compiles the checker's unit to bitcode from one path, splits it in 48 parts and counts the
parts whose bytes differ from a base split after an edit (`scripts/local/edits.sh`); counts, not timings:

| Edit | Parts changed |
| --- | ---: |
| None, again | 0 |
| A function appended to `c_check_input.c` | 1 |
| A function before `c_check_input.c`'s first line | 7 |
| A function appended to `c_checker_driver_test.c` | 1 |
| A function appended to `tier0.c` | 1 |
| An unused `static inline` function in `host_isa.h` | 0 |
| An anonymous struct and a function at the top of `c_types.c` | 17 with names hashed from printed text, **8** with structural hashes |

- The same source from another directory changed 48 of 49 parts: line tables record the compile's directory, so these
  counts compile from one path, as a tree does.
- **Balance** (`raw/local/parts-*.{costs,times}`, each part's `clang -x ir -O3` timed with four at once): with each
  file's chunks dealt by hash over whole parts (the prototype's rule), the largest part took 17.4 s, one holding
  `c_check_input.c`'s functions, against a mean of 3.8 s (185 s in all); with contiguous slices of each file over runs
  sized at half the mean part, and single callers joined only to callers that can inline them (below), 9.6 s against
  3.6 s (176 s): the pull request's rules. `parts-file-slices.report` is the splitter's `--report` for the second:
  each part's definitions and cost, each file's run, the largest functions.
- The first plan also had a part of 214,000 instructions (cost, not time) of tests: single callers had joined optnone
  callers, which can't inline them. The splitter now joins a single caller only where the caller can inline it, and
  reads no callee for an optnone body.

## 9. `build_regression --develop-only` on the development container

`raw/local/build-regression-develop-only.log`: Develop builds in parts beside Release without changing Release's
executable; switching builds nothing; `benchmark-parser` names Release; both executables write the same objects; a
function appended to `c_check_input.c` optimizes one part, one before its first line 8 of 48, a header's time none; the
executable after the edits is a clean build's (8 min 40 s on four CPUs). The first run
(`build-regression-develop-only-first.log`) required the header's touch not to relink, which it does: the units
Develop compiles whole read the header too.

## Limitations

- The 9700X's scenario series ran at `d3799e4a`; `5f6f8d96` was measured again for the clean build, nothing changed
  and the checker's edit only. The units' code and parts are the same; Develop's clean build gained
  `c_preprocessor_benchmark.c` (1.0 s).
- The speed comparison is one placement; the tests ran twice per executable.
- The inventory ran with CI's toolchain at `znver5` on the 9700X; hosted rows run Release, not Develop.
- Counts in section 8 are the development container's (clang 23.1.6), as are its timings.
