#!/bin/bash
# Resume of the #1356 packet recipe (run.sh) after its first two qualification
# points: the same commands, grouped so that one 9700X lock hold covers the
# remaining qualification and one hold covers each timed round of six pairs.
# Inner exclusive.sh calls run under the outer hold (BUSTER_9700X_HELD).
set -euo pipefail
export LC_ALL=C TZ=UTC
work="$HOME/buster-fast-bench/1356-claude"
packet="$HOME/buster-fast-bench/1356-claude-packet"
export EXCLUSIVE_OWNER=claude-1356
export EXCLUSIVE_TITLE='Tier 1 switch and label-table scaling (#1356)'
export EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxng6adVZSsrqxaH43pJ
compiler="$work/compiler/build/compiler"
locked()
{
    local log=$1 seconds=$2
    shift 2
    "$HOME/buster-fast-bench/exclusive.sh" bash -c '
        seconds=$1
        shift
        date -u +%FT%TZ
        printf "command:"
        printf " %q" "$@"
        printf "\n"
        cat /var/lib/buster-9700x/owner
        cat /proc/loadavg
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
        run_status=0
        timeout -k 5 "$seconds" "$@" || run_status=$?
        cat /proc/loadavg
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
        date -u +%FT%TZ
        printf "exit=%s\n" "$run_status"
        exit "$run_status"
    ' _ "$seconds" "$@" > "$log" 2>&1
}
check_report()
{
    awk -F '\t' '
        $1 == "tier1" {
            reports++
            for (i = 2; i <= NF; i++) {
                split($i, field, "=")
                values[field[1]] = field[2]
            }
            good = values["functions"] == "1" && values["requested"] == "1" &&
                   values["admitted"] == "1" && values["compiled"] == "1" &&
                   values["unsupported"] == "0" && values["resource_failures"] == "0" &&
                   values["internal_failures"] == "0" && values["fallbacks"] == "0"
        }
        END { exit !(reports == 1 && good) }
    ' "$1"
}

qualify()
{
    local shape n name
    # run.sh stopped while waiting to execute switch-8000's driver.
    locked "$work/logs/run-switch-8000.log" 60 taskset -c 2 "$work/bin/switch-8000"
    sha256sum "$work/objects/switch-8000.o" "$work/bin/switch-8000" >> "$work/qualified.sha256"
    for name in switch-16000 label-table-4000 label-table-8000 label-table-16000; do
        locked "$work/logs/verify-$name.log" 120 taskset -c 2 "$compiler" -std=gnu17 --lanes 1 --tier1 --tier1-strict --tier1-report --verify -c "$work/inputs/$name.c" -o "$work/objects/$name.o"
        check_report "$work/logs/verify-$name.log"
        locked "$work/logs/link-$name.log" 60 clang -std=c17 -O2 -Wall -Wextra -Werror -no-pie "$work/drivers/$name.c" "$work/objects/$name.o" -o "$work/bin/$name"
        locked "$work/logs/run-$name.log" 60 taskset -c 2 "$work/bin/$name"
        sha256sum "$work/objects/$name.o" "$work/bin/$name" >> "$work/qualified.sha256"
    done
}

round()
{
    local round=$1 sample offset point shape n pair
    local points=(switch:4000 switch:8000 switch:16000 label-table:4000 label-table:8000 label-table:16000)
    shopt -s nullglob
    sample=$round
    if [ "$round" -eq 0 ]; then sample=warmup; fi
    for offset in 0 1 2 3 4 5; do
        point=${points[$(((round + offset) % 6))]}
        shape=${point%:*}
        n=${point#*:}
        pair="$work/raw/$sample/$shape-$n"
        mkdir -p "$pair"
        locked "$pair/run.log" 60 taskset -c 2 "$compiler" measure-compile --runs 1 --warmups 0 --directory "$pair" --keep -- -std=gnu17 --lanes 1 --tier1 --tier1-strict --tier1-report -c "$work/inputs/$shape-$n.c"
        reports=("$pair"/measure-compile-*/errors.txt)
        test "${#reports[@]}" -eq 1
        check_report "${reports[0]}"
        cmp "$work/objects/$shape-$n.o" "${reports[0]%/errors.txt}/default.o"
        sha256sum "${reports[0]%/errors.txt}"/*.o >> "$work/measured-objects.sha256"
        printf '%s\t%s\t%s\t%s\n' "$sample" "$shape" "$n" "${reports[0]}" >> "$work/samples.tsv"
    done
}

case "${1:-drive}" in
qualify) qualify ;;
round) round "$2" ;;
drive)
    self=$(readlink -f "$0")
    "$HOME/buster-fast-bench/exclusive.sh" "$self" qualify 2> "$work/logs/hold-qualify.log"
    printf 'sample\tshape\tn\treport\n' > "$work/samples.tsv"
    for r in 0 1 2 3 4 5 6 7 8 9; do
        "$HOME/buster-fast-bench/exclusive.sh" "$self" round "$r" 2> "$work/logs/hold-round-$r.log"
    done
    sha256sum -c "$work/identities.sha256" > "$work/identities-after.log"
    sha256sum -c "$work/qualified.sha256" > "$work/qualified-after.log"
    echo CAMPAIGN-DONE
    ;;
esac
