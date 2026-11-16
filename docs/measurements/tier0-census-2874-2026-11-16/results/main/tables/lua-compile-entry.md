| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **40.35** | **17.66** | **0.13** | **0.27** |
| … the columns' room and the labels | 26.34 | 10.89 | 0.07 | 0.14 |
| … the values' predicates (P0) | 8.04 | 3.99 | 0.03 | 0.09 |
| … the depths (P4) | 5.96 | 2.78 | 0.03 | 0.05 |
| **the selection** | **86.66** | **49.94** | **0.39** | **0.84** |
| … fusion (P1 to P3) | 21.65 | 10.22 | 0.10 | 0.23 |
| … the templates' words (selection's gather) | 20.78 | 16.05 | 0.08 | 0.34 |
| … measuring: the homes' case, lengths, positions | 22.18 | 10.99 | 0.11 | 0.07 |
| … measuring: a deferred entry's records counted | 11.33 | 6.67 | 0.07 | 0.03 |
| … the immediates' forms: the requests chosen | 2.35 | 2.45 | 0.03 | 0.05 |
| … the immediates' forms: applied to the records | 8.38 | 3.55 | 0.01 | 0.12 |
| **the homes and the frame** | **29.96** | **22.62** | **0.25** | **0.11** |
| … the references' count | 5.43 | 2.82 | 0.03 | 0.02 |
| … the homes | 5.43 | 5.03 | 0.06 | 0.02 |
| … the frame's layout | 10.19 | 8.55 | 0.09 | 0.03 |
| … the prologue and the epilogue | 8.91 | 6.23 | 0.07 | 0.04 |
| **the records' emission** | **71.38** | **40.36** | **0.28** | **0.50** |
| … expansion: hole blocks, a permute and a store an entry | 38.74 | 21.99 | 0.12 | 0.32 |
| … the deferred entries' records (calls, division, copies) | 23.86 | 12.70 | 0.12 | 0.13 |
| … the output's arrays and the code's close | 8.78 | 5.66 | 0.04 | 0.05 |
| **the encoder** | **17.49** | **7.71** | **0.04** | **0.09** |
| **branch sizing** | **16.02** | **12.94** | **0.07** | **0.31** |
| … the branch columns' check | 3.02 | 1.17 | 0.01 | 0.07 |
| … the records' lengths (x86_measure) | 8.65 | 6.84 | 0.02 | 0.14 |
| … size_branches | 4.36 | 4.93 | 0.04 | 0.10 |
| **the atoms and relocations** | **51.07** | **19.17** | **0.20** | **0.22** |
| … the symbols and their names | 14.28 | 6.40 | 0.05 | 0.12 |
| … the atoms and their fixups | 20.78 | 7.21 | 0.06 | 0.09 |
| … link_check | 16.02 | 5.56 | 0.09 | 0.01 |
| **the object's sections** | **27.55** | **23.29** | **0.30** | **0.20** |
| … object_prepare and object_build | 25.27 | 20.35 | 0.25 | 0.12 |
| … the driver's object: sections, the file | 2.28 | 2.95 | 0.04 | 0.08 |
| **the unwind table** | **64.07** | **34.56** | **0.33** | **0.15** |
| … the frames' events from Tier 0's code | 18.36 | 10.59 | 0.11 | 0.04 |
| … the rows resolved and checked | 35.65 | 16.29 | 0.16 | 0.07 |
| … the table written (.eh_frame) | 10.05 | 7.68 | 0.06 | 0.04 |
| **the emission's driver** | **44.37** | **40.96** | **0.28** | **0.94** |
| … the bodies' loop, the windows, what the merge keeps | 43.16 | 38.58 | 0.27 | 0.91 |
| … the inline callees' table (check_tier1_inline_table) | 1.14 | 0.23 | 0.00 | 0.03 |
| … the inline asm's bodies (the assembler) | 0.07 | 2.15 | 0.01 | 0.00 |
| **the static data's atoms** | **4.89** | **3.92** | **0.03** | **0.06** |
| **Tier 0's validation (the lowering's check, in `lower`)** | **40.35** | **30.84** | **0.31** | **0.26** |
| **the process** | **300.45** | **395.44** | **1.85** | **3.83** |
| **libc, caller not in the stack** | **25.87** | **52.62** | **0.05** | **12.57** |
| … memset | 15.41 | 43.20 | 0.02 | 12.08 |
| … memmove and memcpy | 0.34 | 1.41 | 0.00 | 0.16 |
| … memcmp | 3.28 | 2.88 | 0.00 | 0.26 |
| … strings | 6.84 | 5.13 | 0.02 | 0.08 |
| **the lowering** | **624.36** | **284.19** | **2.80** | **3.78** |
| **the front end** | **12801.24** | **4998.02** | **37.65** | **90.95** |
| … the preprocessor and the lexer | 5042.70 | 1911.10 | 15.71 | 44.69 |
| … the parser | 762.22 | 307.66 | 1.46 | 5.11 |
| … the checker | 6970.93 | 2763.34 | 20.33 | 40.82 |
| … the static data's plan (check_data_prepare) | 25.40 | 15.92 | 0.15 | 0.33 |
| **unmatched** | **7.77** | **20.11** | **0.12** | **0.13** |
| **the row** | **453.79** | **273.13** | **2.30** | **3.69** |
| **the issue's eight parts** | **340.46** | **193.70** | **1.66** | **2.55** |
| **their share of the row, %** | **75.03** | **70.92** | **72.06** | **68.90** |
| **every sample** | **14253.83** | **6054.35** | **45.10** | **115.22** |
