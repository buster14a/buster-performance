#!/bin/bash
# profile-xs4.sh: where the side facts' sweep's cycles go, on the frozen code's Release executable (results/xs4): a
# perf record of the shadow's run on sqlite3.c and on Lua, CPU 2, a run a hold of the lock, after the readings' job;
# then the symbols' shares and the sweep's function's own lines.
cd "$(dirname "$0")"
while pgrep -f "job-xs.sh xs4" > /dev/null; do sleep 20; done
. ./corpora.sh
out=$PWD/results/xs4-profile
mkdir -p "$out"
cp results/xs4/compiler "$out/compiler" && cat "$out/compiler" > /dev/null
for c in sqlite3 lua; do
    case $c in
        sqlite3) arguments=$sqlite_arguments ;;
        lua) arguments=$lua_arguments ;;
    esac
    ./lock.sh bash -c "taskset -c 2 perf record -q -e cycles:u -c 1009 -o $out/$c.data -- $out/compiler measure-node-machine --shadow --passes 0 --window-rows $arguments > $out/$c.txt 2>&1; echo status \$? >> $out/$c.txt"
    perf report -i "$out/$c.data" --stdio --sort symbol 2> /dev/null | grep -v '^#' | grep -v '^$' | head -60 > "$out/$c-symbols.txt"
    perf annotate -i "$out/$c.data" --stdio -s node_rows_window_summary 2> /dev/null > "$out/$c-summary-annotate.txt"
    perf annotate -i "$out/$c.data" --stdio -s node_rows_summary_call 2> /dev/null > "$out/$c-call-annotate.txt"
    perf report -i "$out/$c.data" --stdio --sort symbol 2> /dev/null | grep -i "summary\|Samples\|Event count" > "$out/$c-summary-share.txt"
    rm -f "$out/$c.data"
done
rm -f "$out/compiler"
echo "profile finished"
