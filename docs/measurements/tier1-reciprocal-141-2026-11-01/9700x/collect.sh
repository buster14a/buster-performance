#!/usr/bin/env bash
# collect.sh STAGE: the record's logs, as 9700x/ holds them, into STAGE, with the lock's waiting messages (which name
# other sessions' and CI jobs' commands) left out of every text file.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
stage=$1
rm -rf "$stage" && mkdir -p "$stage"
strip() { # FILE DESTINATION
    mkdir -p "$(dirname "$2")"
    awk '/^exclusive\.sh: waiting for the 9700X/ { waiting = 1; next } waiting && /^  (title|link|pull request|workflow|job|run|owner):/ { next } { waiting = 0; print }' "$1" > "$2"
}
copy() { # SOURCE-DIRECTORY DESTINATION-DIRECTORY PATTERN...
    local from=$1 to=$2
    shift 2
    for pattern in "$@"; do
        for f in $from/$pattern; do
            [ -f "$f" ] && strip "$f" "$to/$(basename "$f")"
        done
    done
}
copy logs-build $stage/logs-build "*.log"
for h in e0ae799c 1ea8b02 cc3387f; do
    d=$stage/head-$h
    copy logs-tests-head-$h $d/tests "*.log"
    copy logs-measure-head-$h $d/measure "*.log" "report-*.txt"
    [ -d micro-head-$h ] && copy micro-head-$h $d/micro "r*.txt" "build-*.txt" && ./micro-summary.sh micro-head-$h > $d/micro/summary.txt
    [ -d st-head-$h ] && copy st-head-$h $d/st run.times "stat-*.txt" "verify-*.txt" "build-*.txt"
    for c in diff diff-scalar; do
        if [ -d $c-head-$h ]; then
            name=$([ $c = diff ] && echo campaign || echo campaign-scalar)
            ./tally.sh $c-head-$h > $d/$name.tsv
            copy $c-head-$h $d/$name "chunk-*.log"
        fi
    done
done
d=$stage/head-1ea8b02
strip same-head-1ea8b02/result.txt $d/same.txt
copy select-head-1ea8b02 $d/select "*.txt"
copy select-profile-head-1ea8b02 $d/select-profile "symbols-*.txt" "run-*.txt"
copy verify-experiment $d/verify-experiment "*.txt"
c=$stage/corpora-1ea8b02
mkdir -p $c
./corpora-summary.sh corpora-head-1ea8b02 > $c/summary.txt 2>&1 || true
copy corpora-head-1ea8b02/lua $c/lua times.txt status.txt compare.txt static.txt functions.txt tier1-functions.txt classes.txt "stat-*.txt" "build-*.txt" "*.out"
copy corpora-head-1ea8b02/lua/profile $c/lua/profile classes-shares.txt
for f in corpora-head-1ea8b02/lua/profile/symbols-*.txt; do head -40 $f > $c/lua/profile/$(basename $f); done
copy corpora-head-1ea8b02/cts $c/cts tests.txt "build-*.txt" "check-*.txt" "stat-*.txt" "static-*.txt" times.txt empty-lm.txt
copy corpora-head-1ea8b02/st $c/st run.times "stat-*.txt" "verify-*.txt" "build-*.txt" "count-*.txt" static.txt functions.txt
d=$stage/head-cc3387f
for u in main_unit_backend main_unit_checker; do
    [ -d placements-head-cc3387f-$u ] && copy placements-head-cc3387f-$u $d/placements-$u "*.log"
done
[ -d select-compare ] && copy select-compare $d/select-compare "*.txt"
if [ -d cost-profile-head-cc3387f ]; then
    copy cost-profile-head-cc3387f $d/cost-profile "stat-*.txt"
    for f in cost-profile-head-cc3387f/symbols-*.txt; do head -100 $f > $d/cost-profile/$(basename $f); done
fi
./receipts.sh main-6490b102 head-e0ae799c head-1ea8b02 main-051de9c head-cc3387f exp-verify-1ea8b02 exp-select-051de9c > $stage/receipts.txt 2>&1
tcc -v >> $stage/receipts.txt 2>&1
sha256sum ~/buster-fast-bench/codex-926-lua-174afc-20261030/payload/lua.tar.gz | sed 's|  .*/|  |' >> $stage/receipts.txt
echo "c-testsuite $(git -C $CTS rev-parse HEAD)" >> $stage/receipts.txt
du -sh $stage
