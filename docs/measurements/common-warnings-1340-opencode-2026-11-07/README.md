# #1340: the default warnings' passes, main against the PR head (2026-11-07)

Ryzen 7 9700X (`benchpress`), measured by an OpenCode session for
[buster#1340](https://github.com/buster14a/buster/issues/1340).

## Revisions and builds

| build | commit | SHA-256 of the executable |
| --- | --- | --- |
| `compiler-main-znver5` (main) | `73fcf006db22f7e10acfe315f85e379b77eff875` | `d75f83f9…a8ec3c`, in `builds.sha256` |
| `compiler-znver5` (head) | `33572f5924821504a224c77161aaf31ceeb51c40` | `a1029ff4…8dec3c`, in `builds.sha256` |

Both builds are `BUSTER_HOST_ARCH=znver5` builds made by `tools/microarch/run.sh` (`setup` builds the checkout,
`build-commit main 73fcf006d znver5` builds main from `git archive`), with the host's clang 23.1.1. `builds.txt` and
`microarch/identity.txt` bind each binary to its commit. The PR's commit `c9fec595f` has the head's tree with
`docs/c-checker.md` changed alone (`git diff 33572f592 c9fec595f --stat`), so the head's numbers are the PR's.

## Commands

- `scripts/run1340b.sh`: `tools/microarch/run.sh tools/microarch/hosts/zen5-9700x.sh setup env build-commit main
  73fcf006d znver5`, then the `ab` step (`AB_BUILDS="main-znver5 znver5"`: `sq-c` and `sq-syn`, 11 rotated rounds
  with `--time-stages`, and 5 `perf stat` runs of three counter groups on `sq-c`) and the `ab-self` step (the
  compiler's own `main.c`, 3 rotated rounds). The harness pins every run to CPU 2 and takes the lock per step;
  `microarch/holds.txt` has each step's lock receipt. `sq-c` is the frozen `sqlite3.c`'s `-c --lanes 1` with the
  pinned predefines and headers; `sq-syn` its `-fsyntax-only`.
- `scripts/w1340.sh`: both builds on `sq-c` with warnings on (the default) and off (`-w`), 11 rotated rounds of
  `--time-stages`, in one hold (`warnings-off/logs/holds.txt`), each run's exit status in
  `warnings-off/logs/status.txt` (all 0).
- `scripts/prof1340.sh`: a `cycles` profile (user and kernel, `-c 50003`) of 10 `sq-c` compiles per build, one hold
  each (`profile/*-holds.txt`, status 0); `profile/*-symbols.txt` is `perf report --sort symbol`.
- `scripts/summarize.py` computes the tables below from the raw files (medians).

`microarch/run.log` has the lock-wait lines of other holders removed; nothing else is filtered.

## Results

`sqlite3.c`, medians of 11 rounds (ms):

| | wall | user | `check-program` | `check-input` | total (stages) | peak RSS (KiB) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main, `-c` | 120.59 | 103.24 | 24.90 | 44.35 | 119.29 | 248,432 |
| head, `-c` | 113.53 | 96.37 | 17.66 | 44.17 | 112.23 | 248,332 |
| main, `-fsyntax-only` | 99.35 | 85.17 | 24.95 | 44.32 | 98.09 | 239,712 |
| head, `-fsyntax-only` | 92.00 | 78.14 | 17.75 | 44.23 | 90.74 | 239,636 |

`perf stat` on `-c`, medians of 5: user instructions 1,308.1 M → 1,232.3 M (−5.8%); user cycles 579.4 M → 543.6 M
(−6.2%); kernel cycles 80.4 M → 81.1 M.

The warnings' own cost, `check-program` with warnings on less with `-w` (`-c`, medians of 11):

| | warnings on | `-w` | the warnings' cost |
| --- | ---: | ---: | ---: |
| main | 24.77 | 9.88 | 14.89 |
| head | 17.70 | 9.99 | 7.71 |

The profile's share of the functions of the common warnings and the return facts (`check_driver_common_warnings`, the
`check_common_*` and `check_program_return_*` functions, `builtin_intrinsic_lookup`, `check_program_runtime_truth`,
`check_target_feature_noreturn_object`): 12.1% of main's cycles, 7.0% of the head's.

The compiler's own `main.c` (`ab-self`, 3 rounds): `check-program` 473.6, 484.7 and 492.4 ms on main against
423.4, 437.9 and 445.5 ms on the head; walls 2,143.6–2,227.4 ms against 2,093.1–2,213.2 ms. That workload's system
time (page faults of its 3 GB) varies by more than the difference between the builds, so these rounds show no
regression rather than measure a gain.

## Limitations

- One host and one input set; `main.c`'s rounds are too few to measure it.
- The profile is a different run from the timings (the same binaries and options), and its shares carry the
  attribution of inlined functions to their callers.
- These numbers cover the head's revision only; a later rebase or fix needs measuring again.
