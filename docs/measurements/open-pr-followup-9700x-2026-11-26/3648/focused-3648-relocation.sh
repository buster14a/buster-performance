set -euo pipefail
root="$PWD"
out="$root/followup-9700x/3648"
cd pr3648
source=tests/assembly-output/tls.c
taskset -c 2 ./build/compiler -g -S "$source" -o "$out/tls-debug.s"
taskset -c 2 ./build/compiler -g -c "$source" -o "$out/tls-debug-direct.o"
as --64 -o "$out/tls-debug-gnu.o" "$out/tls-debug.s"
for variant in direct gnu; do
    readelf -Wr -x .debug_info "$out/tls-debug-$variant.o" > "$out/tls-debug-$variant.readelf"
done
