#!/usr/bin/env bash
# profile.sh HEAD: perf profile of benchmark-tier1-cfg-source --only cfg on the frozen sqlite3.c, with a -g build of
# HEAD's tree in HEAD-g. Build and record each one hold of the shared lock; reports after, outside it.
set -u
cd ~/buster-fast-bench/claude-140-cfg
head=$1
tree=$head-g
logs=logs-profile-$head
mkdir -p "$logs"
rm -rf "$tree" && mkdir -p "$tree" && (cd "$head" && git ls-files > /dev/null 2>&1; true)
(cd "$head" && tar cf - --exclude=./build .) | (cd "$tree" && tar xf -)
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 CFG allocation #140: profile"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
lock=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
"$lock" bash -c "cd $tree && ./build.sh > ../$logs/build.log 2>&1; echo \"exit \$?\" >> ../$logs/build.log"
"$lock" bash -c "cd $tree && unset CPATH C_INCLUDE_PATH && export SOURCE_DATE_EPOCH=1792454400 && taskset -c 2 perf record -e cycles:u -c 200003 -o ../$logs/perf.data ./build/compiler benchmark-tier1-cfg-source --only cfg $(printf '%q ' "${sqlite[@]}") > ../$logs/record.log 2>&1; echo \"exit \$?\" >> ../$logs/record.log"
perf report -i "$logs/perf.data" --stdio --sort symbol --percent-limit 0.3 > "$logs/symbols.txt" 2>&1
perf report -i "$logs/perf.data" --stdio --sort srcline --symbols=tier1_cfg_allocate_impl --percent-limit 0.3 > "$logs/cfg-lines.txt" 2>&1
echo done > "$logs/done"
