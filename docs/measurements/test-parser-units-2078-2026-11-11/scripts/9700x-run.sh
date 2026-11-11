#!/bin/bash
# #2078 on the 9700X: test-parser without files and without clang (plain), with --clang (clang), and on the repository's
# translation units (units: --files-only, the base tree's 33 units and predefines for both builds), base and head,
# pinned to CPU 2, interleaved (ABBA by round), each run under its own hold of the lock. Writes results.tsv: wall, user
# and sys seconds (bash's time), and perf stat's task-clock, page faults and context switches.
D=~/buster-fast-bench/2078-claude
export EXCLUSIVE_OWNER=claude-2078 EXCLUSIVE_TITLE="Cut test-parser's own time, CI's longest command (#2078)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2087
rounds=${ROUNDS:-3}
out=$D/${RESULTS:-results.tsv}
printf 'round\tbuild\tcommand\tstatus\twall_s\tuser_s\tsys_s\ttask_clock_ms\tpage_faults\tcontext_switches\n' > $out
for round in $(seq 1 $rounds); do
    order="base head"
    [ $((round % 2)) = 0 ] && order="head base"
    for command in ${COMMANDS:-plain clang units}; do
        for build in $order; do
            case $command in
                plain) args="" ;;
                clang) args="--clang" ;;
                units) args="--files-only -march=native -Isrc -fwrapv -funsigned-char --predefines $D/predefines.h $(tr "\n" " " < $D/units.txt)" ;;
            esac
            name=$build-$command-$round
            # Every build reads the base tree's sources, so that both parse the same files.
            cd $D/base || exit 1
            ~/buster-fast-bench/exclusive.sh bash -c "TIMEFORMAT='%R %U %S'; { time perf stat -x, -e task-clock,page-faults,context-switches -o $D/stat-$name.csv -- taskset -c 2 $D/$build/build/compiler test-parser $args > $D/log-$name.txt 2>&1; echo \$? > $D/status-$name.txt; } 2> $D/time-$name.txt"
            read wall user sys < $D/time-$name.txt
            clock=$(awk -F, '/task-clock/ {print $1}' $D/stat-$name.csv)
            faults=$(awk -F, '/page-faults/ {print $1}' $D/stat-$name.csv)
            switches=$(awk -F, '/context-switches/ {print $1}' $D/stat-$name.csv)
            printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' $round $build $command "$(cat $D/status-$name.txt)" $wall $user $sys $clock $faults $switches >> $out
        done
    done
done
echo "== done $(date -u +%FT%TZ)"
