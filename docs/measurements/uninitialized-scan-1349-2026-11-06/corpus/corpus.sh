#!/bin/bash
# corpus.sh: compare main's and the branch's diagnostics and exit codes, -Wall -Wextra -fsyntax-only, vector and --scalar,
# on sqlite, lua and the repository's C tests and examples.
A=/home/user/bench/compiler-1349-main; B=/home/user/bench/compiler-1349-branch
W=/home/user/wt-1349
same=0; differ=0; diags=0; selfw=0
files=(/home/user/corpus/sqlite-amalgamation-3500400/sqlite3.c /home/user/corpus/sqlite-amalgamation-3500400/shell.c /home/user/corpus/lua-5.4.8/src/*.c)
mapfile -t more < <(find $W/tests $W/examples -name '*.c' -size -400k | sort)
files+=("${more[@]}")
for f in "${files[@]}"; do
  d=$(dirname "$f")
  for m in "" --scalar; do
    a=$(cd "$d" && timeout 60 $A -std=gnu17 -fsyntax-only -Wall -Wextra -I"$d" "$f" $m 2>&1); ea=$?
    b=$(cd "$d" && timeout 60 $B -std=gnu17 -fsyntax-only -Wall -Wextra -I"$d" "$f" $m 2>&1); eb=$?
    if [ "$a" == "$b" ] && [ $ea == $eb ]; then same=$((same+1)); else differ=$((differ+1)); echo "DIFF $f mode '$m' exits $ea $eb"; fi
    diags=$((diags + $(printf '%s\n' "$a" | grep -c "warning:\|error:")))
    selfw=$((selfw + $(printf '%s\n' "$a" | grep -c "within its own initialization")))
  done
done
echo "files ${#files[@]} runs $((same+differ)) same $same differ $differ diagnostics $diags self-init $selfw"
