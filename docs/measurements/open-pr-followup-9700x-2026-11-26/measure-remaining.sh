set -euo pipefail
number=$1 side=$2 baseline=$3
root="$PWD"
out="$root/followup-9700x/$number"
head_compiler="$root/$side/build/compiler"
base_compiler="$root/$baseline/build/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check > "$out/identity.txt"
printf 'base=%s\nhead=%s\n' "$(git -C "$baseline" rev-parse HEAD)" "$(git -C "$side" rev-parse HEAD)" >> "$out/identity.txt"
sha256sum "$base_compiler" "$head_compiler" >> "$out/identity.txt"
clang --version >> "$out/identity.txt"
cat /proc/loadavg > "$out/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-before.txt"
export BUSTER_TIER1_EXPERIMENT=0
cd "$side"
inputs=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
for mode in default full; do
    options=()
    if [[ "$mode" == full ]]; then options=(--no-direct); fi
    if [[ "$mode" == full && "$number" =~ ^(3658|3656|3630|3639)$ ]]; then options=(--tier1 -O2 -march=znver5); fi
    taskset -c 2 "$head_compiler" measure-compile --runs 31 --reference "$base_compiler" -- -c "${options[@]}" "${inputs[@]}" > "$out/$mode.txt" 2>&1
    for role in base head; do
        compiler=$base_compiler
        if [[ "$role" == head ]]; then compiler=$head_compiler; fi
        taskset -c 2 "$compiler" -c "${options[@]}" "${inputs[@]}" -o "$out/$mode-$role.o"
    done
    sha256sum "$out/$mode-base.o" "$out/$mode-head.o" >> "$out/objects.txt"
    if cmp -s "$out/$mode-base.o" "$out/$mode-head.o"; then echo "$mode object bytes match" >> "$out/objects.txt"; fi
    size "$out/$mode-base.o" "$out/$mode-head.o" >> "$out/objects.txt"
done
cat /proc/loadavg > "$out/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-after.txt"
