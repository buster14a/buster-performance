# The file cache's arrays and the parser's two columns in tables (#652)

Evidence for [buster14a/buster#1279](https://github.com/buster14a/buster/pull/1279), part of
[#652](https://github.com/buster14a/buster/issues/652): a small unit's fixed setup cost. The PR moves a unit's own file
cache's four arrays among the preprocessor's tables (so the cache's 120 KB is no longer written zero), and the parser's
names' meanings, and where the address space is unbounded its diagnostics, among the tokens' tables.

## Sources

| tree | revision | executable's SHA-256 |
| --- | --- | --- |
| `main` | `b0474fb1e2864f3a2972375d4bc92a212061d792` (the PR's base) | `3ffc0b2765fea64f8a35255d34f8d258b262bf441f3bf3b156fc111699c41de0` |
| `head` | `643bf03a81e41168eeaa58bb652fba88463a2d48` (the PR's head) | `6e153f4cb97b57bddb8fd157c18a333ae1ecd41cae4d08a4b58885ae3edc7f04` |

`main-again` is `main`'s executable timed again, the floor. Each tree was a `git worktree` built on the 9700X with
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`, each build under the machine's lock.

| input | SHA-256 |
| --- | --- |
| `empty.c` (no bytes) | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `tiny.c` (`int main(void){return 0;}`) | `86004d65c4f387c95467c6cee92bc1f1f8cb04d6650be09fbd1e359834a56766` |
| `sqlite3.c` (the 9700X's corpus, `preprocessor-391e729af658`) | `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |

## Host

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, transparent huge pages `always`, defrag `madvise`. Timed
processes pinned to CPU 2 (`taskset -c 2`); each `time-runs` process ran under the shared 9700X lock, taken per process.

## Runs

`scripts/run.sh`: two `time-runs --copies 3` processes with `main`, `head` and `main-again`, each list's runs rotated
across the builds and their copies:

- `raw/ab-1279-small.txt`: an empty file's `-fsyntax-only` and `-E -P`, and `tiny.c`'s `-c`, 300 runs (20 warm-ups)
  for each build's copy;
- `raw/ab-1279-sqlite.txt`: `sqlite3.c`'s `-fsyntax-only` and `-c`, 15 runs (2 warm-ups) for each copy.

The logs keep only what `time-runs` prints; the lock's waiting notices, which name other sessions, were dropped.

## Results

Wall time, the median of each build's 900 (small) or 45 (`sqlite3.c`) runs, and the range over its copies:

| input | `main` | `head` | `head` against `main` | `main-again` (floor) |
| --- | ---: | ---: | --- | --- |
| empty `-fsyntax-only` | 0.610 ms | 0.586 ms | −3.98% (−5.44% to −2.11%) | −0.43% (−1.87% to +1.63%) |
| empty `-E -P` | 0.484 ms | 0.461 ms | −4.69% (−7.35% to −2.34%) | −0.81% (−3.71% to +1.26%) |
| `tiny.c` `-c` | 0.830 ms | 0.806 ms | −2.94% (−3.99% to −1.75%) | −0.51% (−1.27% to +0.57%) |
| `sqlite3.c` `-fsyntax-only` | 83.615 ms | 83.445 ms | −0.20% (−0.42% to +0.03%) | −0.22% (−0.41% to +0.11%) |
| `sqlite3.c` `-c` | 103.095 ms | 102.792 ms | −0.29% (−0.48% to +0.12%) | −0.26% (−0.32% to −0.03%) |

Minor faults per process (copy 1's medians): empty `-fsyntax-only` 410 → 378, empty `-E -P` 319 → 286, `tiny.c`
`-c` 478 → 446. `sqlite3.c` is within the floor.

## Limits

- One session's run, not repeated in further rounds (`ab --rounds`); the floor's spread is the comparison's noise.
- The two RLIMIT_AS cases the PR's review fixed are checked by `test-parser` (`parse_test_diagnostic_places`), not
  timed here.
