# Source member operands in a fresh native C compilation

The ordinary expression reader can publish a checked member operand from a declared local pointer and the record declarations. It walks up to 16 consecutive source-selected fields, then emits one lvalue for the expression that consumes the operand. A tape supplies the pointer, member offsets, intermediate loads, and the optional terminal load directly to native typed lowering. The source identifier and intermediate member expressions never allocate ordinary graph nodes. Stores and address-of uses share the same operand interface.

The core candidate is b87dfaa84, based on 11e5912d8. Commit 7844b9bd3 additionally keeps a member declaration's typedef when a common diagnostic prints that operand. The baseline includes the prior 3ba348162 single-field window and the a07469363 semantic member cache. Both features retain their original opt-in controls. The new mode is BUSTER_CONTROL_MEMBER_OPERANDS=1.

## Independent observations

| Object | Ordinary graph rows | New graph rows | Accepted operands | Member hops removed | Typed rows supplied by tapes | All final Tier 0 row counts |
|---|---:|---:|---:|---:|---:|---:|
| SQLite | 323,623 | 307,260 | 14,321 | 16,363 | 55,218 | 381,191 across 2,668 emitted functions |
| Buster | 1,407,416 | 1,397,209 | 9,007 | 10,207 | 36,139 | 659,942 across 1,489 emitted functions |
| Directed pointer fixture | 42 | 21 | 7 | 21 | 65 | 73 across 4 emitted functions |

The graph observer captures every retained value, kind, normalized operand, argument, conversion, warning and diagnostic at check_graph_run. The native observer captures the actual Tier0Function operations, operand classes and 64-bit immediates. Both whole objects and every final typed row compare byte-for-byte. SQLite includes 214,308 original operand edges and 34,220 original argument edges. The three raw oracle JSON summaries, compressed graph/typed observations, capture script and SHA-256 list are included. The final load remains a decision of the enclosing expression. The final typed/native operation count stays constant.

The ordinary source contains 32,623 checked member actions. The selected 16,363 occur in 1,811 functions, and 12,578 intersect the physically retained spelling census. All 516 bit-field and 1,004 inherited-qualifier uses retain ordinary checking. The selector also preserves ordinary ownership of flexible and other array terminals, marked or packed records/members, incomplete records, anonymous paths, unsupported aggregate terminals, global/static/vector bases, builtin extent queries, required source inspections and debug information. A separate aggregate-root extension 40d32d532 supports direct declared aggregate local roots followed by a pointer hop and qualified 405 policy cases. Revision 38f8d46ef additionally folds any direct-record prefix to a single symbolic displacement before its first pointer field. A five-hop probe exposed the unconsolidated prefix on 40d32d532; it now emits the exact ordinary ELF. A pure record root without a pointer hop stays on the ordinary path. An attempted pure-record expansion produced separate offsets where the ordinary layout folds them and failed byte equivalence.

The chunk poison invalidates identifier result columns and consumed action coordinates immediately upon success. The early-body poison discards typed storage after publishing the native body. The fixture runs 10,000 cases, and Clang, independent ordinary Buster and the poisoned candidate returned checksum 10156594079078175217. An independent mutation adds one byte to a selected interior field displacement. It changes the object and gives 2173703123948306953. Observable output modes and error cases retain their original content or exit status in observables.tsv. Of the 365 directed native/Clang policy combinations, all 365 match independent ordinary Buster for ELF, stdout and diagnostics. The independent clean compiler disagrees with Clang exit status in 15 existing comparisons, including unsupported extended vector selections. Those cases remain visible in edge.tsv.

## Physical selector composition

The companion descendant of 921845259 consumes the parser-issued borrowed spelling while the use-site name is still zero. The eligible record declaration supplies the canonical identity, offset, type and field slot. Earlier run 0522e0861 emits an exact SQLite object with all-early native bodies from the combined path. It accepts 14,340 source-local operands covering 16,382 member operations. The 12,597 actual source-held operations all had a zero parser name when the declaration supplied the first identity. All independently recorded slots and bit offsets agree. A further 1,220 source-held lookups occurred during preflight for ordinary fallback and are excluded from this count. The combined early-body and chunk poison were enabled. An earlier Buster self-build failed even with chains disabled because the underlying PP study did not return canonical names on some declined bodies. The scoped owner handoff is recorded separately with its revision and qualification.

