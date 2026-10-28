set -e
i='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-compact-template-inputs'
o='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-compact-template-qualification'
s='/home/david/buster-fast-bench/codex-421-prototype-isa-policy-compact-template'
mkdir "$i" "$o"
tar -xf - -C "$i"
printf '%s  %s
' '780ea1a720c683890046077418c82ed737294e414814bfe8ea1ae51646fb1fd9' "$i/source-full.tar" '91fb89ba6d727aca28688c5dfcbe0a14f1e5a83fd6933d4866759bf6a3ee2f6c' "$i/raw/prototype-isa-policy-compact-template-source-files.sha256" 'dd603c64b6308df000d9e7bb66ff85283a0841d2bd1e181ee54b80b1e570416f' "$i/current-tests-split.list" 'd01c3a09408926a278299285c2ae736c3ab899538ed9d55d1d1ab72a78d15d9b' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-semantic-dump.c' | sha256sum -c - > "$o/input-identities.log"
printf '%s  %s
' 939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae /usr/bin/clang 8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51 /usr/bin/wild | sha256sum -c - > "$o/tool-identities.log"
mkdir "$s"
tar -xf "$i/source-full.tar" -C "$s"
cd "$s"
sha256sum -c "$i/raw/prototype-isa-policy-compact-template-source-files.sha256" > "$o/source-identities.log"
env -u CPATH -u C_INCLUDE_PATH BUSTER_DEBUG_INFO=0 LC_ALL=C ./build.sh shifts '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-compact-template-checker-placements' main_unit_checker.c 0 336 672 1008 1344 1680 2016 2352 2688 3024 3360 3696 > "$o/build.log" 2>&1
taskset -c 2 ./build/compiler parallel --jobs 1 --timeout 120 "$i/current-tests-split.list" > "$o/matrix.log" 2>&1
./build.sh check-call-graph > "$o/graph.log" 2>&1
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I src --ld-path=/usr/bin/wild '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-semantic-dump.c' -o '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump-prototype-isa-policy-compact-template' > "$o/dump-build.log" 2>&1
taskset -c 2 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump-prototype-isa-policy-compact-template' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-policy-compact-template.bin' > "$o/dump.log"
test "$(wc -c < '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-policy-compact-template.bin')" -eq 16035840
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-hybrid.bin' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-policy-compact-template.bin'
printf 'dump=0
exact_length=16035840
cmp=0
' >> "$o/dump.log"
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-prototype-isa-policy-compact-template.bin' >> "$o/dump.log"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I '/home/david/buster-fast-bench/codex-421-prototype-base-current92/src' --ld-path=/usr/bin/wild '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-semantic-dump.c' -o '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-semantic-base-isa-policy-compact-template' > "$o/baseline-semantic-build.log" 2>&1
taskset -c 2 '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-semantic-base-isa-policy-compact-template' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-semantic-base-isa-policy-compact-template.bin' > "$o/baseline-semantic.log"
cmp '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-hybrid.bin' '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-semantic-base-isa-policy-compact-template.bin'
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-semantic-base-isa-policy-compact-template.bin' >> "$o/baseline-semantic.log"
sha256sum build/compiler > "$o/binary-identity.sha256"
sha256sum '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-isa-policy-compact-template-checker-placements'/compiler-* > "$o/placement-identities.sha256"
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
