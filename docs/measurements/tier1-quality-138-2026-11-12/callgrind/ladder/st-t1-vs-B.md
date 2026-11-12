Program code (the C library's left out): Tier 1 3078.7 M, clang -O2 2268.4 M, gap 810.3 M (1.36x)

| Cause | `--tier1`, M | clang -O2, M | Gap, M | Share of the gap | `--tier1`'s by origin, M |
| --- | ---: | ---: | ---: | ---: | --- |
| register moves | 383.5 | 199.6 | 183.9 | 22.7% | edge move 89.7, call sequence 143.9, node 149.9 |
| stack loads and stores | 443.8 | 178.8 | 265.1 | 32.7% | spill 23.8, reload 3.2, edge spill 61.3, edge reload 76.3, call save 88.5, call restore 101.9, call sequence 11.9, entry 6.3, node 69.7 |
| other loads and stores | 543.0 | 498.9 | 44.0 | 5.4% | call sequence 5.6, node 537.3 |
| address arithmetic (lea) | 242.4 | 88.2 | 154.2 | 19.0% | recomputed 44.5, node 197.9 |
| zero and sign extensions | 63.9 | 44.0 | 19.9 | 2.5% | call sequence 6.9, entry 2.0, node 55.1 |
| compares and branches | 679.5 | 576.6 | 102.9 | 12.7% | branch 379.8, node 299.4 |
| calls, returns and frames | 349.8 | 392.6 | -42.8 | -5.3% | call sequence 76.4, frame 204.5, node 68.9 |
| constants | 149.2 | 72.1 | 77.2 | 9.5% | recomputed 5.6, node 143.5 |
| arithmetic and the rest | 223.6 | 217.7 | 5.9 | 0.7% | node 223.6 |

| Type | `--tier1`, M | clang -O2, M | Gap, M |
| --- | ---: | ---: | ---: |
| move (moves) | 383.4 | 197.9 | 185.4 |
| self_move (moves) | 0.1 | 1.7 | -1.6 |
| store_stack (stack) | 213.3 | 69.1 | 144.2 |
| load_stack (stack) | 220.0 | 80.3 | 139.7 |
| cmp_stack (stack) | 9.7 | 23.3 | -13.6 |
| alu_load_stack (stack) | 0.8 | 3.7 | -3.0 |
| alu_rmw_stack (stack) | 0.0 | 2.0 | -2.0 |
| load (memory) | 344.4 | 296.8 | 47.6 |
| store (memory) | 110.2 | 97.9 | 12.3 |
| cmp_load (memory) | 83.3 | 79.1 | 4.2 |
| alu_load (memory) | 5.0 | 10.8 | -5.8 |
| alu_rmw (memory) | 0.0 | 13.6 | -13.6 |
| lea (address) | 182.2 | 78.9 | 103.2 |
| lea_stack (address) | 60.2 | 9.2 | 51.0 |
| extend (extend) | 63.9 | 44.0 | 19.9 |
| cmp (branch) | 241.3 | 197.0 | 44.3 |
| jcc (branch) | 289.8 | 293.5 | -3.8 |
| jmp (branch) | 90.1 | 49.1 | 41.1 |
| jmp_indirect (branch) | 12.6 | 12.9 | -0.2 |
| setcc (branch) | 35.4 | 15.2 | 20.1 |
| cmov (branch) | 10.3 | 8.9 | 1.4 |
| call (call) | 76.4 | 79.2 | -2.9 |
| ret (call) | 68.9 | 68.9 | 0.0 |
| push (call) | 54.7 | 111.9 | -57.2 |
| pop (call) | 54.7 | 103.4 | -48.7 |
| frame (call) | 95.2 | 29.2 | 66.0 |
| constant (constant) | 149.2 | 72.1 | 77.2 |
| alu (alu) | 219.6 | 205.4 | 14.1 |
| div (alu) | 2.1 | 2.1 | 0.0 |
| fp (alu) | 1.9 | 2.1 | -0.2 |
| nop (alu) | 0.0 | 8.0 | -8.0 |

| `--tier1`'s origin | M | Share of `--tier1`'s instructions |
| --- | ---: | ---: |
| spill | 23.8 | 0.8% |
| reload | 3.2 | 0.1% |
| edge spill | 61.3 | 2.0% |
| edge reload | 76.3 | 2.5% |
| call save | 88.5 | 2.9% |
| call restore | 101.9 | 3.3% |
| edge move | 89.7 | 2.9% |
| call sequence | 244.8 | 8.0% |
| entry | 8.3 | 0.3% |
| frame | 205.7 | 6.7% |
| recomputed | 50.1 | 1.6% |
| branch | 379.8 | 12.3% |
| node | 1745.3 | 56.7% |
| unattributed | 0.0 | 0.0% |

| `--tier1`'s unattributed instructions | Count | Why they have no tag |
| --- | ---: | --- |
| 0 PLT stubs | 0 | the linker's code |
| `sqlite3CompileOptions-0x100` | 48 | no tag line |

Dynamic calls into the program's own code: Tier 1 68.92 M, clang -O2 68.92 M; into its PLT stubs, the C library's calls: Tier 1 0.00 M, clang -O2 0.00 M

| Function | `--tier1`, M | clang -O2, M | Gap, M | calls, `--tier1` / -O2 | moves | stack | memory | address | extend | branch | call | `--tier1`: spills+reloads, call saves, edge moves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `sqlite3VdbeExec` | 555.6 | 364.9 | 190.8 | 0.08 M / 0.08 M | 54.2 | 67.6 | 1.9 | 51.0 | 3.7 | 15.1 | -0.4 | 98.0, 17.5, 35.8 |
| `substrFunc` | 97.5 | 56.6 | 40.9 | 0.13 M / 0.13 M | 10.3 | 1.6 | 0.0 | 4.4 | 0.0 | 15.0 | 0.0 | 0.0, 1.8, 5.0 |
| `yy_reduce` | 80.5 | 60.5 | 20.0 | 1.23 M / 1.23 M | 5.4 | 5.1 | 2.7 | 9.2 | 1.2 | -0.7 | -4.9 | 3.5, 0.7, 0.7 |
| `sqlite3Parser` | 78.7 | 53.5 | 25.3 | 0.70 M / 0.70 M | 6.8 | 16.5 | 5.3 | 2.6 | 0.5 | -2.5 | -2.8 | 0.0, 12.6, 0.0 |
| `sqlite3BtreeIndexMoveto` | 60.3 | 52.0 | 8.3 | 0.11 M / 0.11 M | 2.3 | 6.9 | 1.3 | -0.5 | -1.0 | -1.6 | 0.0 | 1.5, 9.1, 0.0 |
| `jsonTranslateTextToBlob` | 58.2 | 53.3 | 4.9 | 0.39 M / 0.39 M | 1.7 | -1.0 | 0.1 | 6.8 | 1.0 | -1.2 | -0.0 | 0.1, 1.0, 2.0 |
| `sqlite3_str_vappendf` | 49.0 | 33.8 | 15.1 | 0.13 M / 0.13 M | 4.7 | 5.0 | 0.0 | 1.8 | 0.7 | 1.9 | -0.2 | 7.1, 3.5, 4.0 |
| `yy_find_shift_action` | 45.4 | 51.0 | -5.6 | 1.93 M / 1.93 M | 9.2 | 0.0 | 0.0 | -2.1 | 1.0 | -2.2 | -11.5 | 0.0, 0.0, 1.4 |
| `sqlite3ColumnIndex` | 40.8 | 24.7 | 16.0 | 0.13 M / 0.13 M | 5.9 | 0.7 | 0.0 | 2.9 | 0.0 | 6.2 | 0.0 | 0.0, 0.7, 0.0 |
| `balance_nonroot` | 35.6 | 19.1 | 16.5 | 0.00 M / 0.00 M | 2.4 | 10.0 | 1.1 | 3.0 | -0.5 | 0.8 | -0.0 | 8.5, 0.9, 0.3 |
| `sqlite3RunParser` | 35.4 | 18.7 | 16.8 | 0.04 M / 0.04 M | 5.4 | 6.3 | 1.4 | 0.7 | 0.0 | 2.6 | 0.0 | 0.1, 3.5, 3.7 |
| `sqlite3GetToken` | 33.5 | 30.3 | 3.2 | 0.90 M / 0.90 M | -0.7 | 0.0 | 0.0 | 4.5 | 0.0 | -2.2 | 1.5 | 0.0, 0.0, 0.0 |
| `jsonTranslateBlobToText` | 30.7 | 23.2 | 7.4 | 0.30 M / 0.30 M | -0.3 | 5.5 | 0.2 | 0.7 | -0.0 | 1.2 | -0.8 | 0.0, 6.2, 0.4 |
| `sqlite3VdbeRecordCompareWithSkip` | 29.3 | 23.6 | 5.7 | 0.28 M / 0.28 M | 3.7 | 0.1 | 0.0 | 1.4 | 0.0 | -0.2 | -0.0 | 0.7, 2.0, 3.1 |
| `yy_shift` | 26.7 | 23.2 | 3.5 | 0.70 M / 0.70 M | 0.7 | -0.7 | 1.4 | 0.7 | 0.7 | 0.7 | -1.4 | 0.0, 0.0, 0.0 |
| `patternCompare` | 26.3 | 20.9 | 5.3 | 0.21 M / 0.21 M | 1.8 | 0.0 | 0.0 | 1.1 | 0.2 | 1.6 | -0.2 | 1.4, 1.0, 1.3 |
| `lookupName` | 24.0 | 15.2 | 8.8 | 0.09 M / 0.09 M | 0.3 | 3.1 | 0.2 | 0.9 | 0.1 | 2.5 | 0.0 | 4.8, 1.6, 1.3 |
| `sqlite3DbMallocRawNN` | 22.8 | 20.3 | 2.6 | 1.30 M / 1.30 M | 0.0 | 0.0 | 1.3 | 2.5 | 0.0 | -1.3 | 0.0 | 0.0, 0.0, 0.0 |
| `sqlite3BtreeTableMoveto` | 22.6 | 16.3 | 6.3 | 0.08 M / 0.08 M | 2.2 | 3.4 | 0.4 | -0.6 | 0.6 | -0.8 | -0.2 | 1.0, 3.2, 0.2 |
| `sqlite3Insert` | 21.8 | 13.2 | 8.7 | 0.02 M / 0.02 M | 0.8 | 5.4 | 0.0 | 0.5 | 0.1 | 1.3 | -0.3 | 4.3, 3.8, 0.7 |
| `sqlite3BtreeInsert` | 20.6 | 13.6 | 7.0 | 0.16 M / 0.16 M | 1.4 | 2.0 | 0.1 | 1.5 | -0.1 | 0.8 | -0.0 | 0.0, 2.2, 1.0 |
| `btreeParseCellPtr` | 20.4 | 16.6 | 3.8 | 0.51 M / 0.51 M | 0.5 | 3.1 | 0.5 | 1.4 | 0.0 | -0.3 | 0.0 | 0.0, 0.0, 0.6 |
| `memsys5FreeUnsafe` | 20.2 | 15.8 | 4.5 | 0.19 M / 0.19 M | 2.5 | 0.0 | 0.6 | 1.8 | 0.7 | -0.7 | 0.0 | 0.0, 0.0, 1.0 |
| `walChecksumBytes` | 19.8 | 12.5 | 7.2 | 0.02 M / 0.02 M | 0.0 | 0.5 | 0.0 | 7.0 | 0.0 | 0.2 | 0.0 | 0.5, 0.0, 0.1 |
| `sqlite3StrICmp` | 19.1 | 16.8 | 2.2 | 0.29 M / 0.29 M | 0.9 | 0.0 | 0.0 | 3.7 | 0.0 | 0.1 | 0.0 | 0.0, 0.0, 0.6 |

Calls clang -O2 doesn't make (a callee's calls by Tier 1 less its calls by clang, a count difference): 0.00 M. Their callees' instructions in Tier 1, each callee's scaled by the share of its calls clang doesn't make (an estimate from its average per call): 0.0 M

