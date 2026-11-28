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

## Generic selections, qualified parameters and grouped function definitions

The vector parser validates qualifier-only parameter arrays, addressed pointer compound literals and grouped function definitions. The secondary operator pass pairs a generic association’s colon at its own nesting level and retains nested conditional-expression pairs. The bounded selection check recognizes the type or default at each association, checks the raw closing punctuation, and verifies operand adjacency and the final operand. Other forms still reach the existing parser. Two new diagnostics freeze the closing punctuation for inline assembly, and two more cover malformed generic selections.

| Corpus | Translation units | Tokens | Original declaration reparses | Static bounds and asm casts | Qualified parameters and pointer forms | With generic selections |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | 34 | 571,903 | 0 | 0 | 0 | 0 |
| sqlite | 1 | 716,136 | 6 | 6 | 5 | 0 |
| musl | 1,336 | 5,039,561 | 7,570 | 7 | 0 | 0 |

No declaration or whole unit reached the scalar parser in these three corpora. Each corpus retained the original serialized tree and diagnostics. The five SQLite function bodies that previously needed reparsing have three corrected roles and seven corrected parent links each. Other real sources and error-recovery views may still use the fallback.

The 9700X Clang-backed suite passed 561 snippets, sixteen fixed trees, 35,904 aligned inputs, generated streams, deep nesting and the driver checks. The old and new parsers gave byte-identical results on the original 557 snippets at all 64 alignments. The four new negative snippets were checked at all alignments against the parent before recording the revised alignment digest. The other frozen batches retained their digests.

The qualifier, compound literal and function-pointer matrix covered 32,055 sources per dialect across six dialects. The generic selection matrix covered 28,870 per dialect across eight dialects. All 2,736 delimiter mutations retained their trees and diagnostics. A separate matrix included 14,742 cases per dialect at packet boundaries and in surrounding declaration and expression contexts, comparing preprocessing status and diagnostics as well as parser outputs. Ten deliberate faults changed trees, diagnostics or fallback counts.

[Compiler patches, source generators, per-file counters and digests, fault results and native suite logs](generic-selections-and-delimiters.tar.xz)

## Parser cycles for each declaration and expression size

The parent (`cc7d4ffb4`) and parser draft (`f6af8f9cf`) compiled with the same Zen 5 release options. The driver preprocesses all 108 inputs, then calls the production vector parser benchmark separately for each file, keeping its timing region and hardware counters intact. Each input contains 32 declarations. Size counts array parameters, pointer expressions, generic associations or terms according to the workload. The ratios divide the candidate by its paired parent, taking the median of three rounds and 21 parsing samples per input in each round. Lower is faster. The candidate matched or improved 108 of 108 sizes in core cycles per token.

