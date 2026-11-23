#!/bin/bash
# pair-env2.sh TREE WORKLOAD ROUNDS VARIABLE OFF ON: one executable with VARIABLE=OFF and VARIABLE=ON, BUSTER_EXPERIMENT_FRESH_LIST the zero sites in both,
# as pair2.sh pairs two builds (ABBA or BAAB a round; each position a hold of the lock: a warm-up, a wall-clock run and
# a counters run; objects and diagnostics hashed). Workloads: musl, lua, mixed (sqlite3.c, shell.c and two of Lua's).
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
tree=$1; workload=$2; rounds=$3; variable=$4; off=$5; on=$6
export BUSTER_EXPERIMENT_FRESH_LIST="$HOME/buster-fast-bench/2850-claude-01Egbx/zero26.list"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$dir/inputs/lua-5.4.8/src
export LC_ALL=C
case $workload in
    lua) args=("$lua"/*.c);;
    sqlite) args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c");;
    twice) args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" "$dir/inputs/sqlite3b.c");;
    mixed) args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" "$sqlite/shell.c" "$lua/lapi.c" "$lua/lvm.c");;
    musl)
        files=()
        declare -A seen
        for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
            b=${f##*/}
            if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
        done
        args=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}");;
    *) echo "unknown workload $workload" >&2; exit 2;;
esac
out="$dir/results/pairenv2-$workload-$tree-$variable-$off-$on"
rm -rf "$out"; mkdir -p "$out/scratch"
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: paired $workload, $tree with $variable $off and $on" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
cat > "$out/one.sh" <<'ONE'
#!/bin/bash
set -uo pipefail
cc=$1; key=$2; setting=$3; shift 4
out=$(dirname "$0")
cd "$out/scratch"
manifest() { find . -maxdepth 1 -name '*.o' -print0 | sort -z | xargs -0 -r sha256sum | sha256sum | cut -d' ' -f1; }
cat /proc/loadavg > "$out/$key.load"
rm -f ./*.o
env "$setting" taskset -c 2 "$cc" --lanes 1 -c "$@" > /dev/null 2> "$out/$key.warm.stderr"
rm -f ./*.o
env "$setting" taskset -c 2 python3 "$out/../../wallrun.py" "$out/$key" -- "$cc" --lanes 1 -c "$@"
manifest > "$out/$key.sha"
find . -maxdepth 1 -name '*.o' | wc -l > "$out/$key.objects"
rm -f ./*.o
env "$setting" taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults -o "$out/$key.perf" -- "$cc" --lanes 1 -c "$@" > /dev/null 2>&1
manifest >> "$out/$key.sha"
cat "$out/$key.stdout" "$out/$key.stderr" | sha256sum | cut -d' ' -f1 > "$out/$key.diag"
rm -f ./*.o
ONE
chmod +x "$out/one.sh"
one()
{
    local arm=$1 key=$2 setting
    if [[ $arm = parent ]]; then setting="$variable=$off"; else setting="$variable=$on"; fi
    "$HOME/buster-fast-bench/exclusive.sh" "$out/one.sh" "$dir/trees/$tree/build/compiler" "$key" "$setting" -- "${args[@]}" 2>> "$out/lock.log"
}
for i in $(seq 1 "$rounds"); do
    if (( i % 2 )); then order="parent candidate candidate parent"; else order="candidate parent parent candidate"; fi
    pos=0
    for arm in $order; do
        one "$arm" "r$i.p$pos.$arm"
        pos=$((pos + 1))
    done
done
rm -rf "$out/scratch"
echo 0 > "$out/tokens"
echo done > "$out/complete"
python3 "$dir/reduce2.py" "$out" > "$out/summary.txt" 2>&1 || true
