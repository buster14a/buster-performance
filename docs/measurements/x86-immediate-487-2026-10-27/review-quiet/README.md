# Explicit `-w` review coverage

Source PR: [Buster #561](https://github.com/buster14a/buster/pull/561).
Review: [2026-10-27 follow-up](https://github.com/buster14a/buster/pull/561#pullrequestreview-5670387283).
Source head: `e61532592cab11718ade1f99b4e805794f95ad4a`.
Parent: `a7a4adf4469425cbc26a7a06119486a2af582515`.

The review found no additional static blockers and suggested an explicit
`-w` driver fixture. This commit changes only two test files: the shared
driver helper accepts a quiet flag, and three isolated Clang differential
fixtures exercise it in both production driver schedules. Reachable direct
and compound-literal range violations are accepted without diagnostics under
`-w`; a nonconstant immediate still fails. The fixture total rises from 47
to 50, adding nine assertions including the independent Clang expectations.

## Checks and identities

The local optimized build with warnings as errors passes. The complete driver
suite passes 21,585 checks. The complete checker suite runs 259,568 checks;
all 50 x86 differential fixtures pass. Its four failures are the same existing
Clang 23.1.4 `fpclassify-conditional-selector-effects` and
`fpclassify-known-category-effects` executable-oracle disagreements recorded
in the previous review evidence. Their complete log is retained here.

Local compiler SHA-256:
`fe7221815e8b3152d66344f4c7cb795fde60414fcbc7e97cfe9c5704b89397aa`.

The separately rebuilt optimized Ryzen 7 9700X compiler uses Clang 23.1.1
and passes the 41-source build. Every remote build/test takes the shared lock
per invocation. `head-source.sha256` verifies the remote source and build
script against the source commit; `source.patch` is the zero-context test-only
delta against the parent, applied with `git apply --unidiff-zero`.

Both suites pass at this exact head on the locked 9700X:

| Check | Result |
| --- | --- |
| `test-checker --seed 133` | 259,568 checks, 0 failures |
| `test-checker-driver --executable ./build/compiler` | 21,585 checks, 0 failures |

The run includes all 50 isolated x86 fixtures through both driver schedules.
The two suites use a three-CPU budget and complete in 17.7 seconds. Their full
output is in `logs/qualification.log`. The local Clang-version disagreements
above do not occur on this host's Clang 23.1.1.

9700X compiler SHA-256:
`88dca179f45535d14dc0535653ccf80ab7e1618b4c5a83434f4413a9b626c068`.

## Standalone command-line controls

`cli-probes.sh` runs the three archived inputs through Clang 23.1.4 and both
Buster schedules, each with default policy and with `-w`. All 18 statuses
match the independent expectations in `cli-probes.tsv`. The direct and
compound-literal errors fail by default and succeed with empty stderr under
`-w`. The nonconstant immediate fails under both policies. Raw diagnostic
outputs are under `logs/cli-*`.

From this directory, reproduce those controls with:

```sh
bash cli-probes.sh "$PWD" /absolute/path/to/build/compiler clang
```

The full checker and driver commands are in `qualify.list`. On the shared
9700X, run each build and qualification under its normal per-run lock:

```sh
EXCLUSIVE_OWNER=codex-487 EXCLUSIVE_TITLE='Buster 487 -w qualification' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/561 \
BUSTER_DEBUG_INFO=0 /home/david/buster-fast-bench/exclusive.sh ./build.sh
EXCLUSIVE_OWNER=codex-487 EXCLUSIVE_TITLE='Buster 487 -w qualification' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/561 \
/home/david/buster-fast-bench/exclusive.sh \
./build/compiler parallel --jobs 3 ../qualify.list
```

## Scope of retained performance evidence

Production compiler sources are unchanged by this follow-up. No new timing
claim is made. The matched cost screen remains tied to parent `a7a4adf4`
and its specific binary in [the preceding record](../review-latest/README.md).
Its measurements are not relabeled as measurements of this rebuilt executable.
The required GitHub CI for the new source head is a separate qualification;
the PR remains unmerged while those checks are pending.
