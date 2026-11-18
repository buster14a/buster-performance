#!/bin/sh
# The driver test's unit-inlining fixture (c_check_tier1_driver_test.c) by the tree's compiler: an executable whose
# output is clang -O0's, at least 12 calls expanded, and -c's object defining the kept functions and leaving out the
# four dead ones.
here=$(dirname "$0")
tree=$1
out=$(mktemp -d)
fail=0
r=$("$tree/build/compiler" --tier1 --tier1-report --verify -o "$out/p" "$here/unit.c" 2>&1 | tr '\t' '\n' | sed -n 's/^inlined=//p')
[ -n "$r" ] && [ "$r" -ge 12 ] || { echo "inlined=$r"; fail=1; }
"$out/p" > "$out/actual" && cmp -s "$out/actual" "$here/expected.txt" || { echo "output differs"; fail=1; }
d=$("$tree/build/compiler" --tier1 --tier1-report --verify -c -o "$out/o.o" "$here/unit.c" 2>&1 | tr '\t' '\n' | sed -n 's/^dead=//p')
[ "$d" = 4 ] || { echo "dead=$d"; fail=1; }
for s in scale hook add1 sub1 pinned saved jumpy run wide main; do
    nm "$out/o.o" | grep -qE " [TtWw] $s\$" || { echo "missing $s"; fail=1; }
done
for s in crunch hop lead quotient; do
    nm "$out/o.o" | grep -qE " [TtWw] $s\$" && { echo "kept $s"; fail=1; }
done
rm -rf "$out"
exit $fail
