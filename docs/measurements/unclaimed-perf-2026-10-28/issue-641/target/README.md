# #641 target qualification, 2026-10-28

Retain `7c1f0b09b7e68b28f8281f06580d5c33540d21ae`. Its warning/report,
initializer lookup, shared static-data declaration and emission-clear changes
pass the target checker, driver and deferred suites and preserve object bytes.
The final SQLite runs are close to timing noise; they consistently use about
2.1 MiB less peak RSS. This evidence does not establish a broad compile speedup.

Reject the additional compact-selection/producer-policy slice
`a29b4072c5dc2a5834e4ffce6ab1e274d9afd20b`: its direct comparison with the
retained slice gives -0.25% paired throughput on CPU2 and +0.14% on eight
physical workers, with only 20–48 KiB less peak RSS. That does not justify its
additional representation and policy complexity. The complete experimental
branch `codex/perf-641` remains at a29b4072; `codex/perf-641-retained` points to
7c1f0b09. Neither branch was pushed and no PR was opened.

## Identity and reproducibility

All target work ran on the shared Ryzen 7 9700X host `benchpress`, Linux
6.18.50-2-lts, Clang 23.1.1. The target working directory was
`~/buster-fast-bench/unclaimed-perf-20261028`. Every target build, test and
benchmark acquired `~/buster-fast-bench/exclusive.sh` with owner
`codex-641-qa`, a descriptive title and the #641 link. No machine settings were
changed. Single-worker samples use CPU2; eight workers use physical CPUs 0–7.
Each compiler process uses `--lanes 1`. Correctness suites that exercise
threads have affinity 0–7. Builds use `BUSTER_DEBUG_INFO=0`.

| Role | Source commit | Executable SHA-256 |
| --- | --- | --- |
| base | `bc1b486150850fe00bad1361a19f57d67706bb3b` | `d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d` |
| retained initial | `7c1f0b09b7e68b28f8281f06580d5c33540d21ae` | `541688062fa0addfa7e8d48ff61a5af9ccaf297fa382e5df367d0c7076938186` |
| full experiment | `a29b4072c5dc2a5834e4ffce6ab1e274d9afd20b` | `70da6ec07a4946e9b0724d6f7b868918176e90765293f5e6c904b86f9611f3af` |

The `base-`, `initial-` and `head-blobs.expected.txt`/`.target.txt` pairs match
all 661 tracked source blobs against their named commits. `identities.txt`
and `initial-and-paths.txt` record target binary hashes. The retained build
compiled all 41 units (`641-qa-initial-build.log`). Original C measurement and
analysis helpers are retained beside the raw receipts; no timing information
is reconstructed from rounded report values.

The frozen SQLite source is 9,507,037 bytes, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
The source and header/predefine corpus are the same in every SQLite arm.
The common compiler arguments, from the target working directory, are:

```text
--lanes 1 -c
-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17
--predefines corpus/gnu17-pinned-predefines.txt --clang-features
--target=x86_64-linux-gnu -march=znver5 -nostdinc
-isystem corpus/headers/usr/lib/clang/23/include
-isystem corpus/headers/usr/local/include
-isystem corpus/headers/usr/include
-Icorpus/sqlite corpus/sqlite/sqlite3.c -o @OUTPUT@
```

The cohort command shape is `./samples ROUNDS JOBS TASKS SOURCE OUTDIR
./cohort BASE HEAD COMMON_ARGS`. It alternates the arm order by round. One
worker compiles four tasks per cohort; eight workers compile 32. Stage samples
use seven rounds, one worker and one task, adding `--time-stages`. Sample logs
record each cohort's wall clock, all child CPU clocks, wait4 peak RSS, faults,
context switches, failures and output bytes. `children.tsv` and compiler
stderr are retained under `results/`; large repeated objects remain on the
target, with local per-object hash receipts.

## Final retained-slice results

`641-qa-final-initial-j1.log` and `641-qa-final-initial-j8.log` contain 11
rounds each, role0=base and role1=retained initial. There are no omitted rounds.
Throughput is source bytes divided by complete cohort wall time, including
process creation, object writing and process exit. The reported ratio is the
median of the 11 paired head/base throughputs. Separate arm medians need not
have the same ratio.

