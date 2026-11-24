#!/usr/bin/env bash
# #3070 step 2: where musl's and Lua's commands spend, by symbol. usage: profile-musl.sh BINARY OUT   (takes the lock itself)
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
C=$1; out=$2
mkdir -p "$out"
cat > "$out/inner.sh" <<'INNER'
#!/usr/bin/env bash
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
C=$1; out=$2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
declare -A seen
units=()
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; units+=("$f"); fi; done
lua=("$D"/lua/src/*.c)
luaopts=(-std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
export LC_ALL=C
work=/dev/shm/3070-claude-euler-profm
rm -rf "$work"; mkdir -p "$work"
cd "$work"
{ uname -r; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$out/host-before.txt"
taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "${units[@]}" > /dev/null 2>&1
perf stat -x, -e cycles:u,cycles:k,instructions:u,instructions:k,page-faults,task-clock -o "$out/musl-stat.csv" -- taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "${units[@]}" > /dev/null 2>&1
perf record -q -F 10000 -g -o "$out/musl.data" -- taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "${units[@]}" > /dev/null 2>&1
perf report -i "$out/musl.data" --no-children --sort symbol --stdio -g none 2> /dev/null | grep -E '^ +[0-9.]+%' | head -400 > "$out/musl-flat.txt"
perf report -i "$out/musl.data" --children --sort symbol --stdio -g none 2> /dev/null | grep -E '^ +[0-9.]+%' | head -400 > "$out/musl-children.txt"
perf record -q -F 20000 -g -o "$out/lua.data" -- taskset -c 2 "$C" -c --lanes 1 "${luaopts[@]}" "${lua[@]}" > /dev/null 2>&1
perf report -i "$out/lua.data" --no-children --sort symbol --stdio -g none 2> /dev/null | grep -E '^ +[0-9.]+%' | head -300 > "$out/lua-flat.txt"
perf report -i "$out/lua.data" --children --sort symbol --stdio -g none 2> /dev/null | grep -E '^ +[0-9.]+%' | head -300 > "$out/lua-children.txt"
rm -f "$out/musl.data" "$out/lua.data"
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$out/host-after.txt"
INNER
chmod +x "$out/inner.sh"
export EXCLUSIVE_OWNER=claude-3070-euler EXCLUSIVE_TITLE="#3070 step 2: where the headers' work goes" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3070
~/buster-fast-bench/exclusive.sh timeout -k 5 600 "$out/inner.sh" "$C" "$out" 2> "$out/exclusive.txt"
echo "profile exit $?" > "$out/done.txt"
