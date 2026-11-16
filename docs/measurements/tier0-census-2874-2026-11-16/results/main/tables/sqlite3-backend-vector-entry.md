| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **25.48** | **7.89** | **0.05** | **0.14** |
| … the columns' room and the labels | 10.59 | 3.60 | 0.02 | 0.06 |
| … the values' predicates (P0) | 10.65 | 2.55 | 0.01 | 0.05 |
| … the depths (P4) | 4.24 | 1.74 | 0.01 | 0.03 |
| **the selection** | **71.65** | **30.19** | **0.22** | **0.50** |
| … fusion (P1 to P3) | 15.42 | 6.11 | 0.07 | 0.11 |
| … the templates' words (selection's gather) | 16.45 | 8.88 | 0.05 | 0.25 |
| … measuring: the homes' case, lengths, positions | 19.09 | 8.47 | 0.07 | 0.05 |
| … measuring: a deferred entry's records counted | 7.87 | 3.11 | 0.02 | 0.02 |
| … the immediates' forms: the requests chosen | 2.90 | 1.19 | 0.01 | 0.04 |
| … the immediates' forms: applied to the records | 9.92 | 2.42 | 0.00 | 0.02 |
| **the homes and the frame** | **17.69** | **7.90** | **0.08** | **0.04** |
| … the references' count | 3.87 | 1.90 | 0.02 | 0.01 |
| … the homes | 3.64 | 1.92 | 0.03 | 0.01 |
| … the frame's layout | 4.64 | 2.05 | 0.02 | 0.01 |
| … the prologue and the epilogue | 5.53 | 2.03 | 0.01 | 0.01 |
| **the records' emission** | **58.36** | **19.09** | **0.12** | **0.29** |
| … expansion: hole blocks, a permute and a store an entry | 39.11 | 12.64 | 0.08 | 0.22 |
| … the deferred entries' records (calls, division, copies) | 14.61 | 4.92 | 0.03 | 0.06 |
| … the output's arrays and the code's close | 4.64 | 1.54 | 0.01 | 0.01 |
| … the x87 values' transfers (long double) | 0.00 | 0.00 | -0.00 | 0.00 |
| **the encoder** | **0.06** | **-0.05** | **0.00** | **0.00** |
| **branch sizing** | **-0.00** | **0.02** | **0.00** | **-0.00** |
| … the branch columns' check | 0.00 | 0.00 | -0.00 | -0.00 |
| … the records' lengths (x86_measure) | -0.04 | -0.01 | 0.00 | -0.00 |
| … size_branches | 0.03 | 0.02 | 0.00 | 0.00 |
| **the atoms and relocations** | **-0.02** | **-0.00** | **0.00** | **-0.00** |
| … the symbols and their names | -0.01 | 0.02 | 0.00 | -0.00 |
| … the atoms and their fixups | -0.01 | -0.02 | -0.00 | -0.00 |
| **the unwind table** | **-0.00** | **0.00** | **0.00** | **-0.00** |
| **the emission's driver** | **-0.03** | **-0.01** | **-0.00** | **-0.00** |
| … the bodies' loop, the windows, what the merge keeps | -0.02 | -0.01 | -0.00 | 0.00 |
| … Tier 0's splice of always_inline callees | -0.01 | 0.00 | 0.00 | -0.00 |
| … the inline callees' table (check_tier1_inline_table) | -0.00 | 0.00 | 0.00 | -0.00 |
| … the inline asm's bodies (the assembler) | 0.00 | -0.00 | 0.00 | 0.00 |
| **Tier 0's validation (the lowering's check, in `lower`)** | **-31.08** | **-12.60** | **-0.10** | **-0.19** |
| **the process** | **0.08** | **-0.01** | **-0.00** | **-0.00** |
| **libc, caller not in the stack** | **0.00** | **-0.05** | **-0.00** | **-0.02** |
| … memset | -0.02 | -0.05 | -0.00 | -0.02 |
| … memmove and memcpy | -0.01 | -0.01 | 0.00 | -0.00 |
| … memcmp | 0.02 | 0.01 | 0.00 | -0.00 |
| … strings | 0.01 | 0.00 | -0.00 | 0.00 |
| **the lowering** | **-0.04** | **0.02** | **0.00** | **-0.00** |
| **the front end** | **0.11** | **0.03** | **0.00** | **0.00** |
| … the preprocessor and the lexer | -0.02 | -0.05 | -0.00 | 0.00 |
| … the parser | -0.00 | -0.01 | 0.00 | 0.00 |
| … the checker | 0.13 | 0.07 | 0.00 | -0.00 |
| … the static data's plan (check_data_prepare) | 0.00 | 0.01 | -0.00 | -0.00 |
| **unmatched** | **-0.03** | **-0.01** | **-0.00** | **-0.00** |
| **the row** | **173.19** | **65.03** | **0.47** | **0.97** |
| **the issue's eight parts** | **173.22** | **65.03** | **0.47** | **0.97** |
| **their share of the row, %** | **100.02** | **100.01** | **100.00** | **100.04** |
| **every sample** | **142.24** | **52.40** | **0.37** | **0.77** |
