# Readers of an expression's inside, from today's code

All files are in `/home/user/buster-values/src/buster/compiler/`; citations are `file:line`. Nothing was modified, built or run. "Not verified" marks inference.

## Corrections to the brief and the doc

1. `check_lower_template_splice` rebases nothing, and no compile reaches it (Q7).
2. A scalar automatic initializer is not a `CheckControl.node` root. Its control is `CHECK_CONTROL_INITIALIZE` with `.node = NONE`, `.target = plan`; the expression is `plans[target].parts[0].node`, the source under the reader's INITIALIZE (Q9, Q10).
3. The unused family reads neither nodes nor reference lists. `-Wunused-variable/-function/-parameter/-but-set-variable` are the binder's (c_check_binding.c:376-387; `check_input_discarded_set` is parse-tree only, 92-146). `-Wundefined-internal` scans tokens (c_check_warning_undefined.c:310-343). The scan in c_check_common_warnings.c is `-Wuninitialized` plus `-Wunused-but-set-parameter`.
4. "Whether its callee returns" is three-valued and depends on conditional arms (Q3).
5. Readers the doc's list lacks: the initializer planner, `check_control_foldable`, `-Wfor-loop-analysis`, `-Wswitch`, the candidates' scan, the symbol-pragma/late-weak walk, the lowering's node-count bounds.

## 1. check_program_references and c_check_program.c

- After 3823 the function is only the argument loop (c_check_program.c:3823-3852) and `return reference_count` (3855). Besides references it writes `nodes[node] = epoch`, `region_reached` (3728), `compound_initializers` (3696) and CFString references (3704-3717).
- Callers: `check_program_bodies`, every body, unconditional (6318); `check_program_census_walk` (4817, flag only).
- The scratch `references[]` is sorted by object and copied to `program->references` (6326-6347), so discovery order is erased. The list is ascending and duplicate-free (`seen[object] != epoch`, 3677).
- Consumers of `program->references`:
  - selection edges (c_check_program_select.c:1266-1293), section-bound marks (1351-1362), the selection's copy and its own `needed` (1495-1500) → `check_program_alias_number` (1593), alias "referenced" test (1582-1585);
  - target groups' `resolved` (c_check_program_target_versions.c:404-424);
  - candidate prefilters of the target-feature check (c_check_target_feature.c:2463-2491) and the symbol-pragma walk (c_check_program_symbol_pragma.c:149-153);
  - census compare (c_check_program.c:4690-4701).
- All are set tests or edges; the planner's result is in source order whatever the edge order (c_lowering.c:33-37). Only the census compare needs ascending order. A duplicate would be a duplicate edge (counted only in `visited_edges`, c_lowering.c:36-37) and a wrong census count. No warning reads the lists.
- `needed[]` feeds only `check_program_symbols` (6365-6410) → the full program's `object_symbols` (c_check_program_alias.c:786-791). -c renumbers from the selection's lists, so it matters where the full program is lowered directly and under `--provisional-selection` (6604-6618).
- `nodes[]` marks → `check_program_builtins` (4091-4126, 6458-6464).
- Other walks below roots:
  - `check_program_runtime_truth` (1161-1190): the given node's own columns, no descent.
  - `check_program_branch_truth` (1202-1274): through CONDITION/CONVERT/CAST/NOT and both operands of `&&`/`||`; it decides `x && 0` and `x || 1` by the right operand. Callers: return-flow pass 1 (2976) and the warnings' reach (c_check_common_warnings.c:1297, 9625, 10420). Diagnostics only, but a taken condition needs this answer at its root.
  - Controls writer, every body: `if` and `switch` strip the wrapper (`graph->ops[condition] == CHECK_OP_CONDITION ? graph->operand0[condition] : condition`, 2285; c_check_program_switch.c:257) and ask `check_control_fold_truth` (c_check_program_fold.c:394-409). Where the value is an integer constant without side effects, `check_control_foldable` walks the whole subtree (2108-2175). For a taken expression its only "no" is a comma whose left operand is no constant (2154). A leaf would answer yes and drop an arm that is written today. Codegen.
  - `check_control_static` (1615-1627: CAST/CONVERT → INITIALIZE); `check_control_static_chain` (1579-1588, musttail returns); return flow's switch: root → CONVERT/POSITIVE → enum type (2985-2995).
  - `token_first/node_next`: every node by `graph->tokens[node]` (6007-6012).
  - Only with `options.selection_census || options.candidates` (6184; `--selection-census`, `--provisional-selection`, `--windowed-loop`, c_checker_driver.c:14275-14284): `check_program_census_scan` takes every static VALUE leaf by token range (5054-5088, 5241), and `check_program_constant_arms` scans `CHECK_OP_CONDITION` ops (5605-5646). The provisional selection numbers symbols from it (c_checker_driver.c:9661-9686).
  - `check_program_chains` (3167) and the target groups read controls and reference lists only.
  - `check_program_x86_diagnostics`: only with a DEFERRED x86 range event (c_check_x86_diagnostic.c:308-319).