## Fresh local timing

The candidate/source switch was the only variable within each pair. The argv, optimized configured Develop executable, compiler input and exact SQLite ELF were identical across 96 fresh-process runs. Ten mirrored rotated rounds measure wall, CPU, faults and RSS, and six separate rounds collect native userspace cycles and instructions. A leased Ryzen 9 7940HS core ran the tests. The locked 9700X acceptance host was not used for this candidate.

| Mode | Paired fresh wall | Paired cycles | Paired instructions |
|---|---:|---:|---:|
| Ordinary object compilation | -9.137 ms (-3.03%) | +0.44% | +6.359 M (+0.48%) |
| Prior single-field window | +9.793 ms (+3.25%) | -2.22% | +12.958 M (+0.93%) |
| Function-local early-native release | +3.481 ms (+0.99%) | +0.46% | +40.750 M (+2.45%) |

All six instruction observations in each mode increased. The ordinary wall decreased in seven of ten pairs and the source-local wall decreased in two of ten. This candidate supplies a real source-to-typed operand but does not establish a whole-compiler throughput gain or reach 1 GB/s.

## Lowering work and composition

A second observer counts the evaluator's actual task pops, node expansions and tape splices across the emitted functions. SQLite dropped from 534,539 to 482,562 task pops and from 207,836 to 191,502 graph expansions. Its emitted functions exercised 14,294 splices. Buster dropped from 409,743 to 403,877 pops and from 152,367 to 150,569 expansions, with 1,664 splices in emitted functions. The full object hashes match. Counts in tasks.tsv for unselected and externally unobservable functions should be read together with the typed oracle's emitted-function counts.

The separate statement producer owns complete call and store statements. In a source-coordinate join 3,065 of the 14,321 ordinary-window operands fall fully inside its intervals, with no partial crossings. Including optional condition ownership changes this to 3,086. On 1c77f4963 both source producers actually ran upstream of the same early native fragment emitter. In SQLite it selected 6,399 complete statements, then removed another 13,312 member actions in 11,270 operand tapes. The graph events dropped from 291,872 to 278,560 while every object byte agreed. Buster's complete object agrees as well. The expression and early native lifetime poisons were both enabled.

## Depth and typed reserve

42/42 directed checks cover the depth boundary at 16 versus 17 and 32 hops, zero and 4 GiB offsets, builtin extent, macros and mixed evaluation. A further eight-argument call used a full 16-hop operand in each argument and exhausted the prior compressed graph's typed reserve (7844b9bd3). Commit 90a21788b adds the checked field actions to native capacity, at most three instructions per source action. The old compiler failed that valid example. The corrected compiler and independent ordinary compiler produce the same ELF, SHA-256 1f902bd8f6c95776b30e26721c33355a1cef7edc33ecf427bdfb78ba8f9a181b. The compact, physical selector and independent statement compositions incorporate the same fix.

Raw instruction-sampling profiles of complete fresh SQLite builds (one run per mode, period 131,089 userspace instructions) attribute about 14.4 million additional sampled instructions to getenv and 11.8 million to strncmp on the function-local path. The first compact retry therefore chooses options once per translation unit. It packs one resolved offset/action per hop and dispatches the full span validator only for a source-identifier/field pair. Full paired counters remain the timing evidence.

## Frozen compatibility corpus

All 6,860 independent process comparisons on the 7844b9bd3 warning correction matched clean native Buster for stdout, stderr, exit status and the complete output object when one was written. This covers SQLite, the frozen Buster translation unit, 34 Lua sources and 1,336 musl sources under five warning policies. Both compilers rejected the same 863 inputs under the selected flags. The earlier candidate differed in only three diagnostics on musl's vsnprintf.c, which required the member's size_t typedef spelling for a signed comparison. The repair forwards its recorded declaration slot to the ordinary warning renderer.

The first optimized timing executable SHA-256 is 5013774fbe33499a00443e05d0bd00b617de5173bbbe0aca363b30c49ba71448. The corrected diagnostic qualification executable hash is 68143241603d3b96691aa930e0dcc15347d3c307489127a7973649880cb21515. The full lower and graph observers use separate capture binaries and never run during timed compilation.

