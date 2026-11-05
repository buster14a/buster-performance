#!/bin/sh
# Page faults of an empty file's -fsyntax-only and tiny.c's -c by the static head (shifts-s3/compiler-0), by region:
# the executable's sections (from its section headers), the anonymous mappings, and the stack; and kernel-side
# faults (no user address). Also perf stat's split of the process's time.
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
C=$PWD/shifts-s3/compiler-0
{
readelf -SW $C | awk '$2 ~ /^\./ && $4 ~ /^0/ {print}' | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { name = $i; addr = $(i+2); size = $(i+4); print name, addr, size; break } }' > sections.txt
for args in "-fsyntax-only empty.c" "-c tiny.c -o /dev/null"; do
  echo "== $args"
  ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -e page-faults -c 1 -d -o faults4.data -- $C $args > /dev/null 2>&1; perf script -i faults4.data -F addr,ip,sym 2>/dev/null > faults4.txt; taskset -c 2 perf stat -r 200 -e task-clock,page-faults,cycles:u,cycles:k,instructions:u,instructions:k $C $args 2>&1 >/dev/null | grep -E 'task-clock|faults|cycles|instructions|elapsed'"
  awk 'NR == FNR { start[NR] = strtonum("0x" $2); end[NR] = start[NR] + strtonum("0x" $3); name[NR] = $1; n = NR; next }
       { a = strtonum("0x" $1); region = a == 0 ? "(no address)" : a >= 0x7ff000000000 ? "stack/vdso" : "anonymous";
         for (i = 1; i <= n; i++) if (a >= start[i] && a < end[i]) region = name[i];
         count[region]++ }
       END { for (r in count) print count[r], r }' sections.txt faults4.txt | sort -rn
  echo "-- top faulting functions"
  awk '{ $1 = ""; $2 = ""; print }' faults4.txt | sort | uniq -c | sort -rn | head -25
done
} > faults4.out 2>&1
echo done >> faults4.out
