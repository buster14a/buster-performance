set -e
i='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-unroll4-inputs'
o='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-unroll4-qualification'
s='/home/david/buster-fast-bench/codex-421-prototype-isa-policy-dense-unroll4'
mkdir "$i" "$o"
tar -xf - -C "$i"
printf '%s  %s
' '7a2a435b5621f5775120ca22c701001ac36671aea440fbdabbc2cea4200557c9' "$i/source-full.tar" '06e9939e60577430294425a3d368facd4d71c841e5c7b618aa62669a6452b05a' "$i/raw/prototype-isa-policy-dense-unroll4-source-files.sha256" 'dd603c64b6308df000d9e7bb66ff85283a0841d2bd1e181ee54b80b1e570416f' "$i/current-tests-split.list" '0c10e1bf43cd14d491bce9ec9e92b8fe15db802d96c5d6adf13449c3706cd00c' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump.c' | sha256sum -c - > "$o/input-identities.log"
printf '%s  %s
' 939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae /usr/bin/clang 8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51 /usr/bin/wild | sha256sum -c - > "$o/tool-identities.log"
mkdir "$s"
tar -xf "$i/source-full.tar" -C "$s"
cd "$s"
sha256sum -c "$i/raw/prototype-isa-policy-dense-unroll4-source-files.sha256" > "$o/source-identities.log"
env -u CPATH -u C_INCLUDE_PATH BUSTER_DEBUG_INFO=0 LC_ALL=C ./build.sh shifts '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-unroll4-checker-placements' main_unit_checker.c 0 336 672 1008 1344 1680 2016 2352 2688 3024 3360 3696 > "$o/build.log" 2>&1
taskset -c 2 ./build/compiler parallel --jobs 1 --timeout 120 "$i/current-tests-split.list" > "$o/matrix.log" 2>&1
./build.sh check-call-graph > "$o/graph.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I src --ld-path=/usr/bin/wild '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump.c' -o '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump-prototype-isa-policy-dense-unroll4' > "$o/dump-build.log" 2>&1
taskset -c 2 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump-prototype-isa-policy-dense-unroll4' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-policy-dense-unroll4.bin' > "$o/dump.log"
test "$(wc -c < '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-policy-dense-unroll4.bin')" -eq 16035840
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-hybrid.bin' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-policy-dense-unroll4.bin'
printf 'dump=0
exact_length=16035840
cmp=0
' >> "$o/dump.log"
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-policy-dense-unroll4.bin' >> "$o/dump.log"
sha256sum build/compiler > "$o/binary-identity.sha256"
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-dense-unroll4-checker-placements'/compiler-* > "$o/placement-identities.sha256"
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
