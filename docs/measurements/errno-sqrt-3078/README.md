# Register transfers in Buster’s errno-aware square-root leaves

Buster issue [#3078](https://github.com/buster14a/buster/issues/3078). Base `3741c264fb349e86359acfd1c732ee1c2eaa4052`, head `c7a26554aa6560483d319dfa9fa1c7c30f77b9df`.

| Leaf | ELF symbol bytes, base → head | Decoded instructions | Explicit stack transports | Frame bytes |
| --- | ---: | ---: | ---: | ---: |
| sqrt | 49 → 33 | 13 → 9 | 4 → 0 | 16 → 0 |
| sqrtf | 47 → 30 | 13 → 9 | 4 → 0 | 16 → 0 |

Both the default compiler path and `--tier1` emitted these sizes and counts at `-march=x86-64`. The input consists of ordinary functions returning `__builtin_sqrt(x)` and `__builtin_sqrtf(x)`. For each object, `--helper-report` counted two planned math helpers, two helper calls, and zero direct forms. Both callers reference `__errno_location`. The `plain.c` control calls declared `sqrt` and `sqrtf`. Its only undefined symbols are those two library functions and its helper count is zero. Its object is byte-identical across revisions at each tier. The conditional four-byte EDOM store through RSI is each leaf’s only explicit memory operand at head. Each base leaf has two loads and two stores through RSP, plus the stack adjustments. Counts use the ELF function size to exclude alignment padding. This experiment measures code shape.

Each head FDE covers the exact leaf byte range and inherits the CIE’s CFA of `rsp+8` throughout. Each base FDE changes the CFA to `rsp+24` after the reservation and back to `rsp+8` at the return. [Decoded instructions and FDEs](decoded.txt)

## Native comparisons

On each build and tier, 2,432 input/environment combinations agreed across the normal C caller, its raw-bit leaf and glibc libm. The harness compares all result bits, the complete MXCSR and errno, with guard words around the raw errno cell. Raw float calls pass nonzero bits in the upper half of RDI and check all 64 bits returned in RAX. The harness queries the host’s MXCSR mask. It exercised four rounding directions, DAZ/FTZ independently on and off, and four initial sticky-flag patterns. Its 19 inputs per width include both signs of zero, infinity, qNaN, sNaN and subnormals, exact and inexact square roots, and a negative finite value.

Eight unmasked-invalid checks per build and tier examined the errno cell at SIGFPE for the two widths and two entry points. A negative finite input had written EDOM. A signaling NaN still had the sentinel. The 12 other math helpers compiled from a separate source produced a byte-identical control object across revisions at each tier. The two tiers and both builds produced the same whole-matrix SHA-256. [Test totals and hashes](comparison.txt)

`test-builtin-math-helpers` passed 894,218 checks at base and 894,226 at head. `test-unwind` passed on each, including 9,317 analyzer checks. The optional `test-unwind --cross-check` reached its GDB fixture on both builds, where the local sandbox denied ptrace. That test requires a successful GDB trial before it records its perf profile.

## Reproduce

Use a verified non-9700X Linux host with the ISA required by Buster’s `host_isa.h`. The qualification used an AMD Ryzen 9 7940HS, Linux 7.3.5-1-cachyos, the project’s Clang 23.1.4 Debug/native configuration, and glibc 2.44. Both incremental builds used the same cached objects from a clean, up-to-date build of the base. The native compile and link commands matched after normalizing the checkout path. The checker and backend objects, which include the modified files, were compiled from the corresponding source in each checkout. System Clang 23.1.5 built the external C harness. A clean reproduction uses the following commands in an empty directory with Git, Bash, Clang, GNU awk, GNU binutils and llvm-objdump on PATH.

```sh
git clone https://github.com/buster14a/buster.git sqrt-repo
git -C sqrt-repo worktree add --detach ../sqrt-base 3741c264fb349e86359acfd1c732ee1c2eaa4052
git -C sqrt-repo worktree add --detach ../sqrt-head c7a26554aa6560483d319dfa9fa1c7c30f77b9df
for t in sqrt-base sqrt-head; do
    (
        cd "$t" || exit 1
        if command -v cores >/dev/null 2>&1; then
            CORES_TITLE='sqrt code-shape reproduction' cores -n 4 -- ./build.sh --config Debug
        else
            ./build.sh --config Debug -j1
        fi
    ) || exit 1
done
git clone https://github.com/buster14a/buster-performance.git measurements
bash measurements/docs/measurements/errno-sqrt-3078/compare.sh \
    "$PWD/sqrt-base/build/compiler" "$PWD/sqrt-head/build/compiler"
```

The script emits each original ELF object, the helper report, relocations, full disassembly, frame dump, per-leaf slices and raw per-case results into its own `base/` and `head/` directories. It makes a separate test copy of each roots object with two local symbols exported under test names so a C harness can call the raw ABI. All shape and unwind checks read the original objects.
