#!/bin/bash
# job-bytes.sh: how a file past the read limit (16 KB) gets its bytes: the pull request's tree (files-head.patch on main
# 05c5d95d7) with files-bytes.patch, which takes it from the environment (BUSTER_BYTES: 0 as the code has it, mapped
# with MAP_POPULATE on one lane; 1 mapped without it, its pages faulted in as the lexer reads them; 2 every file read
# into the lane's arena). ONE executable, one copy of it on both sides of every comparison (ab.sh's SAME, A_ENV, B_ENV):
# sqlite3.c (21 rounds), hello.c (41 rounds) and musl's units, a process each (11 rounds), 0 against 1, 2 and 0 again.
cd "$(dirname "$0")"
main=$(cat head-base.txt)
: > job-bytes.done
log=bytes.log
: > "$log"
./build-tree.sh bytes "$main" files-head.patch files-bytes.patch > build-bytes.out 2>&1
tail -2 build-bytes.out >> "$log"
for spec in sqlite:21:1 sqlite:21:0 sqlite:21:2 hello:41:1 hello:41:0 hello:41:2 musl:11:1 musl:11:0 sqlite:21:1:again hello:41:1:again; do
    IFS=: read -r kind rounds bytes again <<< "$spec"
    label=$kind-0-$bytes${again:+-$again}
    start=$(date +%s)
    SAME=1 A_ENV=BUSTER_BYTES=0 B_ENV=BUSTER_BYTES=$bytes ./lock.sh timeout -k 10 900 ./ab.sh "results/abb-$label" "$kind" "$rounds" "populated=$PWD/bytes/build/compiler" "bytes$bytes=$PWD/bytes/build/compiler" > "results/abb-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abb-$label" populated "bytes$bytes" > "results/abstatb-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-bytes.done
