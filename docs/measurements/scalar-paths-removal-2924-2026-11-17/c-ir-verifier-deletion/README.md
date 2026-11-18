# The IR verifier: the twins deleted (#2924, C9a)

The base is `f24dfbcbe`: the tests commit, with both paths still there, on #2979's `bf98659ff`. The head is
`ef00c4267`, which deletes:
- `ir_verify_scalar` and the use-list builder's scalar twin;
- the scalar arms of the row, graph and dominance checks;
- the scalar scans for SIMD values and vectors.

The branch then adds the guides (`4ecf4d40d`) and the survivors' fixtures (`55c8dda07`, tests only; "Mutants" below).

The gate is in [`../c-ir-gate/`](../c-ir-gate/): the verified optimizer's area, its verification included, took 1.09 to
1.16 times as long on the twins in every size bin, with byte-identical objects.

## The 9700X, base against head ([`run.sh`](run.sh), [`logs/`](logs/))

Release, every run under the lock, timings on CPU 2, every benchmark process from a fresh copy of its executable.

- **Objects:** `--tier1` and `--tier1 --tier1-passes=+all` objects of sqlite3.c, Lua, musl and buster's `main.c`,
  every compile in one directory: 1,372 of 1,372 byte-identical in each mode.
- **`benchmark-ir`'s verifier** (base `--only vector`, head `--only verify`), three processes each:
  - 32 instructions: base 61.7 to 62.7 ns a function, head 57.9 to 58.2;
  - 262,144 instructions: base 1.306 to 1.344 ns an instruction, head 1.297 to 1.337.
- **`benchmark-ir-source --only verify`** on the frozen sqlite3.c, three processes each: base 11.74 to 11.85 ns a typed
  entry (183.88 instructions), head 11.83 to 11.88 (183.86).
- **Whole compiles** ([`logs/time.log`](logs/time.log)): `ab`, three rounds, around `time-runs` (3 runs, 3 copies)
  of base, head and base again, `-c --lanes 1`. User cycles against base, round by round:

  | Compile | Head | Base again | User instructions, head against base |
  | --- | --- | --- | --- |
  | sqlite3.c, `--tier1` | −0.40%, −0.32%, −0.39% | −0.07%, +0.00%, −0.07% | 35.13 M fewer (−0.42%) |
  | Lua's units, `--tier1` | −0.43%, −0.15%, −0.26% | −0.21%, +0.05%, +0.12% | 1.96 M fewer (−0.09%) |
  | sqlite3.c, `--tier1 --tier1-passes=+all` | −0.40%, −0.30%, −0.28% | −0.04%, +0.05%, +0.03% | 29.75 M fewer (−0.18%) |

  Head is faster in every round. Base's optimizer preparation and final verification
  (`ir_optimize_prepare_twins`, `ir_optimize_verify_twins`) took the verifier's and the use-list builder's scalar
  twins wherever a pass ran on its own scalar twin (`options.scalar`). Head verifies those functions on the vector
  path.

## Checks on head ([`logs/checks.txt`](logs/checks.txt))

- The unity ownership check (`tools/ci/build_regression.c --ownership-only`) passes.
- The complete driver's `-fsyntax-only -Wall -Werror` of `main.c`, and its `--lanes 1 --verify -c`, pass.
- Start order: 578 functions in `.text.buster_start` in each build, none of base's missing in head. The 30 function
  names new in head are the renamed entry points (`ir_verify`, `ir_uses_validated`, `ir_optimize_prepare`, ...) and
  clang's split parts of unchanged functions.

## Tests by head (benchpress, `c9a/head`)

All pass:
- `test-ir` (the frozen digests), `test-ir-simd`, `test-ir-lowering`, `test-ir-parse`, `test-ir-reduce`;
- `test-ir-metamorphic` (default, and `--seed 731 --count 6`), `test-ir-interpreter`, `test-interpreter`;
- `test-ssa-ir`, `test-ssa`;
- `test-ir-optimize`, `-gvn`, `-licm`, `-sroa`, `-unroll`, `-inline`, `-vectorize`;
- `test-tier1-select`, `-liveness`, `-emit`, `-pipeline --cross-check`, `-masks`, `-wide`, `-cfg`, `-model`,
  `-allocation`, `-schedule`;
- on c-testsuite's 220-program subset: `test-ir-source --passes` and `--dominators`, `test-ssa-source --typed --tier1`
  and `test-tier1-cfg-source`;
- `test-ir-source --simd` and `--benchmark-self-test`.

## Mutants ([`mutation/`](mutation/))

[`mutants.py`](mutation/mutants.py) has sixteen mutants. They break the vector code that stays:
- the row checks: an operand's type far outside the window, from the first 64 types, and from the window's upper half;
  a shift's count, a select's false value, an access's alignment bound;
- the dominance batches: an earlier block's operand `c`, lane 15's earlier uses;
- the complete verifier's reachable uses: the nested-interval test, and the last partial batch;
- the graph check: the scan for switches, and its tail's last operation;
- the use lists: a fixed operand's column, and a phi's input stride;
- the scans for SIMD values and vectors: the `v4i32` and `v16i32` bounds.

[`run.py`](mutation/run.py) runs `test-ir`, `test-ir-simd`, `test-ir-metamorphic --seed 731 --count 6`,
`test-ir-reduce`, `test-ir-optimize` and `test-ir-source --passes` on c-testsuite's first 30 programs, on an archive of
the tree. Round `uses` adds plain `test-ir-source` on the same programs, whose use lists are checked against their
definition.

- **Round `final`**, on the deletion's tree `ef00c4267` ([`mutation/final.results`](mutation/final.results)): 8 of 16
  killed. Eight survived, each a case no test had:
  - `r5`: a select's false value of a narrower type than its result;
  - `r6`: an access aligned to 2^32 bytes, one past the largest;
  - `d1`: an operand `c` from an earlier block that doesn't dominate, with the tree supplied;
  - `d3`: a use in a sibling of the definition's block, by the complete verifier's own tree;
  - `d4`: the complete verifier's last partial batch of reachable uses;
  - `g2`: a phi or switch as the last operation of the graph check's tail;
  - `s1` and `s2`: a `v4i32` type to the SIMD scan, and a `v16i32` type to the vector scan.
- **Round `cases`**, on the fixtures commit `55c8dda07` ([`mutation/cases.results`](mutation/cases.results)): the base
  passes, and all eight are killed, each by its new fixture's message (the `.test` logs):
  - test-ir's `ir_test_survivors`: a select of an `i32` false value; a load at `alignment_log2` 32; a diamond whose
    arm's select reads the other arm's value (with the tree, and by the complete verifier in both orders of the arms);
    a switch of duplicate cases as the function's last operation;
  - test-ir-simd's markers: every vector type.
- **Round `uses`** ([`mutation/uses.results`](mutation/uses.results)): `u1` and `u2` again, with plain
  `test-ir-source`.
  - `u2` is killed by it as well (a crash: its phi stride reads past the extra array).
  - `u1` is killed by `test-ir`'s use-list digest alone. None of the 30 programs' 96 forms has a use in column `c`, so
    the definition check sees nothing there.
