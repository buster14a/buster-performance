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

## File-scope and block assembly statements

The candidate recognizes file-scope assembly with string templates and block assembly statements whose operands and clobbers fit one 64-token window. It checks the statement boundary, modifier, parenthesis, strings, up to three operand sections and the terminator. An unresolved flag elsewhere in a declaration still sends that declaration to the repair parser.

Four builds parsed every translation unit in the pinned Lua, SQLite and musl inputs using the same headers and predefines. The probes serialized all returned tree columns and diagnostics. Their SHA-256 hashes matched in each workload. The table counts top-level reparses and their tokens. The assembly operand checks removed 6,791 reparses in musl beyond the grouped-declarator change.

| Corpus | Files | Input tokens | Parent items | Grouped names | File-scope asm | With block asm | Parent tokens reparsed | Final tokens reparsed |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | 34 | 571,903 | 0 | 0 | 0 | 0 | 0 | 0 |
| sqlite | 1 | 716,136 | 6 | 6 | 6 | 6 | 8,391 | 8,391 |
| musl | 1,336 | 5,039,561 | 7,570 | 7,561 | 7,561 | 770 | 398,386 | 35,230 |

The block candidate also matched the grouped-name revision on all 557 snippets at 64 token alignments, including their route counters. Separate differential cases covered 1,440 file-scope inputs and 6,076 block inputs in each of six C and GNU dialects. All serialized results matched their respective controls. Six faults in syntax validation changed a tree or diagnostic. Disabling either recognition path changed the positive fixtures' reparse counts. Both candidates passed the complete Clang-backed parser suite on the Ryzen 7 9700X.

These are coverage and correctness measurements. The native per-size and whole-compile measurements run separately.

[Production patch, probe and fixture generators, corpus hashes, per-file counters, fault results and native parser logs](assembly-statements.tar.xz)

## Static parameter bounds and pointer casts in asm operands

The parent flagged the initial `static` and first constant in named array parameters such as `char buf[static 15 + 3 * sizeof(int)]`. The candidate verifies the parameter and its brackets, then checks every token in the constant expression using packet masks. Only those first two flags are covered by that check. An independent change handles memory operands such as `"m"(*(void *volatile *)p)`. After validating the pointer type, the parser compresses the remaining token kinds into the same operand checker used for plain dereferences.

| Corpus | Files | Parent reparses | Plain asm | With array bounds | With pointer casts | Parent tokens reparsed | Final tokens reparsed |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | 34 | 0 | 0 | 0 | 0 | 0 | 0 |
| sqlite | 1 | 6 | 6 | 6 | 6 | 8,391 | 8,391 |
| musl | 1,336 | 7,570 | 770 | 198 | 7 | 398,386 | 4,294 |

The candidate matched every returned tree, traversal column and diagnostic in the three corpora. Seven musl declarations in seven files still reached the repair parser. SQLite retained its six reparses. The two changes also preserved the results and route counts of all 35,648 aligned parser snippets.

The bounds tests covered 5,705 sources and the asm operand tests covered 10,885 sources, each in six dialects. The parent and candidate produced byte-identical serialized results. The 9700X parser suite passed with Clang, including eleven fixed trees. Eight mutations to the bound checks, pointer grammar, unresolved-flag handling or positive coverage changed the expected results. Four changed a tree or diagnostic and the other four changed route counts.

[Compiler patch, positive and negative cases, source generators, per-file counters and result hashes](bounds-and-casts.tar.xz)

## End-to-end compilation with grouped function names

Each cell compares five paired rounds of three ordinary compiler processes on the locked 9700X. The table gives the median change in user cycles for a single-lane debug build relative to the parent. All 2,742 objects, standard output and diagnostics matched.

| Corpus | Tier 0 | Tier 1 |
| --- | ---: | ---: |
| lua | +0.171% | +0.332% |
| sqlite | +0.075% | +0.232% |
| musl | -0.081% | +0.034% |

[Native compiler runs, input commands and object manifests](compile-grouped.tar.xz)
