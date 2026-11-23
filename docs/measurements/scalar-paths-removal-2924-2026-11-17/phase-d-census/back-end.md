# Phase D fallback sites in the back end and tools (buster, issue #2924)

All paths below are under `src/buster/compiler/`. Line numbers are where the selection is made. Under "Reached by", "never" means the condition is out of reach on real inputs, and "common" means ordinary corpus or link inputs hit it.

## SSA
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `ssa_ir.c:953-954`, used at `:957` and `:979` | `ssa_construct_scalar` (Braun predecessor reader); `ssa_prepare_path` with `vector` false also takes the scalar `ssa_promote` loop and `ssa_analyze` without frontiers | `vector = dense && VECTOR && ssa_vector_fits(blocks) && (verified \|\| cells <= BUSTER_SSA_IR_VECTOR_CELLS)`, where the cap is 16,384 block×slot cells (`:804`) | `ssa_construct_vector` (dense) | Common: every unverified promotion of a function past 16,384 cells. The comment measured this on sqlite3.c, so real functions take it. It also triggers at 8,192 or more blocks. Reached from the Tier 1 driver. |
| `ssa.c:1412` and `:1426` | Same as above | `BUSTER_VECTOR_PATH(vector) && ssa_vector_fits(block_count)`. The bound is `(2B+1)*row_bytes <= 16 MiB`, so it fails at 8,192 blocks or more | `ssa_construct_vector` | `ssa_build` is only called from tests and benchmarks, so this matters only through the shared kernels. |
| `ssa.c:1411`, `:1422`; `ssa_ir.c:952`, `:983` | `ssa_construct_bounded` (`ssa_bounded.c:345`): a scalar per-local loop with the `ssa_read_entry` reader. Only its renaming has a 16-lane kernel. | `!ssa_dense_fits(input)`: cells > 131,072, or edges×locals > 1 Mi, or the combined dense bytes > 16 MiB | Dense vector constructor | Uncommon: only very large functions. |
| `ssa_ir_private.c:382-392` | `ssa_construct_bounded` | `ssa_ir_place_live` returns MEMORY or LIMIT | Frontier placement | Dead code: `BUSTER_TIER1_PRIVATE_VALUES` is 0 (`ir_lower.c:16`). |

