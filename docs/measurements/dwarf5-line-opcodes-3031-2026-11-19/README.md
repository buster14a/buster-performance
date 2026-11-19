# DWARF 5 special opcodes in ordinary C objects

On a GitHub-hosted AVX-512 Xeon Platinum 8573C, ordinary `-g -c` produced a smaller `.debug_line` for two Buster utilities. LLVM decoded identical file tables and ordered line matrices from both revisions, before and after linking. The programs' machine code was byte-identical.

| Object | Base bytes | Head bytes | Special opcodes | Line rows, including end sequences | Moved address relocations |
| --- | ---: | ---: | ---: | ---: | ---: |
| `tools/codegen/unreferenced.c` | 1,659 | 1,359 | 75 | 275 | 11 of 12 |
| `tools/ci/rerun.c` | 5,770 | 4,270 | 375 | 1,015 | 38 of 39 |
| Two-function producer fixture | 176 | 140 | 9 | 16 | 1 of 2 |

The compiler wrote one byte for each fitting row, saving four bytes per row. Each non-fitting row kept its advances. The real objects' `.text` sections measured 7,787 and 26,376 bytes. The complete objects from ordinary `-c` compared equal across revisions. Within each revision, the complete `--scalar -g -c` and default `-g -c` objects also compared equal. This record measures emitted debug metadata. Compilation time and hardware throughput were unmeasured.

## Independent readers and relocation

`llvm-dwarfdump --debug-line` supplied the file tables and complete matrix with file, address, line, column, ISA, discriminator, operation index, and flags. The comparison removed only each line table's section offset and encoded length. It retained row order, including rows with the same address. `llvm-dwarfdump --verify` passed all six objects and executables on each revision.

GNU readelf independently located every `DW_LNE_set_address` instruction. Each ELF relocation landed on its eight-byte operand and retained its type, symbol and addend. The second slot in `unreferenced.o` moved from `0xcd` to `0xad`, and the second slot in `rerun.o` from `0x85` to `0x7d`. The first slot in each object kept its position.

GNU ld linked each real object with a second ordinary C compilation unit that switches files and goes backwards in source lines. In the two executables the second CU's `DW_AT_stmt_list` moved from `0x67b` to `0x54f` and from `0x168a` to `0x10ae` respectively. These are the measured sizes of the preceding contributions. Both linked matrices and both linked `.text` sections compared equal across revisions.

The producer fixture supplies duplicate addresses directly to `DebugUnit`. Its 16 rows include five successive same-address pairs, five file switches, six decreases in line number, one prologue marker and two end sequences. After linking at `0x420000`, the first two rows still describe different lines and files at that address, and the second row carries `prologue_end`. The normal C frontend coalesces zero-length source events. The two real objects have zero same-address pairs within a sequence.

## Reproduction

Use a disposable Buster checkout and the repository's hosted vector toolchain. The run used Clang 23.1.4, Release, `BUSTER_HOST_ARCH=vector`, `BUSTER_DEBUG_INFO=0`, `BUSTER_SANITIZER=none`, and `BUSTER_SANITIZER_OPTIMIZATION=3`. Both compiler revisions were built in the same checkout and ran on the same VM. The input compilation used `build/compiler -g -c SOURCE -o OBJECT` with the default tier and pass settings.

```sh
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=c069387bc2f00da4dce7683c32db99196340bfd1
git fetch --no-tags origin "$base" "$head"
bash /path/to/this/record/compare.sh "$base" "$head" "$(mktemp -d)"
```

`compare.sh` runs `build/compiler test-debug --cross-check` on both revisions. The head passed 806 boundary batches covering all 243 special opcodes, 4,096 mixed batches, tail and guard-page checks, and GDB and perf on all eight consumer fixtures. The two-function case in `rows.c` calls the production writer. GNU as places those bytes in an ELF object and uses the producer's published address slots for relocations.

`result.txt` records test output, row counts, relocation examples and hashes from the paired job. `decoded-lines-and-fixups.zip` contains its original reader output. Its SHA-256 is `6597c92e3a7bb3f180b7d1f4d17546c9f9a92823c423e07f43cc075add631979`. [Baseline run](https://github.com/buster14a/buster/actions/runs/44601626051) · [Paired verification](https://github.com/buster14a/buster/actions/runs/44602553952) · [Issue 3031](https://github.com/buster14a/buster/issues/3031)
