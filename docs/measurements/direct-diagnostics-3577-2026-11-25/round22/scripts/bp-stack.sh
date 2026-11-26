#!/bin/bash
# bp-stack.sh: does the stack's alignment within a 64-byte line move sqlite3.c's compile? ASLR off (setarch -R), the
# environment padded by K bytes (shifting the initial stack pointer down in 16-byte steps as K grows), main (base tree)
# and the head (work tree rebuilt at eeee61ef8, offset 0): perf stat -r 3 cycles, instructions, refused forwards, and
# the stack pointer main() sees (from /proc/self via a tiny probe: not available, so the K classes are read by mod 64).
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
git checkout -q -- . 2>/dev/null; git checkout -q --detach eeee61ef8 || exit 1
EXCLUSIVE_TITLE="#3577 direct path: build the head (stack alignment)" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-stack-head.log" 2>&1
st=$?; echo "build head status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
cd "$D" || exit 1
cat > spprobe.c <<'PROBE'
#include <stdio.h>
#include <stdint.h>
int main(void) { volatile char c; printf("%lu\n", (unsigned long)((uintptr_t)&c & 63u)); return 0; }
PROBE
cc -O0 -o spprobe spprobe.c || exit 1
EXCLUSIVE_TITLE="#3577 direct path: stack alignment sweep" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-k.o)
  for r in 1 2; do
    for k in 0 16 32 48 64 80 96 112; do
      pad=$(head -c $k /dev/zero | tr "\0" "x")
      probe=$(setarch -R env -i PAD="$pad" ./spprobe)
      for t in base work; do
        echo "== $r $t k$k sp$probe $(cd $t && setarch -R env -i PAD="$pad" taskset -c 2 perf stat -r 3 -e cycles:u,instructions:u,ls_bad_status2.stli_other:u ./build/compiler "${flags[@]}" 2>&1 | grep -E "cycles|instructions|stli" | awk "{print \$1}" | tr "\n" " ")"
      done
    done
  done
' x "$sqlite" > stack.txt
cat stack.txt
echo DONE
