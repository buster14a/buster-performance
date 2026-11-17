#!/bin/bash
# #1590: where the head's extra instructions on a mixed link go, perf record of instructions:u over 300 links.
set -u
W=$HOME/buster-fast-bench/1590-claude
cd $W
export EXCLUSIVE_OWNER=claude-1590 EXCLUSIVE_TITLE="Foreign linker: library versions in mixed links (#1590)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2909
cat > loop.sh <<'L'
#!/bin/bash
for i in $(seq 300); do "$1" -o /dev/shm/1590-prof inputs/hello.c inputs/extra.o -lm || exit 1; done
L
chmod +x loop.sh
for t in base head; do
  $HOME/buster-fast-bench/exclusive.sh timeout -k 5 300 taskset -c 2 perf record -q -e instructions:u -c 100003 -o perf-$t.data ./loop.sh $W/compiler-$t > /dev/null 2>&1
  perf report -i perf-$t.data --no-children --sort symbol --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -40 > report-$t.txt
done
rm -f /dev/shm/1590-prof
echo done