## 2. The uninitialized and set-but-unused scans

Chain: `check_driver_unit` (c_checker_driver.c:12121) → `if (program_checked)` (13125) → `if (!quiet || types.atomic_records)` (13132) → `check_driver_common_warnings` (c_check_common_warnings.c:12609) → `check_common_facts` (12652) → `if (enabled.uninitialized)` (12673) → `check_common_uninitialized` (11283). Also from `check_driver_rejected_read` (c_checker_driver.c:8411).

Gate: `.uninitialized = check_common_enabled(pp, input, CHECK_WARNING_ID_UNINITIALIZED, true) || check_common_enabled(pp, input, CHECK_WARNING_ID_UNUSED_BUT_SET_PARAMETER, true)` (12630-12631). The last argument is `default_ignored` (154), so neither runs without flags (-Wall, -Wextra: c_check_warning_policy.c:64-71, 80).

Only scalar automatic locals and parameters can warn (11594-11603). What it derives from nodes:

- **Read:** a VALUE, LVALUE, with an object, where `evaluated[node] && !nonread[node]` (11566-11575). `nonread` marks the chain under `&`, an explicit `(void)` cast, an `=` target and a comma's discarded left (11440-11476). The chain passes MEMBER, array SUBSCRIPT and same-size casts, and stops at ARROW or a pointer's subscript (11088-11137), so `p->m = 1` reads `p`.
- **Use (set-but-unused):** any such VALUE that is neither the direct operand of a compound assignment/`++`/`--` nor in an `=` target (11576-11579), evaluated or not; and a write whose value is used (11547-11550).
- **Write:** `=`, compound assignment, `++`/`--` whose operand0 is an LVALUE with an object (11539-11543). `first_write` is the node, or `node + 1` for read-write (11551-11555). `statement_write` comes from the operator token's parser parent (11556-11564). An initializer writes at `initializer_node + 1` (11344-11356).
- **Address taken:** an evaluated `&` whose root through array subscripts and members is the local (11443-11448). Array decay and passing an array are not. Calls are not read at all; only builtins' and asm operands mark `addressed` (11491-11515).
- **Member of a local struct:** the struct's VALUE is a read of a non-scalar, which never warns.
- **Short-circuit and conditional operands** count as evaluated unless the condition is known, by a constant or by `check_program_branch_truth` (10397-10429). An unreached control clears its root (9729-9806).
- **Order matters:** the test is `first_read < first_write` over node indices, unit-wide (11736-11738; "Graph order is evaluation order", 11516).
- **Also read:** the first read's token, for the location and the self-initialization range (11607, 11673-11676); a scan of every VALUE for a later read (11696-11703); declared types.

Minimal events per expression, in node order, per scalar automatic object: READ(token; evaluated, nonread, self-read, target), WRITE(read-write, value used, statement level), ADDRESS. Their positions must compare with other nodes' indices.

A second event consumer is `check_common_for_loops` (11980), gated by `check_common_enabled(pp, input, CHECK_WARNING_ID_FOR_LOOP_ANALYSIS, true)` (11986; -Wall). It finds a for's condition through `token_nodes` (12024-12035) and walks it (11852-11934). Then for each use of its variables anywhere in the statement it reads `token_nodes[token]`, the parent's op and the type (11939-11957): a change is `&`, a write target, a MEMBER base or an array value. A use without a node reads as unchanged, which is a false warning.

## 3. Return flow

