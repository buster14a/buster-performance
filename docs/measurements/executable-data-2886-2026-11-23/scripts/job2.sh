#!/bin/bash
# job2.sh: the seal's control again (unsealed.compiler executable this time): head against the same file with the
# sealed segment's write flag put back, musl and sqlite; then main against head for the small commands.
set -u
cd "$(dirname "$0")"
chmod +x unsealed.compiler
rm -rf ab-seal-musl-1 ab-seal-sqlite-1
./lock.sh ./ab.sh ab-seal-musl-2 musl 7 unsealed=unsealed.compiler head=head/build/compiler
./lock.sh ./ab.sh ab-seal-sqlite-2 sqlite 21 unsealed=unsealed.compiler head=head/build/compiler
./lock.sh ./ab.sh ab-hello-1 hello 11 main=main/build/compiler head=head/build/compiler
./lock.sh ./ab.sh ab-tiny-1 tiny 11 main=main/build/compiler head=head/build/compiler
./lock.sh ./ab.sh ab-syntax-1 syntax 11 main=main/build/compiler head=head/build/compiler
./lock.sh ./ab.sh ab-command-1 command 5 main=main/build/compiler head=head/build/compiler
./lock.sh ./ab.sh ab-musl-2 musl 7 main=main/build/compiler head=head/build/compiler
echo done > job2.done
