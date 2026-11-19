# Fixed Huffman table reuse in the ELF debug inflater

[Buster issue 3040](https://github.com/buster14a/buster/issues/3040) · [Hosted comparison](https://github.com/buster14a/buster-performance/actions/runs/44603196552)

The compiler revisions are `6427879e1143026a12fb0388a20bdea1fe4b2bc5` and `4fcc52d74b68ac2b60f638deb43793d4bf559dac`. This measures the work of the foreign linker's zlib decoder. Each stream owns two decode tables. A stored block reads neither. A dynamic block builds its code-length alphabet in the literal table, then installs its own literal and distance alphabets. Head reuses fixed tables until that overwrite.

## Reproduce

Use a clean, disposable checkout of Buster at the base SHA on an ordinary Linux AVX-512 VM with the features checked by `tools/ci/vector-probe.c`. Install libz development headers and gzip. In that checkout, fetch zlib's source for the ELF input and select Buster's pinned hosted tools. Set `measurement_dir` to the directory containing this README. The script switches the disposable checkout to the exact head after measuring base.

```sh
git clone https://github.com/madler/zlib.git zlib
git -C zlib checkout --detach 51b7f2abdade71cd9bb0e7a373ef2610ec6f9daf
export BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=none BUSTER_SANITIZER_OPTIMIZATION=3
export BUSTER_DEBUG_INFO=0 BUSTER_LINKER=auto LC_ALL=C
export PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
bash "$measurement_dir/run.sh"
```

Both revisions use Clang 23.1.4, Release, and the same explicit vector target. `count.sh` instruments a temporary copy of the exact inflater and calls `inflate_zlib` from `probe.c`. It records every `inflate_build` call, byte cleared in the primary tables and code-length histograms, primary-table entry write, and byte initialized in the fixed code-length array. Clearing and filling the same entry count separately. These are byte counts at the source level. The uninstrumented compiler runs `test-inflate` and `link-foreign` separately.

## Results

Each arrow compares base with head on one GitHub-hosted Intel Xeon Platinum 8573C.

| Stream | Builds | Primary table bytes cleared | Primary table entry bytes written | Histogram bytes cleared | Fixed code-length bytes initialized |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1 fixed block | 2 → 2 | 16,384 → 16,384 | 15,872 → 15,872 | 64 → 64 | 318 → 318 |
| 16 fixed blocks | 32 → 2 | 262,144 → 16,384 | 253,952 → 15,872 | 1,024 → 64 | 5,088 → 318 |
| 256 fixed blocks | 512 → 2 | 4,194,304 → 16,384 | 4,063,232 → 15,872 | 16,384 → 64 | 81,408 → 318 |
| Fixed, stored, empty stored, fixed | 4 → 2 | 32,768 → 16,384 | 31,744 → 15,872 | 128 → 64 | 636 → 318 |
| Mixed fixture (five fixed, three stored, one dynamic) | 13 → 7 | 106,496 → 57,344 | 95,744 → 48,128 | 416 → 224 | 1,590 → 636 |
| Re-encoded ELF `.debug_info` (12 fixed, 11 empty stored) | 24 → 2 | 196,608 → 16,384 | 190,464 → 15,872 | 768 → 64 | 3,816 → 318 |

Blocks with the same fixed code use one pair of builds even across a stored block. In the mixed case the first pair is needed before the dynamic block, three builds belong to the dynamic block, and another pair is needed after it.

The two `InflateCode` objects occupy **17,608 bytes** on both revisions. A fixed pair clears 4,096 primary slots and fills 3,968 of them. It initializes 17,092 distinct bytes of the two objects, counting the primary arrays, histograms, alphabet tags, and the 288 literal/length and 30 distance entries in the canonical symbol arrays. The fixed-length buffer is 288 bytes and takes 318 bytes of writes because the distance lengths reuse its first 30 bytes.

Head adds one stream-local `bool` (`sizeof(bool) == 1`), a validity check at a fixed block, and an invalidation at a dynamic block. Clang's `-fstack-usage` on the uninstrumented wrapper around `inflate_zlib` reports **18,104 bytes** on both revisions. The table setup adds no heap allocation.

## Oracle and ELF inputs

The test streams include fixed literals and matches, stored blocks with and without data, and a dynamic block with no distance code. For the mixed stream the harness checks every byte prefix, every cut within DEFLATE with the original four-byte trailer restored, each single-bit change, the two neighboring output sizes, a bad checksum, and an extra data byte. libz 1.3.1 must agree on acceptance when it is required to consume the entire input and produce the exact output size. Bytes agree on success and the guard bytes around the output are checked on every call. Buster's detailed classifications are recorded separately for direct comparison between revisions.

All **482** comparisons on each revision passed. The complete classification records matched (SHA-256 `ced520ff5123422d1cbfe6ebecadf894dcdd833769ac0bbe20ab60e467da6246`). The valid/header/data/truncated/size/checksum counts were **22/16/272/72/26/74**. The uninstrumented `test-inflate` command passed **88,829** checks on base and **88,831** on head.

The ELF input is zlib 1.3.1's unmodified `adler32.c`, compiled with Clang at `-O2 -gdwarf-4` and compressed with `llvm-objcopy --compress-debug-sections=zlib`. Each section is also checked against the original uncompressed section bytes. The second encoding uses stock libz's `Z_FIXED` and `Z_SYNC_FLUSH` every 64 input bytes on that same `.debug_info`. The section's content, ELF symbol and relocation indices, and the other sections are preserved. This deliberately changes the block layout to exercise reuse in the normal linker.

The producer's six compressed debug sections contained four single dynamic blocks and two single fixed blocks. Both revisions made **16 builds** across those independent streams. The controlled encoding had **12 fixed blocks separated by 11 empty stored blocks** in the 725-byte `.debug_info`; that section went from **24 builds to 2**. The normal `link-foreign -static -e _start` command produced the same entire executable for both encodings on both revisions (SHA-256 `cec4cae44e4355f5e4c37b0d7b69cb7f912e5ba01685e9a2f73ca1fe949579b4`). It ran the expected Adler-32 calculation and passed `llvm-dwarfdump --verify`.

The [job transcript](results.log) contains the counts, exact source and input hashes, stack-usage output, test totals, executable digests and DWARF verification. The experiment collected no timing or hardware-counter samples.