- `check_program_return_facts` (c_check_return_flow.c:290) reduces every node once (239-285). It runs when `options.return_warnings && node_count != 0` (c_check_program.c:6177); `.return_warnings = !quiet && return_warning` (c_checker_driver.c:12962), true by default (13848). So it is default-on.
- A call's fact (116-138): the designator through `*` and `&` to a FUNCTION VALUE and its token (c_check_target_feature.c:572-589), `input->declarations[use]`, `CHECK_INPUT_FUNCTION_NORETURN` → STOPS; a library name with attribute `r` → UNKNOWN (74-94); indirect, overloaded or `analyzer_noreturn` → UNKNOWN (120).
- Up the tree (149-230): operands' facts are OR-ed. `&&`, `||` and `?:` keep the condition's fact and only UNKNOWN from the arms; STOPS survives only where both arms of `?:` stop (170-184).
- Consumer: pass 1 of `check_program_return_flow` reads `return_facts[entry->node]` (c_check_program.c:3040-3063) and writes only `body->return_warning` (3097), reported by `check_driver_return_reports` (c_checker_driver.c:2229). Pass 0 sets `return_flow`/`falls` for the lowering (3079-3087; c_check_program_lower.c:20766) and reads no fact or truth (`pass != 0` at 2976, 3038). Verified: diagnostics only. A summary node needs its root's two bits.
- Not verified by running: with `-Wno-return-type` and a noreturn function, pass 1 runs (2955) while `return_facts` is NULL (6177).

## 4. Target features

- It runs at -c and link, on the selection (c_checker_driver.c:13305, 13376), and only `if ((program->attribute_keys != 0 || program->stream->x86_count != 0 || abi) && options != NULL)` (c_check_target_feature.c:2368). `abi` is a vector type over 16 bytes in the unit (2367). `attribute_keys` exist only with a target attribute or a late rename/weak (c_check_program.c:4491). It then walks candidate bodies only (2443-2492).
- For such a body it needs every reached CALL and BUILTIN_X86 node (c_check_x86_diagnostic.c:264-273): the direct callee (555-568), the callee's token and its attributes before it (2284-2288), the call's end token for emission order (2617-2621), the callee's type and the arguments' converted types (2148-2194).
- It also needs the dead-end analysis: evaluation order, joins, noreturn callees (885-933, 1032-1102), and `node_labeled` over the whole graph (1244-1268).
- Output: `CheckTargetFeatureError[]` only — errors that refuse the unit, and -Wpsabi (c_checker_driver.c:8908-8990). It makes no fact for emission; its walk is reused by the symbol-pragma pass (Q6).

## 5. Gates (default-on diagnostics in brackets)

- c_check_musttail.c: `input->musttail_count != 0 && stream->report_count == 0` (383) [errors].
- c_check_ignored_result.c: marks made unconditionally (c_check_common_warnings.c:7579), asked per discarded root call [-Wunused-result, -Wunused-value: 545-567].
- c_check_unsequenced.c: `check_common_enabled(pp, input, CHECK_WARNING_ID_UNSEQUENCED, false)` (c_check_common_warnings.c:7596) [default on]; it walks each evaluated root that holds a modification (7690-7698).
- c_check_warning_graph.c: unconditional op scan after the graph run (1523-1537; c_checker_driver.c:12564) [pointer/integer comparison, -Wvoid-ptr-dereference, pointer-to-int casts, -Wunevaluated-expression; gnu-union-cast and nonscalar cast are default-ignored, 1115, 1148].
- c_check_noderef_graph.c: `check_sparse_wide_present(input->noderef_types)` (c_check_warning_graph.c:1670).
- c_check_condition_graph.c: `input->condition_declaration_count != 0` (1612).
- Interrupt calls: `input->interrupt_calls` (1685); reads every CALL.
- c_check_overload_graph.c, c_check_region_graph.c: inside `check_graph_run`, for overload-set calls and STATEMENT_VALUE (c_checker.c:3124-3138, 3225-3227).
- Inside `check_driver_common_warnings` (12647-12678):
  - Unconditional: `check_common_facts` and `check_common_graph_warnings` (7447).
  - `check_common_switches` [-Wswitch] reads `token_nodes[first token of the condition]` for the enum type (9184-9202), so a taken `switch (e)` would lose it.
  - Default on: parentheses, chained comparison, shift-op parentheses, string-plus-int, sizeof decay, return-stack, format (5020, 5065, 4962, 5191, 5859, 8298).
  - Default-ignored: self-assign, sign-compare, assign-enum, shift-sign-overflow, for-loop (12627-12629, 3241, 5285, 11986).
  - Unit-gated: enum arithmetic `input->enum_operands || stream->enum_operands` (5493); atomic `enabled.atomic_access` (12666); type safety `tags->declaration_count != 0` (12428).
- Also `check_input_packed_finalize`: `input->packed_member_count != 0` (c_check_packed_diagnostic.c:32); `check_driver_default_error_warnings`: `input->relaxed_tokens` (c_checker_driver.c:3989).

## 6. Selection and emission