## IR optimizer
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `ir_optimize.c:2481-2482`, test at `:2466-2470`; same rule at `ir_optimize_verified.c:147-148` (the C driver's Tier 1 entry) | Everything keyed off `work->scalar`: `ir_optimize_sccp_worklist` (`:2493`), `ir_optimize_dce_worklist` (`:1681`), identity candidates (`:1526`), thread targets, merges and layout order (`:1989/2000/2012`, plus `ir_optimize_layout.c:41`), float fold (`:951`), SIMD SCCP fold (`ir_optimize_simd.c:438/559/802`) | `path == AUTO && (instruction_count < 8192 \|\| block_count*512 > instruction_count)` | Vector sweeps and vector kernels | Common: every function on the corpora. The comment says no corpus function reaches the bound. |
| `ir_optimize.c:1317-1320` | `ir_optimize_sccp_worklist` | Still changing after `sweep_limit` (64) sweeps | `ir_optimize_sccp_sweeps` | Rare. Only on the vector path. |
| `ir_optimize.c:1292-1304` | `ir_optimize_visit`, one instruction at a time | Lanes that `ir_optimize_fold_vector` did not fold: anything that is not a constant-operand binary op of 64 bits or less | 16-lane batch fold | Common: most instructions (vector path only). |
| `ir_optimize.c:1714-1717` | `ir_optimize_dce_worklist` | Still changing after 64 sweeps | DCE vector sweeps | Rare |
| `ir_optimize_gvn.c:552` | `ir_gvn_keys` scalar hashing (`ir_gvn_hash_one`) and `ir_gvn_partition_sorted` | `statistics.rounds > sweep_limit` (64) | 8-lane key hashing and hash partition | Rare or never |
| `ir_optimize_gvn.c:389` | `ir_gvn_hash_one` per lane | `op == IR_VCONST`, or a pure phi on non-initial rounds | 8-lane vector hash | Common (phis) |
| `ir_optimize_licm.c:288` | `ir_licm_worklist` | `count > INT32_MAX` (signed gather index) | `ir_licm_sweep` | Never |
| `ir_optimize_licm.c:298-308` | `ir_licm_worklist` | Still changing after an unproductive sweep (`progress*16 < count`) or after 64 sweeps | `ir_licm_sweep` (16-lane gathers) | Likely common: thin dependency chains |
| `ir_optimize_memory.c:1093` | `ir_memory_classify/derive/escapes/events_scalar` (`:202-478`), `ir_memory_hash_scalar` (`:1230`) | `n >= 2^30 \|\| address_count >= 2^30` | `*_vector` phases | Never. The header comment says phase D removes it. |
| `ir_optimize_unroll.c:968` | Remap loop, one instruction at a time | `instruction_count > INT32_MAX` | 16-lane masked-gather remap | Never |
| `ir_optimize_inline.c:1595` | `ir_inline_splice_scalar` (`:1421`) | `!(shape->prefix == shape->parameters && parameters <= 16)` | `ir_inline_splice_vector` | Rare: callees with more than 16 parameters, or parameters not at the head of the entry block (general splice only) |

## IR verifier (ir.c)
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `ir.c:2751`, `:2780-2787` | `ir_check_instruction`, per lane | Deferred rows: any rule other than same, shift, icmp, fcmp, select, memory or none. That covers calls, phis, casts, intrinsics and vector float arithmetic, plus bad terminators. | `ir_check_batch` | Common: every function |
| `ir.c:2644-2656` | Per-lane `f->type[]` load | `instruction_count > 2*64`, operand outside the 128-type window and not among the first 64 | `ir_operand_types` permute | Common in functions over 128 instructions |
| `ir.c:3307-3313`, mask from `:3260-3299` | `ir_check_operands`, per lane | Phi, call, call_indirect and ternary-intrinsic lanes; a use not earlier than its instruction; a use from a non-dominating block | `ir_dominance_batch` | Common (phis and calls) |

## Tier 0 (tier0.c)
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `tier0.c:5159` | Scalar register-pick loop (`:5169` onward), after `tier0_register_locals_vector` ordering | `vector && locals > 64` | `tier0_assign_registers_vector` | Common: functions with more than 64 locals |
| `tier0.c:12020-12022`, then `:10032-10037` and `:9889-9892` | Deep entries emitted by `tier0_emit_deep`, using `tier0_holes_scalar` and `tier0_record_scalar` (also called from vector emission at `:15331`) | `TIER0_ERROR_DEPTH` from selection: the stack is past 14/15 integer or 16 floating registers | Template byte-permute expansion (`tier0_expand`) | Rare: very deep expressions |
| `tier0.c:17202-17205` | `tier0_validate_scalar_entries` | `!tier0_validate_accepts(f)`: vectors, masks, `call_tails`, X86 entries, unknown kinds, calls with more than 64 operands, block pops > `SCAN_POPS`, depth mismatches, `count > 2^24` | `tier0_validate_accepts` | Common: every SIMD or tail-call function, through `ir_lower.c:3271` and `streaming.c:204` |
| `tier0.c:16458` | `tier0_validate_tables` (scalar helpers) | `!plain`: aggregate arguments or results, call result objects, incoming variadic, memory result, vector constants or operations | 64-, 16- and 8-wide table scans | Common |

## Tier 1
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `tier1_allocate.c:1999-2000` | `tier1_resolve_moves_scalar` | `count <= BUSTER_TIER1_MOVE_SMALL_COUNT` (8) | `tier1_resolve_moves_indexed` | Common: nearly every parallel-move set (`tier1_emit*.c`, `tier1_cfg.c:1054`) |
| `tier1_frame.c:652` | `tier1_frame_sort` (radix) for classes | `tier1_frame_classes` fails: more than 8 distinct class keys | Register class match | Very rare: one sqlite function |
| `tier1_frame.c:679` | `tier1_frame_sort` for events | `events > 64` (more than 32 objects) | `tier1_frame_rank` | About 2% of sqlite functions |
| `tier1_select_burs.c:1276-1281` | `tier1_burs_classify_node`, per lane | `IR_STACK_ADDR`, an address whose constant or offset doesn't fit 32 bits, `fcmp ==/!=` | `tier1_burs_classify_vector` | Common (every frame address) |
| Borderline: `tier1_select_burs.c:1435` | `tier1_select_munch` | Operator outside the grammar, or a walk past `BUSTER_TIER1_SELECT_WALK` | BURS vector label and rules | Uncommon |

## x86 tables, semantics, encoder, disassembler
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `x86_semantics.c:3515-3523` | `x86_instruction_resolve`, per record | `x86_instruction_rare`: x87, x87 control, vzeroupper, the RARE flag, implicit vectors | `x86_instructions_effects_lanes` | Common wherever vzeroupper or long double appears |
| `x86_target_forms.c:180-183` | Scalar loop over extended rows | Rows marked `COMPACT_EXTENDED` (feature bits past the 32-bit projection) | 16-row compact loop | Every call (fixed row set) |
| `x86_64_disassembly.c:297-300` | `x86_disassembly_format_scalar` (bounded formatter, `x86_64_disassembler.c:1308`) | `output == 0 \|\| plan->bound == 0 \|\| capacity < plan->bound` | Plan-driven direct stores | Forms without a plan, small buffers, measuring calls |
| `x86_64_disassembler.c:1111-1122` | `x86_decode_one` per instruction. Its matcher compares 8 signatures in a ZMM, so this is partly vector. | `count < 2`, or lanes after the first non-simple instruction (VEX/EVEX, uncommon legacy) | `x86_decode_simple_batch` | Common for SIMD code |
| `branch_sizing.c:939-946` (borderline) | `branch_sizing_worklist`: grows one branch at a time, with 16-lane marks | `rounds >= BUSTER_BRANCH_SIZING_ROUNDS` (4) | Vector rounds | Never on compiled-code shapes |

## Assembler
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `assembler.c:644-653`, `:724-737` | `asm_lex_scalar` on a sub-slice | Bytes `"`, `#`, `/`, NUL or 0x80 and above: strings, comments, non-ASCII | `asm_lex_vector` | Common: every string literal and comment |
| `assembler.c:3833`, rows rejected at `:3772-3791`, words at `:3667` | `asm_instruction` (scalar operand grammar) | Not Intel syntax, or a prefix; directives and labels; aliases; `sal/xchg/shl/...`; hex, long, address or expression operands; leading-zero integers; no room | `asm_parse_vector_batch` and `asm_simple_words_vector` | Common: every AT&T statement, since the batch is Intel-only |

## Linker inputs (import.c, foreign*.c, bind.c)
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `import.c:2199-2202` | `import_object_scalar` | `import_object_vector` gives up: global `SHN_COMMON`, two `.rela` sections for one section, overlapping fields, a table without room, a malformed object | Vector object import | Rare: `-fcommon` objects; runtime members (`runtime.c:1930/1944`) |
| `import.c:2725-2728` | `import_archive_scalar` | No symbol index or an empty index, special members past the first, anything else out of the ordinary | `import_archive_vector` | Archives without an index (`runtime.c:1843`, whole archives at `foreign.c:1381`) |
| `import.c:2899-2902` | `import_archive_lazy_scalar` | Index out of archive order, or other give-up | `import_archive_lazy_vector` | Uncommon |
| `import.c:3544-3547` | `import_library_scalar` | verdef index > 511; names table not NUL-terminated or not NUL-led; empty names | `import_library_vector` | Rare (libc.so, ld.so, libgcc_s at `runtime.c:1854-1881`; `foreign.c:1463`) |
| `foreign.c:1997` | `foreign_headers_exact` | `foreign_headers_vector` false, e.g. section names not NUL-terminated | Vector header read | Rare |
| `foreign.c:2265-2267` | `foreign_symbol_exact`, one symbol at a time | From the first batch `foreign_symbols_vector` refuses (bad bits, empty name, bad common, missing XINDEX table) to the end of the object's stretch | 8-lane symbol batches | Rare |
| `foreign_debug.c:291`, `:330`, `:356` | `foreign_debug_relocate` | A batch holding a rare relocation (NONE, LEFT/XINDEX symbol, value doesn't fit, TLS, non-adjacent fields); **scalar tail** of `total % 8`; an object with no symbols | `foreign_debug_relocate_vector` | Common: every debug `.rela` section's tail |
| `foreign_link.c:915` | **Scalar tail** loop | The last `(count-1) % 16` fixups | 16-wide copy-mark scan | Every link (vector path) |
| `bind.c:888` | `bind_join_records`, one record at a time | `discarded != 0`: the object has a COMDAT group to discard | `bind_join_block` | C++ / COMDAT duplicates |
| `bind.c:1929`, `:1994` | `bind_closure_exact` from the start | More than `BUSTER_BIND_BLOCKED` (16) blocked names | `bind_closure_vector` | Rare |

## Executable, unwind, debug, inflate, emission metadata
| Selection site | Scalar code taken | Exact condition | Vector route it falls from | Reached by |
|---|---|---|---|---|
| `executable_impl.c:3866` (count) and `:5024` (place) | Atom-at-a-time loop | `executable_atom_block` not taken: mixed bucket, class outside `BLOCK_CLASSES` (init/fini arrays), alignment > page, size > max | 16-atom block | Common |
| `executable_impl.c:5399`, `:5381` | `executable_reference`, one symbol at a time | Block has an undefined, TLS or IFUNC symbol, or an atom past the gather limit | 16-symbol gather block | Common (static libc) |
| `executable_impl.c:2253` | `executable_eh_frame_walk` | `executable_eh_frame_fdes` returns `UINT32_MAX`: an atom that isn't one CIE plus its FDEs with only PC32 fixups | 16-candidate FDE check | Personality/LSDA or oddly laid-out `.eh_frame` |
| `unwind.c:1150-1156`, used at `:1176` and `:1322-1324` | `unwind_fde_scalar` (`unwind_rows_scalar`, `unwind_fixed_scalar`, `unwind_tails_scalar`), `unwind_fde_bytes` | Lane with a frame pointer, tail calls, an open frame or a row program | `unwind_function_vector` | Common (Tier 1 row programs, `streaming.c:647`) |
| `debug.c:323-345` | `debug_row_scalar` | **Scalar tail** of fewer than 4 rows; the `prologue_end` row; rows after a file change | `debug_rows_vector`, 4 rows at a time | Every `-g` function |
| `inflate.c:586` | **Scalar tail** byte loop | `length % 64` bytes | `inflate_adler32_vector` | Every zlib stream |
| `emission_metadata.c:247` | `emission_layout_check_scalar` | Besides the flag: `layout == NULL`, or null `starts`/`ends` | Vector layout check | Invalid input only |

## Unconditional callers of scalar twins
These are not data-selected fallbacks, but they block deleting the twins:
- `tier1_schedule.c:444` and `tier1_certificate_emitted.c:868/1712/2043/2549/3999` (`x86_instruction_effects*_scalar`).
- `tier1_certificate_emitted.c:1533` and `tier1_debug_straight.c:107/120` (`x86_choose_forms_scalar` and effects).
- `x86_match.c:775` and `x86_64_encoder.c:6515` (`encode_one`).

## Looked at and judged not vector fallbacks
- Both scalar, no vector counterpart: allocator color vs. scan (`tier1_allocate.c:1387-1393`, despite the `vector_intervals`/`scalar_intervals` names); `ir_gvn_partition_sorted` after the probe budget; `executable_eh_frame_sort`'s radix sort; `abi_finish_rare`; `tier0_emit_deferred`.
- Masked vector, not scalar: the `calling_convention.c` deferred calls (`abi_assign_lanes`) and the encoder tail (`encode_tail64`).
- Not scalar code: the Tier 1 to Tier 0 fallback (`ir_lower.c`, `ir_vector_split.c`) and `lane.c`'s REQUIRE_START.

**Skipped names:**
- Twins chosen only by a flag: `ssa_build_scalar`, `ssa_ir_promote_scalar`, `ir_parse_scalar`, `replay_scalar`, `tier0_compile_scalar(_entries)`, `tier0_validate_scalar` (direct entry), `tier0_fuse/depths/mask_depths/wide_depths/positions/expand_scalar`, `x86_choose_forms_scalar` (`tier0.c:12150`), `tier1_frame_plan_scalar`, `x86_instructions_effects(_opmasks)_scalar`, `x86_target_forms_scalar`, `x86_zen5_lookup_scalar`, `cbuiltin_fold_scalar`, `cbuiltin_lookup_scalar`, `c_environment_types_scalar`, `ir_optimize_fold_scalar` (flag use), `ir_gvn_keep_vectors`, `ssa_bounded_rename` scalar branch, `x87_transfer_candidates`, `asm_word_length`/`asm_relax_*`, `inflate_adler32` byte twin, `import_*_scalar` under `FOREIGN_PATH_EXACT`, `foreign_order_sort`/`foreign_unwind*`/`foreign_gc`/`foreign_strings`/`foreign_exchange_items` exact paths, `BIND_PATH_EXACT`, `ExecutableOptions.exact`, `unwind_write(exact)`, debug `exact`.
- "Scalar" means a type: `ir_splat_scalar_type`, `ir_if_convert_scalar_type`, `ir_thread_scalar_type`, `ir_store_motion_scalar`, `ir_sroa_scalar_load/register/conversion`, `ir_sroa_scalarize(_calls)`, `ir_vectorize_scalar_update`, `tier1_select_scalar_splat`, `ir_typed_debug_scalars`, `IrDebugScalar`, `gvn_scalar_removed`, `after_scalar_ms`, `*_SCALAR_FORMS` macros.
- No vector counterpart: dominators' SEMI-NCA, `foreign_strings` "what stays scalar", `foreign_gc` irregular parts, `object_writer` record writers, the interpreters, `ir_check_join`, and `ir_vectorize_loops`' scalar remainder loops (those are emitted code).
- Tests, benchmarks and measures: all `*_test.c`, `*_benchmark.c`, `*_measure.c`, `tier1_allocate_test_cases.c`, and `fuzz.c`'s `c_tokenize_scalar`.

