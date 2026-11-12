| | `sqlite3.c` | musl's 1,336 units |
| --- | ---: | ---: |
| function bodies | 2,668 | 2,756 |
| evaluated nodes | 266,707 | 131,092 |
| full expressions | 52,368 | 26,451 |
| typed entries; the nodes' own and their conversions | 406,765; 376,035 | 207,461; 185,089 |
| **T** leaves | 112,185 (42.1%) | 58,269 (44.4%) |
| nodes typed by the table | 59,298 (22.2%) | 36,504 (27.8%) |
| nodes whose facts a lookup gives | 95,224 (35.7%) | 36,319 (27.7%) |
| type keys; of one node; in conflict | 3,075; 1,190; 0 | 2,835; 1,000; 0 |
| **C** operands; given (a call's, a builtin's) | 214,339; 34,423 (16.1%) | 104,641; 12,522 (12.0%) |
| context keys; of one operand; in conflict | 9,742; 4,078; 0 | 9,476; 3,733; 14 |
| **X** template keys; of one node; in conflict | 2,400; 623; 3 | 2,396; 574; 4 |
| templates | 787 | 865 |
| rebuilt keys that differ from the lowering's | 0 | 0 |
| nodes that write before or between their operands | 5,770 (2.2%) | 3,616 (2.8%) |
| **taken** full expressions | 50,873 (97.1%) | 24,594 (93.0%) |
| nodes in them | 257,465 (96.5%) | 115,610 (88.2%) |
| entries, of the nodes' | 346,998 (92.3%) | 154,132 (83.3%) |
| emitted entries that differ from the stream's | 0 | 0 |

Refused in `sqlite3.c`:

| expressions | nodes | why, and the operator of the first such node |
| ---: | ---: | --- |
| 450 | 2,459 (0.92%) | an entry where a template has no run (inside an operand's entries, or between operands past the third); first such node's operator: \|= 182 &= 100 += 48 x++ 47 x-- 34 |
| 977 | 6,297 (2.36%) | a node of more than 16 entries, or of a run of more than 8; first such node's operator: x++ 279 = 188 . 165 -> 143 va_arg 114 |
| 68 | 486 (0.18%) | a template key in conflict or unknown; first such node's operator: = 48 builtin-atomic 20 |

Refused in musl's 1,336 units:

| expressions | nodes | why, and the operator of the first such node |
| ---: | ---: | --- |
| 483 | 4,235 (3.23%) | a node the tasks popped again; first such node's operator: value 483 |
| 39 | 186 (0.14%) | an entry where a template has no run (inside an operand's entries, or between operands past the third); first such node's operator: &= 12 -= 9 += 6 \|= 6 x++ 2 |
| 342 | 2,770 (2.11%) | a node of more than 16 entries, or of a run of more than 8; first such node's operator: x++ 144 va_arg 126 x-- 45 -> 7 = 6 |
| 2 | 8 (0.01%) | a context key in conflict or unknown; first such node's operator: convert 2 |
| 991 | 8,283 (6.32%) | a template key in conflict or unknown; first such node's operator: value 933 = 58 |

| a node of the unit, the median of three runs | `sqlite3.c`: cycles | instructions | mispredicted branches | musl's 1,336 units: cycles | instructions | mispredicted branches |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| T | 15.8 | 30.3 | 0.31 | 16.9 | 34.0 | 0.34 |
| C | 32.1 | 68.4 | 0.52 | 30.5 | 69.7 | 0.48 |
| the templates' choice | 37.2 | 94.9 | 0.61 | 36.5 | 94.5 | 0.60 |
| the expansion | 21.3 | 53.7 | 0.32 | 21.0 | 53.4 | 0.32 |
| the four, a unit at a time | 106.4 | 247.3 | 1.76 | 104.8 | 251.6 | 1.74 |
| the four, an expression at a time | 99.7 | 263.6 | 1.16 | 100.6 | 268.4 | 1.16 |
| the four, an expression at a time, a taken node | 103.3 | 273.0 |  | 114.0 | 304.3 | |

The three runs' cycles a node, an expression at a time: `sqlite3.c` 99.5 to 101.7; musl's 1,336 units 98.3 to 100.6.

| a unit by the other's tables | `sqlite3.c` by musl's | musl by `sqlite3.c`'s |
| --- | ---: | ---: |
| nodes the table types: answered; of those, wrong | 51,514 of 59,298; 0 | 27,324 of 36,504; 0 |
| operands the table is asked: answered; nodes whose context or target is wrong | 150,511 of 179,916; 0 | 61,510 of 92,119; 0 |
| nodes in taken expressions | 158,270 (59.3%) | 54,603 (41.7%) |
| emitted entries; of those, differing from the stream's | 192,992; 0 | 70,270; 23 |
