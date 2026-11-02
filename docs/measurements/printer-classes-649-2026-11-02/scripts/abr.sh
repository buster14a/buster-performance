#!/bin/bash
# usage: abr.sh OUT ROUNDS TREE...  (on benchpress): rounds of benchmark-preprocessor --only vectorized runs, each
# round one lock hold (every config and tree once, the trees' order reversed every other round). Output as ab649.sh.
out=~/buster-fast-bench/649-claude/out/"$1"; rounds="$2"; shift 2
mkdir -p "$out"
cat > "$out/round.sh" <<'ROUND'
#!/bin/bash
# round.sh OUT ROUND TREE...: one round, run inside the lock.
out="$1"; round="$2"; shift 2
unset CPATH C_INCLUDE_PATH
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
src=~/buster-fast-bench/649-claude/base/src
main_args="-target x86_64-pc-linux-gnu -march=native -I$src -fwrapv -funsigned-char $src/buster/compiler/main.c"
sqlite_args="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
for config in mainP mainE sqliteP sqliteE; do
    case $config in main*) args=$main_args ;; *) args=$sqlite_args ;; esac
    markers=""; [[ $config == *E ]] && markers="--markers"
    for tree in "$@"; do
        cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
        taskset -c 2 ./build/compiler benchmark-preprocessor --only vectorized $markers $args > "$out/$config.$tree.$round.txt" 2>&1
    done
done
ROUND
chmod +x "$out/round.sh"
trees=("$@")
for round in $(seq 1 "$rounds"); do
    order=("${trees[@]}")
    if (( round % 2 == 0 )); then order=(); for (( i=${#trees[@]}-1; i>=0; i-- )); do order+=("${trees[i]}"); done; fi
    EXCLUSIVE_OWNER=claude-649 EXCLUSIVE_TITLE="solve 649 A/B round" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/649" \
        ~/buster-fast-bench/exclusive.sh "$out/round.sh" "$out" "$round" "${order[@]}" > "$out/lock.$round.txt" 2>&1
done
echo done > "$out/done"
