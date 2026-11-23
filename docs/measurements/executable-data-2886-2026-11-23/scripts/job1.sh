#!/bin/bash
# job1.sh: faults by section of main's and the head's executables (residual.sh), then the A/Bs, each under its own
# hold of the lock: main against head (sqlite, musl), and head against its unsealed copy (the same file but for the
# sealed segment's write flag; unseal.py).
set -u
cd "$(dirname "$0")"
python3 unseal.py head/build/compiler unsealed.compiler > unseal.txt
./lock.sh ./residual.sh main res-main
./lock.sh ./residual.sh head res-head
./lock.sh ./ab.sh ab-sqlite-1 sqlite 21 main=main/build/compiler head=head/build/compiler
./lock.sh ./ab.sh ab-musl-1 musl 7 main=main/build/compiler head=head/build/compiler
./lock.sh ./ab.sh ab-seal-musl-1 musl 7 unsealed=unsealed.compiler head=head/build/compiler
./lock.sh ./ab.sh ab-seal-sqlite-1 sqlite 21 unsealed=unsealed.compiler head=head/build/compiler
./lock.sh ./ab.sh ab-same-musl-1 musl 7 head=head/build/compiler again=head/build/compiler
echo done > job1.done
