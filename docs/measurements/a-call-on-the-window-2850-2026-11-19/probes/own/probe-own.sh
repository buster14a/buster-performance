#!/bin/bash
# probe-own.sh COMPILER: statements that need declarations of their own (head.h: an atomic type's rvalues, a const
# result, a struct with an atomic member), each alone in a function through the shadow with C on the window; and
# four files with #pragma STDC FENV_ACCESS ON before a function, in it, in a block of it, and without it (q1 to q4).
compiler=$1
cd "$(dirname "$0")"
run() {
    out=$("$compiler" measure-node-machine --shadow --passes 0 --window-contexts --verify --list 5 "$1" 2>&1); st=$?
    calls=$(printf '%s\n' "$out" | grep -o "in place's calls: to-make=[0-9]* made=[0-9]* with-every-argument's-conversion=[0-9]*[^;]*; *" | head -1 | sed "s/in place's calls: //; s/with-every-argument's-conversion/whole/; s/of-them-plain/plain/; s/left-for-an-argument/left/")
    diff=$(printf '%s\n' "$out" | grep -o "the kernel in place: to-make=[0-9]* made=[0-9]* left=[0-9]* differences=[0-9]*" | grep -o "differences=[0-9]*")
    cdiff=$(printf '%s\n' "$out" | grep -o "window contexts expressions=[0-9]* records=[0-9]* decided=[0-9]* ([^)]*) their-records=[0-9]* ([^)]*) of-them-refused=[0-9]* differences=[0-9]*" | head -1 | sed 's/window contexts //; s/records=[0-9]* //; s/their-records=[0-9]* ([^)]*) //; s/ ([^)]*)//')
    fail=$(printf '%s\n' "$out" | grep -o 'failed="[^"]*"' | head -1)
    printf '%-30s status=%s %s | %s | C: %s %s\n' "$2" "$st" "$calls" "$diff" "$cdiff" "$fail"
}
while IFS= read -r line; do
    { cat head.h; printf 'int g(int a, long b, double d, f4 ev, v4 vec, int* ip)\n{\n    _Atomic int at = 0;\n    %s\n    return 0;\n}\n' "$line"; } > one.c
    run one.c "$line"
done < statements.txt
for q in q1 q2 q3 q4; do run $q.c "$q.c"; done