| Family | Size | Tokens | Core cycles/token ratio | Instructions/token ratio |
| --- | ---: | ---: | ---: | ---: |
| associations | 0 | 576 | 0.2737 | 0.1671 |
| associations | 1 | 768 | 0.9716 | 1.0043 |
| associations | 2 | 960 | 0.9866 | 1.0045 |
| associations | 3 | 1152 | 0.9863 | 1.0045 |
| associations | 4 | 1344 | 0.9813 | 1.0046 |
| associations | 7 | 1920 | 0.9908 | 1.0047 |
| associations | 8 | 2112 | 0.9976 | 1.0048 |
| associations | 9 | 2304 | 0.9974 | 1.0048 |
| associations | 15 | 3456 | 0.9915 | 1.0031 |
| associations | 16 | 3648 | 0.9903 | 1.0032 |
| associations | 17 | 3840 | 0.9861 | 1.0033 |
| associations | 31 | 6528 | 0.9900 | 1.0040 |
| associations | 32 | 6720 | 0.9967 | 1.0040 |
| associations | 33 | 6912 | 0.9894 | 1.0040 |
| associations | 63 | 12672 | 0.9887 | 1.0045 |
| associations | 64 | 12864 | 0.9922 | 1.0045 |
| associations | 65 | 13056 | 0.9911 | 1.0045 |
| associations | 127 | 24960 | 0.9903 | 1.0047 |
| selection | 0 | 704 | 0.2831 | 0.1694 |
| selection | 1 | 768 | 0.2829 | 0.1687 |
| selection | 2 | 832 | 0.2895 | 0.1697 |
| selection | 3 | 896 | 0.2911 | 0.1697 |
| selection | 4 | 960 | 0.2894 | 0.1699 |
| selection | 7 | 1152 | 0.2959 | 0.1701 |
| selection | 8 | 1216 | 0.2965 | 0.1703 |
| selection | 9 | 1280 | 0.2961 | 0.1697 |
| selection | 15 | 1664 | 0.3078 | 0.1706 |
| selection | 16 | 1728 | 0.3071 | 0.1707 |
| selection | 17 | 1792 | 0.3039 | 0.1703 |
| selection | 31 | 2688 | 0.9952 | 0.9993 |
| selection | 32 | 2752 | 0.9942 | 0.9993 |
| selection | 33 | 2816 | 0.9919 | 0.9993 |
| selection | 63 | 4736 | 0.9961 | 0.9997 |
| selection | 64 | 4800 | 0.9931 | 0.9997 |
| selection | 65 | 4864 | 0.9934 | 0.9997 |
| selection | 127 | 8832 | 0.9947 | 0.9999 |
| ordinary | 0 | 352 | 0.9237 | 0.8725 |
| ordinary | 1 | 416 | 0.9622 | 0.8864 |
| ordinary | 2 | 480 | 0.9422 | 0.8966 |
| ordinary | 3 | 544 | 0.9382 | 0.9055 |
| ordinary | 4 | 608 | 0.9439 | 0.9126 |
| ordinary | 7 | 800 | 0.9483 | 0.9297 |
| ordinary | 8 | 864 | 0.9453 | 0.9336 |
| ordinary | 9 | 928 | 0.9486 | 0.9375 |
| ordinary | 15 | 1312 | 0.9655 | 0.9534 |
| ordinary | 16 | 1376 | 0.9769 | 0.9552 |
| ordinary | 17 | 1440 | 0.9694 | 0.9570 |
| ordinary | 31 | 2336 | 0.9789 | 0.9722 |
| ordinary | 32 | 2400 | 0.9558 | 0.9727 |
| ordinary | 33 | 2464 | 0.9545 | 0.9732 |
| ordinary | 63 | 4384 | 0.9473 | 0.9838 |
| ordinary | 64 | 4448 | 0.9490 | 0.9840 |
| ordinary | 65 | 4512 | 0.9456 | 0.9842 |
| ordinary | 127 | 8480 | 0.9426 | 0.9911 |
| qualifiers | 0 | 192 | 0.9815 | 1.0005 |
| qualifiers | 1 | 320 | 0.2419 | 0.1283 |
| qualifiers | 2 | 512 | 0.2526 | 0.1356 |
| qualifiers | 3 | 704 | 0.2697 | 0.1430 |
| qualifiers | 4 | 896 | 0.2801 | 0.1457 |
| qualifiers | 7 | 1472 | 0.2962 | 0.1509 |
| qualifiers | 8 | 1664 | 0.2971 | 0.1515 |
| qualifiers | 9 | 1856 | 0.3002 | 0.1525 |
| qualifiers | 15 | 3008 | 0.2999 | 0.1537 |
| qualifiers | 16 | 3200 | 0.2999 | 0.1537 |
| qualifiers | 17 | 3392 | 0.3008 | 0.1538 |
| qualifiers | 31 | 6080 | 0.3010 | 0.1543 |
| qualifiers | 32 | 6272 | 0.3048 | 0.1543 |
| qualifiers | 33 | 6464 | 0.3047 | 0.1544 |
| qualifiers | 63 | 12224 | 0.3021 | 0.1547 |
| qualifiers | 64 | 12416 | 0.3014 | 0.1546 |
| qualifiers | 65 | 12608 | 0.3020 | 0.1547 |
| qualifiers | 127 | 24512 | 0.3020 | 0.1548 |
| literal | 0 | 672 | 0.2608 | 0.1507 |
| literal | 1 | 736 | 0.2666 | 0.1514 |
| literal | 2 | 800 | 0.2717 | 0.1516 |
| literal | 3 | 864 | 0.2717 | 0.1508 |
| literal | 4 | 928 | 0.2679 | 0.1510 |
| literal | 7 | 1120 | 0.2729 | 0.1499 |
| literal | 8 | 1184 | 0.2726 | 0.1501 |
| literal | 9 | 1248 | 0.2753 | 0.1496 |
| literal | 15 | 1632 | 0.2829 | 0.1494 |
| literal | 16 | 1696 | 0.2838 | 0.1494 |
| literal | 17 | 1760 | 0.2815 | 0.1490 |
| literal | 31 | 2656 | 0.2879 | 0.1477 |
| literal | 32 | 2720 | 1.0000 | 0.9985 |
| literal | 33 | 2784 | 0.9928 | 0.9985 |
| literal | 63 | 4704 | 0.9891 | 0.9990 |
| literal | 64 | 4768 | 0.9942 | 0.9990 |
| literal | 65 | 4832 | 0.9894 | 0.9990 |
| literal | 127 | 8800 | 0.9893 | 0.9993 |
| parameters | 0 | 512 | 0.2580 | 0.1305 |
| parameters | 1 | 544 | 0.2670 | 0.1385 |
| parameters | 2 | 640 | 0.2581 | 0.1310 |
| parameters | 3 | 736 | 0.2622 | 0.1332 |
| parameters | 4 | 832 | 0.2545 | 0.1289 |
| parameters | 7 | 1120 | 0.2555 | 0.1280 |
| parameters | 8 | 1216 | 0.2532 | 0.1254 |
| parameters | 9 | 1312 | 0.2560 | 0.1268 |
| parameters | 15 | 1888 | 0.2552 | 0.1236 |
| parameters | 16 | 1984 | 0.2521 | 0.1222 |
| parameters | 17 | 2080 | 0.2531 | 0.1232 |
| parameters | 31 | 3424 | 0.2420 | 0.1170 |
| parameters | 32 | 3520 | 0.2389 | 0.1156 |
| parameters | 33 | 3616 | 0.2400 | 0.1159 |
| parameters | 63 | 6496 | 0.2247 | 0.1108 |
| parameters | 64 | 6592 | 0.2262 | 0.1104 |
| parameters | 65 | 6688 | 0.2257 | 0.1107 |
| parameters | 127 | 12640 | 0.2180 | 0.1077 |

The inputs contain 576 declarations per family. Some measurements still include scalar reparsing. The counts below sum the 18 distinct sizes once.

| Family | Parent reparses | Draft reparses |
| --- | ---: | ---: |
| associations | 576 | 544 |
| selection | 576 | 224 |
| ordinary | 0 | 0 |
| qualifiers | 544 | 0 |
| literal | 576 | 192 |
| parameters | 576 | 0 |

[Source, input generator outputs and all native measurements](generic-parser-sizes.tar.xz)
