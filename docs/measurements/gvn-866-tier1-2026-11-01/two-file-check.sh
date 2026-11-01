#!/bin/bash
# The reviewer's two-file check: does --tier1-gvn reach each unit's lanes in a multi-file command, and is a single
# file still changed by it?
set -u
REPO=${REPO:?set REPO to a buster checkout}
OUT=/tmp/opencode/gvn866/t1
C=$CORPUS/tests/single-exec
cd "$REPO" || exit 1
mkdir -p "$OUT/review"
R="$OUT/review"
cat > "$R/two_a.c" <<'EOF'
int two_a(int a, int b)
{
    int x = a + b;
    int y = a + b;
    return x * y;
}
EOF
cat > "$R/two_b.c" <<'EOF'
int two_a(int a, int b);
int main(void)
{
    int x = two_a(2, 3);
    int y = two_a(2, 3);
    return (x + y) & 1;
}
EOF
cd "$R" || exit 1
B="$REPO/build/compiler"
echo "== one file =="
"$B" -c --tier1 --tier1-report -fno-asynchronous-unwind-tables -o "$R/one-plain.o" "$R/two_a.c" 2>&1 | grep -o "records=[0-9]*" | head -1
"$B" -c --tier1 --tier1-gvn --tier1-report -fno-asynchronous-unwind-tables -o "$R/one-gvn.o" "$R/two_a.c" 2>&1 | grep -o "records=[0-9]*" | head -1
size "$R/one-plain.o" "$R/one-gvn.o" | awk 'NR>1 {print $1, $6}'
echo "one-file objects differ: $(cmp -s "$R/one-plain.o" "$R/one-gvn.o" && echo no || echo yes)"
echo "== two files =="
"$B" -c --tier1 --tier1-report -fno-asynchronous-unwind-tables "$R/two_a.c" "$R/two_b.c" 2>&1 | grep -o "records=[0-9]*" | head -1
"$B" -c --tier1 --tier1-gvn --tier1-report -fno-asynchronous-unwind-tables "$R/two_a.c" "$R/two_b.c" 2>&1 | grep -o "records=[0-9]*" | head -1
echo "two-file objects differ: $(cmp -s "$R/two_b.o" "$R/two_b.o" && echo 'see below' || echo yes)"
ls -l "$R"/two_a.o "$R"/two_b.o | awk '{print $5, $9}'
