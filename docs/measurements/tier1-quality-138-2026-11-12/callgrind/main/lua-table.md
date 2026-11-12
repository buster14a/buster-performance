Program code (the C library's left out): Tier 1 5577.0 M, clang -O2 3797.3 M, gap 1779.8 M (1.47x)

| Cause | `--tier1`, M | clang -O2, M | Gap, M | Share of the gap | `--tier1`'s by origin, M |
| --- | ---: | ---: | ---: | ---: | --- |
| register moves | 1014.3 | 535.7 | 478.6 | 26.9% | edge move 469.9, call sequence 176.6, node 366.0, unattributed 1.8 |
| stack loads and stores | 419.5 | 118.8 | 300.7 | 16.9% | spill 32.9, reload 7.4, edge spill 33.3, edge reload 52.5, call save 127.8, call restore 157.6, node 7.5 |
| other loads and stores | 918.2 | 770.2 | 148.0 | 8.3% | node 917.3 |
| address arithmetic (lea) | 423.4 | 152.2 | 271.3 | 15.2% | recomputed 97.4, node 325.5 |
| zero and sign extensions | 45.7 | 37.9 | 7.8 | 0.4% | entry 14.6, node 30.9 |
| compares and branches | 1196.1 | 905.9 | 290.2 | 16.3% | branch 684.1, node 511.2 |
| calls, returns and frames | 534.8 | 473.9 | 60.8 | 3.4% | call sequence 105.8, frame 337.2, node 90.9 |
| constants | 182.2 | 143.9 | 38.3 | 2.2% | node 181.8 |
| arithmetic and the rest | 842.9 | 658.8 | 184.1 | 10.3% | node 842.4 |

| Type | `--tier1`, M | clang -O2, M | Gap, M |
| --- | ---: | ---: | ---: |
| move (moves) | 1013.7 | 533.3 | 480.4 |
| self_move (moves) | 0.6 | 2.4 | -1.8 |
| store_stack (stack) | 195.7 | 61.3 | 134.5 |
| load_stack (stack) | 222.0 | 36.5 | 185.5 |
| cmp_stack (stack) | 1.8 | 9.6 | -7.8 |
| alu_load_stack (stack) | 0.0 | 11.1 | -11.1 |
| load (memory) | 565.1 | 442.7 | 122.4 |
| store (memory) | 222.8 | 191.5 | 31.3 |
| cmp_load (memory) | 123.3 | 77.3 | 46.0 |
| alu_load (memory) | 7.0 | 37.5 | -30.5 |
| alu_rmw (memory) | 0.0 | 21.2 | -21.2 |
| lea (address) | 311.5 | 148.1 | 163.4 |
| lea_stack (address) | 112.0 | 4.1 | 107.9 |
| extend (extend) | 45.7 | 37.9 | 7.8 |
| cmp (branch) | 377.0 | 304.9 | 72.1 |
| jcc (branch) | 430.6 | 401.0 | 29.7 |
| jmp (branch) | 253.6 | 116.5 | 137.2 |
| jmp_indirect (branch) | 62.8 | 59.3 | 3.4 |
| setcc (branch) | 62.6 | 18.1 | 44.5 |
| cmov (branch) | 9.4 | 6.1 | 3.3 |
| call (call) | 106.0 | 68.3 | 37.7 |
| ret (call) | 91.0 | 47.7 | 43.3 |
| push (call) | 94.6 | 168.3 | -73.6 |
| pop (call) | 93.0 | 154.9 | -61.8 |
| frame (call) | 150.1 | 34.8 | 115.2 |
| constant (constant) | 182.2 | 143.9 | 38.3 |
| alu (alu) | 827.9 | 629.2 | 198.6 |
| div (alu) | 7.5 | 7.5 | -0.0 |
| fp (alu) | 7.5 | 10.2 | -2.7 |
| nop (alu) | 0.0 | 11.9 | -11.9 |

| `--tier1`'s origin | M | Share of `--tier1`'s instructions |
| --- | ---: | ---: |
| spill | 32.9 | 0.6% |
| reload | 7.4 | 0.1% |
| edge spill | 33.3 | 0.6% |
| edge reload | 52.5 | 0.9% |
| call save | 127.8 | 2.3% |
| call restore | 157.6 | 2.8% |
| edge move | 469.9 | 8.4% |
| call sequence | 282.6 | 5.1% |
| entry | 14.6 | 0.3% |
| frame | 337.2 | 6.0% |
| recomputed | 97.4 | 1.7% |
| branch | 684.1 | 12.3% |
| node | 3273.5 | 58.7% |
| unattributed | 6.2 | 0.1% |

| `--tier1`'s unattributed instructions | Count | Why they have no tag |
| --- | ---: | --- |
| 0 PLT stubs | 0 | the linker's code |
| `luaD_rawrunprotected` | 6202736 | no tag line |
| `index2value-0x100` | 240 | no tag line |

Dynamic calls into the program's own code: Tier 1 91.79 M, clang -O2 54.20 M; into its PLT stubs, the C library's calls: Tier 1 0.00 M, clang -O2 0.00 M

| Function | `--tier1`, M | clang -O2, M | Gap, M | calls, `--tier1` / -O2 | moves | stack | memory | address | extend | branch | call | `--tier1`: spills+reloads, call saves, edge moves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `luaV_execute` | 2961.3 | 2094.9 | 866.4 | 1.36 M / 1.36 M | 340.1 | 78.5 | 65.1 | 219.0 | -15.6 | 85.2 | 7.6 | 108.5, 32.6, 424.4 |
| `match` | 257.3 | 247.7 | 9.6 | 3.41 M / 3.41 M | 11.4 | -8.0 | 6.0 | -2.4 | 0.0 | 6.0 | -5.9 | 0.0, 10.6, 14.3 |
| `luaD_precall` | 241.4 | 192.1 | 49.3 | 3.98 M / 3.98 M | 28.5 | 7.3 | -18.3 | 11.0 | 0.0 | 17.8 | -4.2 | 0.0, 7.3, 7.6 |
| `luaV_mod` | 106.6 | 0.0 | 106.6 | 4.01 M / 0.00 M | 15.7 | 8.0 | 0.0 | 4.0 | 4.0 | 43.1 | 12.0 | 0.0, 8.0, 0.0 |
| `index2value` | 104.5 | 0.0 | 104.5 | 9.30 M / 0.00 M | 9.1 | 0.0 | 25.1 | 0.2 | 9.5 | 32.3 | 9.3 | 0.0, 0.0, 0.0 |
| `match_class` | 102.2 | 82.7 | 19.5 | 2.43 M / 2.43 M | 4.9 | 19.5 | -4.9 | 0.0 | 4.9 | 0.0 | -7.3 | 0.0, 19.5, 0.0 |
| `luaV_idiv` | 83.7 | 0.0 | 83.7 | 3.49 M / 0.00 M | 14.0 | 7.0 | 0.0 | 3.5 | 3.5 | 27.9 | 10.5 | 0.0, 7.0, 0.0 |
| `luaH_getshortstr` | 82.3 | 47.5 | 34.8 | 3.02 M / 2.89 M | 8.3 | 6.0 | 1.7 | -6.8 | 3.0 | 11.4 | 0.1 | 0.0, 6.0, 0.0 |
| `prepCallInfo` | 74.5 | 0.0 | 74.5 | 4.38 M / 0.00 M | 0.0 | 0.0 | 39.4 | 4.4 | 0.0 | 8.8 | 21.9 | 0.0, 0.0, 0.0 |
| `luaV_finishset` | 70.6 | 56.1 | 14.5 | 1.30 M / 1.30 M | -1.3 | 0.0 | 3.9 | 2.6 | 0.0 | 6.6 | -2.6 | 0.0, 5.2, 3.9 |
| `lua_settop` | 55.6 | 36.9 | 18.7 | 2.18 M / 2.18 M | 2.2 | 0.0 | 3.6 | 0.4 | 0.4 | 9.1 | 0.0 | 0.0, 0.0, 2.2 |
| `lua_pushvalue` | 54.3 | 47.9 | 6.4 | 3.19 M / 3.19 M | 2.1 | 12.8 | -1.1 | 3.2 | -2.1 | -12.8 | 9.6 | 0.0, 12.8, 0.0 |
| `lua_geti` | 53.9 | 53.9 | 0.0 | 1.20 M / 1.20 M | -2.4 | 2.4 | -1.2 | 0.0 | 0.0 | 0.0 | -3.6 | 0.0, 4.8, 0.0 |
| `sort_comp` | 52.9 | 41.2 | 11.6 | 1.06 M / 1.06 M | 0.0 | 15.9 | 0.0 | 0.0 | 0.0 | 0.0 | -4.2 | 0.0, 15.9, 0.0 |
| `luaH_newkey` | 51.5 | 52.0 | -0.5 | 0.80 M / 0.80 M | -2.9 | 0.7 | 0.4 | 0.6 | -0.0 | 5.3 | -4.8 | 0.0, 4.8, 1.6 |
| `singlematch` | 49.5 | 80.7 | -31.2 | 3.20 M / 3.20 M | -0.8 | 0.0 | 0.8 | 0.0 | 0.0 | -7.3 | -20.7 | 0.0, 0.0, 0.0 |
| `add_s` | 46.0 | 0.0 | 46.0 | 0.23 M / 0.00 M | 7.8 | 19.8 | 3.0 | 1.8 | 0.0 | 4.8 | 5.5 | 0.0, 17.5, 0.0 |
| `ccall` | 40.6 | 0.0 | 40.6 | 1.32 M / 0.00 M | 3.9 | 7.8 | 7.9 | 0.0 | 0.0 | 6.6 | 9.2 | 0.0, 7.8, 1.3 |
| `setnodevector` | 37.3 | 0.0 | 37.3 | 0.80 M / 0.00 M | 5.6 | 2.4 | 6.0 | 1.2 | 0.0 | 7.6 | 6.4 | 0.0, 2.4, 0.0 |
| `luaH_resize` | 35.7 | 51.0 | -15.3 | 0.40 M / 0.40 M | 1.0 | 2.8 | -5.4 | -1.3 | -0.0 | -5.2 | -1.2 | 0.0, 9.2, 0.0 |
| `str_gsub` | 34.9 | 42.5 | -7.6 | 0.00 M / 0.00 M | 2.9 | 4.4 | -2.3 | -0.3 | -0.9 | -5.4 | -2.9 | 7.8, 1.6, 5.5 |
| `moveresults` | 33.7 | 0.0 | 33.7 | 1.12 M / 0.00 M | 3.0 | 0.0 | 6.2 | 1.0 | 1.5 | 11.5 | 5.6 | 0.0, 0.0, 1.2 |
| `luaD_pretailcall` | 32.8 | 33.2 | -0.4 | 0.60 M / 0.60 M | 0.4 | 0.0 | 0.2 | 0.8 | -0.2 | 1.2 | -0.4 | 0.0, 0.0, 1.2 |
| `classend` | 31.5 | 0.0 | 31.5 | 2.25 M / 0.00 M | 0.8 | 0.0 | 3.7 | 3.7 | 0.0 | 7.5 | 15.7 | 0.0, 0.0, 0.0 |
| `precallC` | 30.3 | 30.1 | 0.2 | 0.72 M / 0.72 M | 0.1 | 6.8 | -3.6 | 1.4 | 0.0 | -0.7 | -5.9 | 0.0, 6.8, 0.7 |

Calls clang -O2 doesn't make (a callee's calls by Tier 1 less its calls by clang, a count difference): 37.60 M. Their callees' instructions in Tier 1, each callee's scaled by the share of its calls clang doesn't make (an estimate from its average per call): 885.4 M

