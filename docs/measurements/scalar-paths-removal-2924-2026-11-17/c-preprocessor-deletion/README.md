# C12a: the preprocessor keeps its vector kernels alone, but `pp_define`'s body scan (#2924)

buster `c12a` branch, on C11a (`cba560ce1`, buster#3019):
- **`dbeb325a9` tests** (the twins present): `pp_kernel_digest` folds what the kernel comparisons read (the stream, the expansion history, the directive tables and raw errors, the diagnostics' counts) into an FNV-1a digest. Every comparison of a built-in case checks its vectorized run's digest against `tests/preprocessor-kernels/digests.tsv`, and so do the text `-E -P` prints (`print/` lines) and the fuzz batch's sum per mode. 1,848 digests, recorded where every comparison passed, twice with `$TMPDIR` of two lengths; four hold their directory's name and read `-`. Three new cases, from this record's two surviving mutants.
- **`cdf49131c` deletion:** every preprocessor twin but `pp_define`'s body scan (`pp_scan_body_scalar`, #2924's open question), with `PPPrepare.vectorized`; the start order names the printer and the frontend's `pp_without_splices` again.

The gate is [`../c-preprocessor-gate`](../c-preprocessor-gate).

## 9700X

[`run.sh`](run.sh), [`logs.tar.gz`](logs.tar.gz): base `dbeb325a9` against head `cdf49131c`, Release, every run under the lock, timings on CPU 2, every process from a fresh copy. [`ab_parse.py`](ab_parse.py) reads the `time-*.log` files.

**`-E` text:** byte-identical, base against head: sqlite3.c (2.6 MB), Lua's units (2.5 MB), musl's 1,336 units (24.2 MB), and buster's `main.c` with the complete driver, with line markers (26.1 MB) and with `-P` (25.7 MB).

**Objects:** byte-identical. `-c` (Tier 0) and `-c --tier1` of sqlite3.c, Lua, musl and buster's `main.c`: 1,372 of 1,372 each.

**Whole compiles:** `ab`, three rounds, around `time-runs` of base, head and base again (three runs of three copies each). User cycles against base, by round:

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| sqlite3.c, `-E` | +0.28%, +0.28%, +0.18% | −0.14%, −0.00%, −0.14% | 0.274 M fewer |
| Lua's units, `-E` | +0.31%, +0.03%, +0.09% | −0.12%, −0.13%, −0.40% | 1.926 M fewer |
| musl's units, `-E` | +0.17%, −0.14%, −0.01% | −0.18%, +0.25%, +0.08% | 5.65 M more |
| musl's units, `-c` | −0.08%, −0.41%, −0.47% | +0.00%, −0.02%, −0.17% | 12.0 M more |
| sqlite3.c, `-c` | −0.15%, +0.39%, +0.36% | −0.01%, +0.09%, +0.10% | 0.403 M fewer |

**`benchmark-preprocessor`** (`logs/bench-ROUND-SIDE-INPUT.log`), cycles by round, base / head / base again:

| Benchmark | Round 1 | Round 2 | Round 3 |
| --- | --- | --- | --- |
| `main.c`, `--only vectorized`, per input token | 65.76 / 65.04 / 66.02 | 66.08 / 65.16 / 65.46 | 65.58 / 65.11 / 66.00 |
| sqlite3.c, `--only vectorized`, per input token | 37.42 / 37.31 / 37.72 | 37.55 / 37.15 / 37.52 | 37.51 / 37.15 / 37.58 |
| `--tables src`, per token | 0.206 / 0.187 / 0.206 | 0.207 / 0.190 / 0.207 | 0.205 / 0.189 / 0.206 |
| `--defines src --only vectorized`, per macro compiled | 881.1 / 868.8 / 885.6 | 877.6 / 867.5 / 878.4 | 890.6 / 867.2 / 883.7 |
| `--embed 16777216`, per byte | 1.176 / 1.224 / 1.175 | 1.175 / 1.178 / 1.175 | 1.174 / 1.176 / 1.178 |

Base's `--tables` times its scalar twin by turns with the vector kernel (it has no `--only` there), which head's has not.

**The start section** (`logs/start-*.txt`, functions inside `.text.buster_start`): head's has `pp_print`, base's `pp_print_vector` (the same code: `pp_print` is the printer now). `pp_remove_splices_by` and `pp_run_main` are inlined in head into `pp_without_splices` and `pp_preprocess_file`, both in the section.

**Tests on head:** all pass but `test-preprocessor --clang`: `test-preprocessor` (and `--tables src`), both fuzz modes, `test-files` (three ways), `test-parser` (and `--clang` on `main.c`), `test-refinement`, `test-lexer`, `test-call-graph`, `check-call-graph`, the complete driver's `parse`, `-fsyntax-only -Wall -Werror`, `--verify -c` and `--scalar --verify --lower-all -c` of `main.c`, and the ownership check. `test-preprocessor --clang` fails as base's does, the same 131 lines but for the trees' paths (`run1/clang.tar.gz`: base's `base-clang.log`, head's `t3.log`): `-dM` and feature answers against benchpress's system clang 23.1.1, whose predefines have `__SSP_STRONG__ 2`.

## The first run: the start order

[`run1/`](run1): the same script on head `f21af6eea` (the deletion before the start order's fix, the tests without the three new cases) against `6433a56d4`. Text and objects were byte-identical, but musl's `-E` read +0.47%, +0.51% and +0.84% (base again −0.15% to +0.13%), with the same 5.65 M more instructions.
- **Where the instructions are:** `units.sh` counts `-E` of the first 1, 2, 10, 100 and 400 of musl's units: head retires 17,341, 33,863, 88,386, 452,486 and 1,207,872 more. The excess falls from 17 K for one unit to 3 K a unit, so it grows with the files a unit prepares first, not with tokens. Lua's units retire 1.93 M fewer, and sqlite3.c 0.28 M fewer.
- **Profiles** (`prof3.sh`, 20 runs of each, period 100,003 + 2i): the printer's code is the same size in both (299.1 M in `pp_print` against 300.9 M in `pp_print_vector`), and the other differences are inlining moving code between functions: `pp_without_splices` has its own 22 M in head, `pp_run_main`'s 3.8 M is in `pp_preprocess_file`. The sampling's error is larger than the 5.65 M, so the profile doesn't place the instructions.
- **The stages** (`bisect.sh`): the deletion's work-in-progress commits don't build in Release, so only the endpoints were counted.
- **The start section:** base's held `pp_print_vector`, `pp_remove_splices_by` and `pp_run_main`, which head's didn't. `cmake/BusterStartOrder.txt` named the printer `pp_print_vector`, so head's 35 KB `pp_print` was linked in cold `.text`, as was the frontend's newly out-of-line `pp_without_splices`. The second run's head names both, and musl's `-E` reads within base again's spread.

## Mutants

[`mutation/`](mutation): 13 mutants of the kernels whose twins the deletion removes, each built (Develop) in an archived copy of the tree and checked against `test-preprocessor` and `test-files` (`run_c12a.py`, `mutants_c12a.py`, `results.txt`).
- **First round** (head `f21af6eea`'s tree): 11 killed. Two survived:
  - `m2-splits-unknown`: the count of unknown tokens a prefix splits, left out. No case had an unknown token that a prefix the mode doesn't have starts (`u8''` before C23, an unterminated `u"` before C11).
  - `m12-separation`: no space between a pp-number and a `+` or `-`. No case printed a pp-number before a sign its exponent would take (`1e` then `+1`).
- **The tests commit's three new cases**, checked against clang 23.1.6's text, kill both (`c12a-r2`, head `3ea3d00b8`'s tree, the same kernels).

## Sanitizers

[`sanitizers.sh`](sanitizers.sh), [`sanitizers.log`](sanitizers.log): MSan and ASan (vector host, Release) of head, in the cloud container.

All clean, with no sanitizer report in any log: `test-preprocessor`, `test-files`, `test-parser`, `-E` of `main.c`, and `test-preprocessor-fuzz --std c23 --fuzz 300`. The script's first fuzz runs passed `--count`, which the command doesn't take; the log has the runs with `--fuzz`.
