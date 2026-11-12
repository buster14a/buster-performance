Program code (the C library's left out): Tier 1 5577.0 M, clang -O2 4148.9 M, gap 1428.1 M (1.34x)

| Cause | `--tier1`, M | clang -O2, M | Gap, M | Share of the gap | `--tier1`'s by origin, M |
| --- | ---: | ---: | ---: | ---: | --- |
| register moves | 1014.3 | 544.4 | 469.9 | 32.9% | edge move 469.9, call sequence 176.6, node 366.0, unattributed 1.8 |
| stack loads and stores | 419.5 | 129.9 | 289.6 | 20.3% | spill 32.9, reload 7.4, edge spill 33.3, edge reload 52.5, call save 127.8, call restore 157.6, node 7.5 |
| other loads and stores | 918.2 | 884.3 | 33.9 | 2.4% | node 917.3 |
| address arithmetic (lea) | 423.4 | 114.6 | 308.9 | 21.6% | recomputed 97.4, node 325.5 |
| zero and sign extensions | 45.7 | 41.1 | 4.6 | 0.3% | entry 14.6, node 30.9 |
| compares and branches | 1196.1 | 894.4 | 301.6 | 21.1% | branch 684.1, node 511.2 |
| calls, returns and frames | 534.8 | 706.9 | -172.1 | -12.1% | call sequence 105.8, frame 337.2, node 90.9 |
| constants | 182.2 | 84.9 | 97.3 | 6.8% | node 181.8 |
| arithmetic and the rest | 842.9 | 748.5 | 94.3 | 6.6% | node 842.4 |

| Type | `--tier1`, M | clang -O2, M | Gap, M |
| --- | ---: | ---: | ---: |
| move (moves) | 1013.7 | 544.1 | 469.5 |
| store_stack (stack) | 195.7 | 44.6 | 151.1 |
| load_stack (stack) | 222.0 | 65.2 | 156.8 |
| cmp_stack (stack) | 1.8 | 8.4 | -6.7 |
| alu_load_stack (stack) | 0.0 | 9.6 | -9.6 |
| cmov_stack (stack) | 0.0 | 1.4 | -1.4 |
| load (memory) | 565.1 | 503.1 | 62.0 |
| store (memory) | 222.8 | 200.0 | 22.8 |
| cmp_load (memory) | 123.3 | 126.3 | -3.0 |
| alu_load (memory) | 7.0 | 33.2 | -26.2 |
| alu_rmw (memory) | 0.0 | 21.5 | -21.5 |
| lea (address) | 311.5 | 111.3 | 200.2 |
| lea_stack (address) | 112.0 | 3.3 | 108.7 |
| extend (extend) | 45.7 | 41.1 | 4.6 |
| cmp (branch) | 377.0 | 266.0 | 111.0 |
| jcc (branch) | 430.6 | 401.1 | 29.5 |
| jmp (branch) | 253.6 | 131.3 | 122.3 |
| jmp_indirect (branch) | 62.8 | 62.8 | -0.0 |
| setcc (branch) | 62.6 | 20.8 | 41.9 |
| cmov (branch) | 9.4 | 12.4 | -3.0 |
| call (call) | 106.0 | 120.1 | -14.1 |
| ret (call) | 91.0 | 91.0 | 0.0 |
| push (call) | 94.6 | 241.0 | -146.4 |
| pop (call) | 93.0 | 214.2 | -121.2 |
| frame (call) | 150.1 | 40.6 | 109.5 |
| constant (constant) | 182.2 | 84.9 | 97.3 |
| alu (alu) | 827.9 | 678.9 | 148.9 |
| div (alu) | 7.5 | 7.5 | 0.0 |
| fp (alu) | 7.5 | 7.3 | 0.2 |
| nop (alu) | 0.0 | 54.8 | -54.8 |

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

Dynamic calls into the program's own code: Tier 1 91.79 M, clang -O2 91.79 M; into its PLT stubs, the C library's calls: Tier 1 0.00 M, clang -O2 0.00 M

| Function | `--tier1`, M | clang -O2, M | Gap, M | calls, `--tier1` / -O2 | moves | stack | memory | address | extend | branch | call | `--tier1`: spills+reloads, call saves, edge moves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `luaV_execute` | 2961.3 | 1916.4 | 1044.8 | 1.36 M / 1.36 M | 435.5 | 44.4 | 0.0 | 268.8 | -8.3 | 182.7 | 0.1 | 108.5, 32.6, 424.4 |
| `match` | 257.3 | 194.9 | 62.4 | 3.41 M / 3.41 M | 12.0 | 10.6 | 6.8 | 4.5 | 0.0 | 30.9 | -6.8 | 0.0, 10.6, 14.3 |
| `luaD_precall` | 241.4 | 177.2 | 64.3 | 3.98 M / 3.98 M | 25.0 | 7.3 | 3.7 | 7.3 | 0.0 | 21.5 | -7.9 | 0.0, 7.3, 7.6 |
| `luaV_mod` | 106.6 | 67.5 | 39.1 | 4.01 M / 4.01 M | 3.7 | 8.0 | 0.0 | -3.7 | 3.9 | 19.4 | 8.0 | 0.0, 8.0, 0.0 |
| `index2value` | 104.5 | 85.9 | 18.6 | 9.30 M / 9.30 M | 3.3 | 0.0 | 0.0 | 0.2 | 6.2 | 0.2 | 0.0 | 0.0, 0.0, 0.0 |
| `match_class` | 102.2 | 87.6 | 14.6 | 2.43 M / 2.43 M | 7.3 | 19.5 | 0.0 | 0.0 | 0.0 | -2.4 | -12.2 | 0.0, 19.5, 0.0 |
| `luaV_idiv` | 83.7 | 52.3 | 31.4 | 3.49 M / 3.49 M | 0.0 | 7.0 | 0.0 | 0.0 | 3.5 | 14.0 | 7.0 | 0.0, 7.0, 0.0 |
| `luaH_getshortstr` | 82.3 | 64.9 | 17.4 | 3.02 M / 3.02 M | 8.3 | 6.0 | -1.5 | -8.8 | 0.0 | 5.9 | 0.0 | 0.0, 6.0, 0.0 |
| `prepCallInfo` | 74.5 | 118.3 | -43.8 | 4.38 M / 4.38 M | -21.9 | 0.0 | 0.0 | 4.4 | 0.0 | 0.0 | -26.3 | 0.0, 0.0, 0.0 |
| `luaV_finishset` | 70.6 | 79.5 | -9.0 | 1.30 M / 1.30 M | -2.6 | -5.2 | 3.9 | 2.6 | 0.0 | -5.1 | -2.6 | 0.0, 5.2, 3.9 |
| `lua_settop` | 55.6 | 34.7 | 20.8 | 2.18 M / 2.18 M | 2.2 | 0.0 | 3.6 | 2.6 | 0.4 | 9.1 | 0.0 | 0.0, 0.0, 2.2 |
| `lua_pushvalue` | 54.3 | 47.9 | 6.4 | 3.19 M / 3.19 M | 0.0 | 12.8 | 3.2 | 3.2 | 0.0 | 0.0 | -12.8 | 0.0, 12.8, 0.0 |
| `lua_geti` | 53.9 | 53.9 | 0.0 | 1.20 M / 1.20 M | -3.6 | 2.4 | 1.2 | -1.2 | 0.0 | 1.2 | -4.8 | 0.0, 4.8, 0.0 |
| `sort_comp` | 52.9 | 42.3 | 10.6 | 1.06 M / 1.06 M | 0.0 | 15.9 | 0.0 | 0.0 | 0.0 | -1.1 | -4.2 | 0.0, 15.9, 0.0 |
| `luaH_newkey` | 51.5 | 44.3 | 7.3 | 0.80 M / 0.80 M | -3.2 | 3.2 | 0.0 | 1.6 | 0.0 | 4.8 | -4.8 | 0.0, 4.8, 1.6 |
| `singlematch` | 49.5 | 52.7 | -3.2 | 3.20 M / 3.20 M | 4.9 | 0.0 | 0.0 | 0.0 | 0.0 | -4.9 | 0.0 | 0.0, 0.0, 0.0 |
| `add_s` | 46.0 | 30.4 | 15.6 | 0.23 M / 0.23 M | 1.1 | 15.9 | 0.0 | 1.1 | 0.0 | -0.2 | -2.1 | 0.0, 17.5, 0.0 |
| `ccall` | 40.6 | 39.4 | 1.2 | 1.32 M / 1.32 M | -5.2 | 7.8 | 2.6 | 0.0 | -1.3 | 1.3 | -7.9 | 0.0, 7.8, 1.3 |
| `setnodevector` | 37.3 | 31.2 | 6.0 | 0.80 M / 0.80 M | 2.0 | 2.4 | 0.8 | -0.4 | 0.0 | 1.6 | -3.2 | 0.0, 2.4, 0.0 |
| `luaH_resize` | 35.7 | 30.8 | 4.9 | 0.40 M / 0.40 M | -0.5 | 8.4 | 0.0 | -0.1 | 0.0 | 0.4 | -2.4 | 0.0, 9.2, 0.0 |
| `str_gsub` | 34.9 | 18.0 | 16.9 | 0.00 M / 0.00 M | 7.9 | 7.5 | 0.0 | 2.3 | 0.0 | 0.1 | 0.0 | 7.8, 1.6, 5.5 |
| `moveresults` | 33.7 | 37.1 | -3.4 | 1.12 M / 1.12 M | 2.0 | 0.0 | 0.0 | 0.6 | 0.1 | 2.2 | -6.7 | 0.0, 0.0, 1.2 |
| `luaD_pretailcall` | 32.8 | 32.0 | 0.8 | 0.60 M / 0.60 M | 1.2 | -0.2 | 0.4 | 0.8 | -0.2 | 1.6 | -1.2 | 0.0, 0.0, 1.2 |
| `classend` | 31.5 | 39.6 | -8.2 | 2.25 M / 2.25 M | -3.7 | 0.0 | 0.0 | 3.7 | 0.0 | -4.5 | 0.0 | 0.0, 0.0, 0.0 |
| `precallC` | 30.3 | 25.3 | 5.0 | 0.72 M / 0.72 M | -1.3 | 6.8 | 0.0 | 1.4 | 0.0 | 0.7 | -4.0 | 0.0, 6.8, 0.7 |

Calls clang -O2 doesn't make (a callee's calls by Tier 1 less its calls by clang, a count difference): 0.00 M. Their callees' instructions in Tier 1, each callee's scaled by the share of its calls clang doesn't make (an estimate from its average per call): 0.0 M

