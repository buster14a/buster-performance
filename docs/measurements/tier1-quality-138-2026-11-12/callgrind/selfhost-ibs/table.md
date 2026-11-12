Program code (the C library's left out): Tier 1 3.4 M, clang -O2 1.1 M, gap 2.4 M (3.18x)

| Cause | `--tier1`, M | clang -O2, M | Gap, M | Share of the gap | `--tier1`'s by origin, M |
| --- | ---: | ---: | ---: | ---: | --- |
| register moves | 0.5 | 0.1 | 0.4 | 19.0% | |
| stack loads and stores | 0.5 | 0.1 | 0.4 | 15.2% | |
| other loads and stores | 0.4 | 0.2 | 0.2 | 10.3% | |
| address arithmetic (lea) | 0.2 | 0.1 | 0.2 | 7.4% | |
| zero and sign extensions | 0.0 | 0.0 | 0.0 | 1.7% | |
| compares and branches | 0.8 | 0.2 | 0.5 | 21.7% | |
| calls, returns and frames | 0.3 | 0.0 | 0.2 | 10.6% | |
| constants | 0.3 | 0.1 | 0.3 | 10.6% | |
| arithmetic and the rest | 0.4 | 0.3 | 0.1 | 3.5% | |

| Type | `--tier1`, M | clang -O2, M | Gap, M |
| --- | ---: | ---: | ---: |

| `--tier1`'s origin | M | Share of `--tier1`'s instructions |
| --- | ---: | ---: |
| spill | 0.0 | 0.8% |
| reload | 0.0 | 0.1% |
| edge spill | 0.0 | 1.1% |
| edge reload | 0.1 | 1.7% |
| call save | 0.1 | 2.1% |
| call restore | 0.1 | 2.2% |
| edge move | 0.1 | 1.7% |
| call sequence | 0.2 | 5.9% |
| entry | 0.0 | 0.2% |
| frame | 0.2 | 4.9% |
| recomputed | 0.0 | 0.9% |
| branch | 0.1 | 4.0% |
| node | 2.5 | 74.2% |
| unattributed | 0.0 | 0.2% |

| `--tier1`'s unattributed instructions | Count | Why they have no tag |
| --- | ---: | --- |
| 5 PLT stubs | 6176 | the linker's code |
| `.Lbuster_builtin_0_0` | 40 | no tag line |

Dynamic calls into the program's own code: Tier 1 0.00 M, clang -O2 0.00 M; into its PLT stubs, the C library's calls: Tier 1 0.00 M, clang -O2 0.00 M

| Function | `--tier1`, M | clang -O2, M | Gap, M | calls, `--tier1` / -O2 | moves | stack | memory | address | extend | branch | call | `--tier1`: spills+reloads, call saves, edge moves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `host_aesenc` | 0.8 | 0.0 | 0.8 | 0.00 M / 0.00 M | 0.1 | 0.1 | 0.1 | 0.1 | 0.0 | 0.1 | 0.0 | 0.0, 0.0, 0.0 |
| `pp_count_lines` | 0.3 | 0.0 | 0.3 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.1 | 0.0 | 0.0 | 0.1 | 0.0 | 0.0, 0.0, 0.0 |
| `pp_named_ucn_candidates` | 0.2 | 0.0 | 0.2 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.1 | 0.0 | 0.0, 0.0, 0.0 |
| `intern_hash_bytes_scalar` | 0.1 | 0.3 | -0.2 | 0.00 M / 0.00 M | -0.0 | -0.0 | -0.0 | -0.0 | 0.0 | -0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `get_char` | 0.1 | 0.0 | 0.1 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `check_input_deprecated_use` | 0.1 | 0.0 | 0.1 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `intern_lane_rounds` | 0.1 | 0.0 | 0.1 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `encode_one` | 0.1 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | -0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `check_input_rare_verify` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `host_mm512_test_epi8_mask` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | -0.0 | 0.0, 0.0, 0.0 |
| `c_tokenize_scalar_range` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | -0.0 | 0.0 | 0.0 | -0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `host_mm512_maskz_loadu_epi8` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | -0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `check_input_expression_class` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | -0.0 | -0.0 | -0.0 | -0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `check_common_next_token` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `instruction_is_valid` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `skip_block_comment` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `check_input_count_tokens` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | -0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `tier0_fuse_entries` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `refine_intern_identifier` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | -0.0 | 0.0, 0.0, 0.0 |
| `check_lower_node_count` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | -0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `refine_tokens_scalar` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `is_ascii_identifier_continue` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `lex_identifier_continue` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | -0.0 | -0.0 | 0.0 | -0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `peek_char` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |
| `check_common_sizeof_array_decay` | 0.0 | 0.0 | 0.0 | 0.00 M / 0.00 M | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0, 0.0, 0.0 |

Calls clang -O2 doesn't make (a callee's calls by Tier 1 less its calls by clang, a count difference): 0.00 M. Their callees' instructions in Tier 1, each callee's scaled by the share of its calls clang doesn't make (an estimate from its average per call): 0.0 M

| Callee | `--tier1` calls, M | -O2 calls, M | `--tier1` instructions, M | per call | frame + call saves + entry, M | clang's inlining remarks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `host_aesenc` | 0.00 | 0.00 | 0.8 | 0.0 | 0.0 | - |
| `pp_count_lines` | 0.00 | 0.00 | 0.3 | 0.0 | 0.0 | - |
| `pp_named_ucn_candidates` | 0.00 | 0.00 | 0.2 | 0.0 | 0.0 | - |
| `intern_hash_bytes_scalar` | 0.00 | 0.00 | 0.1 | 0.0 | 0.0 | - |
| `get_char` | 0.00 | 0.00 | 0.1 | 0.0 | 0.0 | - |
| `check_input_deprecated_use` | 0.00 | 0.00 | 0.1 | 0.0 | 0.0 | - |
| `intern_lane_rounds` | 0.00 | 0.00 | 0.1 | 0.0 | 0.0 | - |
| `encode_one` | 0.00 | 0.00 | 0.1 | 0.0 | 0.0 | - |
| `check_input_rare_verify` | 0.00 | 0.00 | 0.0 | 0.0 | 0.0 | - |
| `host_mm512_test_epi8_mask` | 0.00 | 0.00 | 0.0 | 0.0 | 0.0 | - |
| `c_tokenize_scalar_range` | 0.00 | 0.00 | 0.0 | 0.0 | 0.0 | - |
| `host_mm512_maskz_loadu_epi8` | 0.00 | 0.00 | 0.0 | 0.0 | 0.0 | - |
| `check_input_expression_class` | 0.00 | 0.00 | 0.0 | 0.0 | 0.0 | - |
| `check_common_next_token` | 0.00 | 0.00 | 0.0 | 0.0 | 0.0 | - |
| `instruction_is_valid` | 0.00 | 0.00 | 0.0 | 0.0 | 0.0 | - |
