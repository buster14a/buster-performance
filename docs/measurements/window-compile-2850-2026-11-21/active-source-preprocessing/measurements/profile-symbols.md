# Frozen SQLite preprocessing profile

Each executable handled 35 fresh preprocessing processes. The profiles sampled the same user-cycle period on the same locked Ryzen 7 9700X core. Eager recorded 9,589 samples and directive-aware active tiles recorded 12,206. Both captures reported zero lost samples.

| Rank | Eager leaf | Samples | Active tiles leaf | Samples |
| ---: | --- | ---: | --- | ---: |
| 1 | `tokenize_c_raw_no_separators` | 2,353 | `tokenize_c_raw_no_separators` | 2,625 |
| 2 | `pp_run_contexts` | 1,777 | `pp_run_contexts` | 1,346 |
| 3 | `refine_pass_b_64_plain` | 1,370 | `refine_pass_b_64_plain` | 1,270 |
| 4 | `pp_invoke` | 681 | `pp_skip_group` | 1,040 |
| 5 | `refine_tokens_blocks_plain` | 345 | `pp_copy_file_text_vector` | 927 |
| 6 | `pp_scan_arguments` | 278 | `pp_invoke` | 743 |
| 7 | `pp_expand_current` | 247 | `c_tokenize_scalar_range` | 330 |
| 8 | `pp_template_operators` | 167 | `pp_expand_current` | 268 |
| 9 | `pp_finish_directives` | 153 | `pp_scan_arguments` | 264 |
| 10 | `pp_emit_template` | 152 | `refine_tokens_chunks_plain` | 241 |
| 11 | `pp_directive` | 151 | `pp_finish_directives` | 224 |
| 12 | `pp_prepare_into` | 141 | `pp_directive_table` | 179 |
| 13 | `pp_compile_macro` | 132 | `pp_directive` | 170 |
| 14 | `pp_define` | 105 | `pp_template_operators` | 161 |
| 15 | `pp_evaluate_value` | 100 | `pp_emit_template` | 144 |
| 16 | `pp_start_condition` | 88 | `refine_tokens_blocks_plain` | 144 |
| 17 | `pp_lookup_path` | 77 | `pp_compile_macro` | 140 |
| 18 | `pp_append_tokens` | 72 | `arena_push` | 119 |
| 19 | `arena_push` | 60 | `pp_define` | 117 |
| 20 | `intern_find_or_add` | 60 | `pp_prepare_fragment` | 112 |

[Source-line counts and code ranges](profile-source-shares.json), [full reports and native perf records](active-paired-profile.tar.gz) and [matching executables](paired-profile-binaries.tar.gz).
