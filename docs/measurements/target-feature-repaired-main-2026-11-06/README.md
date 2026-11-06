# PR #1313: repaired-main SQLite instruction controls

This is a follow-up to [#277](https://github.com/buster14a/buster-performance/pull/277). The compiler PR's literal zero instruction-delta acceptance remains **unmet**. These measurements do not identify the cause.

On the Ryzen 7 9700X, the compiler was built with Clang Release, `BUSTER_HOST_ARCH=znver5`, and `BUSTER_DEBUG_INFO=0`. The base was `a581e20b8cd202196d8f2dcfff22ce7a5e09e9b6`, the PR head was `5929d0e2e2ab5a179313c082811b59a3ccdd0e0d`, and their clean integration tree was `17c98f3e603bf4adb17cdd04bb2d2a0f0fd53555`. Each build and compiler process held a separate exclusive lock; `perf stat` counted `instructions:u` on CPU 2 with 100% event running time. The same executable path, input, argv and output path were used for each paired run. Source and executable hashes, complete commands, machine details, build logs, outputs, individual counts, and scripts are in `raw/` or beside this file. Executable path and hash were checked for every sample.

Independent review reproduced the integration tree from those source commits.
The scripts show one exclusive-lock invocation per build or sample, and their
`set -e` completion markers report that the sequence finished; per-sample exit
status files or lock-holder snapshots were not recorded. Other sessions'
lock-holder details have been replaced with generic wait markers in eight
published logs; unmodified originals remain on Benchpress.

`sha256sum -c SHA256SUMS` verifies the published files, and
`python3 verify.py` regenerates [`verification.txt`](verification.txt) from
the retained counters, per-sample executable hashes and output snapshots.
For the source tree independently, `git merge-tree --write-tree` on the base
and head commits above yields the listed integration tree.
`run.sh` fetches then-current `main` and PR head rather than pinning those
recorded commits; a later reproduction must explicitly select the identities
above and verify its resulting tree and inputs.

For SQLite whole compilation (`-c`), seven alternating-order base/integration pairs had deltas of **+17,814, +17,815, +17,774, +17,818, +17,762, +17,765, +17,810** user instructions. The median paired delta was **+17,810** (approximately **+0.001088%** of the base median of 1,636,690,985). Separate within-binary A/A pairs differed by 36 and 14 instructions. All 18 recorded object hash snapshots match, stdout was empty, and diagnostics were identical after excluding lock-wrapper messages.

Four alternating-order preprocessing-only (`-E`) pair deltas were **−38, −40, −38, −40** instructions; within-binary A/A differences were 1 and 2 instructions. All 12 recorded preprocessed-output hash snapshots match. The preprocessing-only result does not explain the whole-compile increase in this build. It does not prove which later stage or binary-layout effect causes the difference. A later independent check of the retained, hash-matching preprocessed file found none of the literal strings `__target__`, `target(`, `__builtin_ia32`, `__builtin_cpu`, or `__builtin_x86` ([receipt](raw/independent-text-search.txt)). This limited text search is not proof that the feature-pass gate is never reached.

Four alternating syntax-only (`-fsyntax-only`) pairs differed by **+17,644, +17,639, +17,647, +17,664** instructions (median **+17,645.5**); within-binary A/A differences were 34 and 31. All 12 normalized diagnostic streams matched and all perf events ran 100%. The syntax-only difference is similar in magnitude to the whole-compile difference in this experiment. The modes run separately with different options, so this similarity does not isolate a stage or establish a cause.

The `-c` and `-E` modes each reused one output path without deleting it before
every sample. The matching hash snapshots therefore do not prove that each run
freshly wrote an output, and no direct byte-comparison receipt was retained. Only this host,
compiler build and frozen SQLite input were measured; counts are not timings.
The SQLite source was checked by hash, but system headers were not individually
hashed before and after these runs. No broader performance or correctness
conclusion follows. The compiler PR still needs its acceptance condition and
remaining CI and review gates.

Collector: OpenAI / GPT-6, Codex thread `01a1b0e0-d979-7e63-94ff-ff91f3213a51`; parent session `01a1b0e0-a314-7252-9c29-d958f2e64d73` (no share URL exposed).

Independent review: OpenAI / GPT-6, Codex thread `01a1b0e1-da73-7731-9bcf-4312e3561034`; parent session `01a1b0e0-a314-7252-9c29-d958f2e64d73` (no private share URL exposed).
