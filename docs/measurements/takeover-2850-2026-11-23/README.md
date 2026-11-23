# #2850 after the 2026-11-23 handoff: main read again, and a unit preprocessed twice

Records of the session that took [buster14a/buster#2850](https://github.com/buster14a/buster/issues/2850) over on
2026-11-23 ([its claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7101547626)), after
[the handoff](https://github.com/buster14a/buster/issues/2850#issuecomment-7101108212) of
[`takeover-2850-2026-11-22`](../takeover-2850-2026-11-22). Everything here is the 9700X (`benchpress`), Release builds
by `./build.sh --config Release --target compiler` under the lock, one lane on CPU 2, the frozen `sqlite3.c` with the
9700X job's `compile_time` options unless a line says otherwise. `scripts/` has what ran:

- `setup.sh REV` builds a revision; `exp.sh NAME BASE PATCH CONFIG` builds a tree with a patch.
- `stages.sh REV` is seven `--time-stages` runs; `profile.sh REV` eight `perf record` runs (`cycles`, one sample each
  100,003) and a counters run.
- `prof2.sh NAME TREE [OPTIONS]` is both with the compiler's options given, reduced to `by-function.txt` (cycles a run
  by symbol, every symbol) and `stages.txt` (`stages-reduce.py`: each line's median, least and most of seven runs).
- `pair2.sh PARENT CANDIDATE WORKLOAD ROUNDS` and `reduce2.py` are the earlier record's: each round runs the two
  builds in ABBA or BAAB order, each position one hold of the lock with a warm-up, a wall-clock run and a counters run,
  and every run's objects and diagnostics are hashed.
- `job-main1.sh`, `job-nb1.sh` and `job-fix1.sh` are the three jobs as they ran.

The lock's wait lines that name other sessions are removed from the `lock.log` files.

## Main at `55008c81e` (`main-55008c81e/`)

The handoff's last reading of main was 117.4 ms at `96fac43e0`. Twenty-eight merges later:

| `--time-stages`, ms, medians of 7 | `d541430bf` (11-22, the earlier record) | `55008c81e` |
| --- | ---: | ---: |
| preprocess | 9.505 | 9.511 |
| parse | 6.821 | 6.835 |
| check-input | 41.735 | 41.474 |
| check-expressions | 10.555 | 12.093 |
| check-declarations | 2.077 | 2.198 |
| check-program | 18.986 | 35.068 |
| lower | 11.603 | 11.942 |
| tier0 | 4.908 | 4.952 |
| total | 111.696 | 130.094 |

(`main-55008c81e/stages/`; its fifth run read 1,489 ms with 1,401 of them in `check-input`, one stall the medians leave
out.) The counters (`main-55008c81e/profile/stat.csv`, five runs): 622.2 M user cycles, 82.6 M kernel, 1,428.7 M user
instructions, where `96fac43e0` ran 1,287.8 M.

**Where it went.** `main-55008c81e/profile/by-symbol.txt` is the cycles a run by symbol (734.5 M in all). Against the
earlier record's `profile-whole-bbe80f1a9/by-function.txt`, every symbol of the preprocessor doubled:
`tokenize_c_raw_no_separators` 10.4 M to 20.8 M, `pp_run_contexts` 8.3 to 16.9, `refine_pass_b_64_plain` 7.7 to 14.4,
`pp_invoke` 3.1 to 6.5, and `pp_prepared_directive`, `pp_scan_arguments`, `pp_expand_current`,
`pp_emit_simple_write`, `pp_substitute`, `pp_finish_directives`, `pp_without_splices` and `pp_append_tokens` each
appear with 1.4 M to 2.4 M, while the `preprocess` stage reads what it read. The unit is preprocessed a second time,
inside `check-program`.

**Why.** buster14a/buster#3381 (merged 2026-11-23 11:04Z) made `check_common_stmt_marker` ask of every discarded
statement that is no call whether a macro's body wrote it (`check_common_unused_quiet`), before knowing that the
statement would warn. For a token a macro gave, the answer reads the unit's expansion history
(`check_common_ignored_macro`), and the driver defers that history: `pp_history_ensure` records it by preprocessing
the unit again. A break at `pp_history_ensure` in a Release build of `55008c81e` stops first under
`check_common_stmt_marker` (`c_check_common_warnings.c:4555`) on `sqlite3.c`, which prints no diagnostic.

## The fix (`history-fix/`, [buster14a/buster#3405](https://github.com/buster14a/buster/pull/3405))

The question is asked last, of a value that would warn otherwise (`scripts/history-fix.patch`, the pull request's
commit `2b01af6e` as a patch on `55008c81e`; the tree is `fix1`). `--time-stages` gains a line, `time-process
history-replays`, the command's units preprocessed again for their history.

Paired against main `55008c81e` (`history-fix/pair2-*/summary.txt`); each workload's objects and diagnostics are one
set in every run:

| | rounds | main, ms | the fix, ms | paired, ms | lower | user instructions, M |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 7 | 128.716 | 117.786 | -10.828 | 6/7 | 1,428.686 to 1,290.523 |
| the compiler's own source | 5 | 663.709 | 621.041 | -42.316 | 5/5 | 9,981.438 to 9,175.536 |
| Lua, 34 units | 5 | 84.728 | 65.463 | -19.241 | 5/5 | 998.292 to 745.421 |
| musl, 1,336 units | 5 | 682.750 | 668.642 | -14.113 | 5/5 | 6,854.265 to 6,731.247 |

`sqlite3.c`'s one round that is not lower took base pages for a run (24,792 more faults in its wall-clock run: the
host busy as it started); its cycles are lower in 7 of 7 rounds: 707.6 M to 648.1 M in all (-58.6 M), 988 to 905 a
token.

Its stages (`history-fix/prof2/stages.txt`): `check-program` 23.928 ms where main reads 35.068, the total 117.295
where main reads 130.094, `history-replays` 0, the peak 245.8 MB where main's is 264.0.

## `--node-bodies` at buster14a/buster#3373's head (`node-bodies-3ef312992/`)

`prof2.sh` on `3ef312992` (main `94ec1ca8c` merged in, so with the second preprocessing above in both arms), without
the option (`plain/`) and with it (`bodies/`):

| ms, medians of 7 | without | with | |
| --- | ---: | ---: | ---: |
| check-input | 41.252 | 69.984 | +28.732 |
| check-expressions | 12.193 | 8.773 | -3.420 |
| check-declarations | 2.185 | 1.737 | -0.448 |
| check-program | 34.814 | 29.422 | -5.392 |
| lower | 11.939 | 10.946 | -0.993 |
| total | 128.548 | 147.035 | +18.487 |

734.9 M cycles a run without it and 843.7 M with it (`by-function.txt` of each). What the option adds, by symbol, M
cycles a run: `node_census_node` 20.1, `node_alone_bodies` 16.6, `node_front_chunk` 14.8, `clear_page_erms` 11.4,
`node_alone_begin` 9.3, `node_machine_type_in_context` 8.8, `node_twin_build` 7.3, `node_machine_contexts` 7.2,
`check_lower_taken_body` 6.8, `node_machine_rule` 6.7, `node_machine_reader_chunk` 5.9, `node_machine_reader_side`
5.9, `node_machine_expand` 5.0, `node_producer_before` 4.6, `check_input_expression_literals` 4.5,
`node_census_walk` 3.7, `check_input_expression_identifiers` 3.5: about 183 M (33 ms) over the sixty symbols that
grow most. What it removes is about 61 M (11 ms) over the thirty that shrink most: `check_graph_run` 7.7,
`check_lower_drain` 7.7, `check_program_references` 6.3, `check_input_expressions_coded_range` 5.1,
`check_input_warning_graph` 4.3, `check_common_own_reach` 3.1.
