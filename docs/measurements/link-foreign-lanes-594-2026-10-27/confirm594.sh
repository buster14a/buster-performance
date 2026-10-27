#!/bin/bash
# confirm594.sh PASSES: #594's confirmation (lists594c.py), PASSES passes of two holds of the shared lock each (about
# 100 s): confirm-small (41 rounds) and confirm-big (6), then confirm-mid (8) and confirm-time (10). Each list's
# rounds continue procbench's rotation from its last pass (--first); results append to results594c-LIST.tsv, the --time
# reports to outc594/.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > confirm594.pid
export EXCLUSIVE_OWNER=claude-594 EXCLUSIVE_TITLE="link-foreign lanes by the link's work (#594): confirmation" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/594
python3 lists594c.py || exit 1
mkdir -p outc outc594
for list in confirm-small confirm-big confirm-mid confirm-time; do
    [ -s "results594c-$list.tsv" ] || ./procbench --rounds 0 "$list.list" > "results594c-$list.tsv"
done
run() {
    local list=$1 rounds=$2 pass=$3
    echo "./procbench --first $(( (pass - 1) * rounds + 1 )) --rounds $rounds --no-header --out outc594 $list.list >> results594c-$list.tsv"
}
for pass in $(seq 1 "$1"); do
    ~/buster-fast-bench/exclusive.sh bash -c "$(run confirm-small 41 "$pass"); $(run confirm-big 6 "$pass")"
    echo "confirm pass $pass A status $? $(date -Is)" >> confirm594.log
    sleep 20
    ~/buster-fast-bench/exclusive.sh bash -c "$(run confirm-mid 8 "$pass"); $(run confirm-time 10 "$pass")"
    echo "confirm pass $pass B status $? $(date -Is)" >> confirm594.log
    sleep 20
done
echo "confirm done $(date -Is)" >> confirm594.log
