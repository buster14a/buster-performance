| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **27.14** | **9.12** | **0.06** | **0.21** |
| … the columns' room and the labels | 13.25 | 4.88 | 0.03 | 0.11 |
| … the values' predicates (P0) | 9.69 | 2.44 | 0.02 | 0.06 |
| … the depths (P4) | 4.20 | 1.80 | 0.01 | 0.04 |
| **the selection** | **71.75** | **31.19** | **0.23** | **0.64** |
| … fusion (P1 to P3) | 15.53 | 6.41 | 0.07 | 0.15 |
| … the templates' words (selection's gather) | 16.43 | 9.59 | 0.05 | 0.30 |
| … measuring: the homes' case, lengths, positions | 19.82 | 8.46 | 0.08 | 0.06 |
| … measuring: a deferred entry's records counted | 7.30 | 3.16 | 0.02 | 0.02 |
| … the immediates' forms: the requests chosen | 2.52 | 1.25 | 0.01 | 0.05 |
| … the immediates' forms: applied to the records | 10.15 | 2.32 | 0.00 | 0.06 |
| **the homes and the frame** | **19.77** | **8.91** | **0.10** | **0.07** |
| … the references' count | 3.70 | 1.83 | 0.02 | 0.01 |
| … the homes | 3.88 | 2.08 | 0.03 | 0.01 |
| … the frame's layout | 5.95 | 2.70 | 0.03 | 0.02 |
| … the prologue and the epilogue | 6.25 | 2.30 | 0.02 | 0.02 |
| **the records' emission** | **57.70** | **20.44** | **0.14** | **0.41** |
| … expansion: hole blocks, a permute and a store an entry | 37.47 | 12.87 | 0.07 | 0.30 |
| … the deferred entries' records (calls, division, copies) | 15.35 | 5.86 | 0.06 | 0.09 |
| … the output's arrays and the code's close | 4.87 | 1.71 | 0.01 | 0.02 |
| … the x87 values' transfers (long double) | 0.01 | 0.00 | 0.00 | 0.00 |
| **the encoder** | **13.56** | **4.29** | **0.01** | **0.06** |
| **branch sizing** | **12.56** | **6.37** | **0.03** | **0.23** |
| … the branch columns' check | 1.59 | 0.71 | 0.00 | 0.04 |
| … the records' lengths (x86_measure) | 6.67 | 3.22 | 0.01 | 0.11 |
| … size_branches | 4.31 | 2.45 | 0.02 | 0.08 |
| **the atoms and relocations** | **24.07** | **7.41** | **0.04** | **0.10** |
| … the symbols and their names | 4.78 | 2.81 | 0.01 | 0.05 |
| … the atoms and their fixups | 10.50 | 2.60 | 0.01 | 0.05 |
| … link_check | 8.80 | 2.00 | 0.02 | 0.00 |
| **the object's sections** | **13.92** | **4.44** | **0.06** | **0.10** |
| … object_prepare and object_build | 13.09 | 4.17 | 0.05 | 0.10 |
| … the driver's object: sections, the file | 0.83 | 0.27 | 0.00 | 0.00 |
| **the unwind table** | **32.80** | **10.70** | **0.04** | **0.10** |
| … the frames' events from Tier 0's code | 8.75 | 3.32 | 0.01 | 0.03 |
| … the rows resolved and checked | 19.12 | 5.87 | 0.03 | 0.04 |
| … the table written (.eh_frame) | 4.93 | 1.50 | 0.01 | 0.02 |
| **the emission's driver** | **19.01** | **13.58** | **0.06** | **0.36** |
| … the bodies' loop, the windows, what the merge keeps | 14.29 | 9.22 | 0.04 | 0.26 |
| … Tier 0's splice of always_inline callees | 1.40 | 0.56 | 0.00 | 0.02 |
| … the inline callees' table (check_tier1_inline_table) | 3.31 | 3.78 | 0.02 | 0.08 |
| … the inline asm's bodies (the assembler) | 0.00 | 0.02 | 0.00 | 0.00 |
| **the static data's atoms** | **2.80** | **0.87** | **0.01** | **0.01** |
| **Tier 0's validation (the lowering's check, in `lower`)** | **32.05** | **13.86** | **0.13** | **0.23** |
| **the process** | **33.79** | **22.78** | **0.05** | **0.25** |
| **libc, caller not in the stack** | **8.10** | **37.44** | **0.00** | **3.55** |
| … memset | 7.44 | 35.74 | 0.00 | 3.20 |
| … memmove and memcpy | 0.61 | 1.64 | 0.00 | 0.36 |
| … strings | 0.06 | 0.06 | 0.00 | 0.00 |
| **the lowering** | **385.65** | **156.89** | **0.94** | **1.90** |
| **the front end** | **2676.31** | **1190.82** | **6.60** | **20.18** |
| … the preprocessor and the lexer | 323.76 | 117.18 | 0.62 | 3.08 |
| … the parser | 208.20 | 77.91 | 0.28 | 1.59 |
| … the checker | 2134.78 | 990.88 | 5.67 | 15.43 |
| … the static data's plan (check_data_prepare) | 9.57 | 4.86 | 0.03 | 0.08 |
| **unmatched** | **0.30** | **0.30** | **0.00** | **0.00** |
| **the row** | **295.10** | **117.31** | **0.79** | **2.30** |
| **the issue's eight parts** | **240.48** | **92.17** | **0.67** | **1.83** |
| **their share of the row, %** | **81.49** | **78.57** | **85.57** | **79.67** |
| **every sample** | **3431.30** | **1539.39** | **8.51** | **28.42** |
