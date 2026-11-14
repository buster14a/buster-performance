#!/usr/bin/env bash
cd /home/david/buster-fast-bench/2768-claude || exit 1
status=0
while read -r o perm; do
    for t in base head; do
        objs=""; for f in $perm; do objs="$objs /home/david/buster-fast-bench/2768-claude/obj-$t/$f.o"; done
        cc -o /home/david/buster-fast-bench/2768-claude/exe/lua-$t-o$o $objs -lm -ldl || status=1
    done
done < orders.txt
for n in 0 528 1056 1584 2112 2640 3168 3696; do for t in base head; do cc -o /home/david/buster-fast-bench/2768-claude/exe/st-$t-s$n /home/david/buster-fast-bench/2768-claude/pad/pad$n.o /home/david/buster-fast-bench/2768-claude/obj-$t/speedtest1.o -lm || status=1; done; done
exit $status
