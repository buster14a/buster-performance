# C12c-3 core-3: bit 14's remaining sites, classified (core-2 head 88741d83b)

## A. Twins selected only by --scalar (ParseOptions.scalar / CheckSource.scalar) or by tests: core-3's scope
- c_check_environment.c:41 check_environment_body_count: roles scan vs every token. Every unit.
- c_check_literals.c check_literal_strings_by(scalar): only c_check_input.c:6657 passes --scalar; the step
  (check_literal_string_part_scalar) stays: raw, non-ordinary encodings and `extended` (#1447) take it. Drop the flag only.
- c_check_condition.c:1225 condition declarations' marks (vector && count <= INT32_MAX: the walk stays for huge counts?).
- c_check_overload_index.c:117 check_overload_index_find(scalar): callers pass options.scalar
  (condition.c:817, overload_input.c:75/121/122/211).
- c_check_mangle.c:127 (substitutions), :174 (global tags scan) by CheckSource.scalar.
- c_check_unsequenced.c marks (:1044), repeats (:928), plans' sort (:1227, c_bindings_sort: bindings module's flag)
  by common_warnings.c:7583's vector (--scalar). -Wunsequenced (-Wall).
- c_check_deferred.c entries/entries64/count_bytes(vector) by pass.vector = !--scalar && !scalar_merge;
  deferred_expressions.c:889/903 by scalar_merge (check_corpus's tool option). Only with --deferred-bodies.

## B. Scalar arm chosen by production code (phase D or a sweep first; not core-3)
- CheckAction.scalar: c_checker.c:3105 false; c_check_condition_eval.c:182 TRUE (the constant conditions' evaluator).
  -> member lookup (type_lookup_member_scalar, c_types.c: types module, also the initializers' bit 30) and the wide
  fold's kernels (CheckWideKernels.scalar). Wide's divide uses check_wide_add_scalar/compare_scalar itself (keep).
- CheckOverloadRequest.scalar -> rank order: check_overload_explain passes TRUE (semantic_diagnostic.c:2184);
  graph passes false; c_check_constant.c:2857 passes --scalar. Sweep argument counts before deleting.
- check_builtins(scalar): c_checker.c:3160/3165 and query_runtime.c:435 pass TRUE (one lane, cbuiltin_fold_scalar,
  c_builtin.c: builtins module); builtin_constant.c passes --scalar. Sweep one lane.
- c_check_debug.c rows: origins != 0 (Tier 1's events) takes check_debug_rows_scalar: data-selected, stays.

## C. Owned by another piece
- c_check_debug.c exact (driver's --scalar for -g): lines/keep twins + debug_prepare(exact) (debug.c): the check-debug
  piece (test-check-debug --cross-check, benchmark-check-debug compares both).
- c_check_target_feature.c scalar -> c_bindings_sort(!scalar): bindings piece.
- c_check_unsequenced.c:1227 c_bindings_sort(vector): bindings piece (the flag's other use goes in core-3).
- c_check_initializer*.c, init_history: bit 30, waits for David.

## D. Not paths
- check_action_is_scalar (C scalar types), check_action_scalar (one action's compute), unsequenced.c:1194's local
  (a declaration's initializer is a scalar's).
