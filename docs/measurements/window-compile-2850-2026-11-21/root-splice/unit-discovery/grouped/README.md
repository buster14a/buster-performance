# Group-aware source discovery for integer arithmetic

This private diagnostic experiment measures the cost and coverage of screening a translation unit before enabling the integer arithmetic window. The source scans existing expression-action bytes and uses parser-parent links to walk through parentheses in macro expansions. It confirms an eligible bottom-level unary or binary operation with the existing decoder and arithmetic rules. The clock, source-index handoff, and accepted operand family match the profile-integrated shipping experiment.

With the threshold set to one, every positive unit stays enabled and every empty unit stays on the ordinary path in the four frozen inputs. All 2,895 musl accepted operands survive, including 255 in one macro-expanded table. All 781 Lua roots survive. The complete per-unit matrix compares threshold zero, one, four and sixteen against the existing arithmetic graph counts and complete ELF. All 5,488 compilations match their expected count and object.

| Input | Units requiring the window | Units bypassed | Ordinary nodes removed at threshold one |
|---|---:|---:|---:|
| SQLite | 1 | 0 | 4,759 |
| Buster compiler | 1 | 0 | 67,186 |
| Lua | 30 | 4 | 1,986 |
| musl | 754 | 582 | 4,005 |

The local development-build screen on the Ryzen 9 7940HS uses one pinned core, a warmup and three fresh process samples per variant. The eight variants emit identical full-corpus object manifests and diagnostics on each input. The unfiltered option, adjacent-only threshold one and grouped threshold one respectively cost 11.247M, 6.701M and 12.358M extra retired user instructions compared with the ordinary mode on full musl. Including grouping therefore costs 1.112M user instructions over the unfiltered option, despite removing all 582 empty-unit scans. Its source-prediction accuracy did not translate to a reduction in retired instructions. The results retain the unfiltered arithmetic path. Local elapsed and cycle samples include concurrent work and the instrumented command. They are diagnostic observations. The production four-workload throughput records use a separate locked host.

The source patch applies to the combined source tree shared by 27441f465 and fcccbaf80. In screen-pmu.tsv, parent runs the unmodified combined driver in ordinary mode and original-on enables its arithmetic window. Plain is the research executable ordinary mode. At0 enables the unfiltered arithmetic window in that executable. At1 enables the adjacent-only threshold of one. T1, t4 and t16 enable grouped thresholds. The source-prediction matrix uses t0 with full reporting for its no-filter reference. Independent differences in compiler images are retained in the raw table.
