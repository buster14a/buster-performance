#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Build and execute the bounded C readers with a before-execution identity DAG.
set -euo pipefail
script=$(realpath -- "$0")
packet=$(realpath -- "${1:?PACKET NEW_BUILD_DIRECTORY OFFICIAL_CLANG}")
build=${2:?}
clang=$(realpath -- "${3:?}")
test ! -e "$build"
mkdir -p "$build"
build=$(realpath "$build")
analysis=$packet/analysis
mkdir -p "$analysis"
printf '%s  %s\n' c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67 "$clang" | sha256sum --check > "$analysis/final-compiler-check.txt"
sha256sum "$clang" "$script" "$packet/tools/read-results.c" "$packet/tools/call-controls/stage_summary.c" > "$analysis/final-before-build.sha256"
printf '%s\0' "$clang" -std=c17 -O2 -Wall -Wextra -Werror "$packet/tools/read-results.c" -o "$build/read-results" > "$analysis/timing-reader-build.argv0"
"$clang" -std=c17 -O2 -Wall -Wextra -Werror "$packet/tools/read-results.c" -o "$build/read-results"
printf '%s\0' "$clang" -std=c17 -O2 -Wall -Wextra -Werror "$packet/tools/call-controls/stage_summary.c" -o "$build/stage-summary" > "$analysis/stage-reader-build.argv0"
"$clang" -std=c17 -O2 -Wall -Wextra -Werror "$packet/tools/call-controls/stage_summary.c" -o "$build/stage-summary"
sha256sum --check "$analysis/final-before-build.sha256" > "$analysis/final-after-build-check.txt"
sha256sum "$build/read-results" "$build/stage-summary" > "$analysis/final-built-tools.sha256"
grep -Fx 'PASS complete_grid=9_time_plus18_stage no_parallel_lock_requests=true' "$analysis/primary-campaign.log" > "$analysis/campaign-terminal-check.txt"
cd "$packet"
printf '%s  %s\n' 8c8b3b73b81cf5567dd2ab2d9d2069b9d09bcc9c7ea3476724984273f606edce source/primary-inputs.sha256 | sha256sum --check > "$analysis/primary-manifest-check.txt"
input_count=$(wc -l < source/primary-inputs.sha256)
for process in 1 2 3; do
    for shift in 0 64 256; do
        for role in time-head stages-base stages-head; do
            side=results/bindings/$role-p$process-s$shift.txt
            test -f "$side"
            test "$(grep -c '^producer_exit_status=0$' "$side")" -eq 1
            test "$(grep -c '^before_run_utc=' "$side")" -eq 1
            test "$(grep -c '^after_run_utc=' "$side")" -eq 1
            before=$(sed -n 's/^before_run_utc=//p' "$side")
            after=$(sed -n 's/^after_run_utc=//p' "$side")
            test "$(date -u -d "$after" +%s)" -ge "$(date -u -d "$before" +%s)"
            raw=results/time-p$process-s$shift.log
            if [ "$role" != time-head ]; then raw=results/$role-p$process-s$shift.log; fi
            expected=$(sha256sum "$raw")
            test "$(grep -Fxc "$expected" "$side")" -eq 1
            test "$(grep -c ': OK$' "$side")" -eq "$((2 * input_count))"
            while read -r digest path; do
                test "$(grep -Fxc "$path: OK" "$side")" -eq 2
            done < source/primary-inputs.sha256
        done
    done
done
printf 'PASS all27producer_sidecars_status_freshness_and_raw_hashes\n' > "$analysis/sidecar-check.txt"
test "$(grep -c '^PASS revision=' results/locks/validation.log)" -eq 12
for role in base head; do
    for shift in 0 64 256; do
        for path in vector scalar; do
            test "$(grep -Fxc "PASS revision=$role shift=$shift path=$path three_outputs_identical=true" results/locks/validation.log)" -eq 1
        done
    done
done
for ledger in corpus runtime-tools; do
    before=results/bindings/$ledger-before.sha256
    after=results/bindings/$ledger-after-check.txt
    test -s "$before" && test -s "$after"
    test "$(wc -l < "$before")" -eq "$(wc -l < "$after")"
    test -z "$(sed '/: OK$/d' "$after")"
    while read -r digest path; do
        test "$(grep -Fxc "$path: OK" "$after")" -eq 1
    done < "$before"
done
find results -type f -print0 | sort -z | xargs -0 sha256sum > "$analysis/final-raw-before-execution.sha256"
sha256sum "$build/read-results" "$build/stage-summary" "$packet/tools/read-results.c" "$packet/tools/call-controls/stage_summary.c" "$script" >> "$analysis/final-raw-before-execution.sha256"
date -u +before_final_analysis_utc=%Y-%m-%dT%H:%M:%SZ > "$analysis/final-execution-receipt.txt"
"$build/read-results" results > "$analysis/whole-medians.csv"
"$build/read-results" results --samples > "$analysis/whole-samples.csv"
"$build/stage-summary" results > "$analysis/stages.csv"
date -u +after_final_analysis_utc=%Y-%m-%dT%H:%M:%SZ >> "$analysis/final-execution-receipt.txt"
sha256sum --check "$analysis/final-raw-before-execution.sha256" > "$analysis/final-raw-after-execution-check.txt"
printf 'PASS exact_current_sources_tools_raw_inputs_bound_before_final_analysis\n' >> "$analysis/final-execution-receipt.txt"
