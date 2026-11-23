#!/bin/bash
# Small and middling units, the unit as one against tiles of 4,096 tokens, by time-runs on CPU 2 (one hold of the lock).
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
out=$dir/results/small-units
mkdir -p "$out"
cd "$dir/tiles3"
export EXCLUSIVE_OWNER=claude-2536-kcl1ed
export EXCLUSIVE_TITLE="#2536: the parser's tiles on small units"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
cat > "$out/hold.sh" <<'EOS'
#!/bin/bash
out=$1
{ date -u +%FT%TZ; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > "$out/busy.txt"
small=tests/driver/$(ls tests/driver | grep '\.c$' | head -1)
echo "small: $small" > "$out/inputs.txt"
taskset -c 2 ./build/compiler time-runs --runs 41 --list -c "$small" -o "$out/small.o" --parse-tile=0 --list -c "$small" -o "$out/small.o" --parse-tile=4096 > "$out/small.txt" 2>&1
taskset -c 2 ./build/compiler time-runs --runs 21 --list -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/c_lexer.c --parse-tile=0 --list -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/c_lexer.c --parse-tile=4096 > "$out/lexer.txt" 2>&1
taskset -c 2 ./build/compiler time-runs --runs 9 --list -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c --parse-tile=0 --list -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c --parse-tile=4096 > "$out/main.txt" 2>&1
EOS
chmod +x "$out/hold.sh"
~/buster-fast-bench/exclusive.sh "$out/hold.sh" "$out" 2> "$out/lock.err"
echo SMALL-DONE
