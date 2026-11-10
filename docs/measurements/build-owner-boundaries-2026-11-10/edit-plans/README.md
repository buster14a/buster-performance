# Incremental edit-plan receipts

These are actual Ninja dry-run plans from fully built ordinary Release trees. The harness changes one source's mtime, asks Ninja for the complete `compiler` target plan, then restores nanosecond source timestamps and verifies a no-op. It never executes the planned build commands and never writes source bytes.

Baseline: `39506e8609750fa31ef5a443dea12f0d545a27c6`. All four runs are complete: `base-scalar/`, `base-vector/`, `candidate-scalar/` and `candidate-vector/`. Candidate runs began only after the final integrated scalar/vector native builds were complete and the source tree was frozen.

## Harness

From this directory, build the C harness in `../tools/` with:

```sh
cc -O2 -Wall -Wextra -Werror ../tools/incremental_plans.c -lcrypto -o ../incremental-plans
```

Run from any directory, with the pinned Ninja 1.13.2 on PATH:

```sh
incremental-plans ROOT TREE_RELATIVE LABEL base|candidate OUTPUT_DIRECTORY
incremental-plans --list
```

For example, the completed scalar baseline run used:

```sh
incremental-plans /workspace/scratch/6891521e933c/buster-baseline build/cmake/x86-64-g0 base-scalar base /workspace/scratch/6891521e933c/ninth-evidence/edit-plans
```

Use `build/cmake/znver5-g0` for the vector tree. Labels name new output directories; the harness refuses to overwrite an existing receipt. It acquires `build/.trees.lock` exclusively and refuses an active build or a tree with pending work. Ordinary signal/error cleanup restores the active source; restoration journals are flushed before each touch.

## Files and interpretation

| File | Contents |
|---|---|
| `summary.tsv` | Each initial control, source edit and restored control; exact compilation source names, unity and standalone counts, link/bake counts and unexpected-step count. |
| `timestamps-and-content.tsv` | Before/restored source SHA256, device/inode, size and nanosecond atime/mtime. Mode is checked by the harness. |
| `metadata.txt` | Tree identity, method and restoration status, plus before/after complete compiler SHA256. |
| `00-noop.log` | Initial actual Ninja no-op output. |
| `NN-SAMPLE-edit.log` | Complete actual Ninja dry-run plan after the source timestamp edit. |
| `NN-SAMPLE-restored.log` | Actual Ninja no-op output after restoring that source. |

`compiles` counts compilation commands only. Each successful edit plan also contains exactly one link and one bake/post-link step. Initial and restored controls contain zero commands. Touching/restoring mtime necessarily changes ctime; that kernel metadata is neither restored nor claimed to be.

The three newly extracted implementation paths do not exist in the baseline. Their baseline rows explicitly say `not_present_in_baseline`; their `baseline_container_sample` identifies the original file that contained the same implementation. This makes a moved implementation comparison distinct from the retained shared-interface positive control.

| Candidate implementation sample | Baseline implementation container sample |
|---|---|
| `pp_impl` (`c_preprocessor_impl.c`) | `pp_interface` (`c_preprocessor.c`) |
| `pp_history_impl` (`c_preprocessor_history_impl.c`) | `pp_history_interface` (`c_preprocessor_history.c`) |
| `executable_impl` (`executable_impl.c`) | `executable_interface` (`executable.c`) |

## Completed baseline observations

Every existing sampled source selects all eleven unity units in the baseline. The vector configuration adds the following standalone compilation steps; scalar adds none:

| Sample | Additional vector sources |
|---|---|
| PP literal, PP interface, PP history interface | `c_preprocessor_benchmark.c`, `c_files_benchmark.c`, `c_parser_benchmark.c` |
| Executable interface | `executable_benchmark.c`, `link_benchmark.c`, `snapshot_benchmark.c` |
| Checker actions | `c_checker_benchmark.c` |
| Tier 0 | `tier0_benchmark.c`, `tier1_select_benchmark.c` |

`c_check_input.c`, `c_checker_test.c`, `ir_dataflow.c` and `ir_if_convert.c` add no standalone compilation steps in the baseline. Both configurations passed every initial/restored no-op and source-content/timestamp check. The baseline worktree remained clean, and neither compiler changed.

## Final integrated comparison

Counts below are compilation steps; every edited plan also has one link and one bake/post-link step. The implementation rows use their explicitly recorded baseline containers.

| Edit | Scalar before → after | Vector before → after | Candidate unity consumers |
|---|---:|---:|---|
| PP literal | 11 → 1 | 14 → 4 | FRONTEND |
| PP private implementation | 11 → 1 | 14 → 4 | FRONTEND |
| PP private history implementation | 11 → 1 | 14 → 4 | FRONTEND |
| PP shared interface | 11 → 11 | 14 → 14 | All eleven |
| PP shared history interface | 11 → 11 | 14 → 14 | All eleven |
| Executable private implementation | 11 → 2 | 14 → 5 | DYNAMIC, EXECUTABLE |
| Executable shared interface | 11 → 11 | 14 → 14 | All eleven |
| Checker input | 11 → 1 | 11 → 1 | CHECKER |
| Checker actions | 11 → 3 | 12 → 4 | BACKEND, CHECK_BUILTINS, CHECKER |
| Checker test root | 11 → 3 | 11 → 3 | BACKEND, CHECK_BUILTINS, CHECKER |
| IR dataflow | 11 → 2 | 11 → 2 | BACKEND, CHECKER |
| IR if conversion | 11 → 2 | 11 → 2 | BACKEND, CHECKER |
| Tier 0 | 11 → 2 | 13 → 4 | BACKEND, CHECKER |

The vector standalone consumers remain exactly as listed for the baseline; the new PP implementation files have the same three PP/files/parser benchmark consumers, and the new executable implementation has the same three executable/link/snapshot benchmark consumers. The shared-interface positive controls still select the full expected consumer set.

Every candidate source's original content, inode, size, mode and nanosecond atime/mtime were restored; all thirteen restored controls per configuration were no-ops. Candidate compiler hashes remained unchanged and match the baseline hashes in the corresponding metadata receipts. Both harness processes exited and released their build locks before root resumed further validation.

No elapsed-time build-performance claim is made from these plans.
