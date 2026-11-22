set -eu
cd "$(dirname "$0")"
clang=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
./compiler --lanes 1 -nostdinc -c "$PWD/tabled.c" -o jump.ref.o 2>jump.ref.stderr
BUSTER_CONTROL_SOURCE_ONLY=1 BUSTER_CONTROL_SOURCE_AUDIT=1 BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_SOURCE_COVERAGE=1 ./compiler --lanes 1 -nostdinc -c "$PWD/tabled.c" -o jump.source.o 2>jump.source.stderr
cmp jump.ref.o jump.source.o
"$clang" -O0 -c tabled.c -o jump.clang.o
for arm in ref source clang; do "$clang" run.c jump.$arm.o -o jump.$arm; ./jump.$arm > jump.$arm.result; cmp jump.$arm.result jump.ref.result; done
sha256sum jump.{ref,source}.o
