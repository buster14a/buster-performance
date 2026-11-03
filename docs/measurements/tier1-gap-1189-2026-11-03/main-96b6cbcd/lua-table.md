Program code (the C library's left out): Tier 1 7228.2 M, clang -O2 3768.0 M, gap 3460.2 M (1.92x)

| Cause | `--tier1`, M | clang -O2, M | Gap, M | Share of the gap | `--tier1`'s by origin, M |
| --- | ---: | ---: | ---: | ---: | --- |
| register moves | 969.9 | 522.2 | 447.7 | 12.9% | edge move 269.8, call sequence 259.9, node 440.2 |
| stack loads and stores | 1052.5 | 105.6 | 946.9 | 27.4% | spill 31.7, reload 2.2, edge spill 346.8, edge reload 349.7, call save 161.2, call restore 161.0 |
| other loads and stores | 1041.0 | 771.6 | 269.3 | 7.8% | node 1041.0 |
| address arithmetic (lea) | 783.6 | 152.9 | 630.8 | 18.2% | recomputed 316.0, node 467.6 |
| zero and sign extensions | 470.5 | 37.9 | 432.6 | 12.5% | node 470.5 |
| compares and branches | 1517.9 | 901.0 | 616.9 | 17.8% | branch 708.4, node 795.3, unattributed 14.2 |
| calls, returns and frames | 526.3 | 474.0 | 52.4 | 1.5% | call sequence 106.0, frame 329.3, node 91.0 |
| constants | 119.6 | 143.9 | -24.3 | -0.7% | node 119.4 |
| arithmetic and the rest | 746.8 | 658.9 | 87.9 | 2.5% | node 746.8 |

| Type | `--tier1`, M | clang -O2, M | Gap, M |
| --- | ---: | ---: | ---: |
| move (moves) | 810.3 | 519.8 | 290.5 |
| self_move (moves) | 159.6 | 2.4 | 157.2 |
| store_stack (stack) | 539.6 | 54.6 | 485.0 |
| load_stack (stack) | 512.9 | 36.5 | 476.4 |
| cmp_stack (stack) | 0.0 | 3.0 | -3.0 |
| alu_load_stack (stack) | 0.0 | 11.1 | -11.1 |
| load (memory) | 747.6 | 443.3 | 304.4 |
| store (memory) | 282.4 | 191.5 | 90.9 |
| cmp_load (memory) | 0.0 | 78.1 | -78.1 |
| alu_load (memory) | 10.9 | 37.5 | -26.5 |
| alu_rmw (memory) | 0.0 | 21.2 | -21.2 |
| lea (address) | 447.7 | 148.8 | 298.9 |
| lea_stack (address) | 335.9 | 4.0 | 331.9 |
| extend (extend) | 470.5 | 37.9 | 432.6 |
| cmp (branch) | 585.5 | 305.3 | 280.2 |
| jcc (branch) | 439.1 | 395.7 | 43.4 |
| jmp (branch) | 269.3 | 116.5 | 152.8 |
| jmp_indirect (branch) | 77.0 | 59.3 | 17.6 |
| setcc (branch) | 147.0 | 18.1 | 128.9 |
| cmov (branch) | 0.0 | 6.1 | -6.1 |
| call (call) | 106.0 | 68.3 | 37.7 |
| ret (call) | 91.0 | 47.7 | 43.3 |
| push (call) | 90.3 | 170.0 | -79.8 |
| pop (call) | 88.8 | 154.9 | -66.1 |
| frame (call) | 150.3 | 33.1 | 117.2 |
| constant (constant) | 119.6 | 143.9 | -24.3 |
| alu (alu) | 731.8 | 629.3 | 102.5 |
| div (alu) | 7.5 | 7.5 | -0.0 |
| fp (alu) | 7.5 | 10.2 | -2.7 |
| nop (alu) | 0.0 | 11.9 | -11.9 |

| `--tier1`'s origin | M | Share of `--tier1`'s instructions |
| --- | ---: | ---: |
| spill | 31.7 | 0.4% |
| reload | 2.2 | 0.0% |
| edge spill | 346.8 | 4.8% |
| edge reload | 349.7 | 4.8% |
| call save | 161.2 | 2.2% |
| call restore | 161.0 | 2.2% |
| edge move | 269.8 | 3.7% |
| call sequence | 366.1 | 5.1% |
| entry | 0.0 | 0.0% |
| frame | 329.3 | 4.6% |
| recomputed | 316.0 | 4.4% |
| branch | 708.4 | 9.8% |
| node | 4171.8 | 57.7% |
| unattributed | 14.2 | 0.2% |

| `--tier1`'s unattributed instructions | Count | Why they have no tag |
| --- | ---: | --- |
| 36 PLT stubs | 14209916 | the linker's code |
| `index2value-0xf0` | 240 | no tag line |
| `.init` | 35 | no tag line |
| `.fini` | 20 | no tag line |

Dynamic calls into the program's own code: Tier 1 91.79 M, clang -O2 54.20 M; into its PLT stubs, the C library's calls: Tier 1 14.21 M, clang -O2 0.00 M

| Function | `--tier1`, M | clang -O2, M | Gap, M | calls, `--tier1` / -O2 | moves | stack | memory | address | extend | branch | call | `--tier1`: spills+reloads, call saves, edge moves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `luaV_execute` | 4298.2 | 2088.4 | 2209.7 | 1.36 M / 1.36 M | 258.3 | 680.9 | 162.4 | 503.8 | 278.8 | 315.0 | 5.0 | 707.0, 33.9, 223.7 |
| `match` | 295.7 | 247.7 | 48.0 | 3.41 M / 3.41 M | -0.0 | -5.8 | 10.7 | 11.2 | 23.4 | 24.3 | -12.7 | 0.0, 12.8, 8.4 |
| `luaD_precall` | 256.0 | 192.1 | 63.9 | 3.98 M / 3.98 M | 28.7 | 7.3 | -18.3 | 11.0 | 14.7 | 17.5 | -4.2 | 0.0, 7.3, 3.7 |
| `match_class` | 114.3 | 82.7 | 31.6 | 2.43 M / 2.43 M | 7.3 | 24.3 | -4.9 | 4.9 | 7.3 | 0.0 | -7.3 | 0.0, 24.3, 4.9 |
| `luaV_mod` | 106.6 | 0.0 | 106.6 | 4.01 M / 0.00 M | 15.7 | 8.0 | 0.0 | 4.0 | 15.7 | 43.1 | 12.0 | 0.0, 8.0, 0.0 |
| `index2value` | 101.2 | 0.0 | 101.2 | 9.30 M / 0.00 M | 0.0 | 0.0 | 25.1 | 9.3 | 9.3 | 38.4 | 9.3 | 0.0, 0.0, 0.0 |
| `prepCallInfo` | 87.6 | 0.0 | 87.6 | 4.38 M / 0.00 M | 0.0 | 0.0 | 39.4 | 4.4 | 8.8 | 13.1 | 21.9 | 0.0, 0.0, 0.0 |
| `luaV_idiv` | 80.2 | 0.0 | 80.2 | 3.49 M / 0.00 M | 10.5 | 7.0 | 0.0 | 3.5 | 10.5 | 27.9 | 10.5 | 0.0, 7.0, 0.0 |
| `luaV_finishset` | 79.8 | 56.1 | 23.7 | 1.30 M / 1.30 M | -1.3 | 0.0 | 6.6 | 7.8 | 1.3 | 6.6 | -2.6 | 0.0, 5.2, 3.9 |
| `sort_comp` | 73.0 | 41.2 | 31.7 | 1.06 M / 1.06 M | 10.6 | 25.4 | 0.0 | 0.0 | 0.0 | 0.0 | -4.2 | 0.0, 25.4, 0.0 |
| `luaH_getshortstr` | 72.1 | 51.0 | 21.0 | 3.02 M / 2.89 M | 8.3 | 0.0 | -0.4 | -4.4 | 5.5 | 10.4 | 0.1 | 0.0, 0.0, 0.0 |
| `lua_geti` | 67.1 | 47.9 | 19.2 | 1.20 M / 1.20 M | 2.4 | 4.8 | 3.6 | 3.6 | 1.2 | 2.4 | -1.2 | 0.0, 4.8, 0.0 |
| `singlematch` | 63.9 | 80.7 | -16.7 | 3.20 M / 3.20 M | 6.5 | 0.0 | 0.8 | 0.0 | 4.0 | -3.3 | -20.7 | 0.0, 0.0, 0.0 |
| `lua_pushvalue` | 60.7 | 47.9 | 12.8 | 3.19 M / 3.19 M | 5.3 | 12.8 | -1.1 | 6.4 | -2.1 | -12.8 | 9.6 | 0.0, 12.8, 0.0 |
| `add_s` | 57.0 | 0.0 | 57.0 | 0.23 M / 0.00 M | 9.9 | 23.0 | 5.3 | 1.8 | 1.8 | 6.0 | 6.0 | 0.0, 23.0, 0.7 |
| `luaH_newkey` | 56.4 | 48.0 | 8.4 | 0.80 M / 0.80 M | -1.3 | 2.3 | 0.4 | 0.6 | 2.4 | 9.3 | -4.8 | 0.0, 4.8, 1.6 |
| `ccall` | 55.1 | 0.0 | 55.1 | 1.32 M / 0.00 M | 7.9 | 10.3 | 7.9 | 4.0 | 2.6 | 9.3 | 9.2 | 0.0, 10.3, 1.3 |
| `lua_settop` | 54.8 | 36.9 | 17.9 | 2.18 M / 2.18 M | 0.0 | 0.0 | 3.6 | 2.6 | 2.2 | 10.5 | 0.0 | 0.0, 0.0, 2.2 |
| `luaH_resize` | 40.3 | 48.6 | -8.3 | 0.40 M / 0.40 M | 3.0 | 5.6 | -5.4 | -1.3 | 1.2 | -3.7 | -1.2 | 0.0, 11.2, 0.4 |
| `setnodevector` | 39.7 | 0.0 | 39.7 | 0.80 M / 0.00 M | 5.6 | 2.4 | 6.0 | 2.4 | 1.6 | 8.0 | 6.4 | 0.0, 2.4, 0.0 |
| `partition` | 39.1 | 0.0 | 39.1 | 0.02 M / 0.00 M | 13.6 | 11.0 | 0.0 | 0.5 | 1.2 | 5.6 | 2.9 | 0.0, 11.0, 1.0 |
| `str_gsub` | 38.6 | 42.5 | -3.9 | 0.00 M / 0.00 M | 1.5 | 6.3 | -0.2 | -0.8 | -0.7 | -3.9 | -2.9 | 10.7, 2.8, 3.9 |
| `precallC` | 38.1 | 30.1 | 8.0 | 0.72 M / 0.72 M | 2.1 | 6.8 | -3.6 | 1.4 | 2.9 | 2.1 | -5.9 | 0.0, 6.8, 0.7 |
| `classend` | 37.4 | 0.0 | 37.4 | 2.25 M / 0.00 M | 0.8 | 0.0 | 3.7 | 3.7 | 5.2 | 12.7 | 11.2 | 0.0, 0.0, 0.0 |
| `luaD_pretailcall` | 34.4 | 33.2 | 1.2 | 0.60 M / 0.60 M | -1.4 | 0.0 | 0.2 | 2.6 | 1.8 | 1.2 | -0.4 | 0.0, 0.0, 0.8 |

Calls clang -O2 doesn't make (a callee's calls by Tier 1 less its calls by clang, a count difference): 37.60 M. Their callees' instructions in Tier 1, each callee's scaled by the share of its calls clang doesn't make (an estimate from its average per call): 960.3 M

