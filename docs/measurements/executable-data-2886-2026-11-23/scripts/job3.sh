#!/bin/bash
# job3.sh: job2 again after the host's disk filled: the seal's control (head against the same file with the sealed
# segment's write flag put back) and the small commands, from the kept executables.
set -u
cd "$(dirname "$0")"
m=keep/main.compiler
h=keep/head.compiler
./lock.sh ./ab.sh ab-seal-musl-3 musl 7 unsealed=unsealed.compiler head=$h
./lock.sh ./ab.sh ab-seal-sqlite-3 sqlite 21 unsealed=unsealed.compiler head=$h
./lock.sh ./ab.sh ab-tiny-1 tiny 11 main=$m head=$h
./lock.sh ./ab.sh ab-syntax-1 syntax 11 main=$m head=$h
./lock.sh ./ab.sh ab-musl-2 musl 7 main=$m head=$h
echo done > job3.done
