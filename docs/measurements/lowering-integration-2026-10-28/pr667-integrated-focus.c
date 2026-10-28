// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// The executable's entry point, main, which includes most of the compiler and all of its tests. build.sh compiles this
// file once per unit, in parallel, so that the build waits for the largest unit rather than for all of this code in one
// clang process (#270): main.c alone is the driver's unit, and each main_unit_*.c names another unit and includes this
// file. Every unit reads all of it, and so has the whole file's diagnostics, but emits only its own commands' code: each
// of main_command's branches first tests its unit, so that the other units' branches fold to false, and clang, which
// emits a static function only once emitted code refers to it, emits none of theirs. main, in the driver's unit, asks
// each other unit for the command in turn, then its own commands, then runs the compiler itself.
//
// The modules that several units' commands run compile in one unit alone, their home, which the others call (#270):
// the lexer in the driver's unit, the preprocessor and the parser in the front end's, and the linker's (the runtime's
// import and binding, a PIE's inputs and the executable writer) in the dynamic PIEs' unit. A module's entry points
// take its macro (BUSTER_LEXER_ENTRY and the others, below) where its other functions take static: in the home it is
// nothing, so that they have external linkage there, and in the other units BUSTER_ELSEWHERE, which makes their
// definitions inline ones that are never inlined, which clang doesn't emit: their calls go to the home's, and the
// static functions that only the entry points reach aren't emitted there either. A unit without main.c, a benchmark's,
// has them static. Each unit still reads every definition, so that its diagnostics are the whole file's. A command
// whose code calls a home's entry point runs in two units' copies of the code, so a home's code must share no static
// variable with its callers' units: main.c's units have one lane context (lane.c), and ./build.sh check-call-graph
// checks the rest (call_graph.c).
#define BUSTER_UNIT_DRIVER 0
#define BUSTER_UNIT_X86 1
#define BUSTER_UNIT_FRONTEND 2
#define BUSTER_UNIT_ASSEMBLER 3
#define BUSTER_UNIT_LINK 4
#define BUSTER_UNIT_EXECUTABLE 5
#define BUSTER_UNIT_DYNAMIC 6
#define BUSTER_UNIT_TYPES 7
#define BUSTER_UNIT_BACKEND 8
#define BUSTER_UNIT_CHECKER 9
#define BUSTER_UNIT_CHECK_BUILTINS 10
#ifndef BUSTER_UNIT
#define BUSTER_UNIT BUSTER_UNIT_DRIVER
#endif
#define BUSTER_IN_UNIT(unit) (BUSTER_UNIT == (unit))

// An entry point in a unit that isn't its module's home: an inline definition, which clang emits only to inline it,
// and noinline keeps it from that, so that the unit's calls go to the home's external definition. Calling the module's
// static functions from it is a C2y feature that clang takes in C17 as an extension (-Wstatic-in-inline): the
// definition is only ever compiled in its home.
#define BUSTER_ELSEWHERE static
#pragma clang diagnostic ignored "-Wstatic-in-inline"
#if BUSTER_IN_UNIT(BUSTER_UNIT_DRIVER)
#define BUSTER_HOME_DRIVER
#else
#define BUSTER_HOME_DRIVER BUSTER_ELSEWHERE
#endif
#if BUSTER_IN_UNIT(BUSTER_UNIT_FRONTEND)
#define BUSTER_HOME_FRONTEND
#else
#define BUSTER_HOME_FRONTEND BUSTER_ELSEWHERE
#endif
#if BUSTER_IN_UNIT(BUSTER_UNIT_DYNAMIC)
#define BUSTER_HOME_DYNAMIC
#else
#define BUSTER_HOME_DYNAMIC BUSTER_ELSEWHERE
#endif
// The modules' homes (at the top): the lexer's (c_lexer.c), the preprocessor's (c_preprocessor.c), the parser's
// (c_parser.c) and the linker's (link.c's).
#define BUSTER_LEXER_ENTRY BUSTER_HOME_DRIVER
#define BUSTER_PREPROCESSOR_ENTRY BUSTER_HOME_FRONTEND
#define BUSTER_PARSER_ENTRY BUSTER_HOME_FRONTEND
#define BUSTER_LINKER_ENTRY BUSTER_HOME_DYNAMIC

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <limits.h>
#include <assert.h>
#include <errno.h>

#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#define BUSTER_COMPILE_TIME_STRING_LENGTH(strlit) (BUSTER_ARRAY_LENGTH(strlit) - 1)
#define BUSTER_S8_INIT(strlit) {.pointer = (char*)(strlit), .length = BUSTER_COMPILE_TIME_STRING_LENGTH(strlit)}
#define BUSTER_S8(strlit) ((String8)BUSTER_S8_INIT(strlit))

