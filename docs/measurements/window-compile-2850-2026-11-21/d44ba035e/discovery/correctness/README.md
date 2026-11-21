# Source-order discovery for Buster comparison windows

This experiment uses private source revision `543e46c4f9ee68801dceafc644d3ad7016348797`. It includes the independently selectable assignment switch from PR #3224 and compares three ways to find an eligible comparison before constructing the ordinary expression graph. All three use the same kernel to build the front, type the leaves and comparison, preserve warnings and splice sourced native rows. Each production fallback runs the original graph builder.

| BUSTER_CONDITION_DISCOVERY | Candidate source |
| --- | --- |
| original | Visit every compacted binary action and test its source bounds. This is the discovery algorithm used in PR #3226. |
| control | Visit the parser's closing conditions in source order, follow the control's children through grouping, and mark its comparison action. |
| plain | Read 64 source tokens per iteration. Match an `if` or `while` keyword with an opening condition, an equality or relational operator at the middle and the closing condition five tokens after the keyword. Mark its ordinary binary action. More complex predicates go through the ordinary checker. |

On frozen SQLite, original and control each considered 5,540 bounded candidates, took 1,367 comparisons and retained 4,101 native rows. Plain considered 2,493, took 1,352 and retained 4,056 rows. Each of the 15 differences has redundant outer parentheses, as verified against the parser tokens in `results/declined-grouped.tsv`. All three outputs matched the ordinary native object. With the independently gated assignment route also enabled, these represented 4,344, 4,344 and 4,329 total admissions respectively. `results/sqlite.tsv` contains the graph counts and object hashes from that configuration.

Lua's 34 files produced 99 admitted comparisons and musl's 1,336 produced 702 in each discovery mode. The plain scanner reduced the candidate counts from 753 to 195 for Lua and from 3,990 to 1,480 for musl. Every file retained its original admissions under default and `-Wall -Wextra`. Both source-order routes matched status and full diagnostics in every comparison. The `results/*-units.jsonl` rows contain file name, controls, bounded candidates, admissions, retained rows, exit status and option difference flag, in that order.

The checker shard exercising complete values, sourced lowering and deferred fallback ran 210,494 checks per mode. At each of the 64 source-token positions inside a vector, a dedicated generator tried seven forms with both eligible and refused expressions. It issued 5,376 actual `-c` invocations across default, warning and warning-as-error policies. The ordinary compiler and all three options gave identical status, objects and diagnostics. The 1,344 timed probes compare actual admissions and confirm the selective grouping fallback.

A separate debugger capture read the full 96-byte checked value of each admitted SQLite comparison and the ordinary comparison at its parser token. All 1,367 original/control values agreed. The 1,352 plain values formed an exact subset, with zero value differences. `results/values-summary.tsv` records all six operator counts and the digest of the sorted token/opcode/value tuples. The debugger script uses the x86-64 layouts for these exact sources. It reconstructs both dense and sparse stream representations.

The full SQLite test additionally lowers every selected function with native source rows enabled through the ordinary checker and again through each candidate. All 2,668 bodies and 381,191 entries matched for each option. The complete native function comparison covers kinds, classes, values, locals, parameters and call metadata. Every entry's source token also matched. Each run passed 210,495 assertions. To reproduce, apply `sourced-oracle.patch` on the discovery tree, build and run checker shard 5 with `BUSTER_COMPARE_WINDOW_FILE=/absolute/path/to/sqlite3.c` and one of the same `BUSTER_CONDITION_DISCOVERY` values. This second test-only patch yields tree `e26c7dc36c99c4fdde3d6e7890448ca4dcbc809f`.

## Reproduce

Starting at public PR #3226 head `d44ba035e84172eaac4ddd4b4b3339bb4fd34b9b`, applying `discovery.patch` yields Git tree `3ef5e4eed1271ca17ababaef1b0971e5d80ad704`. It includes both the assignment gate integration and the discovery experiment. Build with the repository's normal build script. The `BUSTER_CONDITION_DISCOVERY` modes apply when `--node-window-conditions` is present. `--node-window-assignments` can be independently added. Use `--time-stages` for admissions and controls.

```sh
python3 boundary.py /tmp/buster-condition-offsets /path/to/buster/build/compiler

# Supply the same frozen SQLite command-line arguments and source path for all four captures.
for mode in ordinary original control plain; do
    option=()
    if [ "$mode" != ordinary ]; then option+=(--node-window-conditions); fi
    PROBE_SOURCE="$mode" PROBE_ROOTS="/tmp/values-$mode.bin" BUSTER_CONDITION_DISCOVERY="$mode" \
        gdb -q -nx -batch -x sqlite-values.gdb --args /path/to/buster/build/compiler "${option[@]}" \
        --dump-typed -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 \
        -DSQLITE_ENABLE_RTREE -I/path/to/sqlite /path/to/sqlite/sqlite3.c
done
python3 compare-values.py /tmp
```

The matching corpus script and historical generator qualification for the initial source are in the [original comparison correctness archive](https://github.com/buster14a/buster-performance/tree/8539de473c77ff0cc0fb6234581ad8db61a16524/docs/measurements/window-compile-2850-2026-11-21/d44ba035e/correctness). The [eight-stage native ablation](https://github.com/buster14a/buster-performance/tree/e7f5ff762fafb94a2118c621fcb2689853b5ed43/docs/measurements/window-compile-2850-2026-11-21/d44ba035e/controls) measures the initial scanner, front, typing and publication on a locked 9700X.

The local Develop-build PMU records under `results/local-*` come from a single pinned hardware thread on a Ryzen 9 7940HS. Seven randomized rounds compare process counters and verify the object hash. Against the same binary with only the assignment window, enabling comparisons with original discovery added 738,677 retired user instructions, control added 126,494 and plain saved 1,148,403. All seven instruction differences had the same sign for each comparison. Cycles varied widely on this shared host.

For the optional local thirteen-mode reproduction, run `python3 local-pmu.py COST_COMPILER DISCOVERY_COMPILER SCRATCH SQLITE_FLAGS... SQLITE_SOURCE`. The cost compiler is the private diagnostic source reconstructed by the eight-stage archive. Run on a single hardware thread.
