# Tier 0's splice and the unwind analyzer: the twins deleted (#2924, C8a)

The base is `c280bdca9` (#2971's head). The head is branch `c8` on that base: tests `b52c1d4c8`, deletion
`a28f621e8`, docs `7f39ee952`. The branch was later rebased onto main `e55e0334a` and gained the survivors' cases
(`e91cd2582`, tests only). The gate is in [`../c-tier0-gate/`](../c-tier0-gate/): both twins took more ticks than
their vector paths in every size bin and every round (the splice 1.09 to 1.23 times, the unwind analyzer 1.11 to
2.54), with byte-identical objects.

## The 9700X, base against head ([`run.sh`](run.sh), [`logs/`](logs/))

Release, every run under the lock, timings on CPU 2, every benchmark process from a fresh copy of its executable.

- **Tests by head:** `test-tier0-inline` (with and without `--tier0-inline-shapes`), `test-unwind` and `test-tier0`
  pass.
- **Objects:** `-c`, `-c -g` and `-c --verify` of sqlite3.c, Lua, musl and buster's `main.c`, every compile in one
  directory: 1,372 of 1,372 byte-identical in each mode.
- **`benchmark-unwind --only vector`** (the analyzer and the vector writer on 256 generated functions), ns a typed
  entry, three processes each: base 26.40 to 26.63, head 26.10 to 26.33.
- **Whole compiles** ([`logs/time.log`](logs/time.log)): `ab`, three rounds, around `time-runs` (3 runs, 3 copies)
  of base, head and base again, `-c --lanes 1`. User cycles against base, round by round:

  | Compile | Head | Base again | User instructions, head against base |
  | --- | --- | --- | --- |
  | sqlite3.c | −0.02%, +0.08%, −0.10% | −0.16%, −0.15%, +0.19% | 4,700 to 5,200 fewer |
  | Lua's units | −0.14%, −0.14%, −0.44% | +0.15%, −0.17%, −0.24% | 2,100 to 3,300 fewer |
  | buster's `main.c` | +0.04%, +0.08%, +0.38% | +0.01%, −0.02%, +0.19% | 215,000 to 219,000 more |

  `main.c` is the corpora's one unit with splices (137). Its extra instructions are the splice's: with
  `--tier0-no-inline`, head retires 18,000 fewer ([`logs/prof/`](logs/prof/), `perf stat`, three runs each). That is
  about 1,580 more a splice, or 0.002% of the compile, and its cycles stay within base-again's spread. Base's splice
  (`tier0_inline_path`, 38,064 bytes) took the path flag at run time; head's (`tier0_inline`, 34,726 bytes) has the
  vector path alone. The difference is in how clang compiled the one path that is left.

## Locally (AVX-512 Xeon)

- `test-tier0-inline` (fixture, shapes, and on `main.c`), `test-unwind`, `test-tier0`, `test-builtin-math-helpers` and
  `test-builtin-rounds-helper` pass.
- c-testsuite's 220 single-exec programs give byte-identical objects, base against head, under `-c`, `-c -g` and
  `-c --verify`.
- The complete driver's parse and `-Wall -Werror` self-check of `main.c` pass, and so does the unity ownership check.

## Mutants ([`mutation/`](mutation/))

[`mutants.py`](mutation/mutants.py) breaks the vector code that stays:
- the splice's site scan (lane 63), the starts' prefix sum (the 8-lane step) and the positions' compress (lane 15);
- the segment copy's branch kinds and its values (lane 7);
- the body's rewrite of a RETURN with a value, its vector constants' meaning, and its clamp of a target past the body
  (lane 7);
- the unwind analyzer's check of forbidden writes (the last lane of each batch).

[`run.py`](mutation/run.py) runs `test-tier0-inline` (the fixture with and without the shapes, and `main.c`),
`test-unwind` and `test-builtin-math-helpers` on an archive of the tree.

- **Round `final`**, on the deletion's tree ([`mutation/final.results`](mutation/final.results)): 6 of 9 killed.
  Three survived, each a case no test had:
  - `i7`: a callee's vector constants left unrebased. Every caller with a spliced callee's vector constant had none of
    its own, so the constants landed at base 0.
  - `i8`: lane 7 of the clamp of a target past the body. No C callee branches to its end past its RETURN, which
    `tier0_validate` allows.
  - `u1`: the last lane of the forbidden-write check. No fixture writes an unsaved nonvolatile register at that lane.

  Commit `e91cd2582` adds their cases: the fills against their definitions on random columns, in every lane; a callee
  with a vector constant spliced into a caller that has one (`iota`, `plus_iota`); and a write of an unsaved RBX in
  place of each of a body's NOPs, over two batches of filler.
- **Round `pr2`**, the three survivors on the final tree ([`mutation/pr2.results`](mutation/pr2.results)): `i7` and `i8`
  killed by `test-tier0-inline` (the fills, and the fixture in all three runs), `u1` by `test-unwind`.