// OS-dependent includes
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>

// CPU architecture dependent includes
#include <immintrin.h>

#include "buster/compiler/c_lexer.c"

typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};

// The lexer benchmark is a separate translation unit, linked into the compiler executable.
int run_c_lexer_benchmark(int argc, char** argv);

// The lexer tests, for the test-lexer command.
#include "buster/compiler/c_lexer_test.c"

// The x86-64 encoder and its tests, for the test-x86-encoder command. Its benchmark is another translation unit.
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_64_encoder_test.c"
#include "buster/compiler/x86_zen5.c"
#include "buster/compiler/x86_zen5_measure.c"
#include "buster/compiler/x86_zen5_test.c"
#include "buster/compiler/x86_64_disassembler.c"
#include "buster/compiler/x86_64_disassembler_test.c"
#include "buster/compiler/x86_64_disassembler_cli.c"
int run_x86_disassembler_benchmark(int argc, char** argv);
int run_x86_encoder_benchmark(int argc, char** argv);

// The lane base layer (groups of threads, and the arenas they allocate from) and its tests, for the test-lanes command.
// Its benchmark is another translation unit.
#include "buster/compiler/lane.c"
#include "buster/compiler/lane_test.c"
int run_lane_benchmark(int argc, char** argv);

#include "buster/compiler/diagnostic.c"
#include "buster/compiler/diagnostic_test.c"
#include "buster/compiler/diagnostic_benchmark.c"

// Liveness and interference over aligned bitsets, independent of the future IR's use/def construction.
#include "buster/compiler/dataflow.c"
#include "buster/compiler/dataflow_program.c"
#include "buster/compiler/dataflow_test.c"
int run_dataflow_benchmark(int argc, char** argv);

// Entry-rooted dominance, frontiers and natural loops over borrowed CFG columns.
#include "buster/compiler/dominators.c"
#include "buster/compiler/dominators_test.c"
int run_dominator_benchmark(int argc, char** argv);

// Local promotion over a completed CFG: vector SSA construction, its nonrecursive scalar twin and semantic tests.
#include "buster/compiler/ssa.c"
#include "buster/compiler/ssa_program.c"
#include "buster/compiler/ssa_test.c"
#include "buster/compiler/ssa_benchmark.c"

#include "buster/compiler/tier1_allocate.c"
#include "buster/compiler/tier1_rematerialize.c"
#include "buster/compiler/tier1_allocate_test.c"
int run_tier1_allocate_benchmark(int argc, char** argv);

// The preprocessor's fuzz tooling (#109): the generator, the clang oracle, the comparison and the minimizer, and their
// self-tests, for the test-preprocessor-fuzz command. test-preprocessor --fuzz runs the preprocessor against them
// (c_preprocessor_fuzz.c).
#include "buster/compiler/preprocessor_fuzz.c"
#include "buster/compiler/preprocessor_fuzz_generate.c"
#include "buster/compiler/preprocessor_fuzz_clang.c"
#include "buster/compiler/preprocessor_fuzz_test.c"
#include "buster/compiler/preprocessor_fuzz_benchmark.c"

// External randomized C compiler comparison and its independent process/accounting fixtures.
#include "buster/compiler/differential.c"
#include "buster/compiler/differential_test.c"

// Token refinement: identifier interning (c_intern.c) and the per-file pass after the lexer (c_refine.c), and their
// tests, for the test-refinement command. Its benchmark is another translation unit.
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_refine_test.c"
int run_refinement_benchmark(int argc, char** argv);

// The preprocessor (c_preprocessor.c, with the predefined macros of c_predefines.c) and its tests, for the -E and
// test-preprocessor commands.
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"
#include "buster/compiler/c_builtin_catalog.c"
#include "buster/compiler/test_process.c"
// The clang and gcc runs the tests compare with, kept between runs (#542), and its tests, for the test-oracle-cache
// command.
#include "buster/compiler/oracle_cache.c"
#include "buster/compiler/oracle_cache_test.c"
#include "buster/compiler/c_preprocessor_test.c"
#include "buster/compiler/c_predefines_test.c"
#include "buster/compiler/c_preprocessor_fuzz.c"
#include "buster/compiler/c_preprocessor_oracle.c"
#include "buster/compiler/x86_target_forms.c"
#include "buster/compiler/x86_target_test.c"
int run_preprocessor_benchmark(int argc, char** argv);

