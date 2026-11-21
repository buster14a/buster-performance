#!/bin/bash
# relink-main.sh: links every generated program (review/clinks/*/, from genc.py and genlink.py) with main's build and
# --merge-strings, with the branch's build and --merge-strings, and with main's build and --no-merge-strings; runs each
# against expected.bin and prints: name status main-rodata final-rodata no-merge-rodata (bytes). Paths are the session's
# scratchpad's; MAIN and FINAL are the two Develop builds named in the README.
S=${S:-/tmp/claude-0/-home-user/17ca334c-b389-40bd-9a1c-a7a69684778b/scratchpad}
MAIN=${MAIN:-$S/compiler-main-b86}
FINAL=${FINAL:-$S/r3044/fix/compiler-final}
W=$S/r3044/bymain
mkdir -p $W
sz() { llvm-readelf -SW "$1" | awk '{for(i=1;i<=NF;i++) if($i==".rodata") print $(i+4)}'; }
for d in $S/r3044/review/clinks/*/; do
  name=$(basename $d); objs=""
  for u in $(cat $d/units.txt) main; do objs="$objs $d/$u.o"; done
  st=ok
  for b in main final none; do
    case $b in main) bin=$MAIN; fl=--merge-strings;; final) bin=$FINAL; fl=--merge-strings;; none) bin=$MAIN; fl=--no-merge-strings;; esac
    $bin link-foreign $fl --lanes 1 -o $W/$name-$b $objs > $W/$name-$b.log 2>&1 || st=link-$b-failed
    [ -x $W/$name-$b ] && { $W/$name-$b > $W/$name-$b.out 2>/dev/null; cmp -s $W/$name-$b.out $d/expected.bin || st=out-$b-differs; }
  done
  echo "$name $st $((16#$(sz $W/$name-main))) $((16#$(sz $W/$name-final))) $((16#$(sz $W/$name-none)))"
done
