#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# tables.sh RESULTS TABLES: every table of the record, from the host's results directory (RESULTS, as the scripts here
# left it: results/ under the session's directory on the 9700X) into TABLES. The record's raw/ keeps a part of RESULTS
# (README.md says which); the tables were made from all of it. Needs python3 alone; no lock, no compiler.
set -eu
results=${1:?the results directory}
tables=${2:?the tables directory}
tools=$(dirname "$0")/tools
mkdir -p "$tables"
r=$results

# 1. The baseline: default against --tier1, three corpora, one lane and eight.
python3 "$tools/baseline_table.py" "$r"/baseline3/{sqlite-1,sqlite-8,lua-1,lua-8,musl-1,musl-8} > "$tables/baseline.md"
python3 "$tools/runs_table.py" --title "the instrumented executable against the unpatched one (sqlite3.c)" "$r/overhead" > "$tables/overhead.md"

# 2. The pipeline by stage and by function size, from the lap logs (wall time, the TSC).
for c in sqlite lua musl; do
    python3 "$tools/stage_table.py" "$r"/laps/$c/tier1-*.laps.gz > "$tables/$c-stages.tsv"
    python3 "$tools/stage_table.py" --groups "$r"/laps/$c/tier1-*.laps.gz > "$tables/$c-groups.tsv"
    python3 "$tools/stage_table.py" "$r"/laps/$c/default-*.laps.gz > "$tables/$c-default-stages.tsv"
    python3 "$tools/stage_by_size.py" "$r"/laps/$c/tier1-*.laps.gz > "$tables/$c-stage-by-size.tsv"
    python3 "$tools/function_sizes.py" --top 20 --functions "$tables/$c-functions.tsv" "$r"/laps/$c/tier1-*.laps.gz > "$tables/$c-sizes.txt"
done

# 3. Counters by stage (sqlite3.c): each sample in the lap its time falls in. Then the ranking table, which needs both.
s=$r/stagecounters/sqlite
for g in work td lat mem; do
    python3 "$tools/samples_reduce.py" "$s" $g 1 2 3 4 5 6 > "$tables/sqlite-counters-$g-stages.tsv"
    python3 "$tools/samples_reduce.py" --groups "$s" $g 1 2 3 4 5 6 > "$tables/sqlite-counters-$g-groups.tsv"
    python3 "$tools/samples_by_size.py" "$s" $g 1 2 3 4 5 6 > "$tables/sqlite-counters-$g-sizes.tsv"
done
python3 "$tools/samples_reduce.py" --functions 12 "$s" work 1 2 3 4 5 6 > "$tables/sqlite-counters-work-functions.tsv"
python3 "$tools/stage_summary.py" "$tables/sqlite-stages.tsv" "$tables/sqlite-counters-work-stages.tsv" "$tables/sqlite-counters-td-stages.tsv" "$tables/sqlite-counters-lat-stages.tsv" > "$tables/sqlite-stage-summary-stages.tsv"
python3 "$tools/stage_summary.py" --markdown "$tables/sqlite-groups.tsv" "$tables/sqlite-counters-work-groups.tsv" "$tables/sqlite-counters-td-groups.tsv" "$tables/sqlite-counters-lat-groups.tsv" > "$tables/sqlite-stage-summary.md"
python3 "$tools/footprint.py" "$s" work 1 2 3 4 5 6 > "$tables/sqlite-footprint.txt"
python3 "$tools/ranking.py" "$tables/sqlite-stages.tsv" "$tables/sqlite-counters-work-stages.tsv" "$tables/sqlite-counters-td-stages.tsv" 426.1 > "$tables/sqlite-ranking.md"

# 4. The stage-batch prototype (laps4.patch): the sweeps, and the counters at 64 functions a batch.
{
    python3 "$tools/runs_table.py" --title "sqlite3.c, functions a batch (bN; b1000000 is the whole unit)" "$r/batch/sqlite-count"
    python3 "$tools/runs_table.py" --title "sqlite3.c, typed entries a batch (eN)" "$r/batch/sqlite-entries"
    python3 "$tools/runs_table.py" --title "Lua, functions a batch" "$r/batch/lua-count"
    python3 "$tools/runs_table.py" --title "musl, functions a batch" "$r/batch/musl-count"
} > "$tables/batch.md"
b=$r/stagecounters-batch64/sqlite
for g in work td lat; do
    python3 "$tools/samples_reduce.py" --groups "$b" $g 1 2 3 4 5 6 > "$tables/sqlite-batch64-counters-$g-groups.tsv"