Neither indexes nodes. `grep -c -E '\bops\[|operand0|operand1|operand2|argument_nodes|token_nodes|check_stream_[a-z_]+\(|check_graph_leaf|leaf_slots'` gives 0 for c_check_program_select.c and c_check_program_emit.c.

- The selection reads the reference lists, `dropped_ranges`, `region_reached` (540-574), `graph.tokens` of `builtin_nodes` (1552, 1561) and two stream counts (1019-1029).
- The emission reads `graph.overload_candidates` (4491-4493) and lowers through `check_lower_part` (1989-1993).
- One exception: the selection calls `check_program_symbol_bodies` (c_check_program_select.c:668, 952), which walks expressions for each VALUE's object and token in emission order (c_check_program_symbol_pragma.c:87-131, 135-249). It runs only with a `redefine_extname` after a use or a late weak declaration (c_check_program_select.c:1022-1026, 1594-1597). Codegen, rare.

## 7. Lowering

- Loop: `check_lower_part_body` (c_check_program_lower.c:20277), bodies at 20315, statements at 20739-20763 (`check_lower_control(writer, i)`, then a drain).
- Roots: `check_lower_control` (18735) calls `check_lower_expression(writer, control.node, false, target)` for EVALUATE and branches (18770), JUMP_INDIRECT (18800), VLA (18808), SWITCH (18862), RETURN (18920; RESULT, tail and aggregate returns 18836-18895). INITIALIZE goes `check_lower_initializer` (17274) → `check_lower_expression(writer, write->node, false, write->conversion.type)` (16767).
- `check_lower_expression` (2744-2768) reads the root's op and operand0 and pushes an EXPRESSION task, popped in `check_lower_drain_body` (16548, 16569-16593).
- `static inline __attribute__((always_inline)) bool check_lower_template_splice(CheckLowerWriter* writer, uint32_t node, uint8_t flags)` (c_check_program_templates.c:1298):
  - It needs `template_ready`, a CLOSED and not FOLDED node, and `flags == template_contexts[r]` (1302-1304).
  - It copies each subtree node's 8-entry slot of `kinds`, `classes` and `values` in node order, advancing by `template_total`, the root's by `template_own` (1313-1320).
  - It patches no entry: locals are already the body's (`check_lower_local_of`, 511), and templates have no call, label or temporary.
  - Side effects: `BUSTER_TYPED_LOCAL_ADDRESS_TAKEN` on copied LOCAL_ADDRESS locals (1321-1330), `constant_end`/`constant_node` (1332-1336), `writer->token` (1337).
  - No compile takes it: `shared->templates = false` (c_check_program_lower.c:19978-19982).
- Numbering: each body's list of locals (19922-19966); `local_map` set for parameters and declared objects (20494-20569, 20625-20721) and put back at 21069-21073. Per body, `local_count`, `call_count` and `argument_count` restart and `label_count = body.count + 1` (20338-20348).
- Temporaries are locals made on demand (2892); labels come from `check_lower_label` (2846); call rows are `writer->call_count++`, with part-wide ABI rows `abi->count++` and `call_targets` from `program->object_symbols` (7236-7260).
- Rooms are bounded by the graph's node count: entries `nodes * 32` (19637), locals `nodes * 6` (19646), call rows `nodes * 3` (19747), arguments `graph.argument_count + nodes * 4` (19749). Summary nodes shrink them.

## 8. -g rows

They come from `CheckProgramLowered.entry_tokens` (c_check_debug.c:8-9, 135-139). `check_lower_settle` writes `writer->tokens[e] = writer->source` (c_check_program_lower.c:2450-2456); the source is `graph.tokens[task.node]` for EXPRESSION and BRANCH tasks, else the control's token (16523-16539, 20744); the column is copied at 21013. No debug pass reads the graph: the Q6 grep gives 0 for c_check_debug.c, c_check_debug_values.c and c_check_tier1*.c.

## 9. Sweep, beyond the above

- **Feeds codegen:** the initializer planner, `check_initializers_run_events` (c_check_initializer_input.c:841; called at c_checker_driver.c:12635), in every unit. For each declaration with an initializer (866) it takes the greatest node among `token_nodes[begin..end)` (c_check_initializer.c:1097-1135) and converts its value again (2330-2358). The lowering and the references walk read that part's node (c_check_program.c:3105-3138).
- Also feeding codegen, none in a taken expression: c_check_data*.c (static data), c_check_asm_input.c and c_check_program_asm.c (asm operands), c_check_program_helpers.c (builtins), and the lowering's helpers c_check_program_{batch,half,atomic,transport,contract,x86_lanes,fortify,padding,dump}.c.
- **Diagnostics only:** c_check_semantic_diagnostic.c, c_check_diagnostic.c, c_check_warning_render.c, c_check_warning_source.c, c_check_program_diagnostic.c, the driver's message helpers (c_checker_driver.c:2562-4513).
- **Graph run or reader:** c_checker.c, c_check_transitions.c, c_check_query_runtime.c, c_check_constant.c, c_check_region_input.c, c_check_vla_input.c.
- **Tools:** c_check_corpus.c, c_check_lower_inventory.c.

