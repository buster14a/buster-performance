# Windowed file preparation: whole-process comparison (#451 part 1)

This is a measurement protocol, not a result or performance acceptance claim.
Parts 2 (directive-table implementation) and 3 (long logical lines) are excluded.

- Compiler: Buster `9de3d30ba437b381394095d7a77635a2e877435d`, one native 9700X build shared by every variant.
- Control: `--window-bytes 2000000000`, selecting whole-file preparation for these inputs.
- Treatment: default `BUSTER_PP_WINDOW_BYTES`, 131,072 bytes; only files of at least two windows take the windowed path.
- Inputs: #408's frozen SQLite and main tree in `/home/david/buster-fast-bench/refine-116-claude/inputs`.
- CPU: 2. Each invocation is independently scheduled by the coordinator under the existing `exclusive.sh` host lock.
- Workloads: SQLite `-E -o /dev/null` and `-fsyntax-only`; main `-E -o /dev/null` and `parse -fsyntax-only` with `-march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h` from its frozen tree.
- Processes: five rounds per workload, two warmups and 21 timed processes per variant and round through the existing `time-runs`; the first variant reverses each round and timed list order rotates each run.
- Phases: five separate process pairs per input through `benchmark-preprocessor --only vectorized`, reversing pair order each round; each process has the existing warmup and 21 measured passes.
- Preflight: every direct command must exit 0 before timing, since `time-runs` verifies status consistency rather than requiring zero.
- Environment: `SOURCE_DATE_EPOCH=1792454400`; `CPATH`, `C_INCLUDE_PATH`, and `CPLUS_INCLUDE_PATH` unset.

Preserve every raw process line, phase report, exact invocation, compiler/build identity, source/header/predefines manifest, and host configuration. Check the input manifests before and after the campaign.

`time-runs` measures fork-to-`wait4` wall time and the child's `rusage`, including exit and address-space reclamation. Its printed peak-memory unit (`KB`) is KiB on Linux. Phase timings exclude printing and `pp_release`/`intern_release`; the benchmark reports printing and release separately. Those phase medians are not an exit-inclusive compiler time or a whole-process RSS measurement. Scratch arenas are popped rather than unmapped at `scratch_end`, so the release timer must not be described as all memory deallocation.

Acceptance commands are the unchanged compiler's `test-preprocessor` (including its windows fixtures), `test-files`, and `test-refinement`, plus full-input `test-preprocessor` comparisons at 64-byte and whole-file settings with each input's flags. They belong to separate lock holds, outside measurements.

The result should show median-of-round medians and every round's range, with the direction defined as windows relative to whole files. Keep actual page-fault and RSS differences even if their wall-time effect is within the measured spread. Explain retained costs from the measured total rather than proposing an optimization from an isolated phase.

## Rebuilding the derived tables

`summarize.c` is an original C reader of the existing compiler's reports, with no new dependencies. Build it with `clang -O2 -Wall -Wextra -Werror -std=c17 summarize.c -o summarize`, then run `./summarize raw derived 5` after the complete five-round campaign. It writes `derived-process-rounds.tsv`, `derived-phase-rounds.tsv`, `derived-summary.tsv` and `derived-comparison.tsv`. The summary's minimum and maximum are the range of the five round medians. The process table separately retains each round's within-round wall-time minimum and maximum.

An expected-round count of zero allows explicitly partial snapshots. The final command requires all five rounds for all four process workloads and both phase workloads, both variants, with no duplicate round. Only logs whose last line is `exit=0 end:...` enter a table; a completed nonzero command fails the reader. Every process report must contain 42 timed exit-zero processes and the zero-failure footer. Every phase report must have 21 passes, every requested phase, printing and release, and unchanged input/output token counts across variants and rounds. Nonfinite or negative observations fail. `validate-reader.sh` verifies ignored incomplete files and rejection of nonzero process statuses, nonzero command exits, missing required rounds and missing release timings.
