| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **1.05** | **0.93** | **0.01** | **0.01** |
| … the columns' room and the labels | 0.73 | 0.71 | 0.01 | 0.01 |
| … the values' predicates (P0) | 0.23 | 0.12 | 0.00 | 0.00 |
| … the depths (P4) | 0.10 | 0.10 | 0.00 | 0.00 |
| **the selection** | **2.22** | **2.36** | **0.02** | **0.03** |
| … fusion (P1 to P3) | 0.48 | 0.34 | 0.00 | 0.01 |
| … the templates' words (selection's gather) | 0.69 | 0.95 | 0.00 | 0.01 |
| … measuring: the homes' case, lengths, positions | 0.33 | 0.43 | 0.00 | 0.00 |
| … measuring: a deferred entry's records counted | 0.27 | 0.44 | 0.01 | 0.00 |
| … the immediates' forms: the requests chosen | 0.05 | 0.08 | 0.00 | 0.00 |
| … the immediates' forms: applied to the records | 0.39 | 0.12 | 0.00 | 0.01 |
| **the homes and the frame** | **0.66** | **1.47** | **0.02** | **0.01** |
| … the references' count | 0.09 | 0.10 | 0.00 | 0.00 |
| … the homes | 0.12 | 0.27 | 0.00 | 0.00 |
| … the frame's layout | 0.29 | 0.64 | 0.01 | 0.00 |
| … the prologue and the epilogue | 0.16 | 0.46 | 0.01 | 0.00 |
| **the records' emission** | **2.91** | **2.61** | **0.03** | **0.02** |
| … expansion: hole blocks, a permute and a store an entry | 0.99 | 0.93 | 0.01 | 0.01 |
| … the deferred entries' records (calls, division, copies) | 0.57 | 0.56 | 0.01 | 0.00 |
| … the output's arrays and the code's close | 0.26 | 0.52 | 0.01 | 0.00 |
| … the x87 values' transfers (long double) | 1.09 | 0.59 | 0.01 | 0.00 |
| **the encoder** | **0.44** | **0.37** | **0.00** | **0.00** |
| **branch sizing** | **0.33** | **0.64** | **0.00** | **0.01** |
| … the branch columns' check | 0.02 | 0.05 | 0.00 | 0.00 |
| … the records' lengths (x86_measure) | 0.10 | 0.34 | 0.00 | 0.00 |
| … size_branches | 0.21 | 0.25 | 0.00 | 0.00 |
| **the atoms and relocations** | **0.93** | **1.24** | **0.02** | **0.01** |
| … the symbols and their names | 0.18 | 0.37 | 0.00 | 0.00 |
| … the atoms and their fixups | 0.60 | 0.60 | 0.01 | 0.00 |
| … link_check | 0.15 | 0.26 | 0.01 | 0.00 |
| **the object's sections** | **1.16** | **2.43** | **0.04** | **0.04** |
| … object_prepare and object_build | 0.90 | 1.75 | 0.03 | 0.01 |
| … the driver's object: sections, the file | 0.26 | 0.68 | 0.01 | 0.03 |
| **the unwind table** | **0.01** | **0.03** | **0.00** | **0.00** |
| **the emission's driver** | **3.47** | **6.91** | **0.08** | **0.09** |
| … the bodies' loop, the windows, what the merge keeps | 2.40 | 4.26 | 0.05 | 0.07 |
| … the inline callees' table (check_tier1_inline_table) | 0.01 | 0.05 | 0.00 | 0.00 |
| … the inline asm's bodies (the assembler) | 1.06 | 2.61 | 0.03 | 0.01 |
| **the static data's atoms** | **1.35** | **0.43** | **0.00** | **0.01** |
| **Tier 0's validation (the lowering's check, in `lower`)** | **1.04** | **1.93** | **0.03** | **0.02** |
| **the process** | **56.51** | **86.92** | **0.56** | **0.89** |
| **libc, caller not in the stack** | **3.39** | **4.91** | **0.01** | **1.02** |
| … memset | 1.54 | 3.09 | 0.00 | 0.91 |
| … memmove and memcpy | 0.13 | 0.48 | 0.00 | 0.03 |
| … memcmp | 0.10 | 0.15 | 0.00 | 0.02 |
| … strings | 1.62 | 1.19 | 0.01 | 0.06 |
| **the lowering** | **53.59** | **26.57** | **0.35** | **0.37** |
| **the front end** | **1356.22** | **527.26** | **4.08** | **8.36** |
| … the preprocessor and the lexer | 438.47 | 154.13 | 1.23 | 3.47 |
| … the parser | 94.67 | 38.27 | 0.27 | 0.57 |
| … the checker | 819.02 | 333.10 | 2.56 | 4.30 |
| … the static data's plan (check_data_prepare) | 4.06 | 1.76 | 0.02 | 0.03 |
| **unmatched** | **7.89** | **9.46** | **0.05** | **0.07** |
| **the row** | **14.52** | **19.42** | **0.23** | **0.23** |
| **the issue's eight parts** | **9.69** | **12.04** | **0.14** | **0.13** |
| **their share of the row, %** | **66.77** | **62.02** | **62.60** | **56.79** |
| **every sample** | **1493.16** | **676.46** | **5.31** | **10.96** |