// The per-file jobs on lanes and the run-ahead that fill the preprocessor's file cache (c_files.c), and their tests, for
// the test-files command. Its benchmark is another translation unit.
#include "buster/compiler/c_files.c"
#include "buster/compiler/c_files_test.c"
int run_files_benchmark(int argc, char** argv);

// The parser (c_parser.c) and its tests, for the default command, which preprocesses and parses a file, and the
// test-parser command.
#include "buster/compiler/c_parser.c"
#include "buster/compiler/c_parser_test.c"
#include "buster/compiler/c_gnu_test.c"
#include "buster/compiler/c_gnu_benchmark.c"
int run_parser_benchmark(int argc, char** argv);

// Scoped name-resolution kernels and their event-stream oracle; c_parser.c includes the shared kernels.
#include "buster/compiler/c_bindings_test.c"
#include "buster/compiler/c_bindings_benchmark.c"
#include "buster/compiler/c_parser_bindings.c"
#include "buster/compiler/c_parser_bindings_test.c"
#include "buster/compiler/c_parser_bindings_benchmark.c"

// Selective lowering consumes resolved definition/reference columns; the checker producer is still pending.
#include "buster/compiler/c_lowering.c"
#include "buster/compiler/c_lowering_test.c"
#include "buster/compiler/c_lowering_benchmark.c"

// The link representation (atoms, symbols, fixups and names, which the object writer and the linker share), the test
// programs generated in it, and their tests, for the test-link command.
#include "buster/compiler/link.c"
#include "buster/compiler/link_program.c"
#include "buster/compiler/link_test.c"
#include "buster/compiler/link_order_test.c"

// The object writer (ET_REL objects from the link representation, for -c) and its tests, for the test-object-writer
// command. Its benchmark is another translation unit.
#include "buster/compiler/object_writer.c"
#include "buster/compiler/object_writer_test.c"
#include "buster/compiler/debug.c"
#include "buster/compiler/debug_test.c"
#include "buster/compiler/debug_benchmark.c"
int run_object_writer_benchmark(int argc, char** argv);

// The import path's readers (ELF objects, archives, shared libraries and linker scripts into the link representation),
// the C runtime's files, found and imported with them, and their tests, for the test-import command.
#include "buster/compiler/import.c"
#include "buster/compiler/runtime.c"
#include "buster/compiler/import_test.c"
int run_import_benchmark(int argc, char** argv);

// Binding: the C runtime joined to a program's link and each name bound, and its tests, for the test-bind command. Its
// benchmark is another translation unit.
#include "buster/compiler/bind.c"
#include "buster/compiler/bind_test.c"
int run_bind_benchmark(int argc, char** argv);

// The direct path's executables (layout, patching, the build ID and the output file) and their tests, for the
// test-executable command. Its benchmark is another translation unit.
#include "buster/compiler/executable.c"
#include "buster/compiler/executable_test.c"
#include "buster/compiler/debug_executable_test.c"
// The object writer's DWARF checks (ObjectOptions.debug), which test-object-writer runs: they need debug.c's units and
// the executable tests' ELF reading.
#include "buster/compiler/object_debug_test.c"
int run_executable_benchmark(int argc, char** argv);

// A dynamic PIE's inputs from the runtime and binding, and the dynamic PIE's tests, for the test-dynamic command.
#include "buster/compiler/dynamic.c"
#include "buster/compiler/dynamic_test.c"

// The static executables' tests with the C runtime, for the test-static command.
#include "buster/compiler/static_test.c"

// The runtime snapshot (the imported runtime kept in the cache directory) and its tests, for the test-snapshot command.
// Its benchmark is another translation unit.
#include "buster/compiler/snapshot.c"
#include "buster/compiler/snapshot_test.c"
int run_snapshot_benchmark(int argc, char** argv);

// Foreign inputs (other compilers' objects, archives, shared libraries and scripts: opened, parsed and resolved, with
// the archive members the link needs loaded and COMDAT groups picked) and their tests, for the test-foreign command. Its
// benchmark is another translation unit.
#include "buster/compiler/inflate.c"
#include "buster/compiler/inflate_test.c"
#include "buster/compiler/foreign.c"
#include "buster/compiler/foreign_unwind.c"
#include "buster/compiler/foreign_unwind_benchmark.c"
#include "buster/compiler/foreign_gc.c"
#include "buster/compiler/foreign_link.c"
#include "buster/compiler/foreign_gc_link.c"
#include "buster/compiler/foreign_unwind_dedup.c"
#include "buster/compiler/foreign_unwind_dedup_link.c"
#include "buster/compiler/foreign_strings.c"
#include "buster/compiler/foreign_strings_link.c"
#include "buster/compiler/foreign_driver.c"
#include "buster/compiler/foreign_test.c"
#include "buster/compiler/foreign_gc_benchmark.c"
#include "buster/compiler/foreign_unwind_dedup_benchmark.c"
int run_foreign_benchmark(int argc, char** argv);
// The link benchmark (the direct path against the object writer and the linkers, on the same programs) and the floors'
// (what the machine and the kernel charge a linker) are other translation units.
int run_link_benchmark(int argc, char** argv);
int run_floors_benchmark(int argc, char** argv);

