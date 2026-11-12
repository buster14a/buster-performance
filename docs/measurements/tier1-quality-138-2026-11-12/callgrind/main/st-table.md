Program code (the C library's left out): Tier 1 3078.7 M, clang -O2 1918.4 M, gap 1160.3 M (1.60x)

| Cause | `--tier1`, M | clang -O2, M | Gap, M | Share of the gap | `--tier1`'s by origin, M |
| --- | ---: | ---: | ---: | ---: | --- |
| register moves | 383.5 | 167.7 | 215.8 | 18.6% | edge move 89.7, call sequence 143.9, node 149.9 |
| stack loads and stores | 443.8 | 170.5 | 273.4 | 23.6% | spill 23.8, reload 3.2, edge spill 61.3, edge reload 76.3, call save 88.5, call restore 101.9, call sequence 11.9, entry 6.3, node 69.7 |
| other loads and stores | 543.0 | 441.2 | 101.8 | 8.8% | call sequence 5.6, node 537.3 |
| address arithmetic (lea) | 242.4 | 95.6 | 146.7 | 12.6% | recomputed 44.5, node 197.9 |
| zero and sign extensions | 63.9 | 33.1 | 30.9 | 2.7% | call sequence 6.9, entry 2.0, node 55.1 |
| compares and branches | 679.5 | 527.0 | 152.4 | 13.1% | branch 379.8, node 299.4 |
| calls, returns and frames | 349.8 | 218.0 | 131.8 | 11.4% | call sequence 76.4, frame 204.5, node 68.9 |
| constants | 149.2 | 47.5 | 101.7 | 8.8% | recomputed 5.6, node 143.5 |
| arithmetic and the rest | 223.6 | 217.9 | 5.8 | 0.5% | node 223.6 |

| Type | `--tier1`, M | clang -O2, M | Gap, M |
| --- | ---: | ---: | ---: |
| move (moves) | 383.4 | 166.7 | 216.6 |
| self_move (moves) | 0.1 | 1.0 | -0.8 |
| store_stack (stack) | 213.3 | 73.8 | 139.5 |
| load_stack (stack) | 220.0 | 80.7 | 139.3 |
| cmp_stack (stack) | 9.7 | 13.1 | -3.4 |
| alu_load_stack (stack) | 0.8 | 2.6 | -1.9 |
| load (memory) | 344.4 | 253.4 | 91.1 |
| store (memory) | 110.2 | 91.9 | 18.3 |
| cmp_load (memory) | 83.3 | 70.4 | 12.9 |
| alu_load (memory) | 5.0 | 15.4 | -10.4 |
| alu_rmw (memory) | 0.0 | 9.7 | -9.7 |
| lea (address) | 182.2 | 88.8 | 93.3 |
| lea_stack (address) | 60.2 | 6.8 | 53.4 |
| extend (extend) | 63.9 | 33.1 | 30.9 |
| cmp (branch) | 241.3 | 178.3 | 62.9 |
| jcc (branch) | 289.8 | 264.3 | 25.5 |
| jmp (branch) | 90.1 | 54.3 | 35.8 |
| jmp_indirect (branch) | 12.6 | 13.7 | -1.1 |
| setcc (branch) | 35.4 | 7.0 | 28.3 |
| cmov (branch) | 10.3 | 9.4 | 0.9 |
| call (call) | 76.4 | 33.5 | 42.8 |
| ret (call) | 68.9 | 23.4 | 45.5 |
| push (call) | 54.7 | 73.8 | -19.2 |
| pop (call) | 54.7 | 68.4 | -13.7 |
| frame (call) | 95.2 | 18.8 | 76.4 |
| constant (constant) | 149.2 | 47.5 | 101.7 |
| alu (alu) | 219.6 | 203.1 | 16.4 |
| div (alu) | 2.1 | 2.0 | 0.1 |
| fp (alu) | 1.9 | 4.4 | -2.4 |
| nop (alu) | 0.0 | 7.9 | -7.9 |

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

Dynamic calls into the program's own code: Tier 1 68.92 M, clang -O2 25.62 M; into its PLT stubs, the C library's calls: Tier 1 0.00 M, clang -O2 0.00 M

| Function | `--tier1`, M | clang -O2, M | Gap, M | calls, `--tier1` / -O2 | moves | stack | memory | address | extend | branch | call | `--tier1`: spills+reloads, call saves, edge moves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `sqlite3VdbeExec` | 555.6 | 398.6 | 157.1 | 0.08 M / 0.08 M | 39.5 | 55.6 | -0.4 | 46.5 | 1.1 | 14.5 | 4.0 | 98.0, 17.5, 35.8 |
| `substrFunc` | 97.5 | 48.4 | 49.1 | 0.13 M / 0.13 M | 10.1 | 1.6 | 3.7 | 4.6 | -0.1 | 19.3 | 0.8 | 0.0, 1.8, 5.0 |
| `yy_reduce` | 80.5 | 60.4 | 20.2 | 1.23 M / 1.23 M | 6.7 | 7.7 | 0.3 | 5.5 | 1.2 | -0.8 | -3.7 | 3.5, 0.7, 0.7 |
| `sqlite3Parser` | 78.7 | 0.0 | 78.7 | 0.70 M / 0.00 M | 16.0 | 23.2 | 9.4 | 3.3 | 5.8 | 8.3 | 11.6 | 0.0, 12.6, 0.0 |
| `sqlite3BtreeIndexMoveto` | 60.3 | 44.2 | 16.1 | 0.11 M / 0.11 M | 6.0 | 7.9 | -0.1 | 0.3 | -0.1 | 1.5 | 0.3 | 1.5, 9.1, 0.0 |
| `jsonTranslateTextToBlob` | 58.2 | 57.1 | 1.2 | 0.39 M / 0.39 M | 3.1 | -1.0 | -1.7 | 5.3 | 1.4 | -1.1 | -0.3 | 0.1, 1.0, 2.0 |
| `sqlite3_str_vappendf` | 49.0 | 45.2 | 3.8 | 0.13 M / 0.13 M | 3.1 | 5.4 | -3.4 | 1.0 | 0.6 | 0.2 | -0.3 | 7.1, 3.5, 4.0 |
| `yy_find_shift_action` | 45.4 | 0.0 | 45.4 | 1.93 M / 0.00 M | 11.8 | 0.0 | 5.8 | 6.5 | 4.6 | 11.8 | 1.9 | 0.0, 0.0, 1.4 |
| `sqlite3ColumnIndex` | 40.8 | 0.0 | 40.8 | 0.13 M / 0.00 M | 6.9 | 0.7 | 3.6 | 2.9 | 0.1 | 18.4 | 1.7 | 0.0, 0.7, 0.0 |
| `balance_nonroot` | 35.6 | 0.0 | 35.6 | 0.00 M / 0.00 M | 2.7 | 14.7 | 3.5 | 3.3 | 0.9 | 4.6 | 0.3 | 8.5, 0.9, 0.3 |
| `sqlite3RunParser` | 35.4 | 89.2 | -53.8 | 0.04 M / 0.04 M | 1.0 | -7.7 | -9.1 | -8.2 | -5.3 | -21.1 | -0.4 | 0.1, 3.5, 3.7 |
| `sqlite3GetToken` | 33.5 | 28.2 | 5.2 | 0.90 M / 0.90 M | -1.1 | 0.0 | 0.5 | 4.5 | -0.0 | 2.4 | 0.0 | 0.0, 0.0, 0.0 |
| `jsonTranslateBlobToText` | 30.7 | 26.0 | 4.6 | 0.30 M / 0.30 M | -0.3 | 5.6 | -1.9 | 0.1 | -0.0 | 0.5 | -0.4 | 0.0, 6.2, 0.4 |
| `sqlite3VdbeRecordCompareWithSkip` | 29.3 | 26.4 | 2.9 | 0.28 M / 0.28 M | 1.7 | 3.4 | -1.3 | 1.1 | 0.1 | -0.8 | 0.3 | 0.7, 2.0, 3.1 |
| `yy_shift` | 26.7 | 0.0 | 26.7 | 0.70 M / 0.00 M | 2.1 | 4.2 | 7.0 | 1.4 | 1.4 | 3.5 | 4.9 | 0.0, 0.0, 0.0 |
| `patternCompare` | 26.3 | 19.1 | 7.2 | 0.21 M / 0.21 M | 0.4 | 3.1 | 0.5 | 2.0 | 0.2 | 1.5 | -0.2 | 1.4, 1.0, 1.3 |
| `lookupName` | 24.0 | 0.0 | 24.0 | 0.09 M / 0.00 M | 1.9 | 6.5 | 2.5 | 1.0 | 0.1 | 7.6 | 1.5 | 4.8, 1.6, 1.3 |
| `sqlite3DbMallocRawNN` | 22.8 | 15.8 | 7.1 | 1.30 M / 1.25 M | 0.0 | 0.0 | 1.5 | 2.5 | 0.0 | 0.1 | 2.9 | 0.0, 0.0, 0.0 |
| `sqlite3BtreeTableMoveto` | 22.6 | 15.1 | 7.5 | 0.08 M / 0.08 M | 1.5 | 2.8 | 1.5 | -0.1 | 1.0 | 0.1 | -0.1 | 1.0, 3.2, 0.2 |
| `sqlite3Insert` | 21.8 | 33.0 | -11.1 | 0.02 M / 0.02 M | 0.1 | 4.1 | -5.0 | 0.4 | -0.6 | -6.4 | -0.1 | 4.3, 3.8, 0.7 |
| `sqlite3BtreeInsert` | 20.6 | 31.8 | -11.2 | 0.16 M / 0.16 M | -0.3 | -0.9 | -4.7 | 0.8 | -1.1 | -2.7 | -0.9 | 0.0, 2.2, 1.0 |
| `btreeParseCellPtr` | 20.4 | 15.3 | 5.2 | 0.51 M / 0.51 M | 0.5 | 3.1 | 0.5 | 1.4 | 1.0 | -0.9 | 1.0 | 0.0, 0.0, 0.6 |
| `memsys5FreeUnsafe` | 20.2 | 0.0 | 20.2 | 0.19 M / 0.00 M | 4.9 | 0.0 | 3.6 | 2.4 | 1.3 | 2.6 | 2.4 | 0.0, 0.0, 1.0 |
| `walChecksumBytes` | 19.8 | 8.1 | 11.7 | 0.02 M / 0.00 M | 0.1 | 0.5 | 0.1 | 7.0 | 0.0 | 0.5 | 0.0 | 0.5, 0.0, 0.1 |
| `sqlite3StrICmp` | 19.1 | 0.0 | 19.1 | 0.29 M / 0.00 M | 0.9 | 0.0 | 4.6 | 4.0 | 0.0 | 9.3 | 0.3 | 0.0, 0.0, 0.6 |

Calls clang -O2 doesn't make (a callee's calls by Tier 1 less its calls by clang, a count difference): 43.30 M. Their callees' instructions in Tier 1, each callee's scaled by the share of its calls clang doesn't make (an estimate from its average per call): 978.6 M

