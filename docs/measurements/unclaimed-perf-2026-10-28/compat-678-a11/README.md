# Frozen a11 compatibility qualification

This stage composes pinned PR 678 `a11d8065104f07ce8ab3e752404bb48f07df9d4c`
with the retained performance union, main 416 and qualified next-main d3.
The compiler revision tested is `06150c52db27a31fe0106acbe00c1e34ae8249d0`.
It deliberately does not claim compatibility with later PR 678 revisions.

Both native and generic x86-64 builds completed all 41 translation units.
The generic build uses the PR's pinned private baseline runtime, not this
host's ISA-v4 startup objects. Preserved binaries and hashes:

* native `compiler-native-06150`: d48b6142fe4569de3023fee17ccd5bb5d67dc6d529b7f67f889fd7aa9dec8465
* generic `compiler-generic-06150`: e12ddb0808db4d4abe19676acbffd7ba65f28535eb292ba287395e0a17eded4e

Every build/test used a separate local cores grant of two physical cores.
Native/generic checker: 488,843/0 and 491,626/0 respectively. Both driver
suites passed 21,660 checks; deferred suites 1,147 checks across 72 fixtures;
source lanes and worker-budget protocol passed; c-testsuite passed all 220
units; parser/Clang comparisons, streaming (188 checks), and tier1 schedule
(609,462 checks, seed 172) passed. The native call-graph check passed 41 units,
25,440 functions and 151,409 calls with no unapproved cycle or split.

Native preprocessor passed. Generic preprocessor exited 1 solely because its
location-limit fixture expected two benchmark commands to run, whereas PR 678
explicitly refuses benchmarks on a scalar host. Semantic preprocessor cases,
argument-allocation faults, window/source-location and printed-byte checks,
headers and 1,500 C17 plus 1,500 C23 fuzz cases all passed. The three ordinary
location-limit command rows already passed. A minimal test-only availability
correction is signed commit `95dd639c`; focused adapters then passed all five
rows on both native and generic hosts, forwarding child requests to the exact
frozen full compiler, preserving the real command-availability gate.

The byte/runtime/printer controls compare native, native --scalar, generic and
frozen b8 main-416 union using the same absolute input names. All object,
diagnostic, stdout and preprocessed output bytes agree; linked checksum
programs run successfully. Inputs include a 257-element integer table with a
zero tail, adjacent embedded-NUL string literals, zero storage, an empty unit
and macro diagnostics. These are correctness controls, not performance claims.

Raw individual command logs, focused fixture sources and controls remain in
this directory. This stage remains frozen; the meaningful main-321 and nullable
ASM composition is qualified separately under `../compat-678-current/`.