| Callee | `--tier1` calls, M | -O2 calls, M | `--tier1` instructions, M | per call | frame + call saves + entry, M | clang's inlining remarks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `index2value` | 9.30 | 0.00 | 104.5 | 11.2 | 9.3 | - |
| `prepCallInfo` | 4.38 | 0.00 | 74.5 | 17.0 | 17.5 | - |
| `luaV_mod` | 4.01 | 0.00 | 106.6 | 26.6 | 16.0 | - |
| `luaV_idiv` | 3.49 | 0.00 | 83.7 | 24.0 | 14.0 | - |
| `classend` | 2.25 | 0.00 | 31.5 | 14.0 | 13.5 | - |
| `ccall` | 1.32 | 0.00 | 40.6 | 30.7 | 13.1 | - |
| `reprepstate` | 1.13 | 0.00 | 3.4 | 3.0 | 0.0 | - |
| `moveresults` | 1.12 | 0.00 | 33.7 | 30.2 | 5.6 | - |
| `start_capture` | 0.93 | 0.00 | 23.7 | 25.5 | 5.6 | - |
| `luaH_realasize` | 0.82 | 0.02 | 7.4 | 9.0 | 0.0 | - |
| `setnodevector` | 0.80 | 0.00 | 37.3 | 46.6 | 7.2 | - |
| `freehash` | 0.80 | 0.00 | 8.8 | 11.0 | 1.6 | - |
| `end_capture` | 0.59 | 0.00 | 16.4 | 28.1 | 6.4 | - |
| `capture_to_close` | 0.59 | 0.00 | 7.6 | 13.0 | 1.2 | - |
| `get_onecapture` | 0.52 | 0.00 | 11.0 | 21.0 | 2.6 | - |
