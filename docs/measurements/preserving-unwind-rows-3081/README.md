# Preserving-function unwind rows

Buster [#3081](https://github.com/buster14a/buster/issues/3081) and [PR #3098](https://github.com/buster14a/buster/pull/3098). Base `3741c264fb349e86359acfd1c732ee1c2eaa4052`, head `adcac4b9173b020927894b12443c659bfa458cc5`. Both builds used Linux x86-64, a Ryzen 9 7940HS, native Debug and the pinned Clang 23.1.4. GNU binutils 2.47 decoded the objects. These measurements count work in the preserving-row adapter.

## Ordinary compilation

```c
__attribute__((no_caller_saved_registers)) void keep(volatile long *p) { *p += 1; }
```

```sh
./build/compiler --verify -c -march=x86-64-v4 keep.c -o keep.o
readelf --debug-dump=frames-interp keep.o
```

The normal driver sent 5 fixed rows to the adapter. It returned the same 152 rows on both revisions. Existing-row movement fell from 4,365 to 5, saving 69,760 bytes of logical row copies. Both builders wrote 147 new rows. Enumeration visited 16 GP and 1,024 vector mask positions on base, and 9 GP and 32 vector set bits on head. Each mask register has a known ordinal.

The six functions in `frames.c` exercise an ordinary function, `preserve_most`, `preserve_all`, `no_caller_saved_registers` and both interrupt signatures. `--verify -c` produced byte-identical whole objects and GNU readelf states. Each object contains six FDEs. The fourth control, `-fno-asynchronous-unwind-tables` on x86-64-v4, produced identical objects with the section absent.

| Target | .eh_frame bytes on both | SHA-256 |
| --- | ---: | --- |
| x86-64 | 1,072 | `c83c8f5ff0ef5c2ac63f0658d5cf99422c7f6c8c8c43c9aababc1bf1f6fb017f` |
| x86-64-v3 | 1,072 | `007d9aef8627187418577139faf4f4d28a6c0b75fd8966d31236a77b1739198e` |
| x86-64-v4 | 1,808 | `d8b8e69b9099328751508903233e32c95ad0b584788e639cde43e7db2d75d025` |

## Paired fixture results

The 112 comparisons cover 80 ordinary frames and 32 interrupt frames. The fixtures vary general and vector masks, vector save widths, K-register save widths, frame sizes, alignment and stack probes. The format encodes the K registers as a group of eight. The cases include the group alone, the group alongside vector saves, and the group absent. The sparse golden frame also fixes the order of entry rules, RBP's tied push and pop rules, and XMM15, XMM16 and XMM31.

The complete 7,926 record-boundary rows matched byte for byte, including their reserved byte. After resolving instruction offsets, the 112 CIE/FDE contributions matched across all 29,352 bytes. Wrapping each contribution in its own ELF section gave identical GNU readelf state tables, covering 5,470 state rows including the CIEs.

| Selected registers (GP/V/K) | Existing-row moves, base → head | GP bit visits, base → head | Vector bit visits, base → head | New row writes, both |
| --- | ---: | ---: | ---: | ---: |
| 0/0/0 | 0 → 0 | 0 → 0 | 0 → 0 | 0 |
| 1/3/0 | 57 → 5 | 16 → 1 | 96 → 3 | 12 |
| 0/0/8 | 156 → 5 | 16 → 0 | 0 → 0 | 24 |
| 8/0/0 | 184 → 5 | 16 → 8 | 0 → 0 | 24 |
| 8/16/0 | 1,200 → 5 | 16 → 8 | 512 → 16 | 72 |
| 9/32/8 | 4,365 → 5 | 16 → 9 | 1,024 → 32 | 147 |

The table uses the small, naturally aligned, unprobed fixture in each group. The two dense interrupt variants both have the last row's work. The later error-code adjustment produces 154 final rows in that variant. `work.tsv` contains all 224 observations.

`moved` counts an existing 16-byte row shifted by one insertion on base, or a row copied by either of the two `memmove` calls on head. `gp_visits` and `vector_visits` count loop-body positions examined by base and set bits extracted by head. The counters cover only the preserving builder. The interrupt adjustment, FDE writer and instruction selector execute their regular paths.

| Concatenated fixture outputs, ascending case ID | SHA-256 on both |
| --- | --- |
| Complete rows | `9944f06d59c5be093325e977022042f9fc0f338881d426124b64de3db0c7ea16` |
| CIE/FDE bytes | `a074b267071ffde1d3462e7317b417bee405bb3ecd03ce383a3517c8c30e0c48` |
| GNU readelf 2.47 state tables | `77c44b77eace38c9cdbc01433aabe0d04a713bdcb50f305597efbcdb4a8f0100` |

## Reproduction

From a Buster checkout, with this evidence repository cloned beside it, run the following on a qualifying Linux host other than the 9700X.

```sh
bash ../buster-performance/docs/measurements/preserving-unwind-rows-3081/reproduce.sh "$PWD" "$(mktemp -d)"
```

The script builds and tests both named revisions, compiles the C controls and runs the C probe in a disposable head worktree. It uses the real builders with counters at their row copies and bit visits. Each fixture supplies one validated fixed descriptor and one instruction layout to both builders. The probe poisons the two row arrays differently, compares every emitted event with the actual adapter, and writes both row arrays and both resolved FDEs. The script compares all three outputs independently and retains them in the output directory. `BUSTER_ROW_CORE_RUNNER` can name a one-core launcher on machines using a shared core allocation.

On the clean trees, `test-emitted-code` passed 55,838 checks on base and 57,767 on head. `test-emission-metadata` and `test-unwind` also passed on both. The hosted inventory additionally runs `./build/compiler test-emitted-code --cross-check`, including GDB's native unwind check. The local sandbox denied GDB's request to trace its child.
