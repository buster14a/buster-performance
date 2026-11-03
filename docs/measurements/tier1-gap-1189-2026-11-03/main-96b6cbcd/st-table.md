Program code (the C library's left out): Tier 1 3743.8 M, clang -O2 1887.5 M, gap 1856.3 M (1.98x)

| Cause | `--tier1`, M | clang -O2, M | Gap, M | Share of the gap | `--tier1`'s by origin, M |
| --- | ---: | ---: | ---: | ---: | --- |
| register moves | 503.6 | 155.2 | 348.3 | 18.8% | edge move 130.1, call sequence 220.7, node 151.2, unattributed 1.5 |
| stack loads and stores | 592.1 | 175.2 | 416.9 | 22.5% | spill 25.8, reload 5.5, edge spill 141.8, edge reload 155.3, call save 118.5, call restore 118.5, call sequence 5.6, entry 6.3, node 6.3, unattributed 7.7 |
| other loads and stores | 648.9 | 424.4 | 224.5 | 12.1% | node 646.7, unattributed 2.2 |
| address arithmetic (lea) | 370.5 | 95.8 | 274.7 | 14.8% | recomputed 75.4, node 294.6 |
| zero and sign extensions | 200.4 | 33.1 | 167.3 | 9.0% | call sequence 6.9, node 193.6 |
| compares and branches | 796.0 | 521.3 | 274.7 | 14.8% | branch 421.6, node 365.9, unattributed 8.2 |
| calls, returns and frames | 354.6 | 217.1 | 137.5 | 7.4% | call sequence 77.7, frame 206.2, node 68.8, unattributed 1.9 |
| constants | 107.2 | 47.5 | 59.7 | 3.2% | recomputed 3.6, node 102.7 |
| arithmetic and the rest | 170.5 | 217.8 | -47.2 | -2.5% | node 169.2, unattributed 1.3 |

| Type | `--tier1`, M | clang -O2, M | Gap, M |
| --- | ---: | ---: | ---: |
| move (moves) | 387.0 | 154.3 | 232.8 |
| self_move (moves) | 116.6 | 1.0 | 115.6 |
| store_stack (stack) | 302.2 | 70.0 | 232.2 |
| load_stack (stack) | 288.9 | 91.9 | 197.0 |
| cmp_stack (stack) | 0.0 | 9.8 | -9.8 |
| alu_load_stack (stack) | 0.5 | 3.2 | -2.7 |
| load (memory) | 486.7 | 242.1 | 244.6 |
| store (memory) | 155.5 | 89.6 | 65.9 |
| cmp_load (memory) | 0.0 | 67.8 | -67.8 |
| alu_load (memory) | 6.5 | 14.9 | -8.3 |
| alu_rmw (memory) | 0.0 | 9.6 | -9.6 |
| lea (address) | 262.1 | 87.6 | 174.5 |
| lea_stack (address) | 108.4 | 8.2 | 100.2 |
| extend (extend) | 200.4 | 33.1 | 167.3 |
| cmp (branch) | 326.3 | 178.3 | 147.9 |
| jcc (branch) | 299.7 | 258.3 | 41.4 |
| jmp (branch) | 122.0 | 54.5 | 67.5 |
| jmp_indirect (branch) | 20.0 | 13.7 | 6.3 |
| setcc (branch) | 27.4 | 7.0 | 20.4 |
| cmov (branch) | 0.6 | 9.4 | -8.8 |
| call (call) | 77.7 | 33.5 | 44.2 |
| ret (call) | 70.3 | 23.4 | 46.9 |
| push (call) | 54.8 | 73.9 | -19.1 |
| pop (call) | 54.8 | 68.1 | -13.2 |
| frame (call) | 96.9 | 18.2 | 78.7 |
| constant (constant) | 107.2 | 47.5 | 59.7 |
| alu (alu) | 166.4 | 203.1 | -36.7 |
| div (alu) | 2.1 | 2.0 | 0.1 |
| fp (alu) | 1.9 | 4.4 | -2.5 |
| nop (alu) | 0.0 | 7.9 | -7.9 |

| `--tier1`'s origin | M | Share of `--tier1`'s instructions |
| --- | ---: | ---: |
| spill | 25.8 | 0.7% |
| reload | 5.5 | 0.1% |
| edge spill | 141.8 | 3.8% |
| edge reload | 155.3 | 4.1% |
| call save | 118.5 | 3.2% |
| call restore | 118.5 | 3.2% |
| edge move | 130.1 | 3.5% |
| call sequence | 311.1 | 8.3% |
| entry | 6.3 | 0.2% |
| frame | 207.4 | 5.5% |
| recomputed | 79.0 | 2.1% |
| branch | 421.6 | 11.3% |
| node | 1999.0 | 53.4% |
| unattributed | 24.0 | 0.6% |

| `--tier1`'s unattributed instructions | Count | Why they have no tag |
| --- | ---: | --- |
| 32 PLT stubs | 7326526 | the linker's code |
| `sqlite3Multiply160` | 7968674 | no tag line |
| `sqlite3Multiply128` | 5893002 | no tag line |
| `main` | 2824339 | its tags didn't fit |
| `sqlite3CompileOptions-0xf0` | 48 | no tag line |
| `.init` | 7 | no tag line |
| `.fini` | 4 | no tag line |

Dynamic calls into the program's functions: Tier 1 76.25 M, clang -O2 25.62 M

| Function | `--tier1`, M | clang -O2, M | Gap, M | calls, `--tier1` / -O2 | moves | stack | memory | address | extend | branch | call | `--tier1`: spills+reloads, call saves, edge moves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `sqlite3VdbeExec` | 792.8 | 398.2 | 394.6 | 0.08 M / 0.08 M | 78.3 | 147.0 | 25.6 | 93.9 | 29.0 | 30.8 | 4.5 | 201.4, 20.7, 51.7 |
| `yy_reduce` | 96.9 | 54.2 | 42.7 | 1.23 M / 1.23 M | 10.7 | 8.3 | 4.7 | 8.9 | 8.5 | 0.6 | -1.2 | 0.4, 6.0, 2.1 |
| `sqlite3Parser` | 91.0 | 0.0 | 91.0 | 0.70 M / 0.00 M | 23.7 | 21.7 | 10.8 | 3.3 | 7.0 | 11.7 | 11.6 | 0.0, 12.6, 0.0 |
| `substrFunc` | 88.9 | 48.4 | 40.5 | 0.13 M / 0.13 M | 6.1 | 2.6 | 3.7 | 4.6 | 4.8 | 23.7 | 0.5 | 0.0, 2.9, 5.7 |
| `jsonTranslateTextToBlob` | 75.5 | 55.1 | 20.4 | 0.39 M / 0.39 M | 8.2 | -0.7 | -0.5 | 6.6 | 7.4 | 6.1 | -1.0 | 0.9, 1.0, 2.2 |
| `sqlite3BtreeIndexMoveto` | 67.2 | 44.2 | 23.0 | 0.11 M / 0.11 M | 9.8 | 1.4 | 4.8 | 0.6 | 3.2 | 3.3 | 0.1 | 0.0, 9.1, 3.4 |
| `sqlite3_str_vappendf` | 61.0 | 44.6 | 16.5 | 0.13 M / 0.13 M | 3.4 | 12.8 | -1.2 | 3.5 | 2.3 | 1.0 | -0.6 | 14.4, 3.6, 3.6 |
| `sqlite3RunParser` | 52.9 | 89.0 | -36.1 | 0.04 M / 0.04 M | 4.9 | 0.8 | -6.9 | -7.7 | -5.2 | -18.8 | -0.2 | 10.5, 4.1, 5.2 |
| `balance_nonroot` | 47.4 | 0.0 | 47.4 | 0.00 M / 0.00 M | 4.2 | 14.0 | 10.0 | 5.4 | 3.4 | 6.1 | 0.3 | 12.0, 2.0, 0.6 |
| `sqlite3ColumnIndex` | 46.8 | 0.0 | 46.8 | 0.13 M / 0.00 M | 6.8 | 0.8 | 3.6 | 2.9 | 3.6 | 21.2 | 1.7 | 0.0, 0.8, 2.9 |
| `yy_find_shift_action` | 43.9 | 0.0 | 43.9 | 1.93 M / 0.00 M | 9.0 | 0.0 | 5.8 | 7.9 | 6.7 | 11.1 | 1.9 | 0.0, 0.0, 0.0 |
| `jsonTranslateBlobToText` | 41.6 | 24.5 | 17.1 | 0.30 M / 0.30 M | 2.7 | 6.0 | 2.4 | 2.7 | 1.7 | 2.7 | -0.4 | 0.5, 7.2, 0.4 |
| `sqlite3GetToken` | 39.6 | 28.2 | 11.4 | 0.90 M / 0.90 M | -0.2 | 0.0 | 0.6 | 7.2 | 0.9 | 4.9 | 0.0 | 0.0, 0.0, 0.0 |
| `sqlite3VdbeRecordCompareWithSkip` | 33.5 | 25.0 | 8.5 | 0.28 M / 0.28 M | 2.5 | 4.9 | 1.1 | 2.2 | 0.2 | 0.2 | -0.3 | 4.0, 2.0, 3.2 |
| `lookupName` | 32.0 | 0.0 | 32.0 | 0.09 M / 0.00 M | 2.4 | 10.1 | 4.8 | 1.8 | 0.7 | 8.2 | 1.3 | 8.5, 1.7, 1.8 |
| `sqlite3Insert` | 29.2 | 32.8 | -3.6 | 0.02 M / 0.02 M | 1.4 | 7.2 | -4.0 | 1.6 | 0.2 | -5.9 | -0.1 | 6.1, 5.3, 1.3 |
| `yy_shift` | 27.7 | 0.0 | 27.7 | 0.70 M / 0.00 M | 2.1 | 1.4 | 9.8 | 3.1 | 1.7 | 3.2 | 6.3 | 0.0, 0.0, 0.4 |
| `patternCompare` | 26.9 | 18.0 | 8.8 | 0.21 M / 0.21 M | -0.2 | 1.0 | 4.0 | 2.4 | 0.4 | 2.4 | -0.6 | 2.1, 1.3, 0.4 |
| `sqlite3BtreeTableMoveto` | 25.1 | 14.7 | 10.4 | 0.08 M / 0.08 M | 2.1 | 2.9 | 2.1 | 0.3 | 1.3 | 1.4 | -0.1 | 0.8, 4.0, 1.7 |
| `vdbeRecordCompareInt` | 25.0 | 13.1 | 11.8 | 0.71 M / 0.71 M | 0.8 | 1.4 | 0.0 | 3.6 | 3.5 | 1.8 | 1.5 | 1.4, 0.0, 0.0 |
| `btreeParseCellPtr` | 24.9 | 15.3 | 9.7 | 0.51 M / 0.51 M | 1.8 | 0.8 | 3.6 | 2.5 | 2.1 | 0.0 | 1.0 | 0.8, 0.0, 1.0 |
| `sqlite3BtreeInsert` | 24.6 | 31.0 | -6.3 | 0.16 M / 0.16 M | 0.5 | -3.2 | -0.9 | 1.6 | -0.6 | -0.6 | -1.2 | 1.2, 2.2, 0.9 |
| `memsys5FreeUnsafe` | 23.0 | 0.0 | 23.0 | 0.19 M / 0.00 M | 5.8 | 0.4 | 3.6 | 2.8 | 2.2 | 2.9 | 2.4 | 0.0, 0.4, 1.4 |
| `sqlite3DbMallocRawNN` | 22.9 | 15.8 | 7.1 | 1.30 M / 1.25 M | 0.0 | 0.0 | 1.5 | 2.5 | 0.0 | 0.2 | 2.9 | 0.0, 0.0, 0.0 |
| `walFindFrame` | 21.3 | 9.7 | 11.6 | 0.09 M / 0.09 M | 3.0 | 6.4 | 0.1 | 0.4 | 0.7 | 1.4 | 0.6 | 2.4, 4.7, 0.4 |

Calls clang -O2 doesn't make (a callee's calls by Tier 1 less its calls by clang): 50.63 M, whose callees' bodies run 1125.9 M of Tier 1's instructions