| Workers | Base median MB/s | Retained median MB/s | Paired throughput change | Base/retained peak RSS KiB |
| --- | ---: | ---: | ---: | ---: |
| 1, CPU2 | 66.042091 | 66.357940 | +0.4350% | 517196 / 515032 |
| 8, physical 0–7 | 191.443642 | 192.149268 | +0.7309% | 517204 / 515044 |

RSS is the median cohort maximum of per-process wait4 peak RSS, not the sum
of eight concurrent processes. Amortized cohort wall per completed task is
143.954210→143.269019 ms with one worker and 49.659716→49.477352 ms with
eight; the latter is not individual concurrent-file latency. Per-compile CPU
and fault details are in the `*-summary.txt` files. All processes succeed.
Single-worker final samples have no major faults. Eight-worker arms have
70/56 major faults in total, retained in the comparison.

The seven-round eight-worker A/A control uses the identical baseline binary
in both arms (`641-qa-aa-j8.log`). It reports +0.5176% median paired drift;
individual paired ratios range 0.986936–1.026473. It has 48/60 major faults.
The retained change's modest timing gains are within this dispersion, so
near-neutral throughput plus a roughly 2.1 MiB RSS reduction is the defensible
whole-compile conclusion.

### Construction, handoff and consumer stages together

`stage-initial-summary.tsv` reports seven base/retained pairs, using complete
compiler runs. These are stage clocks from the real compile path. The report
does not rely on `benchmark-lowering-source`, which constructs static data and
program state outside its timed region.

| Stage | Base median ms | Retained median ms |
| --- | ---: | ---: |
| check-input | 65.679 | 66.380 |
| check-expressions | 15.993 | 15.531 |
| check-declarations | 2.923 | 2.356 |
| static-data | 0.430 | 0.477 |
| check-program | 12.246 | 12.044 |
| select | 0.885 | 0.902 |
| emit-setup | 1.248 | 1.183 |
| lower | 14.610 | 14.507 |
| whole compiler total | 143.571 | 143.094 |

For each individual process, the post-check sum charges check-declarations,
static-data, check-program, select, emit-setup and lower together; the median
of these complete sums is 32.320→31.489 ms (-2.57%). Including warning
producers check-input and check-expressions gives 114.237→113.328 ms (-0.80%).
These medians are formed after summing each run, rather than by adding stage
medians. The complete stage-reported total changes -0.33%. This preserves the
cost of construction and policy handoff when assessing the removed scans.

### Small controls and memory

The external c-testsuite input is pinned to
`5c7275656d751de0e68b2d340a95b5681858ed07`; its checkout was verified locally
before copying it outside the compiler repository to `641-qa-inputs/` on the
target. No third-party implementation was added to the compiler repository.
The standard CI c-testsuite checkout was absent on this host, so this explicit
copy was used. `c-testsuite-token-bins.tsv` records actual parser token counts
under the frozen stdgnu17/predefines/header options. The bins contain 154
units under 300 tokens, 61 at least 3000 tokens and five between them.

`small_samples.c` starts a fresh compiler for each unit/arm. CPU2 is pinned
for the entire run. Round0 is declared warmup and retained; rounds1–7 are
measured. Pair order alternates by file and round. Wall clocks cover fork
through wait4, all outputs are nonempty and every pair's complete object and
diagnostic bytes are compared. The harness fails on compiler failure, missing
or empty output, or differing bytes; `/bin/false` and `/bin/true` negative
controls demonstrate failure and missing-output rejection. The same frozen
options as SQLite are used without SQLite defines or its include path.

`641-qa-small-initial.tsv` has all 3,520 records (220 units × two arms ×
eight rounds) and 1,760 byte-identical object/diagnostic pairs. The summary
below sums each unit's seven measured median whole-process times. RSS is the
median across units of each unit's seven-run median peak RSS.

| Bin | Units | Base/retained sum ms | Cost change | Base/retained median RSS KiB |
| --- | ---: | ---: | ---: | ---: |
| under 300 tokens | 154 | 223.996882 / 223.421673 | -0.257% | 21924 / 21780 |
| 300–2999 tokens | 5 | 9.264849 / 9.237386 | -0.296% | 24832 / 24620 |
| at least 3000 tokens | 61 | 161.788907 / 160.522090 | -0.783% | 33232 / 31116 |
| all | 220 | 395.050638 / 393.181149 | -0.473% | 21964 / 21842 |

