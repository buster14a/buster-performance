#!/bin/bash
# shell.sh: SQLite's shell.c on CPU 2 (sqlite-host options: -I alone), 5 rounds of 3 compiles each:
#   main38 as it is (the direct path tries and leaves at the first assert), main38 --no-direct,
#   main38 and deep with the emulation (-DNDEBUG, __builtin_ceil/floor as ceil/floor): deep takes the direct path.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$here/step2/shell.txt
: > "$out"
emul=(-DNDEBUG -D__builtin_ceil=ceil -D__builtin_floor=floor)
for b in main38 deep; do "$here/bin/compiler-$b" --version > /dev/null || exit 1; done
for r in 1 2 3 4 5; do
  for v in main38:plain main38:nodirect main38:emul deep:emul sq:main38; do
    b=${v%%:*}; m=${v#*:}
    case $m in
      plain) args=(-c "$C/shell.c");;
      nodirect) args=(--no-direct -c "$C/shell.c");;
      emul) args=("${emul[@]}" -c "$C/shell.c");;
      main38) b=main38; args=(-c "$C/sqlite3.c");;
    esac
    perf stat -x, -e task-clock,instructions:u,cycles:u,cycles:k -r 3 -o "$here/step2/ps.tmp" -- taskset -c 2 "$here/bin/compiler-$b" -I"$C" "${args[@]}" -o /dev/shm/sh-np4nn5.o
    echo "$v $r $(grep -v '^#' "$here/step2/ps.tmp" | grep -v '^$' | awk -F, '{printf "%s=%s ", $3, $1}') $(readelf -p .comment /dev/shm/sh-np4nn5.o | grep -o 'buster[^ ]*' | head -1)" >> "$out"
  done
done
cat "$out"
