#!/bin/bash
# The side facts' census: the experiment build's shadow on the three corpora and the compiler's own source, one at a time.
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
out=$S/fcensus
. /home/user/keep/corpora.sh
cd /home/user/buster-values || exit 1
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $out/predefines.h
main_arguments="-march=native -Isrc -fwrapv -funsigned-char --predefines $out/predefines.h src/buster/compiler/main.c"
: > $out/progress.txt
for unit in sqlite lua musl main; do
    case $unit in sqlite) a=$sqlite_arguments ;; lua) a=$lua_arguments ;; musl) a=$musl_arguments ;; main) a=$main_arguments ;; esac
    BUSTER_CENSUS_F=1 bash -c "$out/compiler measure-node-machine --shadow --passes 0 --window-rows --list 20 $a" 2> $out/$unit.err | gzip > $out/$unit.txt.gz
    echo "$unit status ${PIPESTATUS[0]}" >> $out/progress.txt
done
echo "all done" >> $out/progress.txt