Of those 37598228 calls, by clang's inlining remarks (-Rpass=inline): to callees it inlined at one call site or more 37597254, to code without a symbol after a function (no function to inline) 0, to other callees 974

| Callee | `--tier1` calls, M | -O2 calls, M | `--tier1` instructions, M | per call | frame + call saves + entry, M | clang's inlining remarks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `index2value` | 9.30 | 0.00 | 101.2 | 10.9 | 0.0 | 39 |
| `prepCallInfo` | 4.38 | 0.00 | 87.6 | 20.0 | 17.5 | 2 |
| `luaV_mod` | 4.01 | 0.00 | 106.6 | 26.6 | 16.0 | 2 |
| `luaV_idiv` | 3.49 | 0.00 | 80.2 | 23.0 | 14.0 | 2 |
| `classend` | 2.25 | 0.00 | 37.4 | 16.6 | 9.0 | 2 |
| `ccall` | 1.32 | 0.00 | 55.1 | 41.6 | 15.6 | 3 |
| `reprepstate` | 1.13 | 0.00 | 3.4 | 3.0 | 0.0 | 3 |
| `moveresults` | 1.12 | 0.00 | 32.8 | 29.3 | 4.5 | 1 |
| `start_capture` | 0.93 | 0.00 | 25.6 | 27.5 | 5.6 | 2 |
| `luaH_realasize` | 0.82 | 0.02 | 7.4 | 9.0 | 0.0 | 5 |
| `setnodevector` | 0.80 | 0.00 | 39.7 | 49.6 | 7.2 | 2 |
| `freehash` | 0.80 | 0.00 | 9.6 | 12.0 | 1.6 | 2 |
| `end_capture` | 0.59 | 0.00 | 17.6 | 30.1 | 7.0 | 1 |
| `capture_to_close` | 0.59 | 0.00 | 7.6 | 13.0 | 1.2 | 1 |
| `get_onecapture` | 0.52 | 0.00 | 12.6 | 24.0 | 2.1 | 2 |
