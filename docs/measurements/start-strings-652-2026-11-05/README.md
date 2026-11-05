# A small unit's start: the string pool's order (#652)

Evidence for buster14a/buster#1437, from `claude/fervent-meitner-mg6onh` after buster14a/buster#1431, part of
[#652](https://github.com/buster14a/buster/issues/652): the fixed cost every translation unit's compile pays at its
start. The change links a static build with lld at `-O0` (lld first for a static build's `auto` linker), which keeps each
object's strings in its order where lld and mold merge every object's identical strings in their hashes' order. It also
sends a source command (a first argument that starts with `-`) to the source commands at once, past the units' chains
of `strcmp` against their command names.

## Sources

| tree | revision | executable's SHA-256 (placement 0) | linker |
| --- | --- | --- | --- |
| `base` | `28392fab74fbe3321ce2ed76af39ba3f7e240e06` (#1431's head then) | `1e7d7dbb59081d3af0bd15e3156c53292993b7a8eeb3ae51c2c2170dcdb8eb2a` | mold |
| `head` | `28ace889b9a93dc564c9358069d99691c15d96be` (the change on it) | `f0a25b007d688bf47f5337268e54eb67fa76cea440eebba1f432f32a65792e6a` | lld, `-O0` |

`28ace889` is the change as first committed, on #1431's head before its last commit (`9846d2b6`, which adds the C
library's descriptor calls to the tests' host table and changes no compile's path). Each tree was a `git worktree` built
on the 9700X with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts --config Release DIR main_unit_checker.c
0 1088 2112 3136` (`scripts/run2.sh`), each build under the machine's lock; `raw/linkers-n1.txt` has each build's
configure line and hashes, `raw/baked-n1.txt` the head's `test-baked-tables`. `base-again` is `base`'s four executables
timed again, the floor. The inputs are `small-unit-start-652-2026-11-05`'s and `static-link-652-2026-11-05`'s (`empty.c`,
`tiny.c`, `hello.c`, the corpus' `sqlite3.c`).

## Host

AMD Ryzen 7 9700X, Linux 6.18.50, transparent huge pages `always`. Timed processes pinned to CPU 2 (`taskset -c 2`);
each `time-runs`, `perf` and build process ran under the shared 9700X lock. The logs keep only what the tools print;
the lock's waiting notices, which name other sessions, were dropped.

## Runs

`scripts/run2.sh BASE HEAD n1`: two `time-runs --copies` processes over `base`, `head` and `base-again`, each build's four
placements, their runs rotated (cold starts):

- `raw/ab-n1-small.txt`: an empty file's `-fsyntax-only` and `-E -P`, `tiny.c`'s `-c` and `hello.c`'s `-c`, 30 runs (3
  warm-ups) of each placement's two copies, 240 runs a build;
- `raw/ab-n1-sqlite.txt`: `sqlite3.c`'s `-fsyntax-only`, 4 runs (1 warm-up) of each placement.

## Results

The median of each build's runs against `base`'s, and the range over the placements:

| input | wall | user cycles | `base-again`'s user cycles | minor faults |
| --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | −21.65% (−31.78% to −3.69%) | −12.98% (−16.84% to −8.60%) | +0.01% | 336–338 → 273 |
| empty `-E -P` | −19.36% (−31.93% to −12.31%) | −17.62% (−24.81% to −10.67%) | +0.42% | 267–269 → 204 |
| `tiny.c` `-c` | −11.33% (−21.55% to +0.14%) | −7.90% (−10.01% to −4.66%) | +0.08% | 409–413 → 345–347 |
| `hello.c` `-c` | −8.38% (−22.90% to +5.01%) | −2.58% (−4.91% to −1.08%) | +0.69% | 605–609 → 546–547 |
| `sqlite3.c` `-fsyntax-only` | −0.00% (−0.27% to +0.19%) | +0.05% (−0.34% to +0.41%) | −0.04% | |

The wall times were noisy in this run (`base-again`'s first list is 9.24% below `base`'s, and `base`'s placements spread
23%); the user cycles, whose floor stays within 0.7%, are steadier. The head's `wait4` peak is about 7.5 MB against the
base's 11.5 MB for the empty `-fsyntax-only`, as fewer faults map fewer of the executable's pages.

## The experiments that chose it

- `raw/order.out` (`scripts/order.sh`): `0e1b580b` built with `-ffunction-sections` and relinked by lld, as is
  ("sections") and with the 507 functions that small compiles' samples fell in first (`--symbol-ordering-file`,
  "ordered"). Ordered, `.text` took 75 faults rather than 69 and no time: a unit's static functions have a copy in each
  unit that uses them, and an ordering file, which names symbols, brought every copy forward, some three times.
- `raw/strings.out` (`scripts/strings.sh`): the same objects relinked by lld at `-O0` ("unmerged"): read-only data took
  30 faults rather than 69, and the small compiles 6.9% to 11.5% less time.
- `raw/strings2.out` (`scripts/strings2.sh`): `0e1b580b`'s own objects, without function sections, linked by mold (as
  the build links them), by lld, and by lld at `-O0`: lld at `-O0` took 13.79% less time than mold for an empty file's
  `-fsyntax-only` (6.96% to 26.17% over copies), 11.02% for `-E -P`, 7.30% for `tiny.c`'s `-c` and 6.18% for
  `hello.c`'s, `sqlite3.c`'s the same; lld at its default `-O1` a third of that. Its read-only data took 28 faults
  against mold's 67 (55 in the string pool, 12 in `.rodata`), 280 in all against 319, for 1.8 MB more of the executable.
- `raw/anon.out` (`scripts/anon.sh`): the empty `-fsyntax-only`'s anonymous faults by mapping: 34 in the
  preprocessor's arena of tables, 29 in the intern table's, the rest a few in each arena.
- `raw/thp.txt` and `raw/thp2.txt` (`scripts/thp.sh`, and `scripts/thp2.sh` with `scripts/smapsexit.gdb`): 100 runs of
  the empty `-fsyntax-only` allocated 100 transparent huge pages, of `-E -P` 200, of `tiny.c`'s `-c` 100 and of
  `hello.c`'s 700. The empty compile's is in the intern table's 1 MB of buckets, past its arena's base pages, and `-E`'s
  second in an arena of 64 GiB past its first 64 KB. A table that size starts smaller only at the cost of growing,
  which rehashes it, for any unit with headers, so it is left as it is.
