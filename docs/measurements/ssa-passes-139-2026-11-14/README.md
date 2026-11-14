# #139's SSA passes: twins, differential campaigns, compile and run time per pass (2026-11-14)

This is the evidence for [buster#139](https://github.com/buster14a/buster/issues/139)'s last acceptance items and the pull request that carries them ([buster#2724](https://github.com/buster14a/buster/pull/2724)). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01NNmNQs7PB8a6gnJVnQu8HU)), from the claim of 14 November ([comment 6875002222](https://github.com/buster14a/buster/issues/139#issuecomment-6875002222)).

The pull request:
- **`--tier1-passes=LIST`:** turns each pass of `--tier1`'s pipeline on or off (`sccp`, `dce`, `cfg`, `merge`, `licm`, `sroa`, `gvn`, `inline`, `all`). `--tier1-report` counts what each pass did.
- **`test-ir-source --passes`:** every pass by both versions on every function of the corpora.
- **`benchmark-ir-source --passes`:** the same passes timed by both versions.
- **CFG cleanup's merges** (`BUSTER_IR_OPTIMIZE_MERGE`): a block whose only predecessor has it as its only successor joins that predecessor. Tier 1 runs them by default.

## Revisions

| Role | Commit | Tree | What |
| --- | --- | --- | --- |
| main | `ca1ede6a27c1b2e726f2b54e873fd013d03a1fad` | `e05b9aa9bd13100bcd4799cab26c8e0a08f7efd5` | the branch's base; the 9700X's main build |
| measured head | `6651dfb8b6b8b423e68c0b81f6bc2455dd47703b` (`a9010545c` on the 9700X, the same tree) | `881ea1929c9ff7804a246da5cb20e34d5e221dd3` | the four commits and the merges: every 9700X run and every differential campaign |
| final head | `9d64e7fce26dbb712aa2bd88b6efafaf302eed0b` | `3a2fecb74ea901534c7e2c56b23f785d8e9d099f` | `abd0f839`'s change and its revert to the measured merges' code (a comment's difference), with main `8023523` merged: `local/` |

`abd0f839` resolved only the merged phis' forwards. It broke an identity whose root was a merged join's phi: two of `test-ssa-source --typed --tier1 --generate 48`'s programs failed final verification under `--tier1-strict`. `9d64e7fc` restores `6651dfb8`'s walk over every forward and adds a fixture that fails on `abd0f839`. Neither was measured on the 9700X. Their code is the measured head's, except for that one comment.

`9700x/pre-merge/` holds the first pass benchmark, at `4c3991255` (the three commits before the merges). Its compile step failed, because the driver refuses `--no-default-config` and `scripts/queue.sh` passed it, and the queue was then stopped. `scripts/queue2.sh` is the run that counts.

## 9700X

**Host** (`9700x/host.txt`): Ryzen 7 9700X, Linux 6.18.50, CPU 2 with governor and EPP `performance`, clang 23.1.1. Both compilers were built there by `BUSTER_DEBUG_INFO=0 BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`; their hashes are in `9700x/host.txt`.

Every step of `scripts/queue2.sh` ran as one `exclusive.sh` call pinned to CPU 2 (receipts in each log). No step's log lists another busy process.

**Inputs:**
- the frozen corpus's `sqlite3.c` (`0a409f16…`);
- SQLite 3.53.2's `speedtest1.c` (`b5eaf4bb…`);
- Lua 5.4.8's release and the `cc3387f` record's five scripts, copied from `138-tier1-quality-claude/inputs`;
- tcc (`49e2d1af…`).

**Steps** (`9700x/*-a9010545c.txt`):
- `identity`: head's `--tier1 --tier1-passes=-merge` against main's `--tier1`, on speedtest1's unit and Lua's 33 units. Every object is byte for byte main's (`identity status 0`), so the `-merge` variant is main's pipeline.
- `passes`: `benchmark-ir-source --passes` on `sqlite3.c`.
- `compile`: `time-runs --runs 11` of `--tier1 --lanes 1 -c sqlite3.c` with each variant.
- `compile-ab`: `time-runs` of main's and head's builds, for `--tier1` and for Tier 0.
- `programs1` to `programs5`: `measure-tier1-programs --runs 11` with two variants each, beside its own default `--tier1`, Tier 0, clang -O0 and -O2, and tcc.

### Compile time per pass, both versions (`passes`)

The 2,602 functions of `sqlite3.c`: 599,220 lowered IR instructions, 480,852 promoted, 1,794 callers' inlining units. Medians of 21 rounds:

| Pass | Vector, ms | Scalar, ms | Scalar / vector |
| --- | ---: | ---: | ---: |
| SROA | 46.3 | 63.3 | 1.37 |
| #866's solver | 49.3 | 59.4 | 1.21 |
| SCCP alone | 42.9 | 46.7 | 1.09 |
| dead-code removal alone | 38.2 | 47.0 | 1.23 |
| CFG cleanup alone | 30.9 | 40.4 | 1.30 |
| CFG cleanup and its merges | 33.1 | 41.6 | 1.26 |
| the three | 50.4 | 53.1 | 1.05 |
| Tier 1's set | 54.2 | 56.9 | 1.05 |
| LICM | 55.8 | 58.3 | 1.04 |
| the inliner | 22.8 | 30.4 | 1.34 |

### The driver's compile (`compile`, `compile-ab`)

`--tier1 --lanes 1 -c sqlite3.c`, user cycles, medians of 11:

| Variant | M cycles | Against the default |
| --- | ---: | ---: |
| default | 2,459.1 | |
| `-sccp` | 2,500.5 | +1.7% |
| `-dce` | 2,582.3 | +5.0% |
| `-cfg` | 2,474.0 | +0.6% |
| `-merge` | 2,473.0 | +0.6% |
| `-inline` | 2,099.4 | −14.6% |
| `+gvn` | 3,247.3 | +32.0% |
| `+licm` | 3,023.3 | +22.9% |
| `+sroa` | 3,248.5 | +32.1% |
| `+all` | 4,177.3 | +69.9% |
| `-all` | 2,234.6 | −9.1% |

Main against head:
- `--tier1`: 2,463.3 M against 2,457.5 M user cycles (−0.23%), and 480.8 against 482.0 ms wall.
- Tier 0's compile: 588.1 M against 586.9 M (−0.21%).

### Run time per pass (`programs1` to `programs5`)

User cycles and instructions of each variant against its run's own default `--tier1`:

| Variant | speedtest1, cycles | instructions | Lua, cycles | instructions |
| --- | ---: | ---: | ---: | ---: |
| `-sccp` | +3.7% | +9.4% | +5.8% | +5.3% |
| `-dce` | +24.4% | +54.9% | +22.9% | +46.7% |
| `-cfg` | +0.0% | +0.0% | −1.0% | −0.0% |
| `-merge` | −0.6% | −0.1% | +2.0% | −0.0% |
| `-inline` | +4.4% | +3.0% | +1.5% | +0.6% |
| `+gvn` | −0.8% | +4.5% | +11.0% | +10.5% |
| `+licm` | +5.3% | +6.2% | +57.9% | +56.0% |
| `+sroa` | −1.6% | −0.4% | −0.6% | +0.1% |
| `+all` | +2.6% | +7.6% | +58.3% | +60.7% |
| `-all` | +34.2% | +66.7% | +26.9% | +52.5% |

The default `--tier1`'s medians over the five runs: speedtest1 831.1 to 839.5 M cycles, Lua 1,069.8 to 1,086.3 M. Against clang -O2, that is 1.30 to 1.32 times on speedtest1 and 1.19 to 1.21 on Lua. Every build gave speedtest1's verification hash `1248168 a7fa3957…`, and every Lua script printed clang -O0's output.

## Correctness, off the 9700X

On a cloud host (`local/revision.txt`: Xeon, 4 CPUs, clang 23.1.6), at the final head.

`local/`:
- **`passes-*.txt`:** `test-ir-source --passes` on c-testsuite's subset (430 functions), the frozen `sqlite3.c` (2,602) and musl (2,775). Every pass's versions agree. The inliner's alike refusals are buster#2721's.
- **`metamorphic-139-2000.txt`:** `test-ir-metamorphic --seed 139 --count 2000 --max-ms 600000`: 2,000 cases and 1,568,000 checked executions, `status=ok`. A first run under the default 30-second budget stopped at `time-limit` on case 1,870 of the busy host, with the expected value.
- **`test-ir-*.txt`:** each pass's own tests.
- **`ssa-source-generate-*.txt`:** `test-ssa-source --typed --tier1 --generate 48` at four seeds: 192 programs, each compiled strictly by both paths and run natively against clang.
- **Tier 1's own tests:** `c-testsuite-tier1.txt` (`test-c-testsuite --tier1 --code-size`), `ssa-source-c-testsuite.txt` (`test-ssa-source --typed --tier1` on the subset, 220 programs run natively), `tier1-cfg-source.txt`, `test-tier1-*.txt` and `check-debug.txt` (`test-check-debug --cross-check`).
- **`test-checker-driver.txt`:** the driver's tests in four parts, 181,340 checks, 0 failures, with `--tier1-passes=`'s variants among them.

`differential/` holds the 10 campaigns of #142's harness (`scripts/campaign.sh`, `scripts/matrix.txt`), at the measured head (`6651dfb8`, the compiler's hash in `differential/compiler.sha256`). Each campaign is Csmith `0cdc7103` and YARPGen `1adb290f` (#142's pins, built on that host), seeds 5000 to 5039 of each, both of Buster's tiers against clang -O0 and -O2. Tier 1 runs as `--tier1 --tier1-passes=+all` and with each pass turned off from there; `all-scalar` is `+all` with `--scalar`. Each campaign directory keeps its summary, request, provenance, versions and a ledger of every case and mode (`ledger.tsv`); the generated programs aren't kept.

| Tier 1 | Programs | Passed | Failed: clang -O0's link | Failed: clang -O0's 30 s bound |
| --- | ---: | ---: | ---: | ---: |
| `+all` | 80 | 66 | 8 | 6 |
| `+all,-sccp` | 80 | 66 | 8 | 6 |
| `+all,-dce` | 80 | 66 | 8 | 6 |
| `+all,-cfg` | 80 | 66 | 8 | 6 |
| `+all,-merge` | 80 | 66 | 8 | 6 |
| `+all,-gvn` | 80 | 66 | 8 | 6 |
| `+all,-licm` | 80 | 66 | 8 | 6 |
| `+all,-sroa` | 80 | 66 | 8 | 6 |
| `+all,-inline` | 80 | 66 | 8 | 6 |
| `+all` with `--scalar` | 80 | 66 | 8 | 6 |

The same 14 cases fail in every campaign, each first at a step of clang -O0's:
- **8 YARPGen programs (5001, 5002, 5006, 5008, 5010, 5013, 5029, 5035):** their arrays don't fit the small code model, so clang's link refuses them (`relocation truncated to fit`). Buster's link refuses all but 5029 the same way. 5029 links by Buster, and its executables, which touch about 7 GB, were killed (signal 9) by the host's memory limit.
- **6 Csmith programs:** every build's run, clang -O2's included, passes the 30-second bound.

No case shows a difference or a failure of Buster: 660 accepted Tier 1 comparisons in all.

`differential/pre-merge/` has the first four campaigns at `1c29986e` (before the merges): the same 66 of 80, with the same failures.
