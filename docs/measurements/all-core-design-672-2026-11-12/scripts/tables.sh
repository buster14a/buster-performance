#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# tables.sh: every table of the record, from results/ alone (no compile runs; it is run inside a hold of the lock all
# the same, since it shares the host). Writes results/tables/*.tsv. A cohort's runs are pooled over its rounds, each
# worker's first and last run left out (--interior), and where a stray process shared a core of a cohort of 4 workers
# or more, that core's worker too (the cohort's strays file says where it was).
set -u
cd "$(dirname "$0")"
. ./common.sh
T=results/tables
mkdir -p "$T"

# without_of STRAYS: the first CPUs of the cores the strays were on (8 and 9 are 0's and 1's siblings, 11 to 15 are 3's
# to 7's), or `-`.
without_of()
{
    local list
    list=$(awk '{ c = $3; if (c >= 8) c -= 8; print c }' "$1" 2>/dev/null | sort -un | paste -sd, -)
    echo "${list:--}"
}

# pooled DIR LABEL: `allcore rows`' arguments for LABEL's rounds under DIR (DIR/r*/LABEL.rows.tsv).
pooled()
{
    local dir=$1 label=$2 rows arguments=()
    for rows in "$dir"/r*/"$label".rows.tsv; do
        [[ -f $rows ]] || continue
        case ${label##*.} in
            w4|w8) arguments+=(--without "$(without_of "${rows%.rows.tsv}.strays.txt")") ;;
            *) arguments+=(--without -) ;;
        esac
        arguments+=("$rows")
    done
    printf '%s\n' "${arguments[@]}"
}

