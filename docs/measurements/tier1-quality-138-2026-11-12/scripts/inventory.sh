#!/bin/bash
# inventory.sh PART: evidence for what stands between Tier 1 and -O1 and above selecting it, by src/build/compiler
# (plain main). Run each PART inside one hold of the lock (lock.sh ./inventory.sh PART). results/inventory/PART*.
#   musl         --tier1 --tier1-report --tier1-refusals -c of each of the frozen musl's units (the 9700X job's options)
#   sqlite       the same of the frozen sqlite3.c and shell.c
#   self         the same of the compiler's own units at the build's native flags (the vector host)
#   debug        --tier1 -g -c sqlite3.c against --tier1 and against -g alone: status, time, peak RSS, sizes, .text
#   memory       the shapes of #1353 and #1384 by the default tier and --tier1: time, peak RSS, status
#   compile      measure-compile --runs 7 --variant --tier1 of -c sqlite3.c (the lever-candidates record's command)
#   determinism  --tier1 -c of sqlite3.c and of Lua's lvm.c by the vector and scalar host paths and by 1 and 8 lanes
#   verify       --tier1 --verify -c sqlite3.c: status, time, the certificates' counts
#   ctestsuite   test-c-testsuite --tier1 over the pinned c-testsuite's subset (AGENTS.md's smoke command)
set -u
cd "$(dirname "$0")"
part=${1:?a part}
root=$PWD
out=$root/results/inventory
work=$root/scratch/inventory/$part
rm -rf "$work"; mkdir -p "$out" "$work"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner > "$out/$part.holder.txt"
compiler=$root/src/build/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
sqlite_options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
test -x "$root/runrss" || cc -O2 -o "$root/runrss" "$root/tools/runrss.c"
# Sums the tab-separated key=value fields of --tier1-report's lines.
report()
{
    grep -h '^tier1	' "$@" | awk -F'\t' '{ for (i = 2; i <= NF; i++) { split($i, kv, "="); sum[kv[1]] += kv[2]; if (!(kv[1] in order)) { order[kv[1]] = ++n; name[n] = kv[1] } } }
        END { for (i = 1; i <= n; i++) printf "%s=%d\n", name[i], sum[name[i]] }'
}
status=0
case $part in
    musl)
        musl=$corpus/libc/musl
        options=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include"
                 -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
        : > "$out/musl-units.tsv"
        n=0
        for source in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
            n=$((n + 1))
            "$root/runrss" "$out/musl-units.tsv" "${source#$musl/}" taskset -c 2 "$compiler" --tier1 --tier1-report --tier1-refusals -c "${options[@]}" -o "$work/$n.o" "$source" > "$work/$n.log" 2>&1
        done
        cat "$work"/*.log | grep '^tier1-refused' > "$out/musl-refusals.txt"
        report "$work"/*.log > "$out/musl-report.txt"
        awk -F'\t' '$2 != 0' "$out/musl-units.tsv" > "$out/musl-failed-units.tsv"
        for f in $(awk -F'\t' '$2 != 0 { print NR }' "$out/musl-units.tsv" | head -40); do head -3 "$work/$f.log"; done > "$out/musl-failed-first-lines.txt" 2>&1
        ;;
    sqlite)
        for unit in sqlite3 shell; do
            "$root/runrss" "$out/sqlite-units.tsv" "$unit.c" taskset -c 2 "$compiler" --tier1 --tier1-report --tier1-refusals -c "${sqlite_options[@]}" -o "$work/$unit.o" "$sqlite/$unit.c" > "$work/$unit.log" 2>&1 || status=1
        done
        cat "$work"/*.log | grep '^tier1-refused' > "$out/sqlite-refusals.txt"
        report "$work"/*.log > "$out/sqlite-report.txt"
        ;;
    self)
        cd src
        mapfile -d '' sources < <(BUSTER_DEBUG_INFO=0 ./build.sh print-sources 2>/dev/null)
        mapfile -d '' flags < <(BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags 2>/dev/null)
        printf '%s\n' "${flags[@]}" > "$out/self-flags.txt"
        export work out compiler root
        printf '%s\0' "${sources[@]}" | xargs -0 -P 8 -I{} bash -c '"$root/runrss" "$out/self-units.tsv" "$1" "$compiler" --lanes 1 "${@:2}" --tier1 --tier1-report --tier1-refusals -c -o "$work/$(basename "$1" .c).o" "$1" > "$work/$(basename "$1" .c).log" 2>&1' _ {} "${flags[@]}"
        cd "$root"
        cat "$work"/*.log | grep '^tier1-refused' | sort -u > "$out/self-refusals.txt"
        report "$work"/*.log > "$out/self-report.txt"
        ;;
    debug)
        for variant in "tier1" "tier1-g" "tier0-g" "tier0"; do
            case $variant in tier1) extra=(--tier1) ;; tier1-g) extra=(--tier1 -g) ;; tier0-g) extra=(-g) ;; *) extra=() ;; esac
            for run in 1 2 3; do
                "$root/runrss" "$out/debug-runs.tsv" "$variant" taskset -c 2 "$compiler" "${extra[@]}" -c "${sqlite_options[@]}" -o "$work/$variant.o" "$sqlite/sqlite3.c" > "$work/$variant.log" 2>&1 || status=1
            done
            size -A "$work/$variant.o" | awk -v v="$variant" '$1 ~ /^\.(text|debug_info|debug_line|debug_loclists|debug_abbrev|eh_frame)$/ { print v, $1, $2 }' >> "$out/debug-sizes.txt"
            objcopy -O binary --only-section=.text "$work/$variant.o" /dev/stdout | sha256sum | sed "s/-/.text of $variant/" >> "$out/debug-sizes.txt"
            head -5 "$work/$variant.log" >> "$out/debug-messages.txt"
        done
        llvm-dwarfdump --verify "$work/tier1-g.o" > "$out/debug-dwarfdump-verify.txt" 2>&1; echo "dwarfdump status $?" >> "$out/debug-dwarfdump-verify.txt"
        ;;
    memory)
        python3 - "$work" <<'PY'
import sys
d = sys.argv[1]
def write(name, text):
    open(f'{d}/{name}.c', 'w').write(text)
for n in (1000, 2000, 4000):
    write(f'max-{n}', '#define MAX(a, b) ({ __typeof__(a) _a = (a); __typeof__(b) _b = (b); _a > _b ? _a : _b; })\nint f(const int *p) {\n  int s = 0;\n' + ''.join(f'  s += MAX(p[{i}], p[{i + 1}]);\n' for i in range(n)) + '  return s;\n}\n')
for n in (4000, 8000):
    write(f'loops-{n}', 'int f(int x) {\n  int s = 0;\n' + ''.join(f'  for (int i_{i} = 0; i_{i} < x; i_{i}++) s += i_{i};\n' for i in range(n)) + '  return s;\n}\n')
for n in (16000,):
    write(f'or-{n}', 'int f(const int *a) {\n  return ' + ' || '.join(f'a[{i}]' for i in range(n)) + ';\n}\n')
PY
        for source in "$work"/*.c; do
            name=$(basename "$source" .c)
            "$root/runrss" "$out/memory-runs.tsv" "$name default" taskset -c 2 "$compiler" -c -o "$work/$name-0.o" "$source" > "$work/$name-0.log" 2>&1
            "$root/runrss" "$out/memory-runs.tsv" "$name tier1" taskset -c 2 "$compiler" --tier1 --tier1-report -c -o "$work/$name-1.o" "$source" > "$work/$name-1.log" 2>&1
            "$root/runrss" "$out/memory-runs.tsv" "$name clang-O2" taskset -c 2 clang -O2 -c -o "$work/$name-c.o" "$source" > "$work/$name-c.log" 2>&1
            { echo "## $name --tier1"; head -4 "$work/$name-1.log"; } >> "$out/memory-messages.txt"
        done
        ;;
    compile)
        taskset -c 2 "$compiler" measure-compile --runs 7 --variant --tier1 -- -c "${sqlite_options[@]}" "$sqlite/sqlite3.c" > "$out/compile-measure-compile.txt" 2>&1 || status=1
        ;;
    determinism)
        lvm=$root/inputs/lua-5.4.8/src/lvm.c
        for variant in "vector" "scalar --scalar" "lanes1 --lanes 1" "lanes8 --lanes 8" "scalar-lanes1 --scalar --lanes 1"; do
            set -- $variant; name=$1; shift
            "$compiler" --tier1 -fno-asynchronous-unwind-tables "$@" -c "${sqlite_options[@]}" -o "$work/sqlite3-$name.o" "$sqlite/sqlite3.c" > "$work/sqlite3-$name.log" 2>&1 || status=1
            "$compiler" --tier1 -fno-asynchronous-unwind-tables "$@" -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o "$work/lvm-$name.o" "$lvm" > "$work/lvm-$name.log" 2>&1 || status=1
            "$compiler" "$@" -c "${sqlite_options[@]}" -o "$work/sqlite3-tier0-$name.o" "$sqlite/sqlite3.c" > "$work/sqlite3-tier0-$name.log" 2>&1 || status=1
        done
        (cd "$work" && sha256sum *.o && for o in *.o; do echo "$o .text $(size -A "$o" | awk '$1 == ".text" { print $2 }')"; done) > "$out/determinism.txt"
        ;;
    verify)
        for run in 1 2 3; do
            "$root/runrss" "$out/verify-runs.tsv" "tier1 --verify" taskset -c 2 "$compiler" --tier1 --verify --tier1-report -c "${sqlite_options[@]}" -o "$work/verify.o" "$sqlite/sqlite3.c" > "$work/verify.log" 2>&1 || status=1
            "$root/runrss" "$out/verify-runs.tsv" "tier1" taskset -c 2 "$compiler" --tier1 --tier1-report -c "${sqlite_options[@]}" -o "$work/plain.o" "$sqlite/sqlite3.c" > "$work/plain.log" 2>&1 || status=1
        done
        report "$work/verify.log" > "$out/verify-report.txt"
        cmp "$work/verify.o" "$work/plain.o" > "$out/verify-cmp.txt" 2>&1; echo "cmp status $?" >> "$out/verify-cmp.txt"
        ;;
    ctestsuite)
        cd src
        if [ ! -d build/c-testsuite/tests ]; then
            git init -q --template= build/c-testsuite
            git -C build/c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
            git -C build/c-testsuite checkout -q FETCH_HEAD
        fi
        ./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt build/c-testsuite > "$out/ctestsuite.txt" 2>&1 || status=1
        cd "$root"
        ;;
    *) echo "unknown part $part" >&2; status=1 ;;
esac
echo "status $status" > "$out/$part.status"
date -u +%FT%TZ > "$out/$part.done"
exit $status