## 10. Roots and controls

Reader, the wrappers (c_check_expression_input.c):
- `check_input_expression_terminator` (1262): a CAST to void per value, or CONDITION for a for's condition, at the `;` or the for's `)`.
- `check_input_expression_condition` (1310): CONDITION, POSITIVE for a switch; `token_nodes[token]` at 1322.
- `check_input_expression_return` (1235): CONVERT, 1245.
- `check_input_expression_initialize` (1127): INITIALIZE, `initializer_nodes`, 1142.
- The walk's action is `check_input_expression_act` (c_check_input.c:15076; 15453-15460, 15494-15537, 15856-15858, 15897).

Controls are made in c_check_program.c:
- EVALUATE: each node at a terminator (`token_first`, 2755-2786, only without a plan or asm), and a typeof operand (2690).
- BRANCH_FALSE: if/while (`token_nodes[token]`, 2272, 2320, 2331) and for (2393-2396). BRANCH_TRUE: do-while (2500).
- SWITCH (c_check_program_switch.c:378); RETURN, RESULT, tail RETURN (2423-2439); JUMP_INDIRECT (2460-2463); VLA (2719-2725).
- INITIALIZE, ASM and CASE carry no node; LIFETIME's `node` is a flag.

Could not determine: whether the machine takes switch conditions or constant-valued conditions; the default flags of the null-conversion and noderef events.

## Table

| pass | file:function | runs when | reads below a root | consumer | codegen |
| --- | --- | --- | --- | --- | --- |
| references | c_check_program.c:check_program_references | every body | static VALUE leaves, ops, operands, arguments | selection edges, symbols, target groups, prefilters | yes |
| controls folding | check_control_expand, check_control_foldable, check_control_switch_prune | every if/switch; subtree only for a constant value | CONDITION's operand; comma's left | controls, dropped ranges | yes |
| initializer planner | c_check_initializer_input.c:check_initializers_run_events | every unit | source node by `token_nodes` | plans → INITIALIZE | yes |
| lowering and its rooms | c_check_program_lower.c:check_lower_part_body, check_lower_prepare | every lowered body | everything; node counts | entries, rows, -g tokens | yes |
| symbol pragma, late weak | c_check_program_symbol_pragma.c:check_program_symbol_bodies | rename after use, late weak | VALUE object + token, emission walk | symbol spelling, binding | yes |
| candidates' scan | check_program_census_scan, check_program_constant_arms | the three flags | every static VALUE leaf; CONDITION ops | provisional selection | flags only |
| return flow | c_check_return_flow.c:check_program_return_facts; check_program_return_flow | `return_warnings` (default on) | calls' callees, arms, branch truth | `body->return_warning` | no |
| reach, evaluated | c_check_common_warnings.c:check_common_facts, check_common_body_reached | common warnings | branch truth, operand masks | warning passes | no |
| uninitialized, set parameter | check_common_uninitialized | -Wuninitialized, -Wunused-but-set-parameter | local read/write/address, tokens | diagnostics | no |
| for loops | check_common_for_loops | -Wfor-loop-analysis | condition; each use's parent op | diagnostics | no |
| -Wswitch | check_common_switches | default | selector's node type | diagnostics | no |
| root walk, unsequenced, ignored result | check_common_graph_warnings | default | subtrees (silence's) | diagnostics | no |
| warning graph | c_check_warning_graph.c:check_input_warning_graph | every unit | op scan | warning events | no |
| target features | c_check_target_feature.c:check_program_target_features | -c; target attribute, x86 builtin or wide vector | calls, dead ends | errors | no |
| x86 ranges | c_check_x86_diagnostic.c:check_program_x86_diagnostics | deferred range event | reachability | diagnostics | no |
| musttail | c_check_musttail.c:check_musttail_run; check_control_static_chain | `musttail_count != 0` | the return's call | errors; TAIL control | control only |
| selection, emission, -g | c_check_program_select.c, c_check_program_emit.c, c_check_debug.c | -c | none | code | n/a |