// Branch sizing (each branch's rel8 or rel32 form inside a function, before it's encoded), the functions its tests
// generate, and its tests, for the test-branch-sizing command. Its benchmark is another translation unit.
#include "buster/compiler/branch_sizing.c"
#include "buster/compiler/branch_sizing_generate.c"
#include "buster/compiler/branch_sizing_test.c"
int run_branch_sizing_benchmark(int argc, char** argv);

#include "buster/compiler/x86_match.c"
#include "buster/compiler/assembler.c"
#include "buster/compiler/assembler_driver.c"
#include "buster/compiler/assembler_test.c"
#include "buster/compiler/assembler_benchmark.c"

// What the x86 forms a code generator emits mean (their effects, the immediate's contract, the operand-resolved effects
// and the value-preserving form choice) and its tests, for the test-x86-semantics command (which takes the encoder's
// tests' printer and branch sizing's tests' runner, and checks x86_match.c's ranges). Its benchmark is another
// translation unit.
#include "buster/compiler/x86_semantics.c"
#include "buster/compiler/x86_semantics_test.c"
int run_x86_semantics_benchmark(int argc, char** argv);

// Experimental postallocation scheduling over resolved machine-record effects and measured operand costs.
#include "buster/compiler/tier1_schedule.c"
#include "buster/compiler/tier1_schedule_test.c"
int run_tier1_schedule_benchmark(int argc, char** argv);

// The C type table (TypeIds, hash-consing, layout, conversions, compatibility and printing) and its tests, for the
// test-types command. Its benchmark is another translation unit.
#include "buster/compiler/c_types.c"
#include "buster/compiler/c_builtin_intrinsic_types.c"
#include "buster/compiler/c_builtin_intrinsic_features.c"
#include "buster/compiler/c_builtin_intrinsic_catalog.c"
#include "buster/compiler/c_types_test.c"
int run_type_benchmark(int argc, char** argv);

// Immutable source-position histories retain declaration visibility for deferred body consumers.
#include "buster/compiler/c_environment.c"
#include "buster/compiler/c_environment_test.c"
#include "buster/compiler/c_environment_benchmark.c"
// The checker's own code goes in a section of its own, .text.buster_checker, which every unit starts on a page (#502):
// the driver's time depends on where its hot loops fall in the instruction caches, and code compiled before them, in
// their unit or in another, moved them by any number of bytes. In their section, only the checker's own code moves
// them. Its tests and the builtins' actions, which the driver seldom runs, stay in .text.
__asm__(".section .text.buster_checker,\"ax\",@progbits\n\t.p2align 12\n\t.text");
#pragma clang section text = ".text.buster_checker"
#include "buster/compiler/c_check_environment.c"
#include "buster/compiler/c_check_body_bindings.c"
#include "buster/compiler/c_check_lazy.c"
#pragma clang section text = ""

#include "buster/compiler/c_builtin.c"
#include "buster/compiler/c_builtin_test.c"
#pragma clang section text = ".text.buster_checker"
#include "buster/compiler/c_check_actions.c"
#pragma clang section text = ""
#include "buster/compiler/c_check_builtin_x86.c"
#include "buster/compiler/c_check_builtin.c"
#include "buster/compiler/c_check_varargs.c"
#include "buster/compiler/c_check_builtin_misc.c"
#include "buster/compiler/c_check_builtin_query.c"
#include "buster/compiler/c_check_builtin_bit_cast.c"
#include "buster/compiler/c_check_builtin_float.c"
#include "buster/compiler/c_check_builtin_math.c"
#include "buster/compiler/c_check_builtin_atomic.c"
#include "buster/compiler/c_check_builtin_atomic_rmw.c"
#include "buster/compiler/c_check_builtin_vector.c"
#include "buster/compiler/c_check_builtin_typed_overflow.c"
#include "buster/compiler/c_check_builtin_rounds.c"
#pragma clang section text = ".text.buster_checker"
#include "buster/compiler/c_checker.c"
#include "buster/compiler/c_check_literals.c"
#include "buster/compiler/c_check_initializer.c"
#include "buster/compiler/c_check_data.c"
#include "buster/compiler/c_check_input.c"
// #113's deferred bodies: check_input with every function body read apart, out of order and on lanes.
#include "buster/compiler/c_check_deferred.c"
#include "buster/compiler/c_check_diagnostic.c"
#include "buster/compiler/c_check_initializer_input.c"
#include "buster/compiler/c_check_data_input.c"
#pragma clang section text = ""
int run_checker_benchmark(int argc, char** argv);
int run_builtin_benchmark(int argc, char** argv);

