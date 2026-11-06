# -Wuninitialized's brace-initializer scan on an Ice Lake server (buster#1349)

Raw evidence for buster14a/buster#1349: `check_common_uninitialized`'s brace scan now climbs the parse tree only from
self-read candidates (identifiers spelled as the declared object's name, not after `.` or `->`), found 64 kinds a block
with AVX-512 and a scalar twin under `--scalar`, and memoizes the climbs' sizeof answers per unit.

These are a 2-vCPU virtual machine's numbers on an Ice Lake server, not the 9700X's. The 9700X numbers are still to be
taken.

## Identity

| | |
|---|---|
| host | Intel(R) Xeon(R) Processor @ 2.90GHz (Ice Lake server), 2 vCPU, 7.8 GiB, Linux 6.1.155, KVM guest |
| toolchain | clang 23.1.4 (7a941dfb2877), `BUSTER_DEBUG_INFO=0 ./build.sh` (Release) |
| main | buster `9114e03c`, sha256 `8ea11b3a59ffbafbf6920ba059073f1b80870625549f2047d424938bb52a66f3` |
| branch | buster `1ebb568f` (the change on `9114e03c`), sha256 `6d885eaf71541aba6c6096e7e23648d93785b0ef360f7c593e66785acf060f9a` |
| rebased | buster `03c713a2` (the same change on `7fbf3eb3`), checked in `rebased/` |

`vm.overcommit_memory` was 1 for the A/B timings, the corpus and the test runs (the fuzz ran under the default 0, and
its units are small). Under this VM's default heuristic overcommit both builds stop at `fatal error: can't reserve type
table` on sqlite3.c, and earlier the 32,000-element `-c` runs ended in `code output capacity exhausted` on both
builds. With 1, the retained A/B summary reports exit 0 for the final run of each build and input. The script keeps only
that final exit code, so the summary does not establish the outcome of every individual repetition.

## A/B timings

`ab.sh 11`: main and the branch alternately, 11 runs each, `taskset -c 1`, `compiler check --time-stages`, medians of
wall time (`run.py`), the check-program stage and peak RSS. Inputs are `gen.sh N [static|strings]`, the issue's
generator: one function whose local (or static) `const int t[] = {0, 1, ..., N-1}`. Individual timing and status
records were not retained, so the medians cannot be independently reconstructed or checked for failed repetitions.

| input | main wall | branch wall | main check-program | branch check-program | peak RSS (both) |
|---|---:|---:|---:|---:|---:|
| local1000 `-Wall -c` | 7.58 ms | 5.30 ms | 2.254 ms | 0.166 ms | 13.4 MB |
| local4000 `-Wall -c` | 42.76 ms | 9.85 ms | 32.896 ms | 0.498 ms | 17.4 MB |
| local8000 `-Wall -c` | 145.79 ms | 16.07 ms | 130.292 ms | 1.024 ms | 21.9 MB |
| local16000 `-Wall -c` | 549.84 ms | 29.20 ms | 520.673 ms | 2.047 ms | 32.4 MB |
| local32000 `-Wall -c` | 2,126.47 ms | 55.22 ms | 2,075.448 ms | 4.094 ms | 54.8 MB |
| strings16000 `-Wall -c` | 558.90 ms | 41.66 ms | 518.809 ms | 2.168 ms | 49.1 MB |
| static32000 `-Wall -c` | 53.99 ms | 53.34 ms | 3.482 ms | 3.488 ms | 54.7 MB |
| local32000 `-Wall -fsyntax-only` | 2,120.58 ms | 51.17 ms | 2,072.292 ms | 4.203 ms | 54.8 MB |
| static32000 `-Wall -fsyntax-only` | 51.62 ms | 50.97 ms | 3.484 ms | 3.492 ms | 54.7 MB |
| local16000 `-c` (no `-Wall`) | 28.70 ms | 28.43 ms | 1.815 ms | 1.870 ms | 32.4 MB |
| sqlite3.c 3.50.4 `-Wall -c` | 372.33 ms | 371.95 ms | 52.339 ms | 52.151 ms | 216.2 MB |

The local array's time was quadratic in N (each doubling about 3.8x); it is now linear and equal to the static array's,
which never ran the scan. Without `-Wall` neither build runs the analysis (buster#1488), so nothing changes there.

## Output identity

- `fixture/`: `self.c`, the self-initialization cases of the new `self_init_scan` test fixture plus the issue's
  sizeof-in-statement-expression case (line 9, `h`). `clang.txt` is clang 23's `-Wall -fsyntax-only`; `main*.txt` and
  `b2*.txt` are main's and the branch's, vector and `--scalar`. The branch's are byte-identical to main's. Main's match
  clang's except line 9, where main warns on `int x = { sizeof(({ int y = { x }; y; })) };` and clang doesn't; that
  difference predates this change and is not touched by it.
- `fuzz/`: `run.sh 1 500`, 500 generated well-typed units of 40 functions each, whose brace initializers mention their
  own object through sizeof and alignof operands, members after `.` and `->`, statement expressions, casts, address
  operands, assignments, conditional arms and long element lists. Main and the branch, `-Wall -fsyntax-only`, vector
  and `--scalar`: 1,000 runs, 1,000 identical outputs and exit codes, 17,132 self-initialization warnings among them.
- `corpus/`: `corpus.sh`, sqlite 3.50.4's `sqlite3.c` and `shell.c`, lua 5.4.8's `src/*.c` and the repository's
  `tests/` and `examples/` C files under 400 KB (84 files), `-Wall -Wextra -fsyntax-only`, vector and `--scalar`:
  168 runs, 168 identical outputs and exit codes, 320 diagnostics.

The differential logs do not break out successful versus nonzero exits; identical failures are included in those
counts and are not evidence of successful compilation.

## Tests

`tests/`: `compiler test-checker-driver --clang clang-23 --executable <absolute build>` with each build, run alone.

| build | checks | failures |
|---|---:|---:|
| main `9114e03c` | 60,382 | 122 |
| branch `1ebb568f` | 60,393 | 122 |

The branch's 11 extra checks are the new ones (the candidate walk against a direct reading on 2,000 random ranges with
`PROT_NONE` tails after the kinds and names and a block-edge carry; the memoized climb against the plain one on 600
random forests and cycles; the `self_init_scan` fixture in both modes), and all pass. The 122 failures are the same on
both builds (`failures-*.txt`, the logs without timing lines and with temporary paths normalized): they differ only in
the thread-race counters of the fences and counters checks, which vary run to run. They fail the same way with main's
build on this host; among them are intrinsic cases whose first `-c` error differs from clang 23's.

## Files

- `gen.sh`, `run.py`, `ab.sh`, `ab-11.txt`: the generator, the runner, the A/B script and its output.
- `fixture/`, `fuzz/`, `corpus/`, `tests/`: as above.
- `rebased/`: the change rebased on `7fbf3eb3` against that main, as described there.
