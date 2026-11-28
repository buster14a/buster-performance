# Grouped function declarators in the vector parser

The parent is buster14a/buster@cc7d4ffb449c1f57d8d867c2ad2bf6dc6bfebc7f. The K6 body check reads declarations backwards in blocks of sixteen. A declarator containing one ordinary name in parentheses immediately followed by the function’s parameter list can take the vector path. The scan continues to the preceding declaration boundary to check for a comma, typedef or another group. More complicated declarators can still reach the fallback.

## Aligned parser inputs

All 557 parser snippets ran at each of 64 preceding token alignments in the parent and candidate. For all 35,648 parses, the token counts, errors, diagnostics with their recovery fields, and all available tree and traversal columns for accepted inputs had matching byte representations. Only snippet 259 changed its route. It defines `int (q)(int x)` and `int *(r)(void)`. Across the alignments the candidate removed 128 fallback items and 1,664 reparsed tokens. The sole change in the parser suite’s frozen digests is the alignments row, which also includes the K6 flags and fallback counts. The full locked 9700X parser suite passed, including all 557 Clang syntax cases, the manually checked trees, and the tiled and borrowed-scratch checks.

The standalone Release-optimized native probes also compared nine parser issue fixtures. Their serialized trees and diagnostics matched. A further 768 generated declarations varied grouping, pointer and array forms, parameters, malformed bodies and declarations.

| Fixture | Tokens | Parent fallback items | Candidate fallback items | Parent fallback tokens | Candidate fallback tokens |
| --- | ---: | ---: | ---: | ---: | ---: |
| alignas | 11 | 1 | 1 | 7 | 7 |
| asm | 27 | 2 | 2 | 27 | 27 |
| availability | 19 | 1 | 1 | 19 | 19 |
| c23 | 18 | 1 | 1 | 8 | 8 |
| generic | 22 | 1 | 1 | 22 | 22 |
| group | 12 | 1 | 0 | 12 | 0 |
| knr | 20 | 2 | 2 | 17 | 17 |
| localtypedef | 19 | 0 | 0 | 0 | 0 |
| restrict | 31 | 2 | 2 | 31 | 31 |

[Candidate, fixture sources, per-snippet hashes, Clang suite and native logs](grouped-oracles.tar.xz)

## Fallback declarations on compiler sources

The parent compiler parsed each preprocessed translation unit on the locked 9700X. The probe recorded every flagged token in the ordinary item path and compared the vector roles, depths and parents with the columns after scalar repair. The tree comparison excludes whole-unit kernel failures. A matching tree alone does not establish that a fallback can be removed, since parsing also checks diagnostics and type-name visibility.

| Corpus | Files | Tokens | Files reparsed | Items reparsed | Tokens reparsed | Items with changed tree columns | Items with identical columns | Whole units | Files with errors | Items with a flagged asm keyword |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | 34 | 571,903 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| sqlite | 1 | 716,136 | 1 | 6 | 8,391 | 5 | 1 | 0 | 0 | 0 |
| musl | 1,336 | 5,039,561 | 553 | 7,570 | 398,386 | 0 | 7,570 | 0 | 0 | 6,982 |

| Flagged input kind | Kind index | Occurrences |
| --- | ---: | ---: |
| STRING | 5 | 45,753 |
| R_PAREN | 9 | 31,952 |
| L_PAREN | 8 | 31,945 |
| COLON | 47 | 20,191 |
| COMMA | 51 | 19,760 |
| ASM | 61 | 6,982 |
| QUALIFIER | 55 | 6,236 |
| NUMBER | 3 | 597 |
| STORAGE | 58 | 587 |
| L_BRACE | 10 | 12 |
| GENERIC | 66 | 5 |
| QUESTION | 46 | 5 |
| TYPE | 52 | 5 |
| STAR | 17 | 5 |
| DEFAULT | 75 | 5 |
| IDENTIFIER | 2 | 5 |
| R_SQUARE | 7 | 5 |

[Source inputs, native commands and per-token and declaration records](source-census.tar.xz)
