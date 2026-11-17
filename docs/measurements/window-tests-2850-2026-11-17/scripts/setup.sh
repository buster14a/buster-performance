#!/bin/bash
# setup.sh: the bench directory's clone of buster (from the window's piece's), its scripts and its Lua input
cd "$(dirname "$0")"
mkdir -p results trees inputs
test -d src || git clone -q ~/buster-fast-bench/2850-window-claude/src src
git -C src remote set-url origin https://github.com/buster14a/buster
git -C src fetch -q origin main && git -C src log --oneline -1 FETCH_HEAD
test -d inputs/lua-5.4.8 || cp -r ~/buster-fast-bench/868-claude/inputs/lua-5.4.8 inputs/
for f in build-label.sh turns.sh corpora.sh compile.sh; do test -f $f || cp ~/buster-fast-bench/2850-window-claude/$f .; done
sed -i 's/claude-2850-window.o/claude-2850-tests.o/g' compile.sh
ls inputs/lua-5.4.8/src | wc -l; ls
