# GNU function multiversioning by target strings: the checker's cost on the 9700X, Buster #1838

Compiler pull request: [#1897](https://github.com/buster14a/buster/pull/1897) (stacked on
[#1874](https://github.com/buster14a/buster/pull/1874)), for
[#1838](https://github.com/buster14a/buster/issues/1838). #1897 adds `target`/`target_clones`
multiversioning's semantic rules: hooks in the checker's binding (`check_input_bind`), the declaration
rules and the attribute reader, which every unit passes through, though their work runs only for a function
with a `target` or `target_clones` attribute. This measures what the hooks cost a unit without one.

## Sources and host

Each tree is a clone of buster14a/buster at its commit, built on the 9700X by
`BUSTER_HOST_ARCH=znver5 ./build.sh` under the host lock (`scripts/trees.sh`; the build logs' tails in
`logs/build-tail.txt`):

- **base:** `cb608c1f616f8fe26234bcaaa869caccc571de63`, #1897's base at the time (#1874's head);
- **head:** `8dce66d007c0e26de1a60de9d83e6b3ce7fab6b7`, #1897's head at the time.

`logs/receipt.txt` has the host, toolchain, both executables' SHA-256 and the input's. The later heads of
#1897 change the multiversioned path alone (the parse and the earlier-version search, in scratch), not the
hooks a unit without a multiversioned function runs.

`scripts/trees.sh` ended with an `ab` run whose lists were plain `-fsyntax-only`, which prints nothing, so it
recorded no timings; it was stopped and is not evidence.

## Method

`scripts/ab.sh`: `ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head -- time-runs
--runs 11 --list -fsyntax-only sqlite3.c --list -fsyntax-only ... main.c`, run outside the lock (`ab` takes it
for each run), each process pinned to CPU 2; each round runs both trees in a Williams design's order, and
each `time-runs` runs each list 11 times after a warm-up, a fresh process each time. `logs/ab.txt` is the
whole output (the `exclusive.sh: waiting` lines are other jobs holding the lock between runs);
`logs/medians.txt` has each round's medians: round, tree, list, wall ms, user cycles, instructions.

## Results

Median of the five rounds' medians:

| list | base wall | head wall | wall | base cycles | head cycles | cycles | instructions |
|---|---|---|---|---|---|---|---|
| `-fsyntax-only sqlite3.c` | 94.89 ms | 95.25 ms | +0.4% | 443.5 M | 445.9 M | +0.54% | +141 k (+0.015%) |
| `-fsyntax-only main.c` | 2043.5 ms | 2047.2 ms | +0.2% | 10386.7 M | 10418.1 M | +0.3% | +2.73 M (+0.010%) |

The rounds' ranges: sqlite3.c base 94.58 to 95.54 ms, head 95.05 to 95.59 ms; main.c base 2038.3 to
2046.8 ms, head 2046.4 to 2050.4 ms.

## Limitations

- One build per tree, at one code placement and from one set of pages. Buster's `docs/profiling.md` records
  placement alone moving `-fsyntax-only sqlite3.c` by about 2% of its cycles and a byte-identical copy by
  0.3% (#502, #509); the cycle and wall differences here are within that, though head is above base in
  every round of both lists. The instruction counts (+0.01 to 0.015%) are the hooks' added work.
- The trees' builds kept debug information on (the default).
- No `perf` profile was taken; the attribution to the hooks is by the diff, not by samples.
