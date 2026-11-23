# Front-end fallbacks (phase D of #2924): what I found

All files are under `src/buster/compiler/`. I read each site's code, not just the comments. Where I say how often ordinary input reaches a fallback, the numbers come from the repo docs (`docs/c-parser.md`, `docs/c-checker.md`) or from the conditions in the code; I ran nothing.

Five things to know first:
- **`BUSTER_DIAGNOSTIC_SMALL_COUNT` is no longer a scalar fallback.** `diagnostic_sort_small` (`diagnostic.c:119-187`, selected at `:194`, count ≤ 512) is now an AVX-512 rank sort, 8 records at a time (#2959). It is a size choice between two vector sorts.
- **`check_literal_string_part_scalar` is confirmed.** It takes every raw string and every wide, UTF-16 or UTF-32 string whole (row L2 below).
- **`parse_scalar` is the fallback parser, not the main parser.** `parse_vector` (`c_parser_impl.c:11213`) is the main path. `parse_scalar` takes two things: each top-level declaration K6 or K2 flagged (`parse_fallback`, `:7832`, called at `:11254`), and the whole unit when the kernels give up or a fallback declaration has an error (`:11575-11590`). The roughly 100 `parse_scalar_*` helpers are its internals.
- **Two sources already mark phase D work:** `c_checker.c:3105` (`CheckAction.scalar`) and `docs/c-checker.md:7531` (the non-tree facts walk).
- **The default checker graph run is node-at-a-time.** `check_graph_scalar_node` for every node (`c_checker.c:4296-4318`) is the main path, not a fallback. The batched paths are opt-in: `--check-transitions` and `CheckOptions.regions`/`level_order`. The size routes in rows C2 and C3 matter only inside those.

## Lexer (`c_lexer.c`)
| # | Selection site | Scalar code | Exact condition | Vector route it leaves | Who reaches it |
|---|---|---|---|---|---|
| X1 | `:3774-3776` (`c_tokenize`); `:3719` makes `c_tokenize_vectorized` return NEEDS_SCALAR; `c_preprocessor.c:4025` refuses windows | `c_tokenize_scalar`, whole source | `c_tokenize_scalar_only` (`:3702-3706`): flags have `NO_DOLLARS` or `KEEP_COMMENTS`; or `TRIGRAPHS` and `contains_trigraph`; or C++ with `NO_DIGRAPHS`/`NO_LINE_COMMENTS` (no option sets that) | the chunk loops (`tokenize_with_flags`) | every file under `-C`/`-CC` (`c_preprocessor.c:3637-3639`); every file containing a `??x` trigraph under `-trigraphs` or ISO pre-C23 `-std` |
| X2 | `:3753` (`c_tokenize_from`), via `needs_scalar` `:2500` | `c_tokenize_scalar_range`, from the line before the chunk to the first line start after it | a `BUSTER_LEX_NEEDS_SCALAR` return at `:3074` (splice with `\n\r`), `:3092` (splice after `\` or `'`), `:3123` (whitespace before a splice's newline), `:3164` (`/*/` or `*/*`), `:3194` (block comment still unsettled after 4 rescans), `:3230` (unterminated block comment at EOF), `:3280` (non-ASCII byte or UCN, or a joining splice, outside literals and comments), `:3297` (stray `\` before a quote or `\`), `:3441` (digit separator that is really a quote, `'a'b'c'`), `:3494` (raw-string start with `RAW_STRINGS` = gnu C modes and C++) | the 512-byte chunk loop | every 512-byte chunk with a UTF-8 identifier, a stray non-ASCII byte, a UCN identifier, a splice inside a token, or `R"(` in gnu or C++ modes. Plain ASCII code does not reach it |
| X3 | `:2855-2862` (rare lanes inside the vector loop) | `prefixed_literal_kind`, one token at a time | lanes in `prefixes`/`unknowns` | the Phase III kind compress | every `L""`, `u""`, `U""`, `u8""` and prefixed char literal, and every unknown token |
| X4 | `:3345-3360` | `<=>` and `->*` checked one at a time | C++ only: triple candidates starting with `<` or `-` | Phase II pair/triple masks | C++ sources with `<=` or `->` |

## Preprocessor (`c_preprocessor.c`, `c_preprocessor_impl.c`, `c_preprocessor_history_impl.c`)
These callers use the scalar lexer directly, never `c_tokenize`, so removing `c_tokenize_scalar` must handle each of them (rows P1-P5).

| # | Selection site | Scalar code | Exact condition | Vector route it leaves | Who reaches it |
|---|---|---|---|---|---|
| P1 | `c_preprocessor.c:3088` → `pp_split_dollars` `:3005`; re-lex `:3035`, whole file `:3062` | `c_tokenize_scalar(… \| NO_DOLLARS)` | `dollar_punctuation` and a `$` in an identifier or pp-number. The whole file is re-lexed when a run ends in an unknown token longer than `$` | `c_tokenize` output | only with `-fno-dollars-in-identifiers` or `-x assembler-with-cpp` |
| P2 | `c_preprocessor_impl.c:3580` (`pp_lex_scratch`, called at `:7649`) | `c_tokenize_scalar` | always, for `_Pragma("…")`'s destringized text | none | every `_Pragma` |
| P3 | `c_preprocessor_impl.c:3690` (`pp_paste`) | `c_tokenize_scalar` | the joined `##` spelling is not all `[A-Za-z0-9_$]` (the vector identifier test at `:3670-3676` fails) | the vector identifier-paste test | every paste that makes a non-identifier, e.g. `-##>`, `x##.1`, `L##"s"` |
| P4 | `c_preprocessor_impl.c:9050` (`pp_copy_relexed`), `:1199` (`pp_relex_end`), `:9103` (`pp_continue_relex`) | `c_tokenize_scalar`, `c_tokenize_scalar_range`, `ScalarLexer` | re-lexing the rest of a line after a header name, and condition suffixes after `__has_include(`-style builtins | the file's prepared tokens | `#include <…>` or `__has_include` lines where the file's tokens differ from clang's lexing (rare) |
| P5 | `c_preprocessor.c:6766` (`pp_output_invocation_place`) | `c_tokenize_scalar_range` | a token from a macro whose surrounding file tokens bound one invocation of at most `BUSTER_PP_INVOCATION_BYTES` | none (the history is the alternative) | `-Wempty-body`'s indentation check and similar callers |
| P6 | `c_preprocessor_impl.c:7261-7275` | `pp_collect_step`, a token at a time in the main loop | `pp_collect_argument_slice` and `pp_collect_arguments` (`:4888`) both fail. That happens when `(` and `)` are not both in the top context's run, there are more than 64 commas (`BUSTER_PP_FAST_SEPARATORS`), paren depth exceeds 63, `-C` drops argument comments, or the argument stack is full | `pp_collect_arguments` (one copy) | common: a macro name produced by an expansion whose arguments come from the file (`#define F G` then `F(x)`), and arguments that span contexts |
| P7 | `c_preprocessor.c:2768-2770` | `pp_pair_conditionals_scalar` (stack) | `pp_pair_conditionals_vector` returns false: an `#else`/`#elif`/`#endif` without an open group, depth over 30000 (`:2553`), or scratch exhausted | prefix sum plus pointer jumping | erroneous files only |
| P8 | `c_preprocessor.c:3231-3233` | `pp_directive_places_scalar`, a bit at a time | more than 16 directives in one 64-token word | `vpcompressb` places | runs of null `#` lines or of `#endif`/`#else`/`#undef X` |
| P9 | `c_check_input.c:17059`, `c_check_attested.c:2300`; flag set at `c_preprocessor_impl.c:3107` | `pp_system_levels_history` (token at a time, plus a history replay) | `pp->system_runs_inexact`: a system-level transition while an invocation is collecting or a non-file context is open, or the run arena is full. Also `c_check_pack_input.c:865` skips its walk and `c_preprocessor_impl.c:15157` defers the warning filter | `pp_system_levels` (64 tokens a step) | rare (e.g. an `#include` inside macro arguments) |
| P10 | `c_preprocessor.c:3091-3092` (scalar split at `:2940`; unknown tokens one at a time at `:2925`) | `pp_split_prefixes`, `pp_splits_unknown` | `pp_count_splits_vector` finds prefixed literals the mode's language lacks | the vector count | old `-std` modes with `u8'x'`, `u""` and similar |
| P11 | `c_preprocessor.c:2193-2196` | `pp_clean_splices` (`ScalarLexer`) | `pp_splice_possible_vector`: a `\` followed by a byte ≤ space, or any `?` when trigraphs are on | the vector check | spliced tokens; with trigraphs on (ISO pre-C23), every token containing `?` |
| P12 | `c_preprocessor_history_impl.c:458` | `pp_snippet_line`, one step per byte | tabs, control and non-ASCII bytes | 64-byte plain runs | printed diagnostics only |

## Refinement and intern (`c_refine.c`, `c_intern.c`)
| # | Selection site | Scalar code | Exact condition | Vector route it leaves | Who reaches it |
|---|---|---|---|---|---|
| R1 | `c_refine.c:617`/`:628` (and `:821`/`:827`) mark slow; taken at `:559-561` | `refine_intern_identifier` → `refine_identifier_key` → `intern_find_or_add` (hash plus memcmp) | identifier longer than `BUSTER_INTERN_FAST_LENGTH` (63), or containing `\` (or `?` with trigraphs) | `refine_probe` / `intern_find_or_add_vector` | identifiers of 64 bytes or more, and spliced or UCN identifiers |
| R2 | `c_refine.c:430-436` | `refine_gap_is_splices` per lane | a non-first-of-line token whose gap ends in a newline | the gap masks | line splices between tokens |
| R3 | `c_refine.c:294` | `refine_newlines_before`, bytes one at a time | 16 starts spanning more than 128 bytes | `vpermi2b` window | long tokens or comments |

## Parser (`c_parser_impl.c`, `c_parser_bindings.c`)
| # | Selection site | Scalar code | Exact condition | Vector route it leaves | Who reaches it |
|---|---|---|---|---|---|
| A1 | `:11254` → `parse_fallback` `:7832` → `parse_fallback_item` `:7813` | `parse_scalar`, per top-level declaration | any token flagged by K2/K6 (`parse_check_avx512` `:11244`) or `parse_flag_custom_attributes` `:11185` | K1-K6 kernels | ordinary valid code: asm, `_Generic`, K&R parameters, C23 `[[…]]`, `__restrict` in parameter arrays, block-scope typedef names, a typedef name after `_Alignas`, definitions whose declarator has a group, availability-style attributes. Measured 1.47% of `sqlite3.c`'s tokens, 1.29% of `main.c`'s, 0.20% of libc's |
| A2 | `:11238-11241` (`everything`) and `:11575-11590` (`scalar = fallback.errors`) | `parse_scalar`, whole unit | unbalanced brackets; an unsupported typedef (`:5964`/`:5974`: not at file or block scope, or something other than storage class/qualifier/`__extension__` before `typedef`); K5 verdict not OK; or a fallback item with errors, out of memory, `retyped` (a file-scope typedef name redeclared as an ordinary identifier) or `undecided` (C89 implicit int with GNU attributes) | the whole vector path | every unit with a syntax error; rarely valid code |
| A3 | `:11147-11159` (`deep_node_depths`, set at `:9327`) | `parse_parents_scalar` (K4 token at a time) | node depth > 2047 | `parse_top_parents8_avx512` | no |
| A4 | `:11166-11175` (verdict set at `:9707`) | `parse_statements` (K5 stack) | `PARSE_STATEMENTS_TWIN`: an open `do` without its `while`, a pending `while`, or `state.twin` | `parse_statements_avx512` | rare |
| A5 | `:9160-9172` | `parse_roles_twin_block` (K2 token at a time) | a 64-token block whose rounds (1 inline plus up to 8 out of line) don't settle | `parse_roles_rounds_avx512` / `_block_more_avx512` | rare |
| A6 | `:8188-8191` | `parse_brackets_block_scalar` (K1) | enclosing openers more than 15 depths below the block's start | K1 window | deep nesting crossing a block |
| A7 | `:10994-10997` | `parse_check_range` (K6 block) | block depth span > 63 (`:10694`) or groups unsettled after 16 rounds (`:10790-10814`) | `parse_check_block_avx512` | rare |
| A8 | `:10713-10720` | `parse_check_class`, one lane at a time | `BUSTER_PARSE_CHECK_RARE` lanes with kind `TYPE_ARGUMENT` or `TYPEOF` | the K6 class table | every type-argument builtin (`__builtin_va_arg`, `offsetof`, …) and every `typeof` |
| A9 | `c_parser_bindings.c:191` (`parse_bindings_build`) | always replays `parse_scalar_traced` | always, but its only callers are the binding-column read at `c_check_binding.c:997` (validated diagnostic-prefix views) and the lazy-headers replay (row K16) | none | not ordinary compiles |
| A10 | `c_check_prefix.c:682`/`:1041`, `c_check_repair.c:340`, `c_checker_driver.c:7415` | `parse_scalar` on recovery views | the unit already failed to parse | none | parse errors only |

## Bindings and types (`c_bindings.c`, `c_types.c`, `c_check_initializer.c`)
| # | Selection site | Scalar code | Exact condition | Vector route it leaves | Who reaches it |
|---|---|---|---|---|---|
| B1 | `c_bindings.c:510-518` | `c_bindings_scalar` (whole-log replay, once) | a use whose candidate is still out of scope after `BUSTER_C_BINDING_WALK_LIMIT` (8) backward walks | `c_bindings_scan` (`c_bindings_batch`) | only callers of `c_bindings_batch`: #113 deferred bodies (`c_check_body_bindings.c:339`) and `parse_bindings_resolve`. The default checker uses DIRECT (`c_check_binding.c:1012`) |
| T1 | `c_types.c:3426`/`:3476` set `BUSTER_TYPE_LOOKUP_WALK`; read at `:3734`, `c_check_initializer.c:1808-1811` | `type_lookup_walk`, `type_lookup_scan_scalar` | the member-lookup index capacity is exhausted, or an anonymous member's record walks | `type_lookup_probe`/`type_lookup_scan` | no (capacity) |
| T2 | `c_types.c:4596-4603` | `type_layout_scalar` | a `type_layout_group` lane whose sizes might pass 2^31 bits | `type_layout_records` (16 records a step) | see the note below: production never calls `type_layout_records` |
| T3 | `c_types.c:3075` and `:3134-3138` | `type_derive`, one at a time | `hidden_end != 0` (a deferred lane's view); misses, function kinds, extents > UINT32_MAX | `type_derive_batch` | `type_derive_batch` has no production caller |
| T4 | `c_types.c:5236-5242` | `type_usual_arithmetic` | `BUSTER_TYPE_CODE_DEFERRED` lanes (`_BitInt` or complex integer) | `type_usual_arithmetic_types` | no production caller (`check_actions` filters these out first) |

**Note on layout:** production layout is scalar by caller choice. Every struct or union completes through `type_complete_record` → `type_record_layout` → `type_layout_scalar` (`c_types.c:4167-4190`, called from `c_check_input.c:10574`). The vector `type_layout_records` is used only by tests and benchmarks.

## Checker (`c_check_*.c`, `c_checker*.c`)
| # | Selection site | Scalar code | Exact condition | Vector route it leaves | Who reaches it |
|---|---|---|---|---|---|
| C1 | `c_check_condition_eval.c:187` sets `.scalar = true`; used at `c_check_actions.c:2565`/`:2605` and `:1989` → `c_check_wide.c:959` | `type_lookup_member_scalar`, `check_wide_*_scalar` | the `diagnose_if`/`enable_if` condition evaluator (marked phase D at `c_checker.c:3105`) | `type_lookup_member`, `check_wide_*_vector` | every call to a function carrying `enable_if` or `diagnose_if` |
| C2 | `c_check_actions.c:3800-3803`; `c_checker.c:3392-3395`; `c_check_transitions.c:881`; `c_checker.c:3465-3470` | `check_action_scalar` / `check_graph_scalar_node` (scalar integer fold) | a batch of one; a singleton level; a single miss; a non-fold operator in a postorder region | `check_action_fold_vector` (8 lanes) | only on the opt-in batched paths (see the intro), where it is common |
| C3 | `c_check_actions.c:1963-1969` | `check_action_fold_integer` | MUL, DIV or REM; width > 64; operands not plain BOOL..ULLONG; bit-fields (`check_action_vector_eligible` `:3679`) | same | very common (multiplication, division) |
| C4 | `c_check_comma_input.c:93-95` (gives up at `:76-79`) | `check_input_expression_commas_scalar` (reverse postorder) | a separator whose parent is an earlier separator | `check_input_expression_commas_vector` | separators are left-associative, so valid code should not reach it; likely only prefix and repair views (not measured) |
| C5 | `c_check_expression_input.c:2264` | `check_input_expression_visit` (about 25 branches per token) for the whole unit | `diagnostic_limits`, or a lazy mask with #113 deferred bodies, or `expression_limit < count` (set by errors) | the coded walk | units with errors or deferred bodies |
| C6 | `c_check_input.c:1578-1580`, `:1812-1816` (class table) | `check_input_expression_visit`, per token | class `CHECK_INPUT_CODE_SCALAR` (`return`, `sizeof`'s closer, keyword-group closer, sparse entries), or a class action declining | class actions | every `return` and `sizeof` |
| C7 | `c_check_expression_input.c:1057-1059` (forms at `:748-756`) | `check_input_literal` | a literal that is not a 1-9 digit plain decimal (or a preprocessor int ≤ INT_MAX) | `check_input_expression_literals` (gathers) | every hex, octal, suffixed, floating or char literal |
| C8 | `c_check_literals.c:1197`, `:1212-1215` | `check_literal_string_part_scalar` (every unit by the step) | raw strings, or encoding UTF-16, UTF-32 or wide | `check_literal_string_blocks` | every `L""`/`u""`/`U""` and every raw string |
| C9 | `c_check_literals.c:1205-1208` | `check_literal_string_step` | units the blocks leave: UCNs, invalid escapes, `\x` with 0 or more than 2 digits, octal > 255, bytes no literal holds as written | blocks | strings containing `\u`/`\U` |
| C10 | `c_check_input.c:6994` → `c_check_literals.c:1293` | `check_literal_strings_extended` (scalar step) | a literal the fast decoder refused (delimited `\x{}`/`\o{}`/`\N{}`, unknown escapes) | `check_literal_strings` | rare (error or GNU paths) |
| C11 | `c_check_literal_table_input.c:421-423` | `check_literal_table_classify_scalar` | number longer than 64 bytes | `check_literal_table_classify` | rare |
| C12 | `c_check_literal_table_input.c:207-214` | `check_literal_table_value` (`check_literal_integer`) | element not 1-3 decimal digits or exactly 2 hex digits, or negated | `check_literal_table_small` | table elements like `0x1234`, `-1`, `10u` |
| C13 | `c_check_common_warnings.c:13066-13067` | the facts' node-at-a-time walk (marked phase D in `docs/c-checker.md:7531`) | `check_common_parents` says the graph is not a tree in node order (a node with two readers, or an operand after its node) | `check_common_facts_tree` | frequency not measured |
| C14 | `c_check_common_warnings.c:12081-12090` | `check_common_chosen_span` per selection | `check_common_chosen_depths` fails its depth bound | indexed sweeps | synthetic or deep trees only |
| C15 | `c_check_query_runtime.c:786-836` | `check_graph_scalar_node` over every node (full replay) | a published `__builtin_constant_p` result changed under an observable FP environment, or `replay_queries` | targeted publish | rare (FENV_ACCESS with `constant_p`) |
| C16 | `c_check_data.c:605` (constant at `:39`) | scalar radix passes in `c_bindings_sort` | fewer than 65,536 boundaries | vector radix | every static initializer that needs the overlap proof |
| C17 | `c_check_debug.c:201` | `check_debug_rows_scalar` | `origins != 0` (Tier 1 bodies) | `check_debug_rows_vector` | every Tier 1 function under `-g` |
| C18 | `c_check_debug.c:577-584`, `:637-641`, `:797`/`:807` | `check_debug_line_scalar` | function not spanned (declaration and closing brace not in one range without `#line`, or `run_bits` null); lanes outside the span, a macro chain over `BUSTER_CHECK_DEBUG_WALK`, a link out of bounds; inline-instance call lines always | the 16-row span path | `-g`: bodies that include files, `#line`, deep macros |
| C19 | `c_check_attested.c:1694-1722` | lists made a token at a time (as `check_attested_lists_walk`) | a cache miss: every function definition (its own hash is 0), first sight, single-file commands (no cache) | cache copy | common wherever attested lists run |
| K16 | `c_check_lazy.c:465-472` | `check_lazy_replay` (scalar parser plus `c_bindings`) | `check_lazy_tree_plan` returns UNSUPPORTED (e.g. a name declared inside an attribute group, `c_check_lazy_tree.c:451`) | the tree planner | only with the opt-in `-flazy-system-headers` |

**Gather fit limits (signed 32-bit indices).** None of these can be reached by realistic input: they need a unit past 2^31 tokens, nodes or bytes.
- `c_check_expression_input.c:32` → token loop `:47`
- `:338` → node at a time
- `:644` → `check_input_identifier_entry`
- `:852` → `check_input_literal_plain` `:1003`
- `c_check_attribute.c:11414` → `check_input_deprecated_use` walk `:11597`
- `c_check_condition.c:1242` → loop `:1265`
- `c_check_intrinsic_input.c:186` → `check_input_intrinsic_candidate` (record arena past 2 GiB)
- `c_check_lazy_tree.c:53` → `check_lazy_tree_mask_scalar`
- `c_check_node_machine_flat.c:262` (`node_flat_compact`)
- `c_check_program.c:5914`, `:6224` (2^31 nodes)
- `c_check_program.c:5995` (`leaf_count` ≥ 2^26, `dense_leaves` only in hand-built test graphs, `token_count` < 4)
- `c_check_transitions.c:233-240` (tokens within 3 of the end of `system_tokens`, one at a time)

**Scalar tail loops after full 16- or 64-wide loops:**
- `c_checker.c:3671` (`check_graph_warning_contexts`) and `:4028` (`check_graph_reports`)
- `c_check_transitions.c:216` (`check_transition_statics`)
- `c_check_common_warnings.c:12725` (`check_common_parents`)
- `c_check_input.c:16968` (`check_input_system_token_map`) and `:17044`
- `c_check_data.c:474` (`check_data_nonzero`) and `:547-557` (`check_data_nonzero_bits`: slices under 64 bytes go entirely to bytes)
- These also have a twin: `c_check_attested.c:2318`, `c_check_program.c:4458` (`check_program_addressed`), `c_check_program.c:6064`, `c_check_warning_graph.c:256` (`check_interrupt_first_use`)

**Opt-in experimental, not ordinary:** the node machine's "a record at a time" terms (`c_check_node_machine_window.c:63`, `c_check_node_machine_rows.c`) run only under `--node-bodies` or the `measure-node-machine` shadow (`c_checker_driver.c:15738-15768`).

**Nothing found** in `c_environment.c`, `c_lowering.c`, `c_dependency.c` or `c_files.c`: only twins, benchmark helpers, or lane (not SIMD) fallbacks.

## Skipped
**Twins (selected only by `BUSTER_SCALAR_PATH`/`BUSTER_VECTOR_PATH` or a scalar/vector option):** `pp_scan_body_scalar`, `c_bindings_scalar` (STACKS mode), `c_bindings_replay` (body bindings), `c_lowering_scalar`, `cbuiltin_fold_scalar`, `cbuiltin_lower_scalar`, `cbuiltin_varargs_lower_scalar`, `cbuiltin_misc_lower_scalar`, `cbuiltin_float_lower_scalar`, `check_lower_node_counts_scalar`, `check_lower_classify_types_scalar`, `check_lower_resolve_labels_scalar`, `check_lower_entry_classes_scalar`, `check_program_declaring_scalar`, `check_program_needed_count_scalar`, `check_program_needed_number_scalar`, `tier0_compile_scalar`, `tier0_validate_scalar`, `ssa_ir_promote_scalar`, `check_debug_keep_scalar`, `check_attested_lists_walk`, `type_lookup_scan_scalar`, `type_lookup_probe_scalar`, `type_lookup_member_scalar` (twin uses), `check_wide_*_scalar` (twin uses), `node_flat_compact`, `check_common_chosen_depths` (vector flag), `dependency_special_scalar`, the intrinsic catalog and filter twins, `node_facts_window_names_scalar` (shadow oracle).

**"Scalar" meaning a C scalar type:** `check_action_is_scalar`, `check_lower_scalar_conversion(_body)`, `check_lower_plain_scalar`, `check_lower_scalar_lanes`, `check_lower_transport_scalar(_operand)`, `check_vector_*scalar_row(s)`, `check_init_scalar_bytes`, `check_init_bytes_scalar`, `check_init_scalar_literal`, `check_data_scalar_*`, `check_data_plan_scalar`, `check_data_copy_scalar`, `builtin_intrinsic_type_scalar`, `node_machine_scalar_class`, `node_facts_unfit_scalar`, `BUSTER_NODE_FACTS_(ARGUED_)SCALAR`, `BUSTER_CHECK_OS_LOG_SCALAR`, `CHECK_INIT_HISTORY_SCALAR`, `CHECK_DIAG_SCALAR_REQUIRED`, `CHECK_WARNING_*SCALAR*`, `CHECK_X86_*SCALAR*`, `check_query_scalar_conversion_exact`, `check_lower_limb_scalar_update_emit`, `x86_instruction_effects_scalar(_opmasks)`, `ir_sroa_scalarize(_calls)`.

**No vector counterpart, or unused/oracle only:** `parse_typedefs` (K3 scalar pass), `parse_classify_mask_avx512`'s per-identifier lookups, `check_literal_character_by`, the default `check_graph_scalar_node` loop, the `pp_read_token` main loop, `refine_tokens_scalar`, `intern_hash_bytes_scalar`, `cbuiltin_lookup_scalar`, `c_environment_types_scalar`.

**Tests, benchmarks and measures:** all `*_test.c`, `*_benchmark.c`, `*_measure.c`, plus `c_check_corpus.c` and `c_preprocessor_fuzz.c` (scalar-vs-vector harnesses).

