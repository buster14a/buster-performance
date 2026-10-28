set -e
i='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-inputs'
o='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-qualification'
s='/home/david/buster-fast-bench/codex-421-prototype-isa-only-current'
mkdir "$i" "$o"
tar -xf - -C "$i"
printf '%s  %s
' '0b5dc5bbbed1e818b25d4f82974eda884213127a0a4b601f7a409e3d6ab4caf9' "$i/source-full.tar" '5e15a8b5886718939399c356d51f91199c50cabf6de243b6ecadd3a2b639dc91' "$i/raw/prototype-isa-only-current-source-files.sha256" '3ee3b4d3a74ed9028cb7431f2a4e3b7c11ac716adacd9efc11d89e8b5298bbb1' "$i/current-tests.list" '0c10e1bf43cd14d491bce9ec9e92b8fe15db802d96c5d6adf13449c3706cd00c' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump.c' | sha256sum -c - > "$o/input-identities.log"
printf '%s  %s
' 939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae /usr/bin/clang 8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51 /usr/bin/wild | sha256sum -c - > "$o/tool-identities.log"
mkdir "$s"
tar -xf "$i/source-full.tar" -C "$s"
cd "$s"
sha256sum -c "$i/raw/prototype-isa-only-current-source-files.sha256" > "$o/source-identities.log"
env -u CPATH -u C_INCLUDE_PATH BUSTER_DEBUG_INFO=0 LC_ALL=C ./build.sh shifts '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements' main_unit_checker.c 0 336 672 1008 1344 1680 2016 2352 2688 3024 3360 3696 > "$o/build.log" 2>&1
taskset -c 2 ./build/compiler parallel --jobs 1 --timeout 120 "$i/current-tests.list" > "$o/matrix.log" 2>&1
./build.sh check-call-graph > "$o/graph.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I src --ld-path=/usr/bin/wild '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump.c' -o '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump-prototype-isa-only-current' > "$o/dump-build.log" 2>&1
taskset -c 2 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump-prototype-isa-only-current' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-only-current.bin' > "$o/dump.log"
test "$(wc -c < '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-only-current.bin')" -eq 16035840
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-hybrid.bin' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-only-current.bin'
printf 'dump=0
exact_length=16035840
cmp=0
' >> "$o/dump.log"
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-only-current.bin' >> "$o/dump.log"
sha256sum build/compiler > "$o/binary-identity.sha256"
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-only-current-checker-placements'/compiler-* > "$o/placement-identities.sha256"
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
