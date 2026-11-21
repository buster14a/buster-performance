# Debug information for integer returns admitted by the reader window

[PR #3219](https://github.com/buster14a/buster/pull/3219) lets integer constant returns use the window under debug. A folded return attaches the emitted constant to the return keyword. Every comparison in this record runs the same executable with its window option off and on.

| Source | Checks | Result |
| --- | --- | --- |
| [Integer-return predecessor](347c86ef0/) | 30 DWARF objects, 1,371 corpus objects, 90,000 generated programs, 8,009 historical probes | All agreed. The separate warning-policy sweep found three object differences in one weak-alias fixture. |
| [Local reads with debug fallback](294512f5a/) | DWARF and corpus objects, generated programs and probes | All agreed. Local reads take their ordinary path with debug. |
| [Current debug and weak-alias patches together](combined/) | 210,491 checker assertions, 4,082 debug checks, 30 DWARF objects, 3,774 warning-policy pairs and 1,371 corpus objects | All passed. Of the 3,774 pairs, 1,218 produced objects and 2,556 returned the same diagnostics and failure status. |

The first wider warning sweep compared 41,640 inline inputs across the three policies. All matched, including one identical signal. On tracked sources the 3,690 matching pairs and the three differences are recorded under the predecessor. Repeating the ordinary compiler alone reproduced the varying weak symbol names. [PR #3225](https://github.com/buster14a/buster/pull/3225) repairs the lifetime of those names. [Independent ELF symbol, debug and executable qualification](../weak-alias-debug-3225-2026-11-21/).

The combined build merged [debug head ae81ba107](https://github.com/buster14a/buster/commit/ae81ba107adf8bd0c5d3c8a9c03fdd8a839da9a4) with [weak-alias head 6deb2dcc9](https://github.com/buster14a/buster/commit/6deb2dcc9412f11c6c8b6c8e30d93095e71469e1) without conflicts. The resulting tree is `87f7f804c2dd9f4dc20f1261170dc7e281934826`. The 30 final DWARF comparisons observed 240 admissions, passed whole-object equality and passed LLVM's DWARF verifier. The corpus contains one SQLite, 34 Lua and 1,336 musl translation units. The combined record includes the executable digest and the per-input hashes.

## Reproduction

Build the desired Buster tree with its pinned Clang and generate its native predefines. Use the same absolute source and output paths for both compiles of each pair. Export the absolute build checkout as `WINDOW_TEST_TREE` and a new output directory as `WINDOW_TEST_RESULTS`. Run `python3 scripts/dwarf-matrix.py` with the matching `llvm-dwarfdump` on PATH. Run the source checker and debug tests with `build/compiler test-checker --part 5/8 --seed 133` and `build/compiler test-check-debug --cross-check`.

`scripts/fixture-sweep.py TREE OUT files` reads tracked sources from Git. Its `inline` mode reads extracted sources from `TREE/../gates/inline`. The generated and historical-probe comparison takes the compiler path, the [original generator](../summary-facts-2850-2026-11-21/fuzz/fuzz.py) and an output directory. For the corpus runner, set `src_root` to the directory with the three extracted source trees, `cc` to the compiler and `debug_log` to an empty output directory. From the source directory, source `scripts/corpus-arguments.sh` and pass each expanded corpus argument list to `scripts/corpus-objects.py`, preceded by the corpus name.

The generated campaign launches actual `-g -c` processes. The per-seed output records the status, diagnostic and object comparison for each sample and the number of sampled files that exercised a return summary. The pinned generator's sibling measurement directories supply the 26 historical probe lists. The corpus argument script expects SQLite under `sqlite`, Lua under `inputs/lua-5.4.8`, and the musl sources and generated headers under `libc/musl` and `musl-generated`.
