set -euo pipefail
out="$(realpath -m evidence-3643-qualification)"
cd pr3643
taskset -c 2 ./build/compiler test-tier1-select > "$out/test-tier1-select.txt" 2>&1
taskset -c 2 ./build/compiler test-x86-zen5 > "$out/test-x86-zen5.txt" 2>&1
