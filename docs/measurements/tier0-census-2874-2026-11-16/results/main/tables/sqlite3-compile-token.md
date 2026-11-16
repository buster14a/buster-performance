| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **14.97** | **5.03** | **0.03** | **0.12** |
| … the columns' room and the labels | 7.31 | 2.69 | 0.02 | 0.06 |
| … the values' predicates (P0) | 5.35 | 1.34 | 0.01 | 0.03 |
| … the depths (P4) | 2.32 | 0.99 | 0.01 | 0.02 |
| **the selection** | **39.58** | **17.21** | **0.13** | **0.36** |
| … fusion (P1 to P3) | 8.57 | 3.53 | 0.04 | 0.08 |
| … the templates' words (selection's gather) | 9.06 | 5.29 | 0.03 | 0.17 |
| … measuring: the homes' case, lengths, positions | 10.93 | 4.67 | 0.04 | 0.03 |
| … measuring: a deferred entry's records counted | 4.03 | 1.74 | 0.01 | 0.01 |
| … the immediates' forms: the requests chosen | 1.39 | 0.69 | 0.01 | 0.03 |
| … the immediates' forms: applied to the records | 5.60 | 1.28 | 0.00 | 0.03 |
| **the homes and the frame** | **10.91** | **4.91** | **0.06** | **0.04** |
| … the references' count | 2.04 | 1.01 | 0.01 | 0.01 |
| … the homes | 2.14 | 1.14 | 0.02 | 0.01 |
| … the frame's layout | 3.28 | 1.49 | 0.02 | 0.01 |
| … the prologue and the epilogue | 3.45 | 1.27 | 0.01 | 0.01 |
| **the records' emission** | **31.83** | **11.27** | **0.07** | **0.23** |
| … expansion: hole blocks, a permute and a store an entry | 20.67 | 7.10 | 0.04 | 0.17 |
| … the deferred entries' records (calls, division, copies) | 8.47 | 3.23 | 0.03 | 0.05 |
| … the output's arrays and the code's close | 2.69 | 0.94 | 0.01 | 0.01 |
| … the x87 values' transfers (long double) | 0.00 | 0.00 | 0.00 | 0.00 |
| **the encoder** | **7.48** | **2.37** | **0.01** | **0.03** |
| **branch sizing** | **6.93** | **3.52** | **0.02** | **0.13** |
| … the branch columns' check | 0.87 | 0.39 | 0.00 | 0.02 |
| … the records' lengths (x86_measure) | 3.68 | 1.77 | 0.00 | 0.06 |
| … size_branches | 2.38 | 1.35 | 0.01 | 0.04 |
| **the atoms and relocations** | **13.28** | **4.09** | **0.02** | **0.06** |
| … the symbols and their names | 2.63 | 1.55 | 0.01 | 0.02 |
| … the atoms and their fixups | 5.79 | 1.44 | 0.01 | 0.03 |
| … link_check | 4.85 | 1.10 | 0.01 | 0.00 |
| **the object's sections** | **7.68** | **2.45** | **0.03** | **0.05** |
| … object_prepare and object_build | 7.22 | 2.30 | 0.03 | 0.05 |
| … the driver's object: sections, the file | 0.46 | 0.15 | 0.00 | 0.00 |
| **the unwind table** | **18.10** | **5.90** | **0.02** | **0.05** |
| … the frames' events from Tier 0's code | 4.83 | 1.83 | 0.01 | 0.02 |
| … the rows resolved and checked | 10.55 | 3.24 | 0.01 | 0.02 |
| … the table written (.eh_frame) | 2.72 | 0.83 | 0.00 | 0.01 |
| **the emission's driver** | **10.49** | **7.49** | **0.04** | **0.20** |
| … the bodies' loop, the windows, what the merge keeps | 7.89 | 5.08 | 0.02 | 0.14 |
| … Tier 0's splice of always_inline callees | 0.77 | 0.31 | 0.00 | 0.01 |
| … the inline callees' table (check_tier1_inline_table) | 1.83 | 2.09 | 0.01 | 0.04 |
| … the inline asm's bodies (the assembler) | 0.00 | 0.01 | 0.00 | 0.00 |
| **the static data's atoms** | **1.55** | **0.48** | **0.00** | **0.01** |
| **Tier 0's validation (the lowering's check, in `lower`)** | **17.68** | **7.64** | **0.07** | **0.13** |
| **the process** | **18.64** | **12.56** | **0.03** | **0.14** |
| **libc, caller not in the stack** | **4.47** | **20.66** | **0.00** | **1.96** |
| … memset | 4.10 | 19.72 | 0.00 | 1.76 |
| … memmove and memcpy | 0.34 | 0.90 | 0.00 | 0.20 |
| … strings | 0.03 | 0.03 | 0.00 | 0.00 |
| **the lowering** | **212.75** | **86.55** | **0.52** | **1.05** |
| **the front end** | **1476.40** | **656.93** | **3.64** | **11.13** |
| … the preprocessor and the lexer | 178.60 | 64.64 | 0.34 | 1.70 |
| … the parser | 114.85 | 42.98 | 0.16 | 0.88 |
| … the checker | 1177.66 | 546.62 | 3.13 | 8.51 |
| … the static data's plan (check_data_prepare) | 5.28 | 2.68 | 0.02 | 0.05 |
| **unmatched** | **0.16** | **0.16** | **0.00** | **0.00** |
| **the row** | **162.79** | **64.72** | **0.43** | **1.27** |
| **the issue's eight parts** | **132.66** | **50.84** | **0.37** | **1.01** |
| **their share of the row, %** | **81.49** | **78.57** | **85.57** | **79.67** |
| **every sample** | **1892.90** | **849.22** | **4.69** | **15.68** |
