# Executable `.eh_frame_hdr` sort scratch

On a static link of Buster’s `dco` utility and the hosted system’s glibc, the writer sorted 1,148 disordered FDEs. Its peak live sort arena fell from 18,369 to 9,185 bytes. Both measurements include one alignment byte. The two staging copies accounted for 18,368 bytes on base. Head eliminates them. Both versions scatter 36,736 bytes in the four radix passes.

| Input | FDEs | Sort arena bytes, base → head | Staging copy bytes, base → head | Radix bytes written, each |
| --- | ---: | ---: | ---: | ---: |
| CIE only | 0 | 0 → 0 | 0 → 0 | 0 |
| One row | 1 | 0 → 0 | 0 → 0 | 0 |
| Reversed | 2 | 32 → 16 | 32 → 0 | 64 |
| Reversed | 17 | 272 → 136 | 272 → 0 | 544 |
| Reversed | 257 | 4,112 → 2,056 | 4,112 → 0 | 8,224 |
| Static `dco` | 1,148 | 18,369 → 9,185 | 18,368 → 0 | 36,736 |
| Reversed | 5,000 | 80,000 → 40,000 | 80,000 → 0 | 160,000 |

`instrument.sh` records arena length at entry and exit. The single scratch allocation stays live to return, so the difference is the peak additional live arena space for the call. The fixed 257 × 8-byte histogram is common to both sorts. Copy counters count payload bytes once per copy at the two staging sites and at the scatter site. The sorted normal path allocated and copied zero bytes at every tested size. These are linker work counts. All observations came from hosted correctness runs.

## Output and consumers

All 20 complete ELF files, their `.eh_frame_hdr` sections, and their GNU `readelf --debug-dump=frames` decodes compared byte for byte. The real `dco` header is 9,196 bytes with SHA-256 `7010020f81a5fdb290ee6d4d1e00dda87664c612768cf9b3b45516e4ae9df4a9`. `verify.c` checks the header encoding, the pointer to `.eh_frame`, the count and every signed pair against GNU readelf’s FDE addresses. Equal starts must retain the FDEs’ original address order. `llvm-readobj --unwind` supplies the LLVM decode.

The disordered seven-FDE runtime image compared `_Unwind_Find_FDE` with the header at the first two instruction bytes of three functions. All six lookups found the exact FDE and function base. `_Unwind_Backtrace` walked seven frames on each version. The static `dco` ran its `status` command on each version.

Both revisions passed `test-executable`, `test-unwind --cross-check`, `test-dynamic --cross-check`, `test-static --cross-check`, `test-foreign --cross-check` and `test-check-debug --cross-check`. The head suites ran after restoring the production writer and rebuilding without counters. The private unwind-sort fixture made 6,820 checks on head, including one-byte-short arenas, exact-fit arenas, signed extremes, stability and normal sorted tables with zero capacity.

## Reproduction

Base was `6427879e1143026a12fb0388a20bdea1fe4b2bc5` and head was `0c27d6f47e79d34ea255505f89785241ea898f8f`. The baseline was established through the normal `--lanes 1 -static dco.o` driver entry in a separate hosted run. The paired run used one GitHub-hosted Ubuntu 26.04 VM with an Intel Xeon Platinum 8370C, the repository’s pinned Clang 23.1.4, GNU binutils 2.46 and identical linker inputs for both builds. The objects and complete images are identified in `results.txt`. [Baseline](https://github.com/buster14a/buster/actions/runs/44601745922/job/135835310743) · [Paired run](https://github.com/buster14a/buster/actions/runs/44603681379/job/135841566771) · [Exact job and tool setup](https://github.com/buster14a/buster/blob/a2990fea84fc5ef8e43e63504594d9e074482556/.github/workflows/3039-hosted-proof.yml)

Run the following with this directory in `evidence`, on an ordinary AVX-512 Linux VM with the paired run’s tools. Use a fresh checkout so that restoring the instrumented writer is local to the reproduction.

```bash
evidence=$(pwd -P)
work=$(mktemp -d)
git clone https://github.com/buster14a/buster.git "$work/buster"
cd "$work/buster"
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=0c27d6f47e79d34ea255505f89785241ea898f8f
export BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=none BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_DEBUG_INFO=0
git switch --detach "$base"
bash "$evidence/measure.sh" prepare "$work/objects"
for role in base head; do
    git switch --detach "${!role}"
    bash "$evidence/instrument.sh"
    ./build.sh --config Release
    bash "$evidence/measure.sh" link "$work/objects" ./build/compiler "$work/$role"
    if [[ $role == base ]]; then
        bash "$evidence/measure.sh" test "$work/objects" ./build/compiler "$work/base-tests"
    fi
    git restore src/buster/compiler/executable_impl.c
done
./build.sh --config Release
bash "$evidence/measure.sh" test "$work/objects" ./build/compiler "$work/head-tests"
for hdr in "$work/base"/*.hdr; do
    name=${hdr##*/}; name=${name%.hdr}
    cmp "$work/base/$name" "$work/head/$name"
    cmp "$work/base/$name.hdr" "$work/head/$name.hdr"
    cmp "$work/base/$name.frames" "$work/head/$name.frames"
done
```

Original first-party fixtures and instrumentation use Apache-2.0 WITH LLVM-exception. `tools/dco/dco.c` comes from the pinned compiler revision. The static C runtime and libgcc were supplied by the hosted image.