# rows_table OUT DIR LABEL...: a pooled line a label.
rows_table()
{
    local out=$1 dir=$2 label first=1; shift 2
    : > "$out"
    for label in "$@"; do
        mapfile -t arguments < <(pooled "$dir" "$label")
        ((${#arguments[@]} == 0)) && continue
        if ((first)); then
            ./allcore rows --interior --bytes "$SQLITE_BYTES" --pool "$label" "${arguments[@]}" >> "$out"
            first=0
        else
            ./allcore rows --interior --bytes "$SQLITE_BYTES" --pool "$label" "${arguments[@]}" | tail -n +2 >> "$out"
        fi
    done
}

# stages_table OUT DIR LABEL: LABEL's stage medians over its rounds.
stages_table()
{
    local out=$1 dir=$2 label=$3 rows arguments=()
    for rows in "$dir"/r*/"$label".rows.tsv; do
        [[ -f $rows ]] || continue
        case ${label##*.} in
            w4|w8) arguments+=(--without "$(without_of "${rows%.rows.tsv}.strays.txt")") ;;
            *) arguments+=(--without -) ;;
        esac
        arguments+=("$rows" "$(dirname "$rows")/stages/$label.w%w.r%i.txt")
    done
    ((${#arguments[@]} == 0)) || ./allcore stages --interior "${arguments[@]}" > "$out"
}

# umc_table OUT DIR LABEL...: the memory controllers' counts a run, a line a label and round: read and write CAS
# commands less the round's idle rate over the cohort's span, in MB (64 B a command), with the cohort's bandwidth
# (GB/s over the span), the data bus's utilization (umc_data_slot_clks.all / 2 over umc_mem_clk, perf's
# umc_data_bus_utilization), the memory clock in MHz, and the package's joules a run.
umc_table()
{
    local out=$1 dir=$2 label round rows; shift 2
    printf 'label\tround\truns\tspan_ms\tread_mb_per_run\twrite_mb_per_run\tgb_per_s\tbus_utilization\tmem_clk_mhz\tjoules_per_run\tcounted_percent\n' > "$out"
    for label in "$@"; do
        for rows in "$dir"/r*/"$label".rows.tsv; do
            [[ -f $rows ]] || continue
            round=$(basename "$(dirname "$rows")")
            idle=$(dirname "$rows")/idle.umc.csv
            ./allcore stat "${rows%.rows.tsv}.umc.csv" "$idle" 2>/dev/null | awk -F'\t' -v label="$label" -v round="$round" -v rows="$rows" -v idle="$idle" '
                BEGIN {
                    while ((getline line < rows) > 0) {
                        n = split(line, f, "\t")
                        if (f[1] == "# cohort") start = f[6]
                        else if (f[1] != "label" && n >= 20) { runs += 1; if (f[7] > last) last = f[7] }
                    }
                    span = (last - start) / 1e9
                }
                $1 == idle { idle_value[$2] = $4; idle_ns[$2] = $6; next }
                NR > 1 { value[$2] = $4; counted[$2] = $5; running[$2] = $6 }
                END {
                    # The counts are perf'"'"'s window'"'"'s, a little longer than the cohort'"'"'s span (the workers'"'"' start); the idle
                    # control'"'"'s rate over that window is taken from them. Two controllers count each event, so an
                    # event'"'"'s running time is twice the window.
                    window = running["amd_umc/umc_cas_cmd.rd/"] / 2 / 1e9
                    idle_window = idle_ns["amd_umc/umc_cas_cmd.rd/"] / 2 / 1e9
                    rd = value["amd_umc/umc_cas_cmd.rd/"] - (idle_window > 0 ? idle_value["amd_umc/umc_cas_cmd.rd/"] / idle_window * window : 0)
                    wr = value["amd_umc/umc_cas_cmd.wr/"] - (idle_window > 0 ? idle_value["amd_umc/umc_cas_cmd.wr/"] / idle_window * window : 0)
                    clk = value["amd_umc/umc_mem_clk/"]
                    printf "%s\t%s\t%d\t%.1f\t%.1f\t%.1f\t%.2f\t%.3f\t%.0f\t%.2f\t%s\n", label, round, runs, span * 1e3, rd * 64 / 1e6 / runs, wr * 64 / 1e6 / runs,
                        (rd + wr) * 64 / 1e9 / span, (clk > 0 ? value["amd_umc/umc_data_slot_clks.all/"] / 2 / clk : 0), (window > 0 ? clk / 2 / window / 1e6 : 0), value["power/energy-pkg/"] / runs,
                        counted["amd_umc/umc_cas_cmd.rd/"]
                }' >> "$out"
        done
    done
}

# 1. The baseline: 1 worker (CPU 2 and CPU 5), 2, 4, 8 and 15.
rows_table "$T/baseline.tsv" results/baseline sq.w1 sq.w1b sq.w2 sq.w4 sq.w8 sq.w15
umc_table "$T/baseline-umc.tsv" results/baseline sq.w1 sq.w1b sq.w2 sq.w4 sq.w8 sq.w15
for workers in w1 w1b w2 w4 w8 w15; do
    stages_table "$T/stages-sq.$workers.tsv" results/baseline "sq.$workers"
done

# 2. The other counter sets at 1 and 8 workers.
rows_table "$T/sets-td.tsv" results/sets sq-td.w1 sq-td.w8
rows_table "$T/sets-lat.tsv" results/sets sq-lat.w1 sq-lat.w8
rows_table "$T/sets-mem.tsv" results/sets sq-mem.w1 sq-mem.w8

# 3. The page policy's other two corners.
for set in basic td lat mem; do
    rows_table "$T/pages-$set.tsv" results/pages "sqbase-$set.w1" "sqhuge-$set.w8"
done
stages_table "$T/stages-sqbase.w1.tsv" results/pages sqbase-basic.w1
stages_table "$T/stages-sqhuge.w8.tsv" results/pages sqhuge-basic.w8
umc_table "$T/pages-umc.tsv" results/pages sqbase-basic.w1 sqhuge-basic.w8

# 4. The preprocessed unit whole and without its bodies.
for set in basic lat mem; do
    rows_table "$T/spine-$set.tsv" results/spine "whole-$set.w1" "spine-$set.w1" "whole-$set.w8" "spine-$set.w8"
done
for unit in whole spine; do
    for workers in w1 w8; do
        stages_table "$T/stages-$unit.$workers.tsv" results/spine "$unit-basic.$workers"
    done
done
umc_table "$T/spine-umc.tsv" results/spine whole-basic.w1 spine-basic.w1 whole-basic.w8 spine-basic.w8

# 5. An L3 miss's latency by worker count: perf's l3_read_miss_latency, sampled latency times 10 ns over its requests.
if [[ -d results/latency ]]; then
    rows_table "$T/latency-lat.tsv" results/latency sq.w1 sq.w2 sq.w4 sq.w8 sq.w15
    printf 'label\tround\tl3_miss_latency_ns\tl3_miss_share\tl3_lookups\n' > "$T/latency.tsv"
    for csv in results/latency/r*/*.l3.csv; do
        label=$(basename "$csv" .l3.csv)
        round=$(basename "$(dirname "$csv")")
        ./allcore stat "$csv" | awk -F'\t' -v label="$label" -v round="$round" 'NR > 1 { value[$2] = $4 }
            END {
                requests = value["l3_xi_sampled_latency_requests.dram_near"]
                lookups = value["l3_lookup_state.l3_miss"] + value["l3_lookup_state.l3_hit"]
                printf "%s\t%s\t%.1f\t%.3f\t%.0f\n", label, round, (requests > 0 ? value["l3_xi_sampled_latency.dram_near"] * 10 / requests : 0),
                    (lookups > 0 ? value["l3_lookup_state.l3_miss"] / lookups : 0), lookups
            }' >> "$T/latency.tsv"
    done
fi

# 6. The bandwidth's ceiling: each stream's logical rate (the loop's own count) and what the controllers counted in
# the 100 ms intervals from 1.8 s to 0.2 s before the command's last: the stream alone, past its buffers' first touch.
if [[ -d results/ceiling ]]; then
    printf 'mode\tworkers\tlogical_gb_per_s\tread_gb_per_s\twrite_gb_per_s\tbus_utilization\tintervals\n' > "$T/ceiling.tsv"
    for tsv in results/ceiling/*.w?.tsv; do
        name=$(basename "$tsv" .tsv)
        logical=$(awk -F'\t' '$5 == "all" { print $6 }' "$tsv")
        ./allcore timeline "results/ceiling/$name.intervals.csv" | awk -F'\t' -v name="$name" -v logical="$logical" '
            NR == 1 { for (i = 1; i <= NF; i += 1) column[$i] = i; next }
            { n += 1; time[n] = $1; rd[n] = $column["amd_umc/umc_cas_cmd.rd/"]; wr[n] = $column["amd_umc/umc_cas_cmd.wr/"]; slots[n] = $column["amd_umc/umc_data_slot_clks.all/"]; clk[n] = $column["amd_umc/umc_mem_clk/"] }
            END {
                split(name, part, ".")
                for (i = 2; i <= n; i += 1) {
                    if (time[i] > time[n] - 1.8 && time[i] <= time[n] - 0.2) {
                        seconds += time[i] - time[i - 1]; reads += rd[i]; writes += wr[i]; s += slots[i]; c += clk[i]; used += 1
                    }
                }
                printf "%s\t%s\t%s\t%.2f\t%.2f\t%.3f\t%d\n", part[1], part[2], logical, (seconds > 0 ? reads * 64 / 1e9 / seconds : 0), (seconds > 0 ? writes * 64 / 1e9 / seconds : 0), (c > 0 ? s / 2 / c : 0), used
            }' >> "$T/ceiling.tsv"
    done
fi

# 7. musl five ways.
if [[ -d results/musl ]]; then
    : > "$T/musl.tsv"
    first=1
    for label in m.l1 m.l8 m.p8 m.u1 m.u8; do
        arguments=()
        for rows in results/musl/r*/"$label".rows.tsv; do
            [[ -f $rows ]] && arguments+=("$rows")
        done
        ((${#arguments[@]} == 0)) && continue
        if ((first)); then
            ./allcore rows --pool "$label" "${arguments[@]}" >> "$T/musl.tsv"
            first=0
        else
            ./allcore rows --pool "$label" "${arguments[@]}" | tail -n +2 >> "$T/musl.tsv"
        fi
    done
    umc_table "$T/musl-umc.tsv" results/musl m.l1 m.l8 m.p8 m.u1 m.u8
    # A pass over the 1,336 units, a line a label and round: the cohort's span and its runs' sums over its passes (3 of
    # m.l1, 5 of m.l8 and m.p8, 1 of m.u1 and m.u8), with the units a second and the cycles of both modes a pass.
    printf 'label\tround\tpasses\tpass_ms\tunits_per_s\tuser_mcycles\tkernel_mcycles\tuser_minstructions\tkernel_minstructions\tl2_dram_mlines\tminor_faults\tpeak_mb_max\n' > "$T/musl-pass.tsv"
    for label in m.l1 m.l8 m.p8 m.u1 m.u8; do
        for rows in results/musl/r*/"$label".rows.tsv; do
            [[ -f $rows ]] || continue
            case $label in m.l1) passes=3 ;; m.l8|m.p8) passes=5 ;; *) passes=1 ;; esac
            awk -F'\t' -v label="$label" -v round="$(basename "$(dirname "$rows")")" -v passes="$passes" '
                $1 == "# cohort" { start = $6; next }
                $1 == "label" { for (i = 1; i <= NF; i += 1) column[$i] = i; next }
                {
                    if ($7 > last) last = $7
                    user += $column["cycles:u"]; kernel += $column["cycles:k"]; ui += $column["instructions:u"]; ki += $column["instructions:k"]; lines += $column["l2_dram:a"]
                    faults += $12 + $19; if ($11 > peak) peak = $11
                }
                END {
                    span = (last - start) / 1e6
                    printf "%s\t%s\t%d\t%.1f\t%.0f\t%.1f\t%.1f\t%.1f\t%.1f\t%.2f\t%.0f\t%.1f\n", label, round, passes, span / passes, 1336 / (span / passes / 1e3), user / passes / 1e6, kernel / passes / 1e6,
                        ui / passes / 1e6, ki / passes / 1e6, lines / passes / 1e6, faults / passes, peak / 1024
                }' "$rows" >> "$T/musl-pass.tsv"
        done
    done
fi
# 8. The stages' counters at 1 worker and at 8, from the sampled cohorts' buckets: a line a stage with each group's
# events at both, the emission's interleaved stages as one row (`emission`: tier0 to code-atoms), the object's as one
# (`object`: debug to release) and the process's start and end as one (`start`).
group_of='
function group_of(stage) {
    if (stage == "tier0" || stage == "emit-setup" || stage == "lanes" || stage == "branch-sizing" || stage == "encode" || stage == "unwind" || stage == "code-atoms") return "emission"
    if (stage == "debug" || stage == "publish-data" || stage == "object-build" || stage == "object-write" || stage == "runtime" || stage == "executable" || stage == "write" || stage == "release") return "object"
    if (stage == "startup" || stage == "setup" || stage == "lanes-start" || stage == "type-table" || stage == "backend-setup" || stage == "exit" || stage == "teardown") return "start"
    if (stage == "static-data") return "check-declarations"
    return stage
}'
order="preprocess parse check-input check-expressions check-declarations check-program select lower emission object start"
# buckets_stages FILE: the bucket table's stage rows, grouped, as `group event value` lines.
buckets_stages()
{
    awk -F'\t' "$group_of"'
        /^#/ { next }
        $1 == "stage" { for (i = 2; i <= NF; i += 1) event[i] = sprintf("%02d\t%s", i, $i); columns = NF; next }
        $1 == "outside" || $1 == "total" { next }
        columns > 0 { for (i = 2; i <= columns; i += 1) sum[group_of($1) "\t" event[i]] += $i }
        END { for (key in sum) print key "\t" sum[key] }' <(awk '/^## /{ exit } { print }' "$1") | sort -t$'\t' -k2,2n -k1,1
}
for tag in sq whole spine; do
    for group in work lat kern; do
        one=results/sampled/$tag-$group.w1.buckets.tsv
        eight=results/sampled/$tag-$group.w8.buckets.tsv
        [[ -f $one && -f $eight ]] || continue
        {
            buckets_stages "$one" | sed 's/^/1\t/'
            buckets_stages "$eight" | sed 's/^/8\t/'
        } | awk -F'\t' -v order="$order" '
            { value[$1 "\t" $2 "\t" $4] = $5; if (!($4 in seen) && $4 !~ /^kernel-ip:/) { seen[$4] = 1; events[++count] = $4 } }
            END {
                n = split(order, stages, " ")
                line = "stage"
                for (e = 1; e <= count; e += 1) line = line "\t" events[e] " w1\t" events[e] " w8"
                print line
                for (i = 1; i <= n; i += 1) {
                    line = stages[i]
                    for (e = 1; e <= count; e += 1) {
                        a = value["1\t" stages[i] "\t" events[e]] + 0; b = value["8\t" stages[i] "\t" events[e]] + 0
                        line = line sprintf("\t%.0f\t%.0f", a, b); total1[e] += a; total8[e] += b
                    }
                    print line
                }
                line = "total"
                for (e = 1; e <= count; e += 1) line = line sprintf("\t%.0f\t%.0f", total1[e], total8[e])
                print line
            }' > "$T/sampled-$tag-$group.tsv"
    done
done

# 9. The model's inputs (tools/model.awk): each stage's user cycles at 1 worker and at 8 (the sampled cohorts' clock,
# scaled to the unsampled cohorts' medians), the bodies' share of its time at each (the preprocessed unit whole against
# the unit without its bodies; for the preprocessor, the bodies' share of the tokens), and the pages it faults at 8
# workers, for the unit and for the unit without its bodies; then the compile's totals.
if [[ -f $T/sampled-sq-lat.tsv && -f $T/stages-whole.w8.tsv ]]; then
    stage_ms() { awk -F'\t' "$group_of"' NR > 2 && $1 !~ /\./ && $1 != "process" { ms[group_of($1)] += $2; faults[group_of($1)] += $4 } END { for (g in ms) print g "\t" ms[g] "\t" faults[g] }' "$1"; }
    {
        awk -F'\t' 'NR == 1 { for (i = 1; i <= NF; i += 1) column[$i] = i; next } { print "user\t" $1 "\t" $column["ls_not_halted_cyc:u w1"] "\t" $column["ls_not_halted_cyc:u w8"] }' "$T/sampled-sq-lat.tsv"
        stage_ms "$T/stages-whole.w1.tsv" | sed 's/^/whole1\t/'
        stage_ms "$T/stages-spine.w1.tsv" | sed 's/^/spine1\t/'
        stage_ms "$T/stages-whole.w8.tsv" | sed 's/^/whole8\t/'
        stage_ms "$T/stages-spine.w8.tsv" | sed 's/^/spine8\t/'
        stage_ms "$T/stages-sq.w8.tsv" | sed 's/^/sq8\t/'
        awk -F'\t' 'NR == 1 { for (i = 1; i <= NF; i += 1) column[$i] = i; next } $1 == "sq.w1" || $1 == "sq.w8" { print "base\t" $1 "\t" $column["cycles:u"] "\t" $column["cycles:k"] "\t" $column["aperf:a"] "\t" $column["mperf:a"] "\t" $column["mb_per_s"] "\t" $column["wall_ms"] "\t" $column["minor_faults"] }' "$T/baseline.tsv"
        awk -F'\t' '$1 == "time-process" && $2 == "tsc-mhz" { print "tsc\t" $3; exit }' results/baseline/r0/stages/sq.w1.w0.r1.txt
    } | awk -F'\t' -v order="$order" -v megabytes="$(awk -v b="$SQLITE_BYTES" 'BEGIN { printf "%.6f", b / 1e6 }')" '
        $1 == "user" { user1[$2] = $3; user8[$2] = $4; next }
        $1 == "whole1" || $1 == "spine1" || $1 == "whole8" || $1 == "spine8" || $1 == "sq8" { ms[$1 "\t" $2] = $3; faults[$1 "\t" $2] = $4; next }
        $1 == "base" { cu[$2] = $3; ck[$2] = $4; ghz_ratio[$2] = $5 / $6; rate[$2] = $7; wall[$2] = $8; minor[$2] = $9; next }
        $1 == "tsc" { tsc = $2 / 1e3 }
        END {
            n = split(order, stages, " ")
            scale1 = cu["sq.w1"] / 1e6 / (user1["total"] / 1e6); scale8 = cu["sq.w8"] / 1e6 / (user8["total"] / 1e6)
            print "stage\tuser1\tuser8\tbodies1\tbodies8\tfaults8\tspine_faults8"
            for (i = 1; i <= n; i += 1) {
                s = stages[i]
                b1 = ms["whole1\t" s] > 0 ? (ms["whole1\t" s] - ms["spine1\t" s]) / ms["whole1\t" s] : 0
                b8 = ms["whole8\t" s] > 0 ? (ms["whole8\t" s] - ms["spine8\t" s]) / ms["whole8\t" s] : 0
                # The preprocessed unit has no preprocessing to speak of: the bodies are 568,641 of its 716,136 tokens.
                if (s == "preprocess") { b1 = 568641 / 716136; b8 = b1 }
                if (s == "start") { b1 = 0; b8 = 0 }
                if (b1 < 0) b1 = 0
                if (b8 < 0) b8 = 0
                spine_faults = faults["spine8\t" s] + 0
                if (spine_faults > faults["sq8\t" s]) spine_faults = faults["sq8\t" s]
                printf "%s\t%.2f\t%.2f\t%.3f\t%.3f\t%.0f\t%.0f\n", s, user1[s] / 1e6 * scale1, user8[s] / 1e6 * scale8, b1, b8, faults["sq8\t" s], spine_faults
                all_faults += faults["sq8\t" s]
            }
            ghz1 = tsc * ghz_ratio["sq.w1"]; ghz8 = tsc * ghz_ratio["sq.w8"]
            printf "total\tkernel1\t%.2f\ntotal\tkernel8\t%.2f\ntotal\tfaults8\t%.0f\n", ck["sq.w1"] / 1e6, ck["sq.w8"] / 1e6, all_faults
            printf "total\tghz1\t%.4f\ntotal\tghz8\t%.4f\ntotal\tmegabytes\t%s\ntotal\tbody_tokens\t568641\n", ghz1, ghz8, megabytes
            printf "total\toff8_ms\t%.2f\n", 8 * megabytes / rate["sq.w8"] * 1e3 - (cu["sq.w8"] + ck["sq.w8"]) / 1e6 / ghz8
            printf "total\toff1_ms\t%.2f\n", wall["sq.w1"] - (cu["sq.w1"] + ck["sq.w1"]) / 1e6 / ghz1
        }' > "$T/model-inputs.tsv"
    awk -f tools/model.awk "$T/model-inputs.tsv" > "$T/model.tsv"
fi
# 10. The inflation by stage, one table a unit: each stage's time (the stage reports' medians), user cycles and the
# cycles with a load not complete (the lat group's, scaled to the unsampled cohorts' user cycles), kernel cycles (the
# kern group's less the sampling's own: its cycles a sample, the sampled total less the unsampled median over the
# samples, times the stage's samples), demand fills from DRAM (the work group's), L2 fills from DRAM in user mode and
# in the kernel (the kern group's), pages faulted (the reports') and DRAM bytes moved (the timeline's read and write
# CAS commands, 64 bytes each), at 1 worker and at 8.
inflation()
{
    local tag=$1 rows1=$2 rows8=$3 stages1=$4 stages8=$5
    [[ -f $T/sampled-$tag-lat.tsv && -f $T/sampled-$tag-work.tsv && -f $T/sampled-$tag-kern.tsv && -f $stages1 && -f $stages8 ]] || return 0
    {
        awk -F'\t' "$group_of"' NR > 2 && $1 !~ /\./ && $1 != "process" { ms[group_of($1)] += $2; faults[group_of($1)] += $4 } END { for (g in ms) print "ms1\t" g "\t" ms[g] "\t" faults[g] }' "$stages1"
        awk -F'\t' "$group_of"' NR > 2 && $1 !~ /\./ && $1 != "process" { ms[group_of($1)] += $2; faults[group_of($1)] += $4 } END { for (g in ms) print "ms8\t" g "\t" ms[g] "\t" faults[g] }' "$stages8"
        for group in lat work kern; do
            awk -F'\t' -v group="$group" 'NR == 1 { for (i = 2; i <= NF; i += 1) name[i] = $i; next } { for (i = 2; i <= NF; i += 1) print "event\t" $1 "\t" name[i] "\t" $i }' "$T/sampled-$tag-$group.tsv"
        done
        for workers in w1 w8; do
            file=results/timeline/$tag-timeline.$workers.umcstages.tsv
            [[ -f $file ]] && awk -F'\t' "$group_of"' /^#/ || $1 == "stage" || $1 == "total" || $1 == "no-run-intervals" { next } { mb[group_of($1)] += ($2 + $3) * 64 / 1e6 } END { for (g in mb) print "umc\t" g "\t'"$workers"'\t" mb[g] }' "$file"
        done
        awk -F'\t' 'NR == 1 { for (i = 1; i <= NF; i += 1) column[$i] = i; next } { print "base\t" $1 "\t" $column["cycles:u"] "\t" $column["cycles:k"] }' "$rows1" "$rows8"
    } | awk -F'\t' -v order="$order" -v label1="$6" -v label8="$7" '
        $1 == "ms1" { ms1[$2] = $3; next }
        $1 == "ms8" { ms8[$2] = $3; faults8[$2] = $4; next }
        $1 == "event" { event[$2 "\t" $3] = $4; next }
        $1 == "umc" { umc[$2 "\t" $3] = $4; next }
        $1 == "base" { user[$2] = $3; kernel[$2] = $4; next }
        END {
            n = split(order, stages, " ")
            u1 = user[label1]; u8 = user[label8]; k1 = kernel[label1]; k8 = kernel[label8]
            scale1 = u1 / event["total\tls_not_halted_cyc:u w1"]; scale8 = u8 / event["total\tls_not_halted_cyc:u w8"]
            # The sampling´s own kernel cycles a sample: the sampled total less the unsampled median, over the samples.
            over1 = (event["total\tcycles:k w1"] - k1) / event["total\tcycles w1"]; over8 = (event["total\tcycles:k w8"] - k8) / event["total\tcycles w8"]
            print "stage\tms 1\tms 8\tuser Mcycles 1\tuser Mcycles 8\ttimes\tload not complete M 1\tload not complete M 8\tkernel Mcycles 1\tkernel Mcycles 8\tdemand fills from DRAM k 1\tdemand fills from DRAM k 8\tL2 fills from DRAM user k 1\tuser k 8\tkernel k 1\tkernel k 8\tfaults 8\tDRAM MB 1\tDRAM MB 8"
            for (i = 0; i <= n; i += 1) {
                s = i == 0 ? "total" : stages[i]
                if (i == 0) { for (j = 1; j <= n; j += 1) { ms1[s] += ms1[stages[j]]; ms8[s] += ms8[stages[j]]; faults8[s] += faults8[stages[j]]; umc[s "\tw1"] += umc[stages[j] "\tw1"]; umc[s "\tw8"] += umc[stages[j] "\tw8"] } }
                a = event[s "\tls_not_halted_cyc:u w1"] * scale1 / 1e6; b = event[s "\tls_not_halted_cyc:u w8"] * scale8 / 1e6
                line[i] = sprintf("%s\t%.2f\t%.2f\t%.1f\t%.1f\t%.2f\t%.1f\t%.1f\t%.1f\t%.1f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f", s, ms1[s], ms8[s], a, b, (a > 0 ? b / a : 0),
                    event[s "\tex_no_retire.load_not_complete:u w1"] * scale1 / 1e6, event[s "\tex_no_retire.load_not_complete:u w8"] * scale8 / 1e6,
                    (event[s "\tcycles:k w1"] - over1 * event[s "\tcycles w1"]) / 1e6, (event[s "\tcycles:k w8"] - over8 * event[s "\tcycles w8"]) / 1e6,
                    event[s "\tls_dmnd_fills_from_sys.dram_io_near:u w1"] / 1e3, event[s "\tls_dmnd_fills_from_sys.dram_io_near:u w8"] / 1e3,
                    event[s "\tl2_fill_rsp_src.dram_io_near:u w1"] / 1e3, event[s "\tl2_fill_rsp_src.dram_io_near:u w8"] / 1e3,
                    event[s "\tl2_fill_rsp_src.dram_io_near:k w1"] / 1e3, event[s "\tl2_fill_rsp_src.dram_io_near:k w8"] / 1e3, faults8[s], umc[s "\tw1"], umc[s "\tw8"])
            }
            for (i = 1; i <= n; i += 1) print line[i]
            print line[0]
        }' > "$T/inflation-$tag.tsv"
}
inflation sq "$T/baseline.tsv" "$T/baseline.tsv" "$T/stages-sq.w1.tsv" "$T/stages-sq.w8.tsv" sq.w1 sq.w8
inflation whole "$T/spine-basic.tsv" "$T/spine-basic.tsv" "$T/stages-whole.w1.tsv" "$T/stages-whole.w8.tsv" whole-basic.w1 whole-basic.w8
inflation spine "$T/spine-basic.tsv" "$T/spine-basic.tsv" "$T/stages-spine.w1.tsv" "$T/stages-spine.w8.tsv" spine-basic.w1 spine-basic.w8
# 11. The function bodies' user cycles by family of function at 1 worker and at 8: the whole unit's sampled cycles less
# the unit's without its bodies (the work group's first event, cycles:u), per compile and per body token (568,641).
families_of() { awk '/^## families\tall stages/ { on = 1; next } /^## / { on = 0 } on' "$1" | cut -f1,2; }
if [[ -f results/sampled/whole-work.w8.buckets.tsv && -f results/sampled/spine-work.w8.buckets.tsv ]]; then
    {
        families_of results/sampled/whole-work.w1.buckets.tsv | sed 's/^/whole1\t/'
        families_of results/sampled/spine-work.w1.buckets.tsv | sed 's/^/spine1\t/'
        families_of results/sampled/whole-work.w8.buckets.tsv | sed 's/^/whole8\t/'
        families_of results/sampled/spine-work.w8.buckets.tsv | sed 's/^/spine8\t/'
    } | awk -F'\t' '
        { value[$1 "\t" $2] = $3; if (!($2 in seen)) { seen[$2] = 1; names[++count] = $2 } }
        END {
            print "family\twhole Mcycles 1\twhole 8\tfile scope 1\tfile scope 8\tbodies 1\tbodies 8\ttimes\tbodies cycles a body token 1\t8"
            for (i = 1; i <= count; i += 1) {
                f = names[i]
                w1 = value["whole1\t" f] / 1e6; s1 = value["spine1\t" f] / 1e6; w8 = value["whole8\t" f] / 1e6; s8 = value["spine8\t" f] / 1e6
                printf "%s\t%.1f\t%.1f\t%.1f\t%.1f\t%.1f\t%.1f\t%.2f\t%.1f\t%.1f\n", f, w1, w8, s1, s8, w1 - s1, w8 - s8, (w1 - s1 > 0.5 ? (w8 - s8) / (w1 - s1) : 0), (w1 - s1) * 1e6 / 568641, (w8 - s8) * 1e6 / 568641
                t1 += w1 - s1; t8 += w8 - s8; a1 += w1; a8 += w8; b1 += s1; b8 += s8
            }
            printf "total\t%.1f\t%.1f\t%.1f\t%.1f\t%.1f\t%.1f\t%.2f\t%.1f\t%.1f\n", a1, a8, b1, b8, t1, t8, t8 / t1, t1 * 1e6 / 568641, t8 * 1e6 / 568641
        }' | (read -r header; echo "$header"; sort -t$'\t' -k7,7nr) > "$T/families-bodies.tsv"
fi

# 12. musl by family of function: each sampled way's cycles a pass (the kern group: both modes' cycles and the kernel's)
# and user cycles a pass (the work group), the runs' mean times the units for the ways that run a process a unit.
if [[ -d results/muslsampled ]]; then
    printf 'way\tgroup\tfamily\tfirst event a pass (M)\tsecond event a pass (M)\n' > "$T/musl-families.tsv"
    for buckets in results/muslsampled/*.buckets.tsv; do
        name=$(basename "$buckets" .buckets.tsv)
        way=${name%-*}; group=${name##*-}
        case $way in m.u1|m.u8) scale=1336 ;; m.p8) scale=8 ;; *) scale=1 ;; esac
        awk '/^## families\tall stages/ { on = 1; next } /^## / { on = 0 } on' "$buckets" | awk -F'\t' -v way="$way" -v group="$group" -v scale="$scale" '{ printf "%s\t%s\t%s\t%.1f\t%.1f\n", way, group, $1, $2 * scale / 1e6, $3 * scale / 1e6 }' >> "$T/musl-families.tsv"
    done
fi
ls -l "$T" > /dev/null
echo "tables written to $T"
