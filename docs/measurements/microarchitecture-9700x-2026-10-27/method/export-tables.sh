#!/bin/sh
set -eu
report=${1:-outputs/microarchitecture}
script_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$report/tables"
jq -sr --slurpfile catalog "$report/hardware/9700x-perf-list-uncore.json" -f "$script_directory/export-native-counters.jq" "$report"/raw/9700x/counters-*.jsonl > "$report/tables/9700x-core-counters.csv"
printf '%s\n' '"host","scope","requested_alias","perf_event","count_text","source_bytes","per_source_byte","per_1000_instructions","per_user_cycle","cycles_u_same_run","instructions_u_same_run","running_percent","compile_failures","cohort"' > "$report/tables/local-core-counters.csv"
for capture in "$report"/raw/local/event-*.perf.json; do
    workload=${capture%.perf.json}.work.json
    jq -sr --slurpfile workload "$workload" --rawfile requests "$report/hardware/local-core-event-requests.txt" --arg cohort "$(basename "$capture" .perf.json)" '
        ($workload[0]) as $w |
        (map(select(.event == "cycles:u"))[0]["counter-value"] | tonumber?) as $cycles |
        (map(select(.event == "instructions:u"))[0]["counter-value"] | tonumber?) as $ins |
        ($requests | split("\n"))[($cohort|sub("^event-";"")|tonumber)-2000] as $requested |
        .[2] | (try (."counter-value" | tonumber) catch null) as $count |
        ["7940hs","user",$requested,.event,."counter-value",$w.completed_bytes,($count/$w.completed_bytes),($count*1000/$ins),($count/$cycles),$cycles,$ins,."pcnt-running",$w.failures,$cohort] | @csv
    ' "$capture" >> "$report/tables/local-core-counters.csv"
done
printf '%s\n' '"host","metric_and_unit","value_text","same_row_event","same_row_counter_text","same_row_running_percent","cohort_minimum_running_percent","quality","cohort"' > "$report/tables/derived-metrics.csv"
jq -sr '(map(."pcnt-running" // empty) | min) as $minimum | .[] | select(has("metric-value")) | ["9700x",."metric-unit",."metric-value",.event,."counter-value",."pcnt-running",$minimum,"exploratory_multiplexed_systemwide","all-metrics"] | @csv' "$report/raw/9700x/all-metrics.perf.json" >> "$report/tables/derived-metrics.csv"
for capture in "$report"/raw/9700x/metric-isolated-*.perf.json; do
    test -f "$capture" || continue
    jq -sr --arg cohort "$(basename "$capture" .perf.json)" '(map(."pcnt-running" // empty) | min) as $minimum | .[] | select(has("metric-value")) | ["9700x",."metric-unit",."metric-value",.event,."counter-value",."pcnt-running",$minimum,(if (."metric-value"|test("nan|inf";"i")) then "unavailable_nonfinite" elif $minimum == null then "unavailable_no_coverage" elif $minimum < 99.9 then "multiplexed_systemwide_cpu0_7" else "fully_scheduled_systemwide_cpu0_7" end),$cohort] | @csv' "$capture" >> "$report/tables/derived-metrics.csv"
done
for capture in "$report"/raw/local/metric-*.perf.json; do
    jq -sr --arg cohort "$(basename "$capture" .perf.json)" '(map(."pcnt-running" // empty) | min) as $minimum | .[] | select(has("metric-value")) | ["7940hs",."metric-unit",."metric-value",.event,."counter-value",."pcnt-running",$minimum,(if $minimum < 99.9 then "multiplexed" else "per_process_local_control" end),$cohort] | @csv' "$capture" >> "$report/tables/derived-metrics.csv"
done
printf '%s\n' '"host","requested_metric","cohort","counter_rows","metric_rows","finite_metric_rows","minimum_running_percent","unsupported_counter_rows","compile_failures","quality"' > "$report/tables/metric-collection-status.csv"
for machine in 9700x local; do
    if test "$machine" = 9700x; then pattern=metric-isolated; offset=0; else pattern=metric; offset=3000; fi
    for capture in "$report"/raw/"$machine"/"$pattern"-*.perf.json; do
        test -f "$capture" || continue
        workload=${capture%.perf.json}.work.json
        jq -nr --slurpfile stats "$capture" --slurpfile workload "$workload" --rawfile requests "$report/hardware/$machine-metric-requests.txt" --arg host "$machine" --arg cohort "$(basename "$capture" .perf.json)" --argjson offset "$offset" '
            ($cohort|capture("(?<index>[0-9]+)$").index|tonumber) as $index |
            ($requests|split("\n"))[$index-$offset] as $requested |
            ($stats|map(."pcnt-running"//empty)|min) as $minimum |
            ($stats|map(select(has("metric-value")))) as $metrics |
            ($metrics|map(select(."metric-value"|test("nan|inf";"i")|not))|length) as $finite |
            [ $host,$requested,$cohort,($stats|map(select(has("counter-value")))|length),($metrics|length),$finite,$minimum,($stats|map(select(."counter-value"//""|test("<not")))|length),$workload[0].failures,(if ($metrics|length)==0 then "unavailable_no_metric" elif $finite==0 then "unavailable_nonfinite" elif $minimum<99.9 then "multiplexed" else "fully_scheduled" end)]|@csv
        ' >> "$report/tables/metric-collection-status.csv"
    done
done
jq -r '["host","metric","unit","expression","group","description"]|@csv' -n > "$report/tables/metric-catalog.csv"
for machine in 9700x local; do
    jq -r --arg host "$machine" '.[]|select(.MetricName)|[$host,.MetricName,.ScaleUnit,.MetricExpr,.MetricGroup,.BriefDescription]|@csv' "$report/hardware/$machine-perf-list-uncore.json" >> "$report/tables/metric-catalog.csv"
done
