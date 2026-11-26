set -euo pipefail
out="$(realpath -m evidence-3633-compile)"
base=$(realpath base/build/compiler)
cd pr3633
clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$out/predefines.h"
flags=(--tier1 --tier1-passes=+vectorize,+unroll -c --lanes 1 -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing --predefines "$out/predefines.h" src/buster/compiler/main.c)
taskset -c 2 "$base" "${flags[@]}" -o "$out/main-base.o"
taskset -c 2 ./build/compiler "${flags[@]}" -o "$out/main-head.o"
size "$out/main-base.o" "$out/main-head.o" > "$out/main-size.txt"
taskset -c 2 ./build/compiler measure-compile --runs 11 --reference "$base" -- "${flags[@]}" | tee "$out/main.txt"
cat /proc/loadavg > "$out/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-after.txt"
