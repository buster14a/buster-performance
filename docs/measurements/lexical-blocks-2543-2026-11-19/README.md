# -g's lexical blocks only where a scope declares something (buster#2543), 2026-11-19

`check_debug_values_write` wrote a `DW_TAG_lexical_block`, with a range list in `.debug_rnglists` and a relocation in an
object, for every `{`, `for (` and condition of a body, whether or not the scope declares anything. The change
(`scripts/2543.patch`, on main `3741c264f`) writes one only for a block whose scope declares an object or a typedef of
its own, as LLVM does: `DwarfCompileUnit` drops a scope without children and puts the children of a scope that holds
only scopes in its parent. `check_debug_value_own_blocks` marks those blocks once per function before the writer's two
passes.

## The object (`-c -g` of the frozen corpus's `sqlite3.c`)

The same on the 9700X (`9700x/measure.log`) and in the cloud container (`cloud/census-*.txt`, with
`scripts/dwarf-census.sh`). The object's size differs by a few bytes between runs because of the output's name.

| | main | #2543 | clang 23.1.4 -O0 |
| --- | ---: | ---: | ---: |
| `DW_TAG_lexical_block` | 24,839 | 2,139 | 2,120 |
| `DW_TAG_variable`; `DW_TAG_formal_parameter` | 8,963; 10,567 | 8,963; 10,567 | |
| object, bytes | 4,408,720 | 3,532,160 | |
| `.debug_info`, bytes | 544,443 | 408,243 | |
| `.rela.debug_info`, bytes | 962,328 | 417,528 | |
| relocations of `.debug_info` | 40,097 | 17,397 | |
| `.debug_rnglists`, bytes | 226,119 | 30,557 | |
| `.debug_loclists`, bytes | 176,033 | 176,033 | |
| `llvm-dwarfdump --verify` | No errors | No errors | |
| "DW_CHILDREN_yes but DIE has no children" warnings | 10,278 | 41 | |

The 41 warnings left are 33 `DW_TAG_subprogram`s and 8 `DW_TAG_subroutine_type`s with no children; none is a block.

## The compile on the 9700X (`9700x/results.tsv`)

`scripts/build.sh` built main and main with the patch as Release `znver5` executables (`BUSTER_DEBUG_INFO=0`), each
build under its own hold of the lock. `scripts/measure.sh` then ran, under one hold, 11 rounds of base then new:
`-c -g --lanes 1 --time-stages` of `sqlite3.c`, on CPU 2, under `perf stat -e instructions:u,cycles:u`. The
machine was idle before and after (`9700x/measure.log`).

| median of 11 (min to max) | main | #2543 | change |
| --- | ---: | ---: | ---: |
| `debug` stage, ms | 26.879 (26.773 to 27.197) | 24.047 (23.960 to 24.248) | -10.54% |
| the stages, ms | 278.463 (277.637 to 282.347) | 272.682 (271.988 to 275.163) | -2.08% |
| user instructions | 1,594,815,693 | 1,546,593,953 | -3.02% (-48.2 M) |
| user cycles | 686,766,312 (683,533,758 to 693,301,306) | 671,216,859 (667,680,629 to 678,308,423) | -2.26% |

The new executable read below main in every round, in the `debug` stage and in cycles.

## Not measured

- The link's `debug` phase, which the issue saw at 2.05 ms of a 3.98 ms `link-foreign` of SQLite's shell's two `-g`
  objects: its input relocations of `.debug_info` fall by 57% here, but no link was timed.
- #2542 (the value DWARF built twice) is untouched.