// The System V calling convention (each type's classes, and each call's argument locations) and its tests, for the
// test-calling-convention command. Its benchmark is another translation unit.
#include "buster/compiler/calling_convention.c"
#include "buster/compiler/calling_convention_test.c"
int run_calling_convention_benchmark(int argc, char** argv);

// Frame storage, explicit prologue/epilogue planning and its native instruction consumer.
#include "buster/compiler/tier1_frame.c"
#include "buster/compiler/tier1_frame_test.c"
#include "buster/compiler/tier1_frame_emit.c"
#include "buster/compiler/tier1_frame_execution_test.c"
int run_tier1_frame_benchmark(int argc, char** argv);

// Tier 0 (a function's typed stream to instruction records, by templates with registers from the value stack's
// depths), the programs its tests and benchmark generate, and its tests, for the test-tier0 command. Its benchmark
// (benchmark-backend) is another translation unit.
#include "buster/compiler/tier0.c"
#include "buster/compiler/unwind.c"
#include "buster/compiler/unwind_tier0.c"
#include "buster/compiler/tier0_generate.c"
#include "buster/compiler/tier0_test.c"
#include "buster/compiler/c_builtin_lower.c"
#include "buster/compiler/c_builtin_lower_test.c"
#include "buster/compiler/c_builtin_lower_benchmark.c"
#include "buster/compiler/c_builtin_varargs_lower.c"
#include "buster/compiler/c_builtin_varargs_lower_test.c"
#include "buster/compiler/c_builtin_misc_lower.c"
#include "buster/compiler/c_builtin_misc_lower_test.c"
#include "buster/compiler/c_builtin_float_lower.c"
#include "buster/compiler/c_builtin_float_lower_test.c"
#include "buster/compiler/c_builtin_terminal_helpers.c"
#include "buster/compiler/c_builtin_terminal_helpers_test.c"
#include "buster/compiler/c_builtin_atomic_helpers.c"
#include "buster/compiler/c_builtin_atomic_helpers_test.c"
#include "buster/compiler/c_builtin_atomic_rmw_helpers.c"
#include "buster/compiler/c_builtin_atomic_rmw_helpers_test.c"
#include "buster/compiler/c_builtin_rounds_helper.c"
#include "buster/compiler/c_builtin_rounds_helper_test.c"
#include "buster/compiler/c_builtin_math_helpers.c"
#include "buster/compiler/c_builtin_math_helpers_test.c"
#include "buster/compiler/tier0_variadic_frame_test.c"
#include "buster/compiler/unwind_tier0_test.c"
#include "buster/compiler/unwind_test.c"
#include "buster/compiler/unwind_native_test.c"
#include "buster/compiler/unwind_benchmark.c"
// Streaming the output (#88): Tier 0's code written while it compiles, in the data-first order, against the end.
#include "buster/compiler/streaming.c"
#include "buster/compiler/streaming_test.c"
#include "buster/compiler/streaming_benchmark.c"
int run_backend_benchmark(int argc, char** argv);

// Source checking's program consumer shares the ABI and Tier 0 interfaces. Keep the source driver and its
// integration tests after those consumers so one checked unit can retain both executable bodies and static data.
#pragma clang section text = ".text.buster_checker"
#include "buster/compiler/c_check_program.c"
#pragma clang section text = ""
// #129's oracle: the functions and objects two objects define, compared (ours from -c, clang -O0 -c's), with the names
// the checked source makes, for the checker's selection tests, test-checker-corpus --symbols and test-c-testsuite
// --cross-check.
#include "buster/compiler/c_lowering_symbols.c"
#pragma clang section text = ".text.buster_checker"
#include "buster/compiler/c_check_prefix.c"
#include "buster/compiler/c_check_repair.c"
#include "buster/compiler/c_checker_driver.c"
#pragma clang section text = ""
#include "buster/compiler/c_checker_test.c"
int main(void)
{
    CheckTest test = { 0 };
    check_test_program_batch(&test);
    check_test_program_copies(&test, "/usr/bin/clang");
    check_test_program_initializers(&test, "/usr/bin/clang");
    printf("initializer-copy-packed-integration: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
