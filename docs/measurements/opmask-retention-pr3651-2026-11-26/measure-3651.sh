set -euo pipefail
out="$(realpath -m evidence-3651)"
mkdir -p "$out/work"
cat /proc/loadavg > "$out/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-before.txt"
base=$(realpath base/build/compiler)
(cd pr3651 && taskset -c 2 ./build/compiler measure-tier1-rows --runs 11 --clang clang --base "$base" --march znver5 --lexer src/buster/compiler/c_lexer.c --directory "$out/work") | tee "$out/results.txt"
cat /proc/loadavg > "$out/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-after.txt"