done
python3 "$tools/stage_table.py" --groups "$b"/work-*.laps.gz > "$tables/sqlite-batch64-groups.tsv"
python3 "$tools/stage_summary.py" --markdown "$tables/sqlite-batch64-groups.tsv" "$tables/sqlite-batch64-counters-work-groups.tsv" "$tables/sqlite-batch64-counters-td-groups.tsv" "$tables/sqlite-batch64-counters-lat-groups.tsv" > "$tables/sqlite-batch64-stage-summary.md"

# 5. A profile-guided build trained on the corpora's own compiles.
python3 "$tools/pgo_table.py" "$r"/pgo/{sqlite,lua,musl} > "$tables/pgo.md"

# 6. One allocation's prototypes: laps3.patch (the preferred allocation first), laps5.patch (the restarting exact
# variant), laps6.patch (both problems in one allocator call), laps7.patch (the plain verdict from a prefix, with the
# unpatched executable in the design) and laps8.patch (that verdict inside the preferred assignment's call).
{
    for c in sqlite lua musl; do
        python3 "$tools/runs_table.py" --title "$c: laps3.patch, today's two allocations (two) against the preferred one first (one)" "$r/prototype/$c"
        python3 "$tools/runs_table.py" --title "$c: laps5.patch, with the restarting exact variant (exact)" "$r/prototype5/$c"
        python3 "$tools/runs_table.py" --title "$c: laps6.patch, one allocator call (shared), with the pressure bound (quiet), and the preferred one first (one)" "$r/prototype6/$c"
        python3 "$tools/runs_table.py" --title "$c: laps7.patch, the unpatched executable (src) and the patched one's two, shared, quiet and prefix" "$r/prototype7/$c"
        python3 "$tools/runs_table.py" --title "$c: laps8.patch, the unpatched executable (src) and the patched one's two, shared, prefix and inline" "$r/prototype8/$c"
    done
} > "$tables/one-allocation.md"
python3 "$tools/gains.py" src "$r"/prototype7/{sqlite,lua,musl} > "$tables/one-allocation-gains-laps7.md"
python3 "$tools/gains.py" src "$r"/prototype8/{sqlite,lua,musl} > "$tables/one-allocation-gains.md"
for c in sqlite lua musl; do
    python3 "$tools/second.py" "$r/prototype/$c/two.laps.gz" > "$tables/$c-second-allocation.txt"
    python3 "$tools/variants.py" "$r/prototype6/$c" two shared quiet one > "$tables/$c-one-allocation-stages-laps6.tsv"
    python3 "$tools/variants.py" "$r/prototype7/$c" two shared quiet prefix > "$tables/$c-one-allocation-stages-laps7.tsv"
    python3 "$tools/variants.py" "$r/prototype8/$c" two shared prefix inline > "$tables/$c-one-allocation-stages.tsv"
    python3 "$tools/allocator_rows.py" "$tables/$c-one-allocation-stages.tsv" > "$tables/$c-one-allocation-allocator.md"
    {
        for v in one; do echo "## $c, laps3.patch, $v against two"; cat "$r/prototype/$c/functions-differ.txt"; done
        for v in shared quiet one; do echo "## $c, laps6.patch, $v against two"; cat "$r/prototype6/$c/$v.functions-differ.txt"; done
        for v in two shared quiet prefix; do echo "## $c, laps7.patch, $v against src"; cat "$r/prototype7/$c/$v.functions-differ.txt"; done
        echo "## $c, laps7.patch, the objects"; cat "$r/prototype7/$c/objects.txt"
        for v in two shared prefix inline; do echo "## $c, laps8.patch, $v against src"; cat "$r/prototype8/$c/$v.functions-differ.txt"; done
        echo "## $c, laps8.patch, the objects"; cat "$r/prototype8/$c/objects.txt"
    } > "$tables/$c-one-allocation-differ.txt"
done
python3 "$tools/prefix_share.py" "$r"/prototype5/{sqlite,lua,musl}/two.laps.gz > "$tables/prefix-share.txt"
