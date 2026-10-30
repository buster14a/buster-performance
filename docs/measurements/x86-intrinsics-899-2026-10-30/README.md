# #899's bf16 vector lowering: command cost on the 9700X, 2026-10-30

[Buster #899](https://github.com/buster14a/buster/pull/899) adds bf16 vector arithmetic,
square roots and fused multiply-adds. Campaign `acC` measures its command cost against its
parent, [#898](https://github.com/buster14a/buster/pull/898), with a byte-identical A/A
copy and code-placement controls. These commands do not measure the runtime speed of the
new bf16 instructions. No throughput change is resolved by this record.

- **Base:** `081f16c51c277bbdb9497f285b7120ec8a4832ed` (`base`).
- **Head:** `0d0de695aebaf1fddf82500aaa4062dc899e9942` (`h9f`).
- **A/A:** a copy of base's executable (`aa`), with the same SHA-256.
- **Host:** Ryzen 7 9700X, CPU 2; Clang 23.1.1, Linux `6.18.50-2-lts`.
  The script takes the shared 9700X lock separately for each build, test or measured run;
  the outer `ab` delegates the lock to each `time-runs` invocation.
- **Builds:** `BUSTER_DEBUG_INFO=0`, the trees' ordinary native `build.sh` flags;
  `SOURCE_DATE_EPOCH=1792454400`. The complete commands are in `acC/acC.sh`.

## Inputs and identity

`sqlite3.c` is the frozen input from corpus `preprocessor-391e729af658`, with its pinned
predefines and system headers. `drive` checks it with `-fsyntax-only --clang-features`;
`lower` compiles it with `-c` without `--clang-features`. It calls no x86 builtin.
`main` checks the head's own `main.c`, the same file for all three executables, using the
head's `build.sh print-compile-flags` and `--lanes 1`. All six initial compilation/check
commands exited 0. The three SQLite objects are byte-identical (`acC/acC.log`,
`acC/inputs.sha256`). This is object identity for that input, not a corpus-wide semantic
qualification of the new bf16 lowering.

The campaign saved each source tree's complete file-hash list before building. All 785
base files and 787 head files match the tracked bytes of the exact commits above. Their
aggregate hashes are in `sources.sha256`; the full historical lists are retained in
`acC/sources-base.sha256` and `acC/sources-h9f.sha256`.

## acC: single-placement counters

After building and checking the inputs, `acC.sh` ran three rounds whose order rotates,
using `perf stat -r 11` (`-r 5` for `main`) for user instructions, user cycles and
task-clock. The medians of the three rounds, from `acC/perf.log`, are:

| Measure | base | A/A copy | h9f |
| --- | ---: | ---: | ---: |
| SQLite `-fsyntax-only`, instructions | 1,025,525,397 | 1,025,525,395 | 1,025,526,531 |
| SQLite `-fsyntax-only`, user cycles | 469.798 M | 468.481 M | 469.354 M |
| SQLite `-c`, instructions | 1,302,991,951 | 1,302,991,954 | 1,303,000,228 |
| SQLite `-c`, user cycles | 592.630 M | 593.016 M | 593.383 M |
| `main.c -fsyntax-only`, instructions | 19,791,818,417 | 19,791,817,558 | 19,791,741,728 |
| `main.c -fsyntax-only`, user cycles | 7,538.752 M | 7,501.829 M | 7,511.871 M |

The head's instruction differences are +1,134, +8,277 and -76,689 respectively, each
below 0.001%; the A/A copy differs by -2, +3 and -859. User-cycle differences are
-0.09%, +0.13% and -0.36%, against the A/A copy's -0.28%, +0.07% and -0.49%.
These single placements do not establish a throughput improvement or regression.

## acC: placements and fresh copies

The script then links each tree at six offsets of `main.c`'s own unit: 0, 768, 1536,
2304, 3072 and 3840 bytes. It runs three `ab` rounds, each with three runs of each
placement from three fresh copies, for SQLite `-c` and `-fsyntax-only --clang-features`.
`base-again` runs the same base placements a second time as a comparison floor.
This follows the exact head's [profiling guide](https://github.com/buster14a/buster/blob/0d0de695aebaf1fddf82500aaa4062dc899e9942/docs/profiling.md).
All 972 timed processes exited 0; each round reports zero failed processes and `ab`
reports zero failed runs (`acC/whole.log`).

| Command | h9f user cycles, rounds 1 to 3 (range over placements) | base-again user cycles, rounds 1 to 3 |
| --- | --- | --- |
| SQLite `-c` | +0.02% [-0.38, +0.29], -0.05% [-0.46, +0.40], +0.10% [-0.35, +0.43] | +0.06%, +0.08%, +0.04% |
| SQLite `-fsyntax-only` | +0.05% [-0.27, +0.70], +0.13% [-0.36, +0.74], -0.08% [-0.67, +0.59] | -0.06%, +0.06%, -0.03% |

Every head range includes zero, and both commands change sign across rounds. The head's
round medians average about +0.02% for `-c` and +0.03% for `-fsyntax-only`, while the
base-again averages are +0.06% and -0.01%. Wall-time differences are +0.02%, -0.03%,
+0.08% for `-c` (base-again +0.00%, +0.01%, +0.01%) and +0.08%, +0.07%, -0.07% for
`-fsyntax-only` (base-again -0.04%, +0.01%, -0.04%). These small mixed-sign results
resolve no throughput change. They do not all fall within the reference's own range;
the raw placement and copy spreads remain available in the log.

The head's `.rodata` is 11,358 bytes larger, including 7,260 bytes from the eleven
copies of `x86_effects_rows`. Its `.text` starts 12,288 bytes later, at `0x8f2000`
against `0x8ef000`, and is 11,488 bytes longer (`acC/sizes.log`). The shifts vary offsets
within a page; no control places base's code at the head's later whole-page start.
This record attributes no timing difference to a particular table or code change.

## Recovery and limitations

This packet was recovered read-only from
`benchpress:/home/david/buster-fast-bench/claude-126-cloud/acC` on 2026-10-30. Its historical
`acC.log` ends with `done` and its host modification time is 02:51:02 UTC
(`acC/recovery-metadata.log`); no campaign process remained during recovery.
No measurement was rerun. Twenty historical scripts, logs and manifests are preserved
byte for byte and match fresh host hashes (`acC/transferred-files.sha256`). Fresh read-only
verification of the nine recorded inputs, executables and objects and all twelve shifted
executables passed (`acC/recovery-hash-verification.log`).

The source archives, executables, SQLite objects and external corpus are omitted; source
commits and recorded hashes identify them. The script expects those source archives and
the host's corpus/toolchain/lock when reproducing it. The counter loop did not record
individual `perf stat` exit codes, but all 27 counter blocks contain all three measured
events without an error. No new bf16-heavy source workload, generated-program performance,
`main.c -fsyntax-only` workload over placements, extra cache/branch events or whole-page
layout control was run.
CI and sanitizer qualification remain separate from this historical command-cost evidence.

## Files

| File | Content |
| --- | --- |
| `acC/acC.sh`, `acC/acC.log`, `acC/perf.log`, `acC/inputs.sha256` | Historical commands, completion log, counters and input/binary/object identities. |
| `acC/build_*.log`, `acC/lower_*.log`, `acC/main_*.log` | Historical build and initial compilation/check output, including empty successful logs. |
| `acC/whole.log`, `acC/whole_*.log`, `acC/acC-whole.sha256` | Placement/copy measurements, shifted-build output and executable hashes. |
| `acC/sizes.sh`, `acC/sizes.log` | Historical layout and read-only symbol-size comparison. |
| `sources.sha256`, `acC/sources-*.sha256` | Exact source identities and preserved file-hash lists. |
| `acC/transferred-files.sha256`, `acC/recovery-hash-verification.log`, `acC/recovery-metadata.log` | Fresh recovery receipts and source-host log modification times; these are not historical measurements. |
