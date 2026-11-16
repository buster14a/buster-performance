#!/bin/bash
# checks.sh: the candidate tree's local checks: test-checker's eight parts (part 7 alone, after the others), then the
# shadow with the tests in both forms on sqlite3.c, Lua and the compiler's own source, with both sets of warnings.
cd /home/user/buster-0003
S=/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad
O=$S/own/final
rm -f $O/progress.txt
for p in 1 2 3 4; do ( ./build/compiler test-checker --seed 133 --part $p/8 > $O/t-$p.out 2> $O/t-$p.err; echo "part $p status $? $(tail -1 $O/t-$p.out)" >> $O/progress.txt ) & done; wait
for p in 5 6 8; do ( ./build/compiler test-checker --seed 133 --part $p/8 > $O/t-$p.out 2> $O/t-$p.err; echo "part $p status $? $(tail -1 $O/t-$p.out)" >> $O/progress.txt ) & done; wait
./build/compiler test-checker --seed 133 --part 7/8 > $O/t-7.out 2> $O/t-7.err; echo "part 7 status $? $(tail -1 $O/t-7.out)" >> $O/progress.txt
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S/corpus/sqlite $S/corpus/sqlite/sqlite3.c"
LUA="$S/corpus/lua/lua-5.4.8/src/*.c"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $O/predefines.h
MAIN="-march=native -Isrc -fwrapv -funsigned-char --predefines $O/predefines.h src/buster/compiler/main.c"
run() {
    name=$1; shift
    ./build/compiler measure-node-machine --shadow "$@" > $O/s-$name.out 2> $O/s-$name.err
    echo "$name status $? $(grep -o "own tests expressions=[0-9]* records=[0-9]*" $O/s-$name.out) $(grep -o "records-sent=[0-9]* ([0-9.]*%) walks=[0-9]* ([0-9.]*%) compared-with-the-census's-code differences=[0-9]* walks-of-another-count=[0-9]*" $O/s-$name.out) | $(grep -o "reader-time tests expressions=[0-9]* refused=[0-9]*" $O/s-$name.out) $(grep -o "taken-there-and-refused-by-the-census=[0-9]*" $O/s-$name.out) $(grep -o ") differences=[0-9]* root-kind-differences=[0-9]*" $O/s-$name.out | head -1)" >> $O/progress.txt
}
run sqlite-own --front-own-tests --verify --passes 1 $SQ &
run lua-own --front-own-tests --verify --passes 1 $LUA &
run sqlite-own-wall --front-own-tests --verify --passes 1 -Wall -Wextra $SQ &
run lua-own-wall --front-own-tests --verify --passes 1 -Wall -Wextra $LUA &
wait
run main-own --front-own-tests --verify --passes 1 $MAIN &
run main-own-wall --front-own-tests --verify --passes 1 -Wall -Wextra $MAIN &
run sqlite-tests --front-tests --verify --passes 1 $SQ &
run sqlite-own-last --front-own-tests --front-tests-last --verify --passes 1 $SQ &
wait
run main-tests --front-tests --verify --passes 1 $MAIN &
run lua-own-last --front-own-tests --front-tests-last --verify --passes 1 $LUA &
run sqlite-plain --passes 1 $SQ &
run main-plain --passes 1 $MAIN &
wait
echo all done >> $O/progress.txt
