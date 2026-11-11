# Asm labels naming the unit's own objects, Buster #1979

Compiler issue: [#1979](https://github.com/buster14a/buster/issues/1979). Compiler PR:
[#2112](https://github.com/buster14a/buster/pull/2112), merged.

Frozen sources:

- Base: main `d43c37e51` (`git -C base log`, `run.log`).
- Head: `fa777691b`, the PR's change before its merge of main.

The head gives an object whose asm label names another object of the unit that object's symbol
(`check_program_label_merges`). The new pass only runs in a unit with declarations that have linkage and an asm label.
It scans the static declarations only where such a label is also one of the unit's identifiers or names two objects.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2. `host.txt` has the kernel, the THP mode, clang's version and the executables'
SHA-256 values. Each tree was built with `BUSTER_DEBUG_INFO=0 ./build.sh` (Release, native), one lock invocation per
build. Every process ran through `exclusive.sh`, one lock invocation per run, under `compiler ab --lock`.

- `run.sh`: base and head built once each. Each `-c` object was compared byte for byte, then timed with `ab --rounds 3`
  of `time-runs --runs 5 --copies 3`, for:
  - `sqlite3.c` (the corpus's, with the 9700X job's defines): `ab-sqlite.log`;
  - this compiler's `main.c` (`-march=native -fwrapv -funsigned-char`): `ab-main.log`.
- `run2.sh`: base and head each built at six placements of `main_unit_checker.c` (`./build.sh shifts`: 0, 704, 1408,
  2112, 2752 and 3456 bytes later). `main.c`'s `-c` was timed under `ab --rounds 3` of `time-runs --runs 3 --copies 2`
  over the twelve builds: `ab-main-shifts.log`. `run2.log`'s "ab failed" is the script's message for `ab`'s nonzero
  exit; the log ends with "time-runs: done, 0 failed processes" and "ab: done, 0 failed runs".

## Results

Objects: base and head make the same bytes for both inputs (`run.log`).

`sqlite3.c`, three rounds, head against base:

| round | wall | user cycles |
| --- | --- | --- |
| 1 | +0.12% | -0.02% |
| 2 | -0.02% | -0.04% |
| 3 | -0.39% | -0.19% |

Neutral. Instructions: head 1,278.7M against base 1,276.6M (+0.17%).

`main.c`, one build each, three rounds: wall +0.42%, +0.68%, +0.33%; user cycles +0.35%, +0.94%, +0.47%. Instructions:
head about 10,003.67M against base 10,003.78M, about 0.12M (0.001%) fewer.

`main.c` over six placements of the checker unit, three rounds:

| round | wall | user cycles | cycles over placements |
| --- | --- | --- | --- |
| 1 | +0.40% | +0.57% | +0.08% to +0.94% |
| 2 | +0.70% | +0.62% | +0.28% to +1.61% |
| 3 | +0.55% | +0.62% | +0.40% to +0.82% |

Instructions: head 10,003.67M against base 10,003.78M at every placement. Peak resident set: head about 1.5 MB higher
(1,177,248 KiB against 1,175,672 KiB).

## Reading

`sqlite3.c` is unchanged. `main.c` costs about 0.6% more cycles with no more instructions, at every placement of the
checker unit, so the checker's code placement doesn't explain it. The higher peak resident set suggests a data-layout
effect: arena offsets that the pass's allocations or `CheckProgram`'s larger struct move. That attribution is untested.
The follow-up is recorded on the compiler PR.
