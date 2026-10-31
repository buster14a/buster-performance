#!/usr/bin/env bash
# queue-cfg.sh HEAD: benchmark-tier1-cfg-source and benchmark-backend-source on the frozen sqlite3.c with HEAD's build
# (already built), three processes each and one CFG run after 200 ms of scalar work, each one hold of the shared lock.
set -u
cd ~/buster-fast-bench/claude-140-cfg
head=$1
logs=logs-cfg-$head
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 CFG allocation #140: SQLite measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
lock=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for round in 1 2 3; do
    "$lock" bash -c "cd $head && unset CPATH C_INCLUDE_PATH && export SOURCE_DATE_EPOCH=1792454400 && taskset -c 2 ./build/compiler benchmark-tier1-cfg-source $(printf '%q ' "${sqlite[@]}") > ../$logs/cfg-source-$round.log 2>&1; echo \"exit \$?\" >> ../$logs/cfg-source-$round.log; taskset -c 2 ./build/compiler benchmark-backend-source $(printf '%q ' "${sqlite[@]}") > ../$logs/backend-source-$round.log 2>&1; echo \"exit \$?\" >> ../$logs/backend-source-$round.log"
done
"$lock" bash -c "cd $head && unset CPATH C_INCLUDE_PATH && export SOURCE_DATE_EPOCH=1792454400 && taskset -c 2 ./build/compiler benchmark-tier1-cfg-source --after-scalar 200 $(printf '%q ' "${sqlite[@]}") > ../$logs/cfg-source-after-scalar.log 2>&1; echo \"exit \$?\" >> ../$logs/cfg-source-after-scalar.log"
echo done > "$logs/done"