| Callee | `--tier1` calls, M | -O2 calls, M | `--tier1` instructions, M | per call | frame + call saves + entry, M | clang's inlining remarks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `speedtest1_randomFunc` | 0.00 | 0.00 | 0.0 | 9.0 | 0.0 | - |
| `sqlite3CompileOptions-0x100` | 0.00 | 0.00 | 0.0 | 48.0 | 0.0 | - |
| `sqlite3VdbeExec` | 0.08 | 0.08 | 555.6 | 7157.2 | 18.6 | - |
| `substrFunc` | 0.13 | 0.13 | 97.5 | 747.1 | 3.7 | - |
| `yy_reduce` | 1.23 | 1.23 | 80.5 | 65.6 | 15.4 | - |
| `sqlite3Parser` | 0.70 | 0.70 | 78.7 | 112.2 | 21.0 | - |
| `sqlite3BtreeIndexMoveto` | 0.11 | 0.11 | 60.3 | 548.1 | 10.7 | - |
| `jsonTranslateTextToBlob` | 0.39 | 0.39 | 58.2 | 150.8 | 6.4 | - |
| `sqlite3_str_vappendf` | 0.13 | 0.13 | 49.0 | 385.9 | 5.3 | - |
| `yy_find_shift_action` | 1.93 | 1.93 | 45.4 | 23.5 | 0.0 | - |
| `sqlite3ColumnIndex` | 0.13 | 0.13 | 40.8 | 314.2 | 2.0 | - |
| `balance_nonroot` | 0.00 | 0.00 | 35.6 | 14157.3 | 0.9 | - |
| `sqlite3RunParser` | 0.04 | 0.04 | 35.4 | 865.1 | 4.1 | - |
| `sqlite3GetToken` | 0.90 | 0.90 | 33.5 | 37.3 | 1.8 | - |
| `jsonTranslateBlobToText` | 0.30 | 0.30 | 30.7 | 103.2 | 9.8 | - |
