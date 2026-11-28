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