| Callee | `--tier1` calls, M | -O2 calls, M | `--tier1` instructions, M | per call | frame + call saves + entry, M | clang's inlining remarks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `luaS_hash` | 0.23 | 0.23 | 18.9 | 83.6 | 0.0 | - |
| `internshrstr` | 0.23 | 0.23 | 16.2 | 71.6 | 5.6 | - |
| `luaS_newlstr` | 0.23 | 0.23 | 1.4 | 6.0 | 0.5 | - |
| `equalkey` | 0.00 | 0.00 | 0.0 | 30.9 | 0.0 | - |
| `mainpositionTV` | 0.81 | 0.81 | 25.8 | 32.0 | 4.8 | - |
| `getfreepos` | 0.00 | 0.00 | 0.0 | 19.6 | 0.0 | - |
| `mainpositionfromnode` | 0.00 | 0.00 | 0.0 | 10.0 | 0.0 | - |
| `hashint` | 0.00 | 0.00 | 0.0 | 24.8 | 0.0 | - |
| `index2value-0x100` | 0.00 | 0.00 | 0.0 | 48.0 | 0.0 | - |
| `luaV_execute` | 1.36 | 1.36 | 2961.3 | 2181.7 | 50.9 | - |
| `match` | 3.41 | 3.41 | 257.3 | 75.5 | 51.5 | - |
| `luaD_precall` | 3.98 | 3.98 | 241.4 | 60.7 | 54.5 | - |
| `luaV_mod` | 4.01 | 4.01 | 106.6 | 26.6 | 16.0 | - |
| `index2value` | 9.30 | 9.30 | 104.5 | 11.2 | 9.3 | - |
| `match_class` | 2.43 | 2.43 | 102.2 | 42.0 | 31.6 | - |
