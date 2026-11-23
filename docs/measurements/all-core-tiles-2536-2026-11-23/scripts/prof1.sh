#!/bin/bash
# A profile by function of -c sqlite3.c at one worker (CPU 2) and at eight (CPUs 0-7), cycles in user mode and in the kernel.
# prof1.sh TREE OUT [extra compiler options...]
set -euo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
name=${1:?tree}
out=$dir/results/${2:?out}
shift 2
mkdir -p "$out"
cd "$dir/$name"
export EXCLUSIVE_OWNER=claude-2536-kcl1ed
export EXCLUSIVE_TITLE="#2536: the all-core path, a profile by function"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s\n' "$@" > "$out/options.txt"
cat > "$out/worker.sh" <<EOS
#!/bin/bash
cpu=\$1; loops=\$2; tag=\$3
for i in \$(seq \$loops); do
    taskset -c \$cpu $dir/$name/build/compiler --lanes 1 -c $* -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o $out/\$tag.w\$cpu.o || echo "FAILED \$cpu \$i" >> $out/failed.txt
done
EOS
cat > "$out/cohort.sh" <<EOS
#!/bin/bash
n=\$1; loops=\$2
if [ "\$n" = 1 ]; then cpus="2"; else cpus="0 1 2 3 4 5 6 7"; fi
for c in \$cpus; do $out/worker.sh \$c \$loops c\$n & done
wait
EOS
chmod +x "$out/worker.sh" "$out/cohort.sh"
~/buster-fast-bench/exclusive.sh perf record -q -o "$out/one.data" -e cycles:u,cycles:k -c 100003 -a -C 2 -- "$out/cohort.sh" 1 12 2> "$out/one.err"
~/buster-fast-bench/exclusive.sh perf record -q -o "$out/eight.data" -e cycles:u,cycles:k -c 100003 -a -C 0-7 -- "$out/cohort.sh" 8 6 2> "$out/eight.err"
for w in one eight; do
    perf script -i "$out/$w.data" -F event,sym 2>/dev/null | awk '{ e=$1; sub(/:$/, "", e); $1=""; s=$0; sub(/^ +/, "", s); c[e "\t" s] += 1 } END { for (k in c) print c[k] "\t" k }' | sort -rn > "$out/$w.sym.tsv"
done
ls -la "$out"
echo PROF-DONE
