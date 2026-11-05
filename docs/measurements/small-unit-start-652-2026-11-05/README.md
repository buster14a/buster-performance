# A small unit's start, part 3 (#652)

Evidence for the pull request from `claude/fervent-meitner-mg6onh` in buster14a/buster, part of
[#652](https://github.com/buster14a/buster/issues/652): the fixed cost every translation unit's compile pays at its
start. The branch bakes the parser's tables, reads `RLIMIT_AS` once in a compile's process, keeps the driver's emission
lanes (98 KB) off its stack, runs a compile outside `main_command`'s 140 KB frame, links libm only where it is needed
(the compiler's six exact floating operations are its own), and converts the unit's time to the local calendar at its
first `__DATE__` or `__TIME__`.

## Sources

| tree | revision | executable's SHA-256 (placement 0) |
| --- | --- | --- |
| `main` | `483e5f70d54ff8adccf011e773de4c04abd6489c` (the branch's base) | `fb5995d6138869fbda7f45607a9b5b32f12ad12e260e8fec9a65401f6cb66231` |
| `head` | `5aa61403b5b68f348bc39a8326ba013fa3e98269` (the branch's head) | `dcf332fb58c1473929a0a04122e33f171ff483b4a27b966529a106194f0ffae2` |

Each tree was a `git worktree` built on the 9700X with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts
--config Release DIR main_unit_checker.c 0 1088 2112 3136`: four links of the same objects with `main_unit_checker.c`'s
code at four placements, as the 9700X workflow's checker A/B builds them, each build under the machine's lock.
`main-again` is `main`'s four executables timed again, the floor. `raw/baked-v3.txt` is `head`'s `test-baked-tables`.

| input | SHA-256 |
| --- | --- |
| `empty.c` (no bytes) | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `tiny.c` (`int main(void){return 0;}`) | `86004d65c4f387c95467c6cee92bc1f1f8cb04d6650be09fbd1e359834a56766` |
| `sqlite3.c` (the 9700X's corpus, `preprocessor-391e729af658`) | as in `fewer-arenas-1279-2026-11-04` |

## Host

AMD Ryzen 7 9700X, transparent huge pages `always`. Timed processes pinned to CPU 2 (`taskset -c 2`); each
`time-runs` and `perf stat` process ran under the shared 9700X lock.

## Runs

`scripts/run.sh 5aa61403b5b68f348bc39a8326ba013fa3e98269 v3`: two `time-runs --copies` processes over `main`, `head`
and `main-again`, each build's four placements, their runs rotated:

- `raw/ab-v3-small.txt`: an empty file's `-fsyntax-only` and `-E -P`, and `tiny.c`'s `-c`, 30 runs (3 warm-ups) of
  each placement's two copies, 240 runs a build;
- `raw/ab-v3-sqlite.txt`: `sqlite3.c`'s `-fsyntax-only`, 4 runs (1 warm-up) of each placement, 16 a build.

The logs keep only what `time-runs` prints; the lock's waiting notices, which name other sessions, were dropped.

## Results

The median of each build's runs, and the range of `head` against `main` over the placements:

| input | `main` | `head` | wall, `head` against `main` | user cycles | `main-again` (floor), wall | minor faults |
| --- | ---: | ---: | --- | --- | --- | --- |
| empty `-fsyntax-only` | 0.676 ms | 0.617 ms | −8.77% (−15.91% to −5.89%) | −17.21% (−18.50% to −16.24%) | −0.46% | 390 → 353 |
| empty `-E -P` | 0.517 ms | 0.492 ms | −4.91% (−15.35% to +0.25%) | −5.80% (−6.88% to −5.10%) | +0.00% | 296 → 286 |
| `tiny.c` `-c` | 0.915 ms | 0.850 ms | −7.12% (−11.26% to −4.67%) | −11.19% (−12.59% to −10.70%) | −0.68% | 462 → 427 |
| `sqlite3.c` `-fsyntax-only` | 142.675 ms | 142.666 ms | −0.01% (−0.32% to +0.38%) | −0.00% (−0.55% to +0.36%) | +0.10% | |

`main`'s first placement is slower than its others for the small inputs in every run (0.723 ms against 0.665 to 0.677
for the empty file's `-fsyntax-only`), which widens the ranges over placements; the medians and the user cycles,
whose spread over placements is under 2%, are steadier.

## What the start still pays: the experiments

- `raw/loader2.txt` (`scripts/loader2.sh`): a trivial program dynamically linked with libm needed takes 0.164 ms and
  69 page faults, against 0.140 ms and 57 without it; the branch's first head (`0be486d6`) with `LD_BIND_NOW=1`
  takes the time it takes with lazy binding (0.572 against 0.580 ms), and binds 254 symbols either way.
- `raw/loader-dynamic.txt`, `raw/loader-static.txt` and `raw/loader-compiler.txt`: the same trivial program linked
  statically takes 0.097 ms and 27 faults, against 0.141 ms and 58 dynamically.
- `raw/static.txt` (`scripts/static.sh`): the branch's `c3357300` build's objects linked `-static` and baked, against
  the same objects linked as the build links them: an empty file's `-fsyntax-only` takes 0.34 against 0.38 ms of
  task-clock, `-E -P` 0.29 against 0.33 ms and `tiny.c`'s `-c` 0.44 against 0.48 ms, with 17 to 19 fewer faults. A
  static link is a follow-up: in a static glibc executable `dlsym(RTLD_DEFAULT, ...)` finds nothing and each
  `dlopen`ed library brings its own libc.
- `raw/mapcost.txt` (`scripts/mapcost.c`): what an arena's reservation costs, 27 at a time. A separate 64 GiB
  reservation's `mmap` takes 171 ns, its first commit's `mprotect` 581 ns, its first touch 977 ns (the page tables of
  a new region) and its `munmap` 3,056 ns; 27 arenas laid out as one arena of tables take 18, 6, 340 and 78 ns each.
