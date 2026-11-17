#!/bin/bash
# corpus.sh DIR A B: trees A's and B's --tier1 -c objects of sqlite3.c (the frozen corpus), Lua 5.4.8's 34 sources and
# musl's 312 math, stdlib, printf, scanf and time sources (#2791's sets), all in one hold of the lock; then, outside it,
# each object's disassembly compared: the objects whose code differs, and for each set the counts of the instructions a
# floating == or !='s select changes (shape.txt).
set -u
t=~/buster-fast-bench/2922-claude
mkdir -p $t/$1
cd $t/$1
a=$2
b=$3
export EXCLUSIVE_OWNER=claude-2922 EXCLUSIVE_TITLE="#2922 Tier 1: a select of a floating == or != by two cmovs where its values don't recur" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2922
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$t/inputs/lua-5.4.8/src
sqlite_flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
lua_flags="-march=znver5 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
musl_flags="-march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
musl_files=$(cd $musl && ls src/math/*.c src/stdlib/*.c src/stdio/*printf*.c src/stdio/vfscanf.c src/time/*.c)
{
    sha256sum $sqlite/sqlite3.c $t/$a/build/compiler $t/$b/build/compiler
    (cd $lua && sha256sum *.c) | sha256sum | sed 's/-$/lua sources/'
    cat $t/$a/COMMIT $t/$b/COMMIT
    echo "musl files: $(echo $musl_files | wc -w)"
} > inputs.txt
{
    echo "set -u"
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    for n in $a $b; do
        echo "mkdir -p $n/lua $n/musl"
        echo "$t/$n/build/compiler --tier1 -c $sqlite_flags $sqlite/sqlite3.c -o $n/sqlite3.o || echo '$n sqlite3 failed'"
        for f in $(cd $lua && ls *.c); do
            echo "$t/$n/build/compiler --tier1 -c $lua_flags $lua/$f -o $n/lua/${f%.c}.o || echo '$n $f failed'"
        done
        for f in $musl_files; do
            o=$(echo ${f%.c} | tr / _)
            echo "$t/$n/build/compiler --tier1 -c $musl_flags $musl/$f -o $n/musl/$o.o || echo '$n $f failed'"
        done
    done
} > objects.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash objects.sh > objects.log 2>&1
words="cmovne cmove cmovp cmovnp sete setne setnp setp test ucomisd ucomiss"
count() { objdump -d --no-show-raw-insn "$1" | awk -v w="$words" '/^ +[0-9a-f]+:/ { n++; c[$2]++ } END { printf "records=%d", n; split(w, k, " "); for (i = 1; i in k; i++) printf " %s=%d", k[i], c[k[i]]; printf "\n" }'; }
: > shape.txt
for set in sqlite3 lua musl; do
    files=$([ $set = sqlite3 ] && echo sqlite3.o || (cd $a/$set && ls *.o | sed "s|^|$set/|"))
    changed=0
    for o in $files; do
        if ! cmp -s <(objdump -d --no-show-raw-insn $a/$o | tail -n +4) <(objdump -d --no-show-raw-insn $b/$o | tail -n +4); then
            changed=$((changed + 1))
            echo "$o $a $(count $a/$o)" >> changed.txt
            echo "$o $b $(count $b/$o)" >> changed.txt
        fi
    done
    total_a=$(for o in $files; do objdump -d --no-show-raw-insn $a/$o; done | awk -v w="$words" '/^ +[0-9a-f]+:/ { n++; c[$2]++ } END { printf "records=%d", n; split(w, k, " "); for (i = 1; i in k; i++) printf " %s=%d", k[i], c[k[i]]; }')
    total_b=$(for o in $files; do objdump -d --no-show-raw-insn $b/$o; done | awk -v w="$words" '/^ +[0-9a-f]+:/ { n++; c[$2]++ } END { printf "records=%d", n; split(w, k, " "); for (i = 1; i in k; i++) printf " %s=%d", k[i], c[k[i]]; }')
    echo "$set: $(echo $files | wc -w) objects, $changed differ" >> shape.txt
    echo "  $a $total_a" >> shape.txt
    echo "  $b $total_b" >> shape.txt
done
size -A $a/sqlite3.o $b/sqlite3.o | awk '/^.text/ { print "sqlite3 .text", $2 }' >> shape.txt
echo done > corpus.done