The maximum measured per-process RSS is 61312/61228 KiB. Timing differences
are small; no general small-file speedup is claimed. `small-initial-summary.tsv`
also records the paired per-round aggregate ratios. This is a complete
declared suite, without selective removal of unusual times or faults.

## Correctness and exact-byte evidence

The final retained initial target executable passes:

- `641-qa-initial-checker.log`: 388,497 checks, zero failures (seed641).
- `641-qa-initial-driver.log`: 21,646 checks, zero failures, including 1,600
  independent dense warning-collector comparisons.
- `641-qa-initial-deferred.log`: 70 fixtures, 1,113 checks, 684 successful
  merges, 6,492 separately read bodies, zero failures.
- `641-qa-initial-c-testsuite.log`: 220/220 end-to-end native tests, zero
  unsupported or failed, with `/usr/bin/clang` cross-check and eight workers.
  Invocation is `test-c-testsuite --cross-check --clang /usr/bin/clang
  --jobs 8 --subset tests/c-testsuite/subset.txt ../641-qa-inputs/c-testsuite`
  from the retained source directory.

The target checker resolves the four fpclassify oracle differences seen on
the laptop with its different Clang. The laptop full-a29 campaign, sanitizer
adapters, native 220/220 c-testsuite execution/cross-check, call-graph checks
and their limitations are separately recorded in `../README.md`; they should
not be represented as exact-initial target results.

The retained small campaign above preserves object and diagnostic bytes in
all 1,760 pairs. The equivalent full-a29 small campaign also passes all 1,760
pairs and is retained in `641-qa-small-full.*`/`small-summary.tsv`.

`641-qa-object-hashes-v3.txt` records 2,046 SQLite objects across the original
base/full runs, full stage runs, A/A runs and initial/full ablation. They all
have one SHA-256:
`cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`.
This includes objects from all three exact compiler revisions.
`641-qa-object-hashes-final.txt` adds the 806 final base/retained objects from
both complete-compile campaigns and the retained stage campaign, all with
the same hash. Both audited commands exit0 and check the expected count and
one unique hash. In total, 2,852 SQLite objects agree exactly.

## Ablation and remaining issue scope

The original base/full campaigns (`641-j1.log`, `641-j8.log`) give +0.03%
and +1.39% paired throughput. The direct 11-round ablation
`641-qa-ablate-j1.log`/`j8.log` uses role0=initial7c and role1=fulla29, not
base/head. It gives -0.246% on CPU2 and +0.141% on eight workers. The 20–48 KiB
RSS difference is small relative to the retained slice's roughly 2.1 MiB.

The full stage screen (`stage-summary.tsv`) has static-data 0.445→0.621 ms
and select 0.903→1.130 ms. These are a separate base/full campaign, not a
paired stage ablation against7c. In that campaign post-check construction
through lowering changes 32.165→31.822 ms, and warning producers through
lowering changes 113.787→113.588 ms. Together with the direct complete-compile
ablation, this supplies no evidence to keep the additional moved policy work.

The retained slice removes the initializer token-sized clear, reuses shared
static declaration keys, counts warning columns during their existing
production, skips empty report scans, and sparsifies the readable emission
scratch domain. Its metadata has explicit prepared flags; hand-built inputs
without trusted producer metadata retain dense fallbacks. Regression tests
exercise empty/capacity/tail/poisoned-domain cases and compare to independent
dense oracles. No diagnostic or object-byte change is intended.

Residual #641 scopes are explicit: selection still has its original
object-domain scratch and root/inline reduction scans; builtin ownership and
body ordering keep their original fallback searches. A producer-owned
attributed-declaration list is also not implemented: emission still scans
pointer candidates once before declaration identity checks. The rejected
second slice explores the selection/producer work, but it is not part of the
retained solution. #641 should therefore be described as partially addressed.

## Rejected collection attempts

The first two object-proof attempts assumed `rg` was installed on the target;
it was not. Their logs are retained, and neither is a proof. Version1's empty
stdin SHA is unrelated to any object. Version3 uses installed `find`, fails
closed on pipeline errors, verifies the expected 2,046 count and one unique
hash, and succeeds. `ablation-and-proof.tar.bin` is a preliminary archive with
extra text appended after the tar stream; the extracted raw logs and separate
identity files are authoritative. The later clean archives do not append
text to a tar stream. A first read of the final-proof archive happened before
the queued audit began; its missing-file error is a rejected collection,
with the completed audit collected separately.
