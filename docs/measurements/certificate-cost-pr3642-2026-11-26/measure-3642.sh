set -euo pipefail
mkdir -p evidence-3642
evid=evidence-3642
cat /proc/loadavg > "$evid/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evid/load-before.txt"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$corpus/sqlite/sqlite3.c" | sha256sum --check
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for side in base pr3642; do
    code=0
    taskset -c 2 "$side/build/compiler" benchmark-tier1-code-certificate "${source[@]}" > "$evid/$side-sqlite.txt" 2>&1 || code=$?
    printf '%s\n' "$code" > "$evid/$side-sqlite.status"
    cat "$evid/$side-sqlite.txt"
done
if [[ $(cat "$evid/base-sqlite.status") == 0 && $(cat "$evid/pr3642-sqlite.status") == 0 ]]; then
    for side in base pr3642; do
        taskset -c 2 perf record -e cycles:u -F 999 -o "$evid/$side-decode.perf" -- "$side/build/compiler" benchmark-tier1-code-certificate --only decode "${source[@]}" > "$evid/$side-decode.txt" 2>&1
        perf report --stdio -i "$evid/$side-decode.perf" > "$evid/$side-decode-profile.txt"
    done
fi
cat /proc/loadavg > "$evid/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$evid/load-after.txt"
