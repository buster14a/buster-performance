# #530's A/B against main, repeated with the order balanced

PR #573's fourth review asked for the order selection fixed in the archived harness, and for a position-balanced
repeat of [the A/B](../README.md) before its small stage deltas are read as thresholds. This is that repeat: the same
three builds on the same host, the same 15 rounds of `--time-stages` in three holds of the lock, the order fixed.

## The harness

`ab.sh` here is the fixed harness, for future captures. Round r (1 to 15) runs the builds from index r mod 3 on, with
the hold's number expanded into the locked script by the outer shell. The first capture's `../ab.sh` passed it as
`bash -c`'s `$0`, which left it unset inside the script, so each hold repeated the same five orders. `run.log` ends
with the count of each build's places: each ran first, second and third in 5 rounds.

## Identity

- **Builds:** the parent record's three executables, by sha256 (`run.log`): main `a774acd2`, the merge `2163d68a`
  and `1989a51d`, on the 9700X, pinned to CPU 2.
- **Objects:** each build's default and `--scalar` objects, written again, are the same bytes
  (`objects identical: 0c48ff92978c3125`).
- **Date:** 2026-10-27, 17:05:33 to 17:20:27 UTC.

## Results

Medians of the 15 runs of each build:

| stage | main | merge | change | `1989a51d` | change |
| --- | ---: | ---: | ---: | ---: | ---: |
| check-input | 64.835 ms | 65.435 ms | +0.600 ms (+0.9%) | 65.553 ms | +0.718 ms (+1.1%) |
| check-expressions | 20.550 ms | 15.823 ms | -4.727 ms (-23.0%) | 15.753 ms | -4.797 ms (-23.3%) |
| check-declarations | 5.250 ms | 5.440 ms | +0.190 ms (+3.6%) | 5.559 ms | +0.309 ms (+5.9%) |
| check-program | 16.024 ms | 12.085 ms | -3.939 ms (-24.6%) | 12.141 ms | -3.883 ms (-24.2%) |
| the clock's span | 157.948 ms | 149.474 ms | -8.474 ms (-5.4%) | 149.682 ms | -8.266 ms (-5.2%) |

- **Ranges.** check-expressions ran 20.219 to 21.239 ms on main, 15.658 to 16.662 on the merge and 15.314 to
  16.464 on `1989a51d`; check-program 15.618 to 16.337, 11.967 to 12.221 and 11.912 to 12.219; check-declarations
  5.096 to 5.553, 5.370 to 5.622 and 5.454 to 5.658; check-input 64.546 to 65.633, 64.721 to 66.083 and 64.911 to
  66.316.
- **The other stages.** Each is within 0.2 ms of main's median.
- **Against the first capture.** Its medians (the parent record) are within 0.2 ms of these for check-expressions
  and check-program, and its spans within 0.5 ms. check-declarations' increase is smaller here: 0.190 and 0.309 ms,
  against 0.339 and 0.380. check-input, which runs before any code #573 changes, took 0.600 and 0.718 ms longer here,
  against -0.040 and +0.501 there: where the checker's code falls in each build.

## Files

- `ab.sh`: the fixed harness.
- `run.log`: the script's own lines alone. exclusive.sh's messages about other holders of the lock, which name other
  sessions' commands and links, are left out by keeping only the lines the script writes.
- `stages.txt`: every `--time-stages` report, each line prefixed by its build, in run order.