## Compact retry

Revision c637b0dc3 keeps one record for a resolved member's byte offset, declared type, intermediate load and optional final load. The initial local remains a separate record. This produces 30,684 intermediate rows on SQLite and 19,214 on Buster, versus 55,218 and 36,139 respectively in the first candidate. The native writer reconstructs the same operations. The root condition options are selected once per translation unit, and nonmember source actions skip the out-of-line validator. Its configured Develop binary hash is 16e4eb65f05a3e017a2c3b24cd645f7265bbea7fd982f509293efdb70a250f9c.

| Mode | Paired wall (8 rounds) | Paired cycles (6 rounds) | Paired retired instructions (6 rounds) |
|---|---:|---:|---:|
| Ordinary C object | +5.010 ms (+1.72%) | +2.37% | -9.531 M (-0.725%) |
| Function-local early-native release | -0.701 ms (-0.20%) | +0.84% | -5.156 M (-0.311%) |

All 56 fresh SQLite objects matched, both configurations decreased instructions in all six pairs, and ordinary compilation decreased cycles in one pair. This removes repeatable work from the application, while the existing source operand handoff still does not accelerate fresh ordinary native C compilation. The raw four-arm data and original perf stat files are included separately.

The final physical-selector composition at 350f3d039 passes the same source-held and early-native whole SQLite and Buster objects under both poison modes. All 12,597 selected SQLite fields still resolve from a zero prior canonical use-site ID to the exact independently observed field slot and source bit offset. The Buster control with no operand fusion now succeeds through the bounded declined-body identity handoff.

## Additional local record roots

The integrated local-record branch 38f8d46ef additionally accepts paths such as r.embedded.pointer->field and preserves the symbolic root address as one folded displacement until the first loaded pointer. These add 40 SQLite and 47 Buster selected operands, with byte-exact complete objects. A deeper mixed pointer/record probe first exposed a byte difference on the earlier extension and now matches, including its address, call and store cases. A separate direct scalar return extension retains the aggregate's original stable local object and offset. It adds a further 15 SQLite and 4 Buster returned operands, with exact whole objects and 460/460 directed policy pairs. Pure aggregate field updates and other contexts retain the original member graph. An exploratory unrestricted pure-record assignment wrote the aggregate base and failed a differential probe. It is excluded from the signed candidate.

A second direct capture from the compact c637b0dc3 actual Tier 0 input matches the original independent ordinary stream byte-for-byte in all 381,191 SQLite and 659,942 Buster entries, including operands' 64-bit values. Exact hashes and the compact capture patch are supplied.

## Linked SQLite oracle

A fresh Clang build of the full frozen SQLite source and five native compiler output arms were linked with the same C program. It exercises a 2,400-row recursive insert, update and savepoint rollback, indexed window ranking, an R-tree join, grouped aggregates and integrity_check. All six executables completed the same 2,941 rows and produced digest 1092617091591019106. The source, link commands and per-executable reports are retained.

The expanded record probe independently checked all 118 ordinary graph rows and 40 edges against its 59 retained rows. Its actual Tier 0 input contained 173 entries in 13 functions, byte-identical across ordinary and source modes. The evidence includes both raw streams and the normalized oracle result.

The final 90a21788b compiler also passed all 6,860 complete process/ELF comparisons independently against clean native Buster, including the same 863 intended rejections. Its SHA-256 is 7cedc807e66d096d79da2daaaf3b24765d00ae244f55dd4445854d0f6e42c47d. The final matrix is preserved separately from its predecessor's results.

A source-coordinate join with the separate developing PP bare-object-base owner found 11,383 exact matches among 14,340 actual function-local operand starts. Of these, 10,924 already use physically held names for every field, and 10,993 for at least one. This is an opportunity count for a future joint producer. The current operand candidate independently uses the existing real object declaration at its base.

The exact experimental source revisions are retained in source.bundle, incremental to public Buster commit 0e1d5b825801135bf50e79da9d546bc95209ab30. A Buster checkout containing that commit can inspect the refs with git bundle list-heads and fetch them from the bundle. From this packet directory, run python3 check-packet.py --capacity to verify the graph, typed, timing, declaration, linked-executable and both complete-corpus summaries from the archived evidence. The original capture harnesses preserve their original workspace paths.
