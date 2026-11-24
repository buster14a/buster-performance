#!/bin/bash
cd /home/user/buster-mut
M=/tmp/claude-0/-home-user/6518a586-0028-5254-9ee3-c6500b72668a/scratchpad/mut-t
D=src/buster/compiler
apply() {
  git checkout -q -- $D
  python3 - "$D/$1" "$2" "$3" <<'P'
import sys
p,n,a=sys.argv[1],int(sys.argv[2]),sys.argv[3]
s=open(p).read(); i=-1
for _ in range(n+1):
    i=s.index(a,i+1)
open(p,'w').write(s[:i]+"(("+a+") >> 1)"+s[i+len(a):])
P
}
checker() {
  ( for p in 1 2 3 4 5 6 7 8; do printf '== part %s\n./build/compiler test-checker --seed 133 --part %s/8\n' $p $p; done ) > $M/list
  ./build/compiler parallel --jobs 3 $M/list > $M/test3-$1.log 2>&1
  echo "$1 checker: exit $? $(grep -h ' failures' $M/test3-$1.log | grep '^test-checker' | awk '{s+=$4} END {print s" failures"}') $(grep -c 'Segmentation\|killed' $M/test3-$1.log) crashes"
}
driver() {
  ( for p in $(seq 1 16); do printf '== part %s\n./build/compiler test-checker-driver --executable ./build/compiler --part %s/16 --in-process\n' $p $p; done ) > $M/list2
  ./build/compiler parallel --jobs 3 $M/list2 > $M/test3d-$1.log 2>&1
  echo "$1 driver: exit $? $(grep -h 'parallel: 16 commands' $M/test3d-$1.log)"
}
run() {
  apply "$2" "$3" "$4"
  ./build.sh --config Release > $M/build3-$1.log 2>&1 || { echo "$1: build failed"; return; }
  checker $1
}
run contexts c_checker.c 0 '(__mmask16)((1u << (graph->count - node)) - 1)'
run reports c_checker.c 1 '(__mmask16)((1u << (graph->count - node)) - 1)'
run resource c_checker.c 0 '(__mmask16)((1u << (count - node)) - 1)'
run statics c_check_transitions.c 0 '(__mmask16)((1u << (count - node)) - 1)'
run tokenmap c_check_input.c 0 '(__mmask16)((1u << (count - token)) - 1)'
run marks c_check_input.c 0 '((__mmask64)1 << (count - token)) - 1'
run nonzero c_check_data.c 0 '((__mmask64)1 << (byte_end - byte)) - 1'
run parents c_check_common_warnings.c 0 '(__mmask16)((1u << (count - node)) - 1)'
driver parents
git checkout -q -- $D
echo done
