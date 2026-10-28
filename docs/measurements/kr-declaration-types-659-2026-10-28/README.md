# K&R parenthesized atomic type qualification

Original correctness evidence for Buster issue #659/source PR #752. This local host
is not the qualification 9700X; identity is in `receipts/host.txt`. There is no
throughput, release-build, full-CI or whole-issue-completion claim.

## Frozen stages

| Stage | Source | Outcome |
| --- | --- | --- |
| Parent minimal CLI | PR #735 namespace9bb8cd82; CLI digest retained | `_Atomic(int)` definition rejected; exit1 |
| Boundary-only | 58961ff0a90332945e7471b5377f53da8b89826c | baseline18,742 checks/46 failures |
| Typed-query fix | addd421d60eead9019c64cefa86dd1d720199143 | baseline/native18,780/8 each; atomic/source/ABI controls pass; no sanitizer finding |
| Normal parent integration | 8921da4adc90cb2d68de2518a141346970ce9c39 | baseline and native 18,780 checks / 0 failures each |
| Driver negative, older runtime-call witness | addd421d matrix with frozen9bb CLI | 529 checks/32 failures |
| Final driver negative | 8921da4a matrix with frozen9bb CLI | 529 checks/24 failures, all new atomic cases |

At addd421d, all 8 failures are inherited policy case 23 (parent case 20). The
runtime call in that witness is outside parent #701's admitted return-warning
subset. PR #735's published fbfddda3 changes only that witness to `sizeof(p(1))`,
retaining count/category/status/object assertions. The normal integration
preserves that reviewer change. Historical failures are not relabeled as passes.

The actual-module driver changes only module-home linkage in an overlay and
asserts native/baseline host selection. It runs the permanent eager/lazy,
scalar/vector, syntax/object strict matrix, extended source fixtures and the
mixed atomic/narrowing/float/pointer/padded-aggregate Clang-oracle runtime case.
The new deferred fixture is compiled; full `test-checker-deferred` remains a
separate CI gate.

The first adapter command omitted an include path and stopped before production
compilation. Corrected O1 sanitizer builds checked the boundary-only stage.
Corrected/final source builds use O0, ASan+UBSan and leak checking, without
sanitizer exclusions. Longer builds used the shared core queue. Short focused
commands completed under the documented 25-second single-thread bound.

## Reproduce

Use official Clang 23.1.4, exact Buster source and this separate evidence checkout.
From a fresh output directory, set absolute `source`, `record`, `clang` paths:

```sh
mkdir -p overlay/buster/compiler
sed -e 's/^#define BUSTER_ELSEWHERE inline __attribute__((noinline))$/#define BUSTER_ELSEWHERE static __attribute__((unused))/' \
    -e '/^#define BUSTER_X86_TARGET_DATA_ELSEWHERE$/d' \
    "$source/src/buster/compiler/main.c" > overlay/buster/compiler/main.c
```

Build each mode separately, using `cores -n 1` on the owner's machines. The 9700X
also requires its documented per-run lock. Baseline uses `x86-64`/`0`; native uses
`native`/`1`:

```sh
"$clang" -std=gnu17 -O0 -gline-tables-only -march=x86-64 \
  -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror \
  -Wno-unused-function -Wno-psabi -DKR_EXPECT_HOST_VECTOR=0 \
  -DBUSTER_CLANG_DEFAULT_TARGET='"x86_64-pc-linux-gnu"' \
  -ffunction-sections -fdata-sections -fsanitize=address,undefined \
  -fno-omit-frame-pointer -Ioverlay -I"$source/src" -I"$source/src/buster/compiler" \
  "$record/atomic-driver.c" -Wl,--gc-sections -lm -ldl -pthread -o atomic-baseline
```

Run each correctness command separately and retain its real exit status:

```sh
env BUSTER_PARALLEL_CPUS=1 ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
  ./atomic-baseline --qualify-atomic "$clang"
```

A fourth argument supplies an old CLI for the strict-matrix negative; the entry
then omits in-process source/ABI fixtures rather than attributing those to the
old executable:

```sh
./atomic-baseline --qualify-atomic "$clang" /absolute/path/to/frozen-parent-cli
```

The digests retain executed paths. Production modules and permanent fixtures
come from the named revisions; the generated overlay changes only the two
linkage lines above. Large binaries are omitted. No benchmark, external corpus,
LLVM implementation or third-party fixture is incorporated. The original
harness/probes use Apache-2.0 WITH LLVM-exception; included Buster modules retain
their own terms. Clang is an external behavioral/ABI oracle.

The explicit single-oracle repeats set `BUSTER_PARALLEL_CPUS=1`; both final
native and baseline entries again complete 18,780 checks / 0 failures within
25 seconds. Earlier direct runs omitted that cap, allowing the test adapter's
CPU-derived oracle concurrency. Their results are retained as separate runs;
the explicit-cap receipts support the reproducible short-command resource claim.
