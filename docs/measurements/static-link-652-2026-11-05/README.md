# A static link of the compiler (#652)

Evidence for buster14a/buster#1431, from `claude/fervent-meitner-mg6onh`, part of
[#652](https://github.com/buster14a/buster/issues/652): the fixed cost every translation unit's compile pays at its
start. The branch links the compiler statically wherever nothing needs the loader. Its start doesn't register the
executable's `.eh_frame` with libgcc's unwinder, which `crtbeginT.o` does where glibc's `pthread_exit` links the
unwinder in, and which libgcc 13 and later make sort every FDE.

## Sources

| tree | revision | executable's SHA-256 (placement 0) |
| --- | --- | --- |
| `main` | `52e486e461d2f7fbb52ef9c5d84a96d67eae9965` (the branch's base) | `72216deddbbd9052fc92fd9d1b2eda008715b58ae19d45797c7ecb1c69da2bc3` |
| `s2` | `d47ec1aa5d3502e0ca993bc15e48d9f384355ba7` (the static link, registering its frames) | `879bb4f0554beed1f9bc07ac1dbe8db4db75d65eb4b7305de17d7ec7ad13d472` |
| `s3` | `0e1b580b2ebb7864d3ef1e84c018c12154a27640` (the branch's head) | `26eaeb0665fc070c56783c786caded86b936501c752ed8f49c1ce92397b33ee7` |

Each tree was a `git worktree` built on the 9700X with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts
--config Release DIR main_unit_checker.c 0 1088 2112 3136` (`scripts/run.sh`): four links of the same objects with
`main_unit_checker.c`'s code at four placements, each build under the machine's lock. Both heads link with mold, which
a static build's `auto` linker selects. `main-again` is `main`'s four executables timed again, the floor.
`raw/baked-s3.txt` is `s3`'s `test-baked-tables`.

| input | SHA-256 |
| --- | --- |
| `empty.c` (no bytes) | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `tiny.c` (`int main(void){return 0;}`) | `86004d65c4f387c95467c6cee92bc1f1f8cb04d6650be09fbd1e359834a56766` |
| `hello.c` (`stdio.h` and a `printf`) | `da237356cf3441911f26383d6ab74da70d9a1d5ec46b851b77530596e131e0c6` |
| `sqlite3.c` (the 9700X's corpus, `preprocessor-391e729af658`) | as in `fewer-arenas-1279-2026-11-04` |

## Host

AMD Ryzen 7 9700X, Linux 6.18.50, transparent huge pages `always`. Timed processes pinned to CPU 2 (`taskset -c 2`);
each `time-runs`, `perf stat` and `perf record` process ran under the shared 9700X lock. The logs keep only what the
tools print; the lock's waiting notices, which name other sessions, were dropped.

## Runs

`scripts/run.sh HEAD TAG`: two `time-runs --copies` processes over `main`, the head and `main-again`, each build's four
placements, their runs rotated, so that each process starts after other builds' (a cold start):

- `raw/ab-s3-small.txt` (and `raw/ab-s2-small.txt` for `s2`): an empty file's `-fsyntax-only` and `-E -P`, and
  `tiny.c`'s `-c`, 30 runs (3 warm-ups) of each placement's two copies, 240 runs a build;
- `raw/ab-s3-sqlite.txt` (`raw/ab-s2-sqlite.txt`): `sqlite3.c`'s `-fsyntax-only`, 4 runs (1 warm-up) of each placement.

## Results

The median of each build's runs against `main`'s, and the range over the placements:

| input | `s2` wall | `s2` user cycles | `s3` wall | `s3` user cycles | `main-again` (floor), wall |
| --- | --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | +8.79% | +25.59% | −2.49% (−13.80% to +5.90%) | −2.42% (−4.31% to −0.27%) | −0.94% |
| empty `-E -P` | +10.71% | +33.30% | −2.28% (−15.06% to +2.71%) | −4.28% (−6.98% to −2.95%) | −0.47% |
| `tiny.c` `-c` | +6.16% | +17.11% | −0.18% (−8.40% to +3.06%) | +0.18% (−1.27% to +1.09%) | −0.58% |
| `sqlite3.c` `-fsyntax-only` | | | −0.24% (−0.54% to +0.31%) | −0.23% (−0.74% to +0.39%) | −0.00% |

`main`'s first placement is slower than its others for the small inputs, which widens the wall time's ranges; the user
cycles' spread over placements is about 2%. The placements' median minor faults are 335 to 337 for `s3`'s empty
`-fsyntax-only` against `main`'s 347 to 350, 266 to 268 against 277 to 279 for `-E -P` and 408 to 411 against 418 to
420 for `-c`.

## Why `s2` was slower: the frame table

- `raw/instr.txt` (`scripts/instr.sh`): `s2` runs 1.744 million user instructions for an empty file's `-fsyntax-only`
  against `main`'s 0.804 million, the same in every way `time-runs` and `perf stat` run it. Warm (`perf stat`), `s2`
  still took fewer cycles than `main` (0.668 against 0.725 million), but from a cold start more.
- `raw/host.txt` (`scripts/host.sh`): which build is `time-runs`' own executable doesn't decide it; with either, `s2`
  is 2.6% to 7.0% faster than `main` in two-build runs.
- On a cloud VM, callgrind put 1.16 million of the static executable's 1.41 million instructions in libgcc's
  `classify_object_over_fdes` and `read_encoded_value_with_base`, under `__register_frame_info`, which `crtbeginT.o`'s
  `frame_dummy` calls: it sorts the 634 KB `.eh_frame`'s every FDE. With the registration wrapped into a function
  that does nothing (`s3`), the same start runs 0.25 million, and `s3` runs 0.552 million on the 9700X.

## What the start still pays

- `raw/faults4.txt` (`scripts/faults4.sh`): `s3`'s 319 faults of an empty `-fsyntax-only` by region: 149 anonymous
  (arenas, the heap), 64 in `.text`, 55 in `.rodata.str1.1`, 24 on the stack and the vDSO, 15 in `.bss`, 9 in
  `.data.rel.ro`. `strcmp` takes 38 of them. Warm, the process takes 0.474 ms, 0.488 million user cycles and 1.206
  million kernel cycles.
- `raw/kprof2.txt` (`scripts/kprof2.sh`): 300 such processes' cycles by what entered the kernel: 21.0% page faults on
  file-backed pages, 15.0% on anonymous ones and 18.9% in the faults' common path, 20.1% user code, 7.8% `mprotect`
  (the arenas' first commits), 3.2% `execve`, 1.7% `madvise`, 1.2% `munmap`; `mmap` itself rounds to 0.
  `raw/kprof.txt` (`scripts/kprof.sh`) has the same by symbol.
- `raw/hot.txt` (`scripts/hot.sh`, `scripts/hot2.sh`): user instructions sampled every 499 over 300 processes each of
  an empty file's `-fsyntax-only` and `-E -P`, `tiny.c`'s `-c` and `hello.c`'s `-c`: 553 pages of 4 KB of code ran,
  over 91 of `.text`'s 64 KB windows (the kernel's fault-around maps one at each fault), in 517 functions of 1,882 KB,
  which would fill about 30 windows packed together.