| Callee | `--tier1` calls, M | -O2 calls, M | `--tier1` instructions, M | per call | frame + call saves + entry, M | clang's inlining remarks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `yy_find_shift_action` | 1.93 | 0.00 | 45.4 | 23.5 | 0.0 | - |
| `sqlite3BtreeCursorHasMoved` | 1.44 | 0.00 | 8.6 | 6.0 | 0.0 | - |
| `yy_find_reduce_action` | 1.23 | 0.00 | 9.8 | 8.0 | 0.0 | - |
| `sqlite3DbNNFreeNN` | 1.17 | 0.02 | 12.3 | 10.5 | 2.3 | - |
| `sqlite3VdbeOneByteSerialTypeLen` | 1.06 | 0.00 | 4.2 | 4.0 | 0.0 | - |
| `sqlite3Parser` | 0.70 | 0.00 | 78.7 | 112.2 | 21.0 | - |
| `yy_shift` | 0.70 | 0.00 | 26.7 | 38.0 | 5.6 | - |
| `sqlite3VdbeAddOp3` | 0.64 | 0.02 | 13.5 | 21.0 | 1.3 | - |
| `sqlite3AddInt64` | 0.61 | 0.00 | 10.4 | 17.0 | 0.0 | - |
| `btreeParseCell` | 0.61 | 0.00 | 13.3 | 22.0 | 1.2 | - |
| `sqlite3BtreePayloadSize` | 0.58 | 0.00 | 4.0 | 7.0 | 2.3 | - |
| `fetchPayload` | 0.58 | 0.00 | 5.2 | 9.0 | 0.0 | - |
| `sqlite3BtreePayloadFetch` | 0.58 | 0.00 | 2.3 | 4.0 | 1.2 | - |
| `sqlite3Get4byte` | 0.50 | 0.00 | 5.5 | 11.0 | 0.0 | - |
| `sqlite3ValueText` | 0.42 | 0.00 | 8.0 | 19.0 | 0.8 | - |
