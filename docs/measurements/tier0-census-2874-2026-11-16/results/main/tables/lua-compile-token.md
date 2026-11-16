| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **6.32** | **2.77** | **0.02** | **0.04** |
| … the columns' room and the labels | 4.13 | 1.71 | 0.01 | 0.02 |
| … the values' predicates (P0) | 1.26 | 0.62 | 0.01 | 0.01 |
| … the depths (P4) | 0.93 | 0.44 | 0.00 | 0.01 |
| **the selection** | **13.58** | **7.82** | **0.06** | **0.13** |
| … fusion (P1 to P3) | 3.39 | 1.60 | 0.01 | 0.04 |
| … the templates' words (selection's gather) | 3.25 | 2.52 | 0.01 | 0.05 |
| … measuring: the homes' case, lengths, positions | 3.48 | 1.72 | 0.02 | 0.01 |
| … measuring: a deferred entry's records counted | 1.77 | 1.04 | 0.01 | 0.01 |
| … the immediates' forms: the requests chosen | 0.37 | 0.38 | 0.00 | 0.01 |
| … the immediates' forms: applied to the records | 1.31 | 0.56 | 0.00 | 0.02 |
| **the homes and the frame** | **4.69** | **3.54** | **0.04** | **0.02** |
| … the references' count | 0.85 | 0.44 | 0.00 | 0.00 |
| … the homes | 0.85 | 0.79 | 0.01 | 0.00 |
| … the frame's layout | 1.60 | 1.34 | 0.01 | 0.01 |
| … the prologue and the epilogue | 1.40 | 0.98 | 0.01 | 0.01 |
| **the records' emission** | **11.18** | **6.32** | **0.04** | **0.08** |
| … expansion: hole blocks, a permute and a store an entry | 6.07 | 3.44 | 0.02 | 0.05 |
| … the deferred entries' records (calls, division, copies) | 3.74 | 1.99 | 0.02 | 0.02 |
| … the output's arrays and the code's close | 1.38 | 0.89 | 0.01 | 0.01 |
| **the encoder** | **2.74** | **1.21** | **0.01** | **0.01** |
| **branch sizing** | **2.51** | **2.03** | **0.01** | **0.05** |
| … the branch columns' check | 0.47 | 0.18 | 0.00 | 0.01 |
| … the records' lengths (x86_measure) | 1.35 | 1.07 | 0.00 | 0.02 |
| … size_branches | 0.68 | 0.77 | 0.01 | 0.02 |
| **the atoms and relocations** | **8.00** | **3.00** | **0.03** | **0.03** |
| … the symbols and their names | 2.24 | 1.00 | 0.01 | 0.02 |
| … the atoms and their fixups | 3.25 | 1.13 | 0.01 | 0.01 |
| … link_check | 2.51 | 0.87 | 0.01 | 0.00 |
| **the object's sections** | **4.32** | **3.65** | **0.05** | **0.03** |
| … object_prepare and object_build | 3.96 | 3.19 | 0.04 | 0.02 |
| … the driver's object: sections, the file | 0.36 | 0.46 | 0.01 | 0.01 |
| **the unwind table** | **10.04** | **5.41** | **0.05** | **0.02** |
| … the frames' events from Tier 0's code | 2.88 | 1.66 | 0.02 | 0.01 |
| … the rows resolved and checked | 5.59 | 2.55 | 0.03 | 0.01 |
| … the table written (.eh_frame) | 1.57 | 1.20 | 0.01 | 0.01 |
| **the emission's driver** | **6.95** | **6.42** | **0.04** | **0.15** |
| … the bodies' loop, the windows, what the merge keeps | 6.76 | 6.04 | 0.04 | 0.14 |
| … the inline callees' table (check_tier1_inline_table) | 0.18 | 0.04 | 0.00 | 0.00 |
| … the inline asm's bodies (the assembler) | 0.01 | 0.34 | 0.00 | 0.00 |
| **the static data's atoms** | **0.77** | **0.61** | **0.01** | **0.01** |
| **Tier 0's validation (the lowering's check, in `lower`)** | **6.32** | **4.83** | **0.05** | **0.04** |
| **the process** | **47.07** | **61.95** | **0.29** | **0.60** |
| **libc, caller not in the stack** | **4.05** | **8.24** | **0.01** | **1.97** |
| … memset | 2.41 | 6.77 | 0.00 | 1.89 |
| … memmove and memcpy | 0.05 | 0.22 | 0.00 | 0.02 |
| … memcmp | 0.51 | 0.45 | 0.00 | 0.04 |
| … strings | 1.07 | 0.80 | 0.00 | 0.01 |
| **the lowering** | **97.82** | **44.52** | **0.44** | **0.59** |
| **the front end** | **2005.56** | **783.03** | **5.90** | **14.25** |
| … the preprocessor and the lexer | 790.03 | 299.41 | 2.46 | 7.00 |
| … the parser | 119.42 | 48.20 | 0.23 | 0.80 |
| … the checker | 1092.13 | 432.93 | 3.19 | 6.39 |
| … the static data's plan (check_data_prepare) | 3.98 | 2.49 | 0.02 | 0.05 |
| **unmatched** | **1.22** | **3.15** | **0.02** | **0.02** |
| **the row** | **71.09** | **42.79** | **0.36** | **0.58** |
| **the issue's eight parts** | **53.34** | **30.35** | **0.26** | **0.40** |
| **their share of the row, %** | **75.03** | **70.92** | **72.06** | **68.90** |
| **every sample** | **2233.13** | **948.53** | **7.07** | **18.05** |
