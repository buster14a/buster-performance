#!/bin/bash
# confirm594d.sh PASSES: #594's confirmation (lists594d.py), PASSES passes of two holds of the shared lock each (about
# 110 s): one and eight (41 rounds each), big-one and big-eight (5 each); then mid (6) and time (10). Each list's
# rounds continue procbench's rotation from its last pass (--first); results append to results594d-LIST.tsv, the
# --time reports to outd594/.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > confirm594d.pid
export EXCLUSIVE_OWNER=claude-594 EXCLUSIVE_TITLE="link-foreign lanes by the link's work (#594): confirmation" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/594
python3 lists594d.py || exit 1
mkdir -p outd outd594
for list in one eight big-one big-eight mid time; do
    [ -s "results594d-$list.tsv" ] || ./procbench --rounds 0 "confirm-$list.list" > "results594d-$list.tsv"
done
run() {
    local list=$1 rounds=$2 pass=$3
    echo "./procbench --first $(( (pass - 1) * rounds + 1 )) --rounds $rounds --no-header --out outd594 confirm-$list.list >> results594d-$list.tsv"
}
for pass in $(seq 1 "$1"); do
    ~/buster-fast-bench/exclusive.sh bash -c "$(run one 41 "$pass"); $(run eight 41 "$pass"); $(run big-one 5 "$pass"); $(run big-eight 5 "$pass")"
    echo "confirm pass $pass A status $? $(date -Is)" >> confirm594d.log
    sleep 20
    ~/buster-fast-bench/exclusive.sh bash -c "$(run mid 6 "$pass"); $(run time 10 "$pass")"
    echo "confirm pass $pass B status $? $(date -Is)" >> confirm594d.log
    sleep 20
done
echo "confirm done $(date -Is)" >> confirm594d.log
