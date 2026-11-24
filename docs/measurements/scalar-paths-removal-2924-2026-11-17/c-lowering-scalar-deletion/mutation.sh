#!/bin/bash
cd /home/user/buster-c
M=/tmp/claude-0/-home-user/6518a586-0028-5254-9ee3-c6500b72668a/scratchpad/mut-l
F=src/buster/compiler/c_lowering.c
run() {
  name=$1
  cp $M/orig.c $F
  python3 -c "
import sys
p='$F'; s=open(p).read(); a=sys.argv[1]; b=sys.argv[2]
assert s.count(a)==1; open(p,'w').write(s.replace(a,b))" "$2" "$3"
  ./build.sh --config Release > $M/build-$name.log 2>&1 || { echo "$name: build failed"; return; }
  ./build/compiler test-lowering > $M/test-$name.log 2>&1
  echo "$name: exit $? $(tail -1 $M/test-$name.log)"
}
run lane15 "const __mmask16 selected = (__mmask16)(plan->reached[base / BUSTER_C_LOWERING_WORD_BITS] >> (base % BUSTER_C_LOWERING_WORD_BITS));" "const __mmask16 selected = (__mmask16)(plan->reached[base / BUSTER_C_LOWERING_WORD_BITS] >> (base % BUSTER_C_LOWERING_WORD_BITS)) & (base != 0 ? 0x7fff : 0xffff);"
run optional "mode == C_LOWERING_ALL ? eligible & ~optionals :" "mode == C_LOWERING_ALL ? eligible :"
cp $M/orig.c $F
./build.sh --config Release > $M/build-restore.log 2>&1; echo restore $?
