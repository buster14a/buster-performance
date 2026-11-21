#!/bin/bash
# corpus-mutant.sh INDEX...: each fault alone in the mutation tree, a Develop build, and the shadow with the rows on the
# four inputs: whether a fault the fixture does not see is seen by a corpus. The two files restored after.
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
tree=/home/user/mut-sides
out=$S/sides/faults/corpus
mkdir -p $out
cd $tree || exit 1
. /home/user/keep/corpora.sh
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $out/predefines.h
main_arguments="-march=native -Isrc -fwrapv -funsigned-char --predefines $out/predefines.h src/buster/compiler/main.c"
for n in "$@"; do
    git checkout -q -- src
    name=$(python3 /home/user/keep/sides/faults/faults-sides.py $tree $n) || { echo "not-applied $n"; continue; }
    ./build.sh > $out/build.log 2>&1 || { echo "not-built $n $name"; continue; }
    line="$n $name:"
    for unit in sqlite lua musl main; do
        case $unit in sqlite) a=$sqlite_arguments ;; lua) a=$lua_arguments ;; musl) a=$musl_arguments ;; main) a=$main_arguments ;; esac
        bash -c "build/compiler measure-node-machine --shadow --passes 0 --window-rows $a" > $out/$n-$unit.txt 2> $out/$n-$unit.err
        line="$line $unit status $? ($(grep -o 'reference-differences=[0-9]* fact-differences=[0-9]*' $out/$n-$unit.txt | tr -d 'a-z=-' ))"
    done
    echo "$line"
done
git checkout -q -- src
