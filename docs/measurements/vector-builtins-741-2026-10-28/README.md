# #741's vector builtins: what they cost checking and lowering, 2026-10-28

Branch `claude/loving-carson-j9sz52-vector-builtins` (buster14a/buster#741) adds three things to the lowering:

- the generic vector builtins (`__builtin_shufflevector`, `__builtin_convertvector`, the elementwise and reduction
  builtins);
- the first x86 builtins' rows and leaves;
- the narrowing conversions.

This record measures its commit `5fe76d31889a1d31f5153b70c49f477b40611f2c` against its base, main
`c9a433b5558d07af180dba00486f805e355b61f9`, on the frozen `sqlite3.c` (corpus `preprocessor-391e729af658`). The pull
request's later head, `d50fe6f`, isn't measured here: it is the owner's review commit, which fixed the narrow literal
fusion's effects and the leaves' target gate. `sqlite3.c` has no vector type and calls no x86 builtin, so this measures
what the new code costs a unit that doesn't use it.

The run has an A/A control: `aa` is a copy of main's executable (the same bytes: `inputs.sha256`), run as a third tree
from a directory of its own, in every round.

| Measure (`sqlite3.c`) | main | A/A copy | head | head against the A/A copy |
| --- | --- | --- | --- | --- |
| `-fsyntax-only`, user instructions (`perf stat`) | 959,772,663 | 959,772,326 | 959,750,455 | -21,871 (-0.0023%) |
| `-fsyntax-only`, user cycles (`perf stat`) | 450.633 M | 449.237 M | 449.537 M | +0.07% |
| `-fsyntax-only`, wall (`time-runs`) | 99.159 ms | 98.758 ms | 98.741 ms | -0.02% |
| `-c`, user instructions (`perf stat`) | 1,237,584,310 | 1,237,584,281 | 1,238,483,630 | +899,349 (+0.0727%) |
| `-c`, user cycles (`perf stat`) | 577.598 M | 574.737 M | 573.690 M | -0.18% |
| `-c`, wall (`time-runs`) | 122.709 ms | 121.973 ms | 121.833 ms | -0.11% |

Where the rows come from:

- The `perf stat` rows are the medians of three rounds of `-r 11` each, the trees in the same order in each round
  (`perf.log`).
- The `time-runs` rows are the medians of five `ab` rounds of 11 processes each (`ab.log`). `ab` rotates the trees'
  order from round to round, and every run takes the 9700X's lock on its own. All 15 rounds report no failed process.
- Each run is pinned to CPU 2, with `perf stat -e instructions:u,cycles:u,task-clock`.
- The three trees' `-c` objects are the same, byte for byte (`abV.log`: "lower objects identical"; `inputs.sha256`).

The A/A copy differs from main by +0.31% to +0.63% in cycles and wall time, the same executable from another file. The
head's differences from the A/A copy, -0.24% to +0.07%, are within that spread, so this record shows no time cost and
no time gain. The peak resident set moved by less than 1 MB in either direction (`ab.log`'s `KB peak`).

The instruction counts don't depend on placement. Checking runs 21,871 fewer instructions with the head (-0.0023%).
`-c` runs 899,349 more (+0.073%), so about 0.92 million come after checking, in the lowering, for the same object.
The new code is in the lowering. This record has no profile to place those instructions within it, and doesn't
attribute them further.

## The suites on the head

Each suite ran once, after the builds, on CPUs 0 to 7 as the 9700X's job runs them, each under its own hold of the lock
(`abV.sh`):

| Suite | Result |
| --- | --- |
| `test-checker --program-vectors` | 1,830 checks, 0 failures |
| `test-checker --seed 133` | 502,005 checks, 4 failures |
| `test-tier0 --cross-check` | 268,911 checks, 0 failed |
| `test-checker-driver --executable ./build/compiler` | 26,720 checks, 0 failures |
| `test-checker-deferred` | 2,099 checks, 0 failures |
| `test-check-lanes` | 3,464 checks, 0 failures |

The 4 failures are two programs, by both paths: `fpclassify-conditional-selector-effects` and
`fpclassify-known-category-effects` (`test_test-checker.log`).

As a control, main's own `test-checker --seed 133` ran afterwards in the same environment (`test_base_test-checker.log`:
501,475 checks). It fails the same 4 checks with the same outputs, so the failures predate the head.

In each, the outputs differ only in the order of two of the selectors' marks:
- the compiler's executable gives `n=2 ... ours=512344` and `n=-3 ... ours=1512340`;
- clang -O0's gives `oracle=512434` and `oracle=1512430`.

That is the order of `__builtin_fpclassify`'s normal and subnormal selector arguments. clang's code generation
evaluates them as the two arguments of one C++ call, whose order of evaluation C++ leaves to the compiler that built
clang. This host's clang 23.1.1 (`/usr/bin/clang-23`) and its `libclang-cpp` were built by GCC 16.2.1 (their
`.comment` sections). The 9700X's CI job passed `test-checker` at #741's later head, `d50fe6f`, whose base is the
same main, so the clang that job runs may evaluate them in the other order; this record doesn't establish which clang
that is.

## The builds

Each tree built under its own hold of the lock, with `BUSTER_DEBUG_INFO=0`: 29.5 s for main and 29.9 s for the head
(`build_base.log`, `build_head.log`), once each.

## The inputs

- `abV.sh` is the whole campaign: its environment, its commands and their order.
- `inputs.sha256` holds the hashes of:
  - the three executables (main's and the A/A copy's the same);
  - the three `-c` objects (the same);
  - `sqlite3.c` and the pinned predefines;

  and the kernel (`6.18.50-2-lts`) and clang (`clang version 23.1.1`).
- `source-base.sha256` and `source-head.sha256` hash every source file of each tree but its build directory: 704 and
  707 files. The head changes these, past main:
  - `AGENTS.md` and `docs/c-checker.md`;
  - `c_check_program_helpers.c`, `c_check_program_lower.c` and `c_check_program_x86.c`;
  - `c_check_program_test.c`, `c_check_program_x86_test.c`, `c_checker_test.c` and `main.c`;

  and adds `c_builtin_x86_helpers.c`, `c_check_program_vector_builtins.c` and its test.
- The logs keep the lock's receipt lines (`exclusive.sh:` and the waiting owners' titles and links), which show where
  each run waited for others.
