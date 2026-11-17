#!/bin/bash
# checker.sh OUT COMPILER: the whole test-checker (--seed 133), its eight parts: 1 to 4 side by side, then 5, 6 and 8, then
# 7 alone (its wide vectors' oracle is clang's own build, 54 s here beside nothing and past the harness's 60 s limit
# beside other work). A file a part in OUT, and a line each in OUT/status.txt.
set -u
out=$1; compiler=$2
cd "${TREE:-/home/user/buster}"
mkdir -p "$out"
: > "$out/status.txt"
part() {
    local start=$(date +%s)
    "$compiler" test-checker --seed 133 --part "$1/8" > "$out/part$1.out" 2> "$out/part$1.err"
    echo "part $1 status $? wall $(( $(date +%s) - start )) s; $(tail -1 "$out/part$1.out")" >> "$out/status.txt"
}
for p in 1 2 3 4; do part $p & done; wait
for p in 5 6 8; do part $p & done; wait
part 7
echo "all done" >> "$out/status.txt"
