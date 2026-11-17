# `#pragma weak A = T` clones (buster#2449, PR #2896), 2026-11-17

[buster#2449](https://github.com/buster14a/buster/issues/2449), under
[its takeover claim](https://github.com/buster14a/buster/issues/2449#issuecomment-6945795736), in
[#2896](https://github.com/buster14a/buster/pull/2896) (branch `codex/solve-2449`). The PR is a checker change: the weak
pragma's clones, overload sets and code-generation errors, plus a test of each name in `check_input_resolve_name`, the
reader's per-identifier path. These runs check that the default path doesn't pay for it.

## How it was measured

- The 9700X (`benchpress`), CPU 2. Every build and run held the host's lock (`exclusive.sh`), one hold per build and
  per `time-runs`.
- **Trees:** `base` is buster main `2d817432`. `head` is the PR's merge of it, `b2aa1e3f` in round 1 and `2560a51d`
  (plus `CheckInputReader.name_hooks`) in round 2. Both are Release builds with the job's Clang 23.1.4
  (`logs/build-*.log`).
- **Input:** the frozen `sqlite3.c` of `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, with its pinned
  predefines and headers (`scripts/measure.sh`'s `S`); it has no `#pragma weak`.
- **`time-runs`:** whole processes, the object to `/dev/shm`, 3 fresh copies of each build in a Williams order (base,
  head, base again): `-fsyntax-only` 15 runs a copy, `-c` 9.
- **Scripts:** round 1 `scripts/builds.sh` then `scripts/measure.sh`; round 2 `scripts/round2.sh`, which rebuilt
  `head` and ran `scripts/measure2.sh` (measure.sh writing to `results2`, here `results/round2`). `scripts/run2.sh`
  waited for round 1's first base build: the first `builds.sh` named the base by a mistyped hash, so its fetch failed
  and the clone's default branch, main `2d817432`, the intended base, built; its wrapper was stopped and the build
  left to finish under its hold.
- **Context:** `results/round*/context.txt` has the load and the busiest processes before and after each hold. Round
  2's holds waited for another session's builds (`results/round2/*.err`).

## Main against head

Medians over 45 runs (`-fsyntax-only`) or 27 (`-c`); the instruction counts are each build's first copy's median.

| `sqlite3.c` | round | wall, head against base (base again) | user cycles | instructions, base to head |
| --- | --- | ---: | ---: | ---: |
| `-fsyntax-only` | 1 | +0.07% (−0.03%) | +0.01% (−0.17%) | 1,062,489,686 to 1,062,888,848 (+399,162, +0.038%) |
| `-c` | 1 | +0.10% (−0.04%) | +0.13% (−0.03%) | 1,349,327,541 to 1,349,851,216 (+523,675, +0.039%) |
| `-fsyntax-only` | 2 | −0.08% (+0.01%) | +0.03% (+0.08%) | 1,062,489,693 to 1,062,415,670 (−74,023, −0.007%) |
| `-c` | 2 | +0.02% (+0.09%) | +0.05% (+0.10%) | 1,349,327,542 to 1,349,378,029 (+50,487, +0.004%) |

- Round 1's +0.04% instructions were `check_input_resolve_name`'s second test (the unit's symbol pragmas beside its
  overload tables) on every identifier.
- Round 2 folds both into one reader flag, set where the tables are made and where the unit has a weak alias pragma:
  the instructions are main's within 0.01%, and the times are within main's own repeat.
