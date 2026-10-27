set -e
i='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/refresh2-head-inputs'
o='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/refresh2-head-qualification'
s='/home/david/buster-fast-bench/codex-421-refresh-head-4471'
mkdir "$i" "$o"
tar -xf - -C "$i"
printf '%s  %s
' '44d00948f59f955c9857b1c3f61b1a56d14ce6fe58c0bd0fd94c2fe02fae653f' "$i/source-full.tar" '406403f196ca3c5b74e4d7e01d27f8099ad4783bb50168e46dd18fe33d977995' "$i/raw/refresh2-head-source-files.sha256" '3ee3b4d3a74ed9028cb7431f2a4e3b7c11ac716adacd9efc11d89e8b5298bbb1' "$i/current-tests.list" '0c10e1bf43cd14d491bce9ec9e92b8fe15db802d96c5d6adf13449c3706cd00c' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump.c' | sha256sum -c - > "$o/input-identities.log"
printf '%s  %s
' 939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae /usr/bin/clang 8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51 /usr/bin/wild | sha256sum -c - > "$o/tool-identities.log"
mkdir "$s"
tar -xf "$i/source-full.tar" -C "$s"
cd "$s"
sha256sum -c "$i/raw/refresh2-head-source-files.sha256" > "$o/source-identities.log"
env -u CPATH -u C_INCLUDE_PATH BUSTER_DEBUG_INFO=0 LC_ALL=C ./build.sh shifts '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/refresh-head-checker-placements' main_unit_checker.c 0 336 672 1008 1344 1680 2016 2352 2688 3024 3360 3696 > "$o/build.log" 2>&1
taskset -c 2 ./build/compiler parallel --jobs 1 --timeout 120 "$i/current-tests.list" > "$o/matrix.log" 2>&1
./build.sh check-call-graph > "$o/graph.log" 2>&1
clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I src '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump.c' -o '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump-refresh2-head' > "$o/dump-build.log" 2>&1
taskset -c 2 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump-refresh2-head' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-refresh2-head.bin' > "$o/dump.log"
test "$(wc -c < '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-refresh2-head.bin')" -eq 16035840
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-hybrid.bin' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-refresh2-head.bin'
printf 'dump=0
exact_length=16035840
cmp=0
' >> "$o/dump.log"
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-refresh2-head.bin' >> "$o/dump.log"
sha256sum build/compiler > "$o/binary-identity.sha256"
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/refresh-head-checker-placements'/compiler-* > "$o/placement-identities.sha256"
size -A build/compiler > "$o/sizes.log"
stat -c '%n %s' build/compiler >> "$o/sizes.log"
readelf -Ws build/compiler > "$o/symbols.txt"
cp build/compile_commands.json "$o/compile-commands.json"
printf 'matrix=0
graph=0
dump=0
exit=0
' > "$o/steps.txt"
tar -cf - -C "$o" .
