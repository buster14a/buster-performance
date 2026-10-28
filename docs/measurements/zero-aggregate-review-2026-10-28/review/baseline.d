cached: adversarial.c src/buster/compiler/main.c \
  src/buster/compiler/c_lexer.c src/buster/compiler/c_lexer_test.c \
  src/buster/compiler/x86_64_encoder.c \
  src/buster/compiler/x86_64_encoder_test.c \
  src/buster/compiler/x86_zen5.c src/buster/compiler/x86_zen5_measure.c \
  src/buster/compiler/x86_zen5_test.c \
  src/buster/compiler/x86_64_disassembler.c \
  src/buster/compiler/x86_64_disassembly.c \
  src/buster/compiler/x86_64_disassembler_test.c \
  src/buster/compiler/x86_64_disassembler_cli.c \
  src/buster/compiler/lane.c src/buster/compiler/lane_test.c \
  src/buster/compiler/diagnostic.c src/buster/compiler/diagnostic_test.c \
  src/buster/compiler/diagnostic_benchmark.c \
  src/buster/compiler/dataflow.c src/buster/compiler/dataflow_program.c \
  src/buster/compiler/dataflow_test.c src/buster/compiler/dominators.c \
  src/buster/compiler/dominators_test.c src/buster/compiler/ssa.c \
  src/buster/compiler/ssa_program.c src/buster/compiler/ssa_test.c \
  src/buster/compiler/ssa_benchmark.c \
  src/buster/compiler/tier1_allocate.c \
  src/buster/compiler/tier1_rematerialize.c \
  src/buster/compiler/tier1_allocate_test.c \
  src/buster/compiler/tier1_moves_test.c \
  src/buster/compiler/preprocessor_fuzz.c \
  src/buster/compiler/preprocessor_fuzz_generate.c \
  src/buster/compiler/preprocessor_fuzz_clang.c \
  src/buster/compiler/preprocessor_fuzz_test.c \
  src/buster/compiler/preprocessor_fuzz_benchmark.c \
  src/buster/compiler/differential.c \
  src/buster/compiler/differential_test.c src/buster/compiler/c_intern.c \
  src/buster/compiler/c_refine.c src/buster/compiler/c_refine_test.c \
  src/buster/compiler/c_predefines.c src/buster/compiler/x86_target.c \
  src/buster/compiler/c_preprocessor.c \
  src/buster/compiler/c_builtin_catalog.c \
  src/buster/compiler/c_preprocessor_history.c \
  src/buster/compiler/test_process.c src/buster/compiler/oracle_cache.c \
  src/buster/compiler/oracle_cache_test.c \
  src/buster/compiler/c_preprocessor_test.c \
  src/buster/compiler/c_preprocessor_time_test.c \
  src/buster/compiler/c_preprocessor_history_test.c \
  src/buster/compiler/c_preprocessor_directives_test.c \
  src/buster/compiler/c_preprocessor_order_test.c \
  src/buster/compiler/c_preprocessor_batch_test.c \
  src/buster/compiler/c_preprocessor_semantic_test.c \
  src/buster/compiler/c_preprocessor_windows_test.c \
  src/buster/compiler/c_predefines_test.c \
  src/buster/compiler/c_preprocessor_fuzz.c \
  src/buster/compiler/c_preprocessor_oracle.c \
  src/buster/compiler/x86_target_forms.c \
  src/buster/compiler/x86_target_test.c src/buster/compiler/c_files.c \
  src/buster/compiler/c_files_test.c src/buster/compiler/c_parser.c \
  src/buster/compiler/c_parser_binding_trace.c \
  src/buster/compiler/c_bindings.c src/buster/compiler/c_gnu.c \
  src/buster/compiler/c_parser_test.c src/buster/compiler/c_gnu_test.c \
  src/buster/compiler/c_gnu_benchmark.c \
  src/buster/compiler/c_bindings_test.c \
  src/buster/compiler/c_bindings_benchmark.c \
  src/buster/compiler/c_parser_bindings.c \
  src/buster/compiler/c_parser_bindings_test.c \
  src/buster/compiler/c_parser_bindings_benchmark.c \
  src/buster/compiler/c_lowering.c src/buster/compiler/c_lowering_test.c \
  src/buster/compiler/c_lowering_benchmark.c src/buster/compiler/link.c \
  src/buster/compiler/link_program.c src/buster/compiler/link_test.c \
  src/buster/compiler/link_order_test.c \
  src/buster/compiler/object_writer.c \
  src/buster/compiler/object_writer_test.c src/buster/compiler/debug.c \
  src/buster/compiler/debug_test.c src/buster/compiler/debug_benchmark.c \
  src/buster/compiler/import.c src/buster/compiler/runtime.c \
  src/buster/compiler/import_test.c src/buster/compiler/bind.c \
  src/buster/compiler/bind_test.c src/buster/compiler/executable.c \
  src/buster/compiler/executable_test.c \
  src/buster/compiler/executable_symbols_test.c \
  src/buster/compiler/debug_executable_test.c \
  src/buster/compiler/object_debug_test.c src/buster/compiler/dynamic.c \
  src/buster/compiler/dynamic_test.c \
  src/buster/compiler/dynamic_libraries_test.c \
  src/buster/compiler/static_test.c src/buster/compiler/snapshot.c \
  src/buster/compiler/snapshot_test.c src/buster/compiler/inflate.c \
  src/buster/compiler/inflate_test.c src/buster/compiler/foreign.c \
  src/buster/compiler/foreign_unwind.c \
  src/buster/compiler/foreign_unwind_benchmark.c \
  src/buster/compiler/foreign_gc.c src/buster/compiler/foreign_link.c \
  src/buster/compiler/foreign_unwind_link.c \
  src/buster/compiler/foreign_debug.c \
  src/buster/compiler/foreign_link_lanes.c \
  src/buster/compiler/foreign_gc_link.c \
  src/buster/compiler/foreign_unwind_dedup.c \
  src/buster/compiler/foreign_unwind_dedup_link.c \
  src/buster/compiler/foreign_strings.c \
  src/buster/compiler/foreign_strings_link.c \
  src/buster/compiler/foreign_driver.c \
  src/buster/compiler/foreign_test.c \
  src/buster/compiler/foreign_link_test.c \
  src/buster/compiler/foreign_dynamic_test.c \
  src/buster/compiler/foreign_copy_test.c \
  src/buster/compiler/foreign_bounds_test.c \
  src/buster/compiler/foreign_stack_test.c \
  src/buster/compiler/foreign_unwind_test.c \
  src/buster/compiler/foreign_unwind_dedup_test.c \
  src/buster/compiler/foreign_unwind_runtime_test.c \
  src/buster/compiler/foreign_gc_test.c \
  src/buster/compiler/foreign_gc_link_test.c \
  src/buster/compiler/foreign_unwind_dedup_link_test.c \
  src/buster/compiler/foreign_strings_test.c \
  src/buster/compiler/foreign_strings_output_test.c \
  src/buster/compiler/foreign_strings_benchmark.c \
  src/buster/compiler/foreign_driver_test.c \
  src/buster/compiler/foreign_driver_symbols_test.c \
  src/buster/compiler/foreign_driver_dedup_test.c \
  src/buster/compiler/foreign_driver_pipeline_test.c \
  src/buster/compiler/foreign_debug_test.c \
  src/buster/compiler/foreign_corpus_test.c \
  src/buster/compiler/foreign_gc_benchmark.c \
  src/buster/compiler/foreign_unwind_dedup_benchmark.c \
  src/buster/compiler/branch_sizing.c \
  src/buster/compiler/branch_sizing_generate.c \
  src/buster/compiler/branch_sizing_test.c \
  src/buster/compiler/x86_match.c src/buster/compiler/assembler.c \
  src/buster/compiler/assembler_words.c \
  src/buster/compiler/assembler_sections.c \
  src/buster/compiler/assembler_cfi.c \
  src/buster/compiler/assembler_driver.c \
  src/buster/compiler/assembler_test.c \
  src/buster/compiler/assembler_compat_test.c \
  src/buster/compiler/assembler_corpus_test.c \
  src/buster/compiler/assembler_benchmark.c \
  src/buster/compiler/x86_semantics.c \
  src/buster/compiler/x86_semantics_test.c \
  src/buster/compiler/tier1_schedule.c \
  src/buster/compiler/tier1_schedule_test.c \
  src/buster/compiler/c_types.c \
  src/buster/compiler/c_types_transparent.c \
  src/buster/compiler/c_builtin_intrinsic_types.c \
  src/buster/compiler/c_builtin_intrinsic_features.c \
  src/buster/compiler/c_builtin_intrinsic_catalog.c \
  src/buster/compiler/generated/clang_builtin_metadata_23_1_1.inc \
  src/buster/compiler/generated/clang_builtin_own_main_23_1_1.inc \
  src/buster/compiler/c_types_test.c \
  src/buster/compiler/c_types_deferred_test.c \
  src/buster/compiler/c_environment.c \
  src/buster/compiler/c_environment_test.c \
  src/buster/compiler/c_environment_benchmark.c \
  src/buster/compiler/c_check_environment.c \
  src/buster/compiler/c_check_body_bindings.c \
  src/buster/compiler/c_check_lazy.c src/buster/compiler/c_builtin.c \
  src/buster/compiler/c_builtin_test.c \
  src/buster/compiler/c_check_actions.c \
  src/buster/compiler/c_check_integer_extension.c \
  src/buster/compiler/c_check_complex.c \
  src/buster/compiler/c_check_vector.c \
  src/buster/compiler/c_check_builtin_x86.c \
  src/buster/compiler/c_check_builtin.c \
  src/buster/compiler/c_check_varargs.c \
  src/buster/compiler/c_check_builtin_misc.c \
  src/buster/compiler/c_check_builtin_query.c \
  src/buster/compiler/c_check_builtin_bit_cast.c \
  src/buster/compiler/c_check_builtin_float.c \
  src/buster/compiler/c_check_builtin_math.c \
  src/buster/compiler/c_check_builtin_atomic.c \
  src/buster/compiler/c_check_builtin_atomic_rmw.c \
  src/buster/compiler/c_check_builtin_vector.c \
  src/buster/compiler/c_check_builtin_typed_overflow.c \
  src/buster/compiler/c_check_builtin_rounds.c \
  src/buster/compiler/c_checker.c src/buster/compiler/c_check_overload.c \
  src/buster/compiler/c_check_overload_address.c \
  src/buster/compiler/c_check_builtin_graph_metadata.c \
  src/buster/compiler/c_check_overload_graph.c \
  src/buster/compiler/c_check_region_graph.c \
  src/buster/compiler/c_check_query_runtime.c \
  src/buster/compiler/c_check_literals.c \
  src/buster/compiler/c_check_initializer.c \
  src/buster/compiler/c_check_initializer_vector.c \
  src/buster/compiler/c_check_constant_bytes.c \
  baseline/buster/compiler/c_check_data.c \
  src/buster/compiler/c_check_input.c \
  src/buster/compiler/c_check_attribute.c \
  src/buster/compiler/c_check_function_name_input.c \
  src/buster/compiler/c_check_pragma_input.c \
  src/buster/compiler/c_check_pack_input.c \
  src/buster/compiler/c_check_fp_input.c \
  src/buster/compiler/c_check_loop_input.c \
  src/buster/compiler/c_check_builtin_evidence.c \
  src/buster/compiler/c_check_generic.c \
  src/buster/compiler/c_check_constant.c \
  src/buster/compiler/c_check_intrinsic_input.c \
  src/buster/compiler/c_check_builtin_constant.c \
  src/buster/compiler/c_check_select.c \
  src/buster/compiler/c_check_vla_input.c \
  src/buster/compiler/c_check_overload_input.c \
  src/buster/compiler/c_check_record_input.c \
  src/buster/compiler/c_check_enum_input.c \
  src/buster/compiler/c_check_input_initializer.c \
  src/buster/compiler/c_check_control_input.c \
  src/buster/compiler/c_check_builtin_input.c \
  src/buster/compiler/c_check_asm_input.c \
  src/buster/compiler/c_check_region_input.c \
  src/buster/compiler/c_check_binding.c \
  src/buster/compiler/c_check_packed_input.c \
  src/buster/compiler/c_check_x86_input.c \
  src/buster/compiler/c_check_naked_input.c \
  src/buster/compiler/c_check_deferred.c \
  src/buster/compiler/c_check_diagnostic.c \
  src/buster/compiler/c_check_packed_diagnostic.c \
  src/buster/compiler/c_check_initializer_input.c \
  src/buster/compiler/c_check_data_input.c \
  src/buster/compiler/calling_convention.c \
  src/buster/compiler/calling_convention_test.c \
  src/buster/compiler/tier1_frame.c \
  src/buster/compiler/tier1_frame_test.c \
  src/buster/compiler/tier1_frame_emit.c \
  src/buster/compiler/tier1_frame_execution_test.c \
  src/buster/compiler/tier0.c src/buster/compiler/unwind.c \
  src/buster/compiler/unwind_tier0.c \
  src/buster/compiler/tier0_generate.c src/buster/compiler/tier0_test.c \
  src/buster/compiler/tier0_x87_test.c \
  src/buster/compiler/tier0_int128_test.c \
  src/buster/compiler/tier0_vector_test.c \
  src/buster/compiler/tier0_label_test.c \
  src/buster/compiler/tier0_deep_test.c \
  src/buster/compiler/c_builtin_lower.c \
  src/buster/compiler/c_builtin_lower_test.c \
  src/buster/compiler/c_builtin_lower_benchmark.c \
  src/buster/compiler/c_builtin_varargs_lower.c \
  src/buster/compiler/c_builtin_varargs_lower_test.c \
  src/buster/compiler/c_builtin_misc_lower.c \
  src/buster/compiler/c_builtin_misc_lower_test.c \
  src/buster/compiler/c_builtin_float_lower.c \
  src/buster/compiler/c_builtin_float_lower_test.c \
  src/buster/compiler/c_builtin_terminal_helpers.c \
  src/buster/compiler/c_builtin_terminal_helpers_test.c \
  src/buster/compiler/c_builtin_atomic_helpers.c \
  src/buster/compiler/c_builtin_atomic_helpers_test.c \
  src/buster/compiler/c_builtin_atomic_rmw_helpers.c \
  src/buster/compiler/c_builtin_atomic_rmw_helpers_test.c \
  src/buster/compiler/c_builtin_rounds_helper.c \
  src/buster/compiler/c_builtin_rounds_helper_test.c \
  src/buster/compiler/c_builtin_math_helpers.c \
  src/buster/compiler/c_builtin_math_helpers_test.c \
  src/buster/compiler/tier0_variadic_frame_test.c \
  src/buster/compiler/unwind_tier0_test.c \
  src/buster/compiler/unwind_test.c \
  src/buster/compiler/unwind_native_test.c \
  src/buster/compiler/unwind_benchmark.c src/buster/compiler/streaming.c \
  src/buster/compiler/streaming_test.c \
  src/buster/compiler/streaming_benchmark.c \
  src/buster/compiler/c_check_program.c \
  src/buster/compiler/c_check_program_diagnostic.c \
  src/buster/compiler/c_check_x86_diagnostic.c \
  src/buster/compiler/c_check_program_select.c \
  src/buster/compiler/c_check_program_helpers.c \
  src/buster/compiler/c_check_program_asm.c \
  src/buster/compiler/c_check_program_lower.c \
  src/buster/compiler/c_check_program_batch.c \
  src/buster/compiler/c_check_debug.c \
  src/buster/compiler/c_check_clock.c \
  src/buster/compiler/c_check_program_emit.c \
  src/buster/compiler/c_lowering_symbols.c \
  src/buster/compiler/c_check_prefix.c \
  src/buster/compiler/c_check_repair.c \
  src/buster/compiler/c_checker_driver.c \
  src/buster/compiler/c_checker_test.c \
  src/buster/compiler/c_check_graph_test.c \
  src/buster/compiler/c_check_builtin_graph_test.c \
  src/buster/compiler/c_check_varargs_graph_test.c \
  src/buster/compiler/c_check_special_graph_test.c \
  src/buster/compiler/c_check_builtin_vector_graph_test.c \
  src/buster/compiler/c_check_x86_graph_test.c \
  src/buster/compiler/c_check_binding_test.c \
  src/buster/compiler/c_check_body_bindings_test.c \
  src/buster/compiler/c_check_environment_test.c \
  src/buster/compiler/c_check_source_test.c \
  src/buster/compiler/c_check_overload_test.c \
  src/buster/compiler/c_check_overload_address_test.c \
  src/buster/compiler/c_types_function_abi_test.c \
  src/buster/compiler/c_check_constant_test.c \
  src/buster/compiler/c_check_generic_test.c \
  src/buster/compiler/c_check_enum_test.c \
  src/buster/compiler/c_check_vla_test.c \
  src/buster/compiler/c_check_data_test.c \
  src/buster/compiler/c_check_data_bit_field_test.c \
  src/buster/compiler/c_check_actions_extra_test.c \
  src/buster/compiler/c_check_transparent_test.c \
  src/buster/compiler/c_check_transparent_type_test.c \
  src/buster/compiler/c_check_complex_test.c \
  src/buster/compiler/c_check_integer_extension_test.c \
  src/buster/compiler/c_check_integer_policy_test.c \
  src/buster/compiler/c_check_fp_actions_test.c \
  src/buster/compiler/c_check_query_runtime_test.c \
  src/buster/compiler/c_check_vector_test.c \
  src/buster/compiler/c_check_vector_graph_test.c \
  src/buster/compiler/c_check_function_name_test.c \
  src/buster/compiler/c_check_pragma_test.c \
  src/buster/compiler/c_check_diagnostic_test.c \
  src/buster/compiler/c_check_lazy_test.c \
  src/buster/compiler/c_check_intrinsic_input_test.c \
  src/buster/compiler/c_check_initializer_test.c \
  src/buster/compiler/c_check_initializer_overload_test.c \
  src/buster/compiler/c_check_initializer_diagnostic_test.c \
  src/buster/compiler/c_check_initializer_excess_test.c \
  src/buster/compiler/c_check_data_source_test.c \
  src/buster/compiler/c_check_attribute_test.c \
  src/buster/compiler/c_check_program_test.c \
  src/buster/compiler/c_check_program_helpers_test.c \
  src/buster/compiler/c_check_program_diagnostic_test.c \
  src/buster/compiler/c_check_control_input_test.c \
  src/buster/compiler/c_check_program_select_test.c \
  src/buster/compiler/c_check_program_query_test.c \
  src/buster/compiler/c_check_region_input_test.c \
  src/buster/compiler/c_check_program_atomic_test.c \
  src/buster/compiler/c_check_program_asm_test.c \
  src/buster/compiler/c_check_program_batch_test.c \
  src/buster/compiler/c_check_prefix_test.c \
  src/buster/compiler/c_check_repair_test.c \
  src/buster/compiler/c_check_input_scan_test.c \
  src/buster/compiler/c_builtin_intrinsic_types_test.c \
  src/buster/compiler/c_builtin_intrinsic_features_test.c \
  src/buster/compiler/c_builtin_intrinsic_catalog_test.c \
  src/buster/compiler/c_builtin_intrinsic_inventory_test.c \
  src/buster/compiler/c_check_builtin_x86_test.c \
  src/buster/compiler/c_check_builtin_vector_test.c \
  src/buster/compiler/c_check_builtin_test.c \
  src/buster/compiler/c_check_varargs_test.c \
  src/buster/compiler/c_check_builtin_misc_test.c \
  src/buster/compiler/c_check_builtin_query_test.c \
  src/buster/compiler/c_check_builtin_bit_cast_test.c \
  src/buster/compiler/c_check_builtin_float_test.c \
  src/buster/compiler/c_check_builtin_math_test.c \
  src/buster/compiler/c_check_builtin_atomic_test.c \
  src/buster/compiler/c_check_builtin_atomic_rmw_test.c \
  src/buster/compiler/c_check_builtin_typed_overflow_test.c \
  src/buster/compiler/c_check_builtin_rounds_test.c \
  src/buster/compiler/c_check_corpus.c \
  src/buster/compiler/c_check_mutation.c \
  src/buster/compiler/c_check_deferred_test.c \
  src/buster/compiler/c_check_mutation_test.c \
  src/buster/compiler/c_checker_driver_test.c \
  src/buster/compiler/c_check_packed_test.c \
  src/buster/compiler/c_check_x86_diagnostic_test.c \
  src/buster/compiler/c_check_capacity_test.c \
  src/buster/compiler/c_check_debug_test.c \
  src/buster/compiler/c_check_lanes_test.c \
  src/buster/compiler/c_check_unwind_test.c \
  src/buster/compiler/c_check_asm_test.c \
  src/buster/compiler/c_check_source_benchmark.c \
  src/buster/compiler/c_check_deferred_benchmark.c \
  src/buster/compiler/c_lowering_source_benchmark.c \
  src/buster/compiler/tier0_source_benchmark.c \
  src/buster/compiler/tier0_benchmark_measure.c \
  src/buster/compiler/c_check_lanes_benchmark.c \
  src/buster/compiler/c_check_binding_benchmark.c \
  src/buster/compiler/c_check_debug_benchmark.c \
  src/buster/compiler/c_check_source_benchmark_test.c \
  src/buster/compiler/c_lowering_source_benchmark_test.c \
  src/buster/compiler/tier0_source_benchmark_test.c \
  src/buster/compiler/c_check_corpus_symbols_test.c \
  src/buster/compiler/ir.c src/buster/compiler/ir_lower.c \
  src/buster/compiler/ir_lower_emit.c src/buster/compiler/ssa_ir.c \
  src/buster/compiler/ir_validate.c src/buster/compiler/interpreter.c \
  src/buster/compiler/interpreter_native.c \
  src/buster/compiler/interpreter_link.c src/buster/compiler/ir_parse.c \
  src/buster/compiler/ir_interpreter.c src/buster/compiler/ir_test.c \
  src/buster/compiler/ir_lower_test.c src/buster/compiler/ssa_ir_test.c \
  src/buster/compiler/ir_parse_test.c \
  src/buster/compiler/interpreter_test.c \
  src/buster/compiler/interpreter_native_test.c \
  src/buster/compiler/interpreter_link_test.c \
  src/buster/compiler/ir_interpreter_test.c \
  src/buster/compiler/interpreter_driver.c \
  src/buster/compiler/ir_benchmark.c \
  src/buster/compiler/ir_lower_benchmark.c \
  src/buster/compiler/ir_optimize.c \
  src/buster/compiler/ir_optimize_inline.c \
  src/buster/compiler/ir_optimize_inline_test.c \
  src/buster/compiler/ir_optimize_test.c \
  src/buster/compiler/ir_optimize_benchmark.c \
  src/buster/compiler/ir_optimize_gvn.c \
  src/buster/compiler/ir_optimize_gvn_test.c \
  src/buster/compiler/ir_optimize_licm.c \
  src/buster/compiler/ir_optimize_licm_test.c \
  src/buster/compiler/ir_optimize_sroa.c \
  src/buster/compiler/ir_optimize_sroa_test.c \
  src/buster/compiler/ir_optimize_passes_benchmark.c \
  src/buster/compiler/tier1_select.c \
  src/buster/compiler/tier1_select_test.c \
  src/buster/compiler/tier1_liveness.c \
  src/buster/compiler/tier1_liveness_test.c \
  src/buster/compiler/tier1_emit.c src/buster/compiler/tier1_emit_test.c \
  src/buster/compiler/tier1_call_test.c \
  src/buster/compiler/tier1_narrow_test.c \
  src/buster/compiler/tier1_terminal_test.c \
  src/buster/compiler/tier1_pipeline_test.c \
  src/buster/compiler/ir_stack_test.c src/buster/compiler/call_graph.c \
  src/buster/compiler/call_graph_test.c src/buster/compiler/profile.c \
  src/buster/compiler/profile_test.c \
  src/buster/compiler/compile_measure.c src/buster/compiler/parallel.c \
  src/buster/compiler/parallel_test.c src/buster/compiler/c_testsuite.c
