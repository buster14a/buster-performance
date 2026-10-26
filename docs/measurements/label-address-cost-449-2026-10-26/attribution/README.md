# Same-base label-predicate attribution

This diagnostic is intentionally invalid for production. It disables only `check_input_label_address` and
`check_input_indirect_goto` at exact baseline `9de3d30ba437b381394095d7a77635a2e877435d`, retaining the original
addressed-array allocation, clearing and consumer. It ran only on label-free SQLite/Lua inputs. It never entered
the compiler branch or replaced a correctness test. `DIAGNOSTIC449.txt` records the patch/archive hashes and limits.

Native diagnostic image SHA256: `48f88832d86abb3021af9166637aad2c3a2458a2e33b258b0cb32f9f3c3a2a2c`.
The original base and first candidate images are unchanged from the parent record. `queue449-attribution.sh` uses
three preflights, then three rounds rotating base, first candidate and diagnostic order. Each counter command uses
the same `commands449.sh perf` frozen SQLite command, CPU 2, actual shared host lock, and `perf -r 11`.

| Round | Base instructions:u | First candidate | Predicate-disabled diagnostic |
| --- | ---: | ---: | ---: |
| 1 | 1,718,753,973 | 1,716,439,873 | 1,710,036,903 |
| 2 | 1,718,753,972 | 1,716,439,871 | 1,710,036,895 |
| 3 | 1,718,753,956 | 1,716,439,871 | 1,710,036,894 |
| Median of round means | 1,718,753,972 | 1,716,439,871 | 1,710,036,895 |

The current same-base predicate ablation saves 8,717,077 instructions; the first candidate is 6,402,976 above it.
These are medians of perf's eleven-run means, rather than individual-run medians. All three preflights and nine
counter commands exited zero. The first candidate's source rewrite alone therefore does not remove all the work
the diagnostic can omit. This prompted exact vector candidate filtering inside the existing two control walks.

`STATIC449.txt` and its disassemblies explain why source-level helper calls do not map one-to-one to the historical
instruction hypothesis: LLVM already reuses loaded kind/role registers at some sites, and changing a branch into
combined boolean arithmetic retains work. The separate name-exclusion predicate is unchanged and outside this
ablation. This note measures the current base, not a causal decomposition of the old `2cb9299` → `79cdafe` delta;
subtracting those historical totals from today's totals would mix other source changes.

The root record retains the first production candidate's results separately. Only a fully correct, independently
tested production candidate can satisfy the issue. The diagnostic supplies attribution evidence, not acceptance.
