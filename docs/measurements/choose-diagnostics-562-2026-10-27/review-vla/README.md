# Review: range diagnostics in sizeof VLA bounds

Review head: `d5d7f3307e97a3b2e0a892427c5a2391bac9ad52`, signed off.
The commit adds six fixtures and comments/documentation only; production
checking and VLA capture/lowering behavior are unchanged. Original performance
evidence remains tied to implementation head `77aea067`, not relabeled.

The [review finding](https://github.com/buster14a/buster/pull/588#discussion_r4391682501)
claims that Clang rejects this source with an x86 range error:

```c
typedef char V __attribute__((vector_size(16)));
#define BAD __builtin_ia32_cmpb128_mask(a,a,8,65535)
unsigned f(V a,int n) {
    (void)__builtin_choose_expr(1,0,0);
    return sizeof(int[n+BAD]);
}
```

Both reference compilers accept it with status zero and no range diagnostic:
Clang 23.1.4 locally and Clang 23.1.1 on the locked Ryzen 7 9700X.
`review-clang-local.log` and `review-clang-9700x.log` record the same nine
isolated probes; each invocation uses `-std=gnu17 -fsyntax-only
-fno-color-diagnostics`, with CPATH and C_INCLUDE_PATH unset. The exact case
is entry 0. Selected and unselected choose arms in the VLA bound are entries
2 and 1; both references accept them too.

The pre-#562 baseline `e6153259` rejects entry 0, while the fixed production
implementation accepts it. This supplies a negative control for the new
fixture. The live ordinary call, entry 6, is rejected by both references and
both Buster versions, confirming that the probes do observe range errors.
Entries 5 and 8 expose separate pre-existing Clang disagreements for an
ordinary VLA declaration and a sizeof VLA bound without any selection; both
Buster versions reject them while Clang accepts them. These are retained
explicitly and are not counted as passing review fixtures.

The six added differential fixtures cover entry 0, selected/unselected choose
arms in a sizeof VLA bound, sizeof VLA inside an unselected choose arm,
nested sizeof and an in-range immediate. The complete x86 suite now has 88
isolated fixtures, each through both production driver schedules.

Clang's checking context is distinct from the runtime evaluation of the
bound. The pinned source references are
[`ParseArrayBoundExpression`](https://github.com/llvm/llvm-project/blob/llvmorg-23.1.1/clang/lib/Parse/ParseExpr.cpp#L133),
which uses a constant-evaluated checking context, and
[`BuiltinConstantArgRange`](https://github.com/llvm/llvm-project/blob/llvmorg-23.1.1/clang/lib/Sema/SemaChecking.cpp#L6335),
which bypasses its range helper in that context. These are behavior references;
no LLVM implementation or fixture is copied. The acceptance observations above
are the differential oracle for this change.

The optimized local build passes with warnings as errors. At this exact head,
`test-checker --seed 133` executes 259,854 checks: all 88 x86 fixtures and new
assertions pass, with only the four pre-existing Clang 23.1.4 fpclassify oracle
disagreements retained in the full log. Runtime VLA metadata and native tests
also run as part of this suite.

At this exact head on the locked 9700X with Clang 23.1.1, the optimized build
passes with warnings as errors and `test-checker --seed 133` passes all
259,854 checks with zero failures. `review-source.sha256` was verified against
the transferred checkout; the verification log and compiler binary hash are
retained alongside the build/checker logs. Required GitHub CI remains a
separate gate.

Reproduce the nine exploratory probes from a scratch directory:

```sh
clang -Wall -Werror review-vla-probes.c -o probes
./probes clang
./probes /absolute/path/to/buster/build/compiler
```

The original C harness and sources are project material. Its source and output
scratch files are written in the current directory; use a disposable work
directory. On the 9700X each run takes `exclusive.sh` separately with owner,
title and PR URL recorded. No system settings are changed.
