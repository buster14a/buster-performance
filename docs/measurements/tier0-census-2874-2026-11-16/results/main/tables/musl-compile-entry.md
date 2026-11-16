| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **39.74** | **35.19** | **0.44** | **0.39** |
| … the columns' room and the labels | 27.38 | 26.84 | 0.36 | 0.20 |
| … the values' predicates (P0) | 8.77 | 4.62 | 0.04 | 0.08 |
| … the depths (P4) | 3.60 | 3.72 | 0.04 | 0.11 |
| **the selection** | **83.57** | **88.74** | **0.74** | **1.24** |
| … fusion (P1 to P3) | 18.01 | 12.79 | 0.14 | 0.39 |
| … the templates' words (selection's gather) | 25.94 | 35.67 | 0.18 | 0.35 |
| … measuring: the homes' case, lengths, positions | 12.49 | 16.21 | 0.18 | 0.08 |
| … measuring: a deferred entry's records counted | 10.33 | 16.45 | 0.20 | 0.08 |
| … the immediates' forms: the requests chosen | 2.04 | 3.00 | 0.03 | 0.13 |
| … the immediates' forms: applied to the records | 14.77 | 4.62 | 0.01 | 0.20 |
| **the homes and the frame** | **24.74** | **55.42** | **0.75** | **0.26** |
| … the references' count | 3.24 | 3.60 | 0.06 | 0.01 |
| … the homes | 4.44 | 10.33 | 0.15 | 0.07 |
| … the frame's layout | 11.05 | 24.02 | 0.31 | 0.09 |
| … the prologue and the epilogue | 6.00 | 17.47 | 0.23 | 0.10 |
| **the records' emission** | **109.51** | **98.17** | **1.18** | **0.76** |
| … expansion: hole blocks, a permute and a store an entry | 37.22 | 35.12 | 0.22 | 0.41 |
| … the deferred entries' records (calls, division, copies) | 21.61 | 21.14 | 0.27 | 0.15 |
| … the output's arrays and the code's close | 9.73 | 19.69 | 0.29 | 0.16 |
| … the x87 values' transfers (long double) | 40.95 | 22.22 | 0.40 | 0.04 |
| **the encoder** | **16.69** | **14.11** | **0.09** | **0.12** |
| **branch sizing** | **12.37** | **24.08** | **0.16** | **0.35** |
| … the branch columns' check | 0.60 | 1.98 | 0.04 | 0.04 |
| … the records' lengths (x86_measure) | 3.72 | 12.73 | 0.04 | 0.18 |
| … size_branches | 8.04 | 9.37 | 0.08 | 0.13 |
| **the atoms and relocations** | **34.94** | **46.71** | **0.63** | **0.35** |
| … the symbols and their names | 6.60 | 13.99 | 0.14 | 0.14 |
| … the atoms and their fixups | 22.69 | 22.76 | 0.29 | 0.16 |
| … link_check | 5.64 | 9.97 | 0.20 | 0.06 |
| **the object's sections** | **43.71** | **91.39** | **1.37** | **1.50** |
| … object_prepare and object_build | 33.98 | 65.75 | 1.00 | 0.41 |
| … the driver's object: sections, the file | 9.73 | 25.64 | 0.37 | 1.09 |
| **the unwind table** | **0.36** | **1.26** | **0.01** | **0.05** |
| **the emission's driver** | **130.64** | **260.47** | **3.10** | **3.26** |
| … the bodies' loop, the windows, what the merge keeps | 90.30 | 160.37 | 1.93 | 2.61 |
| … the inline callees' table (check_tier1_inline_table) | 0.36 | 1.86 | 0.03 | 0.12 |
| … the inline asm's bodies (the assembler) | 39.98 | 98.23 | 1.14 | 0.53 |
| **the static data's atoms** | **50.79** | **16.21** | **0.08** | **0.48** |
| **Tier 0's validation (the lowering's check, in `lower`)** | **39.26** | **72.77** | **1.06** | **0.63** |
| **the process** | **2128.90** | **3274.73** | **21.19** | **33.48** |
| **libc, caller not in the stack** | **127.64** | **184.87** | **0.53** | **38.43** |
| … memset | 58.00 | 116.48 | 0.17 | 34.20 |
| … memmove and memcpy | 5.04 | 17.95 | 0.04 | 1.14 |
| … memcmp | 3.72 | 5.52 | 0.01 | 0.83 |
| … strings | 60.88 | 44.91 | 0.31 | 2.26 |
| **the lowering** | **2019.16** | **1000.91** | **13.28** | **14.05** |
| **the front end** | **51097.37** | **19865.02** | **153.79** | **315.04** |
| … the preprocessor and the lexer | 16519.94 | 5806.91 | 46.41 | 130.61 |
| … the parser | 3566.66 | 1441.99 | 10.13 | 21.38 |
| … the checker | 30857.67 | 12549.83 | 96.45 | 161.94 |
| … the static data's plan (check_data_prepare) | 153.09 | 66.29 | 0.80 | 1.11 |
| **unmatched** | **297.30** | **356.41** | **1.83** | **2.47** |
| **the row** | **547.05** | **731.74** | **8.55** | **8.77** |
| **the issue's eight parts** | **365.26** | **453.80** | **5.35** | **4.98** |
| **their share of the row, %** | **66.77** | **62.02** | **62.60** | **56.79** |
| **every sample** | **56256.69** | **25486.45** | **200.22** | **412.87** |