| Callee | `--tier1` calls, M | -O2 calls, M | `--tier1` instructions, M | per call | frame + call saves + entry, M |
| --- | ---: | ---: | ---: | ---: | ---: |
| `memcpy@plt` | 3.94 | 0.00 | 3.9 | 1.0 | 0.0 |
| `yy_find_shift_action` | 1.93 | 0.00 | 43.9 | 22.8 | 0.0 |
| `memset@plt` | 1.44 | 0.00 | 1.4 | 1.0 | 0.0 |
| `sqlite3BtreeCursorHasMoved` | 1.44 | 0.00 | 8.6 | 6.0 | 0.0 |
| `yy_find_reduce_action` | 1.23 | 0.00 | 12.3 | 10.0 | 0.0 |
| `sqlite3DbNNFreeNN` | 1.17 | 0.02 | 15.0 | 12.8 | 2.3 |
| `sqlite3VdbeOneByteSerialTypeLen` | 1.06 | 0.00 | 4.2 | 4.0 | 0.0 |
| `sqlite3Parser` | 0.70 | 0.00 | 91.0 | 129.7 | 8.4 |
| `yy_shift` | 0.70 | 0.00 | 27.7 | 39.5 | 7.0 |
| `memcmp@plt` | 0.68 | 0.00 | 0.7 | 1.0 | 0.0 |
| `sqlite3VdbeAddOp3` | 0.64 | 0.02 | 16.2 | 25.1 | 1.3 |
| `sqlite3AddInt64` | 0.61 | 0.00 | 10.4 | 17.0 | 0.0 |
| `btreeParseCell` | 0.61 | 0.00 | 13.3 | 22.0 | 1.2 |
| `sqlite3BtreePayloadSize` | 0.58 | 0.00 | 4.0 | 7.0 | 1.2 |
| `fetchPayload` | 0.58 | 0.00 | 5.8 | 10.0 | 0.0 |
