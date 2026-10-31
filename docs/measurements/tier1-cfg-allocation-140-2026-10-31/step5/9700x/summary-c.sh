#!/bin/bash
# summary-c.sh LOGS ST: queue-c.sh's results: each compile list's per-round medians by tree (wall ms, user cycles,
# instructions), and speedtest1's runs (median wall, user, system and TOTAL over the rounds, each build's verification hash).
logs=$1
st=$2
export LC_ALL=C
for f in compile-object compile-link compile-tier1; do
    echo "== $f"
    awk '/^== round/ { tree = $5 } /^list [0-9]+ \[/ { match($0, /median [0-9.]+ ms wall/); w = substr($0, RSTART + 7, RLENGTH - 15); match($0, /[0-9]+ user cycles/); c = substr($0, RSTART, RLENGTH - 12); match($0, /[0-9]+ instructions/); i = substr($0, RSTART, RLENGTH - 13); print tree, "list" $2, w, c, i }' $logs/$f.log |
        sort -k1,1 -k2,2 -s | awk '{ k = $1 " " $2; walls[k] = walls[k] " " $3; cycles[k] = cycles[k] " " $4; ins[k] = $5 } END { for (k in walls) print k ": wall" walls[k] " | cycles" cycles[k] " | instructions " ins[k] }' | sort
done
echo "== speedtest1 (median of rounds: wall us, user s, system s, TOTAL s)"
median() { sort -n | awk '{ v[NR] = $1 } END { print v[int((NR + 1) / 2)] }'; }
for c in t0 t1 t1s t0base clang0 clang2; do
    [ -n "$(awk -v c=$c '$2 == c' $st/run.times)" ] || continue
    echo "$c: wall $(awk -v c=$c '$2 == c {print $3}' $st/run.times | median) us, user $(awk -v c=$c '$2 == c {print $4}' $st/run.times | median) s, system $(awk -v c=$c '$2 == c {print $5}' $st/run.times | median) s, TOTAL $(awk -v c=$c '$2 == c {print $6}' $st/run.times | tr -d s | median) s, rounds $(awk -v c=$c '$2 == c' $st/run.times | wc -l), hash $(grep -h 'Verification Hash' $st/verify-$c.txt | awk '{print $3, $4}')"
done
for c in t1 t1s; do
    grep -h "^tier1" $st/build-$c.txt | cut -c1-200
done
