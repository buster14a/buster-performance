# AMX helper tile configuration

[buster issue #3092](https://github.com/buster14a/buster/issues/3092) covers the configuration stores emitted by `cbuiltin_amx_helper`. The base is `3741c264fb349e86359acfd1c732ee1c2eaa4052` and the candidate is `e74f01262f1846a1b3af7a9bae1e842bc1875538`.

| Helper family | IDs | Configuration stores, base → head | Initialization bytes, base → head | Entire helper bytes, base → head |
| --- | ---: | ---: | ---: | ---: |
| Zero | 1 | 11 → 7 | 55 → 36 | 107 → 88 |
| Load | 4 | 11 → 7 | 55 → 36 | 108 → 89 |
| Store | 1 | 11 → 7 | 55 → 36 | 95 → 76 |
| Dot product | 12 | 15 → 11 | 83 → 64 | 153 → 134 |
| Row | 6 | 11 → 4 | 55 → 25 | 101 → 71 |

Initialization starts at the register zero and ends immediately before `LDTILECFG`. Its stores include palette and dimensions. Isolating just the clear gives 8 stores and 41 instruction bytes on base. Head uses 4 stores and 22 bytes in the first four families and 1 store and 11 bytes in the row family. Summed once over all 24 leaves, the initialization saves 114 stores and 522 bytes. The counts are static code shape. The experiment collected no runtime timings.

## What ran

On Linux x86-64, the Ryzen 9 7940HS satisfied Buster’s host ISA. Clang 23.1.4 supplied the Debug build and Clang oracle. The paired build reused the base’s 41 unaffected Debug translation units after verifying their compile commands. The candidate rebuilt both owners of the emitter and relinked. LLVM objdump 23.1.5 decoded every byte of each object’s executable section. GNU readelf 2.47 decoded the relocations, symbols and frame information.

- The project’s `test-checker --program-amx` passed 1,261 checks on each revision. The candidate’s private record fixture compares the entire 64-byte image and its two guards before each generated load. The existing Clang trace covers packed inputs, tile operations and result stores at three dimensions.
- The experiment compiled one ordinary C translation unit per builtin with `-march=x86-64` and the function’s target attribute. Each object contains the caller and the private leaf. Caller and prologue bytes match across revisions, as do the bytes from `LDTILECFG` through `ret`. Relocations, symbol properties apart from leaf size, and decoded CFA/register rules match. Each helper FDE ends at its symbol boundary and restores the entry state at its final `ret`.
- A separate harness extracted the actual straight-line object prefix, stopping immediately before the decoded `LDTILECFG`. It ran those integer and SIMD instructions against a 384-byte guarded stack. It poisoned ZMM0 and the stack, checked the aligned frame, saved RBP, six GPR arguments and dot product’s stack-passed result pointer, and compared all surrounding bytes. The capture does not execute a tile instruction.
- Each ID used six `(m,n,k)` triples and all four SysV entry RSP residues modulo 64. The triples were `(0,0,0)`, `(1,4,4)`, `(3,20,12)`, `(16,64,64)`, `(7,37,22)` and `(0x123,0x12ab,0x3456)`. The final two exercise byte packing on raw inputs before hardware validation. All **576 images per revision** matched the independently constructed palette, column and row bytes. Both 36,864-byte capture files have SHA-256 `61d6beef3c58fc2af29507c84826896a237ad50b6e82ca27d6f9005043f36f7b`.
- A byte written below the configuration, a nonzero reserved byte, and a clobbered argument each triggered the corresponding independent failure. The ordinary scalar control object and the missing-AMX-target rejection matched byte-for-byte. Native AMX arithmetic and hardware rejection of invalid dimensions were outside this execution.

## Reproduce

Use a verified non-9700X Linux x86-64 machine with Buster’s host ISA. The capture harness uses AVX-512F to poison the entire vector register before each prefix. The shell experiment uses Bash, GNU awk, GNU binutils, LLVM objdump and a C compiler. From an empty directory with these tools installed, run the following commands.

```sh
root=$PWD
git clone --no-checkout https://github.com/buster14a/buster.git buster
git -C buster fetch origin codex/amx-tilecfg-stores
git -C buster worktree add --detach "$root/amx-base" 3741c264fb349e86359acfd1c732ee1c2eaa4052
git -C buster worktree add --detach "$root/amx-head" e74f01262f1846a1b3af7a9bae1e842bc1875538
git clone --depth 1 https://github.com/buster14a/buster-performance.git records
proof="$root/records/docs/measurements/amx-tilecfg-3092-2026-11-19"
export PATH="$(cd "$root/amx-base" && bash tools/ci/session-toolchain.sh stage):$PATH"

for rev in base head; do
    (
        cd "$root/amx-$rev"
        if command -v cores >/dev/null; then
            cores -n 1 -- ./build.sh --config Debug --jobs 1
        else
            ./build.sh --config Debug --jobs 1
        fi
        BUSTER_COMPILER="$PWD/build/compiler" ./build/compiler test-checker --program-amx
    )
done

cd "$root/amx-head"
bash "$proof/reproduce.sh" "$root/amx-base/build/compiler" "$PWD/build/compiler" "$root/objects"
build/compiler -march=x86-64 -c "$proof/example.c" -o "$root/example.o"
llvm-objdump -dz --x86-asm-syntax=intel "$root/example.o"
readelf -wF "$root/example.o"
```

`base.tsv` and `head.tsv` contain the per-ID counts. `objects-and-captures.tar.gz` contains the 24 input files, complete emitted objects, disassembly, interpreted FDEs and captured images for both revisions. Within each `configs.bin`, the order is catalog ID, dimensions as listed above, then RSP residue 8, 24, 40, 56. The standalone `example.c` calls the ordinary AMX-TILE zero builtin with dynamic dimensions.

---
Agent session: 6aff6ba3-e798-8191-836b-ae4d3784f050 (OpenAI Codex session ID; no share URL is exposed)
Model: OpenAI / GPT-6 (Codex)
