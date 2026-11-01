# #995's review fixes on the 9700X (buster #148)

The base is [#995](https://github.com/buster14a/buster/pull/995)'s head, `650a1b72`. Each tree adds the fixes for the two
things its review found clang 23 doing otherwise:

- an alignment that is a modification's value (`(s = 3)`), which clang's evaluator doesn't evaluate;
- a probability whose discarded operand that evaluator can't evaluate (`(s, 0.75)`, `((void)s, 0.75)`).

The trees:

| tree | code | what changed against the tree before it |
| --- | --- | --- |
| v1 (`head` in `runs/measure.log`) | `9c947150` | the fixes as first written |
| v2 | v1 + `variants/v2.diff` | the evaluability test out of line |
| v3 | v1 + `variants/v3.diff` | the comma's and the cast's test only in constant evaluations |
| v4 | v1 + `variants/v4.diff` | v3, with all of the comma's new work behind that one test: `2e5c729`'s code |

`2e5c729` is v4 with one comment changed.

## Method

`measure.sh` (a copy of buster-performance#186's harness) runs `-c` of the frozen `sqlite3.c` (the 9700X job's options)
and of stb_image (`-march=native`), base against tree. Each comparison is one hold of the host's lock, holding nothing
else. First a drive of each tree, which compares the objects. Then 8 rounds in which each tree, in an order alternated by
round, compiles each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`, pinned to CPU 2.
`analyze.py runs/TREE-UNIT.log base TREE` gives medians of the rounds' means. Every one of the 48 runs per unit exited
with status 0, and every tree's objects are identical to the base's.

Neither unit calls the alignment builtins or `expect_with_probability`, so these numbers measure what the new flags cost
code that doesn't use them.

## Results

| tree | `sqlite3.c` instructions | `sqlite3.c` cycles | stb_image instructions | stb_image cycles |
| --- | ---: | ---: | ---: | ---: |
| v1 | +663,610 (+0.049%) | −0.05% | +32,967 (+0.017%) | −0.29% |
| v2 | +1,200,491 (+0.089%) | +0.35% | +69,167 (+0.036%) | +1.06% |
| v3 | +368,093 (+0.027%) | +0.54% | +14,956 (+0.008%) | +1.26% |
| v4 | +365,563 (+0.027%) | +0.26% | +13,431 (+0.007%) | +0.80% |

Within each comparison, the instruction counts vary from round to round by tens of instructions in `sqlite3.c` and a
few thousand in stb_image. The cycles move from −0.05% to +0.54% between v1, v3 and v4. v3 and v4 differ by about
2,500 instructions, yet their cycles differ by 0.3 points. That spread is placement noise, not a cost of the changes.

The out-of-line call (v2) cost more than inlining did, so the test is reached often. Running it only in constant
evaluations (v3) halves v1's cost. The rest of the cost is probably the flags' work in the constant evaluations
themselves: the source adapter evaluates every constant expression (initializers, bounds) that way. This record didn't
isolate that. Sampled profiles (`perf record -c 1000`) were throttled to about 9,000 samples, too few for deltas this
small. Callgrind can't run the compiler, whose arenas reserve 64 GB each.

## Tests

`tests/v4.status` holds v4's tests on the 9700X, each in a hold of its own, and `tests/v1-9c947150.status` holds v1's:

- `test-checker --program-align` (1,319 checks);
- `test-check-builtins-misc` (1,387);
- `test-checker --seed 133` (712,634);
- `test-checker-deferred` (3,189);
- `test-checker-driver --executable` (43,576);
- `test-check-builtins` (6,445);
- `./build.sh check-call-graph` (0 cycles past the 3 allowed, 0 split variables).

All of them had 0 failures.
