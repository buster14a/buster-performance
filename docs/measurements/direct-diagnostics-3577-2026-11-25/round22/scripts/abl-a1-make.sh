#!/bin/bash
# abl-a1-make.sh: one measurement-only arm per A1 part (the expression-side checks behind BUSTER_ABL), as commits on
# top of the head eeee61ef8 (branches abl22-a1-PART), each built locally and held to sqlite3.c's object.
S=/tmp/claude-0/-home-user/cf3643bc-6e1c-51b2-99ca-175eb97147e4/scratchpad
C=/home/user/corpus
cd /home/user/buster || exit 1
git diff --quiet && git diff --cached --quiet || { echo "tree not clean"; exit 1; }
for part in cond seq conv binary unary assign prec push subscript end; do
  rm -rf $S/abl-p && mkdir -p $S/abl-p/src/buster/compiler && cp src/buster/compiler/c_direct*.c $S/abl-p/src/buster/compiler/
  python3 $S/abl-a1-part.py $S/abl-p $part > $S/abl-p-$part.log 2>&1 || { echo "apply $part failed: $(tail -1 $S/abl-p-$part.log)"; exit 1; }
  cp $S/abl-p/src/buster/compiler/c_direct*.c src/buster/compiler/
  ./build.sh --config Release > $S/abl-p-$part-build.log 2>&1; st=$?
  if [ $st != 0 ]; then echo "build $part failed"; grep -E "error" $S/abl-p-$part-build.log | head -5; git checkout -q -- src/buster/compiler/; exit 1; fi
  rm -f $S/abl-bail.txt
  BUSTER_TEST_DIRECT_BAILS=$S/abl-bail.txt LLVM_PROFILE_FILE=/dev/null build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" -o $S/sq-abl-p.o
  obj="$(readelf -p .comment $S/sq-abl-p.o | grep -o 'buster[a-z -]*') $(cmp -s $S/sq-abl-p.o $S/sq-m8-head.o && echo identical || echo DIFFERS) $(cat $S/abl-bail.txt 2>/dev/null | cut -f1)"
  git checkout -q -b abl22-a1-$part 2>/dev/null || { git branch -D abl22-a1-$part > /dev/null; git checkout -q -b abl22-a1-$part; }
  BUSTER_DCO_SIGN_OFF=off git commit -q -a -m "measurement only: #3577 A1 part $part behind an opaque test"
  echo "$part commit $(git rev-parse --short HEAD) sqlite3.c: $obj"
  git checkout -q claude/adoring-goodall-mr1480
done
