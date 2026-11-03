#!/bin/bash
# compare.sh (#1203's review): -fsyntax-only of a unit that is only `int main(void) { return 0; }` by scalar
# (BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0) builds under an address-space limit (ulimit -v): each build's exit at
# 512 MiB three times, and its peak of mapped bytes at 1 GiB (strace's mmap less munmap, peak.awk); then main's and
# the head's exits from 360 to 1100 MiB in 4 MiB steps; then Lua 5.4.8's lparser.c by -c at limits from 1024 to 1920 MiB.
cd "$(dirname "$0")"
printf 'int main(void) { return 0; }\n' > tiny.c
builds=(base-703ae9f5:base before-32978178:head main-a4a2182a:main2 head-be422b81:head2)
uname -r; clang --version | head -1; strace -V | head -1
for b in "${builds[@]}"; do sha256sum ${b#*:}/build/compiler; cat ${b#*:}/COMMIT 2>/dev/null; done
for b in "${builds[@]}"; do
  c=${b#*:}/build/compiler; r=""
  for i in 1 2 3; do (ulimit -v 524288; $c -fsyntax-only tiny.c > /dev/null 2>&1); r="$r $?"; done
  (ulimit -v 1048576; strace -f -e trace=mmap,munmap -o ${b%%:*}-1g.strace $c -fsyntax-only tiny.c > /dev/null 2>&1)
  echo "${b%%:*}: 512 MiB exits$r; at 1 GiB $(awk -f peak.awk ${b%%:*}-1g.strace | head -1)"
done
(ulimit -v 524288; head/build/compiler -fsyntax-only tiny.c 2>&1 | head -1)
(ulimit -v 524288; strace -f -e trace=mmap -o before-512m.strace head/build/compiler -fsyntax-only tiny.c > /dev/null 2>&1); grep ENOMEM before-512m.strace | sed 's/^[0-9]* //'
for m in $(seq 360 4 1100); do
  (ulimit -v $((m * 1024)); main2/build/compiler -fsyntax-only tiny.c > /dev/null 2>&1); a=$?
  (ulimit -v $((m * 1024)); head2/build/compiler -fsyntax-only tiny.c > /dev/null 2>&1); h=$?
  (ulimit -v $((m * 1024)); head/build/compiler -fsyntax-only tiny.c > /dev/null 2>&1); o=$?
  echo "limit $m MiB: main $a head $h before $o"
done
cd ~/.cache/claude-1128/lua && sha256sum lparser.c
for m in 1024 1152 1280 1408 1536 1920; do
  for b in main2 head2; do (ulimit -v $((m * 1024)); ~/.cache/claude-1128/rlimit/$b/build/compiler -std=gnu99 -DLUA_USE_LINUX -w -c lparser.c -o ~/.cache/claude-1128/rlimit/lp.o 2> ~/.cache/claude-1128/rlimit/lp.err); echo "lparser.c -c, $b, limit $m MiB: exit $? $(head -1 ~/.cache/claude-1128/rlimit/lp.err)"; done
done
