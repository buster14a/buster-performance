set -euo pipefail
out="$(realpath -m evidence-3622-runtime)"
mkdir -p "$out/work"
cat /proc/loadavg > "$out/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-before.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
cd pr3622
taskset -c 2 ./build/compiler measure-tier1-programs --clang clang --sqlite "$sqlite" --speedtest "$PROGRAM_INPUTS" --lua "$PROGRAM_INPUTS/lua-5.4.8/src" --scripts "$PROGRAM_INPUTS/scripts/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua" --runs 9 --compiles 1 --directory "$out/work" --keep --variant --tier1-passes=+vectors --variant --tier1-passes=+memory | tee "$out/results.txt"
find "$out/work" -type f -executable \( -name 'speedtest*' -o -name 'lua*' \) -print0 | sort -z | xargs -0 -r sha256sum > "$out/programs.sha256"
cat /proc/loadavg > "$out/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-after.txt"
