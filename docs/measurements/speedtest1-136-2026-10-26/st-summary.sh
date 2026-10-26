#!/bin/bash
# The measurement's summaries from its raw data (m/, or the directory given): medians of the compile times, of the
# runs and of the counts, with each build's ratio to clang -O0's; each testset's time by build (speedtest1's own
# per-test times summed per testset in each run, then the median over the rounds); and every run's output against
# clang's first round's, its timings masked and the lines that name the compiler or count the process's I/O set apart.
set -u
. "$(dirname "$0")/st-env.sh"
cd ${1:-$M} || exit 1
median() { sort -g | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}'; }
builds=()
for c in ${BUILDS[@]}; do
    grep -q " $c " run.times && builds+=($c)
done
echo "## Compile times, microseconds (medians of $(grep -c '^ours sqlite3.c ' compile.times))"
for step in "ours sqlite3.c" "ours speedtest1.c" "ours link" "direct build" "clang sqlite3.c" "clang speedtest1.c" "clang link" "tcc sqlite3.c" "tcc speedtest1.c" "tcc link"; do
    echo "$step $(grep "^$step " compile.times | cut -d' ' -f3 | median)"
done
echo
echo "## Runs (medians of $(grep -c ' clang ' run.times)): wall us, user s, system s, TOTAL s; wall and TOTAL against clang's"
cw=$(awk '$2 == "clang" {print $3}' run.times | median)
ct=$(awk '$2 == "clang" {print $6}' run.times | tr -d s | median)
for c in ${builds[@]}; do
    w=$(awk -v c=$c '$2 == c {print $3}' run.times | median)
    t=$(awk -v c=$c '$2 == c {print $6}' run.times | tr -d s | median)
    echo "$c $w $(awk -v c=$c '$2 == c {print $4}' run.times | median) $(awk -v c=$c '$2 == c {print $5}' run.times | median) $t $(awk -v a=$w -v b=$cw 'BEGIN {printf "%.3f", a / b}') $(awk -v a=$t -v b=$ct 'BEGIN {printf "%.3f", a / b}')"
    echo "  wall range $(awk -v c=$c '$2 == c {print $3}' run.times | sort -n | sed -n '1p;$p' | tr '\n' ' ')"
done
echo
if [ -d counts ]; then
    echo "## Counts (medians of $(ls counts/*-clang.stat | wc -l)): instructions:u, cycles:u, IPC; instructions against clang's"
    ci=$(cat counts/*-clang.stat | grep instructions | cut -d, -f1 | median)
    for c in ${builds[@]}; do
        i=$(cat counts/*-$c.stat | grep instructions | cut -d, -f1 | median)
        y=$(cat counts/*-$c.stat | grep 'cycles' | cut -d, -f1 | median)
        echo "$c $i $y $(awk -v a=$i -v b=$y 'BEGIN {printf "%.2f", a / b}') $(awk -v a=$i -v b=$ci 'BEGIN {printf "%.3f", a / b}')"
    done
    echo
fi
echo "## Sizes"
cat sizes.txt
echo
echo "## Testsets, seconds (medians over the rounds of each run's per-test times summed by testset)"
for f in runs/r*-*.txt; do
    b=$(basename $f .txt)
    awk -v r=${b%%-*} -v c=${b#*-} -v set=main '
        /Begin testset/ { set = $3; gsub(/"/, "", set) }
        /^ *[0-9]+ - .*s$/ { t = $NF; sub(/s$/, "", t); s[$1 == "999" ? "reset" : set] += t }
        END { for (k in s) printf "%s %s %s %.3f\n", r, c, k, s[k] }' $f
done > testsets.txt
printf '%-12s' testset; printf ' %8s' ${builds[@]}; echo "  ours/clang"
for set in main orm cte json fp parsenumber rtree star app reset; do
    printf '%-12s' $set
    for c in ${builds[@]}; do
        printf ' %8s' $(awk -v c=$c -v s=$set '$2 == c && $3 == s {print $4}' testsets.txt | median)
    done
    awk -v s=$set '$3 == s && $2 == "ours" {print $4}' testsets.txt | median > /tmp/st-summary-$$.o
    awk -v s=$set '$3 == s && $2 == "clang" {print $4}' testsets.txt | median > /tmp/st-summary-$$.c
    awk 'BEGIN {getline o < ARGV[1]; getline c < ARGV[2]; if (c > 0) printf "  %.2f\n", o / c; else print "  -"}' /tmp/st-summary-$$.o /tmp/st-summary-$$.c
done
rm -f /tmp/st-summary-$$.o /tmp/st-summary-$$.c
echo
echo "## Outputs: timings masked, against clang's round 0 (the lines naming the compiler or counting the process's I/O apart)"
apart='^-- (Compile option: (COMPILER|ATOMIC_INTRINSICS)=|Bytes (received|sent|rcvd)|Read\(\) system|Write\(\) system|Cancelled write)'
mask() { sed -E 's/ +[0-9]+\.[0-9]{3}s$//' $1 | grep -Ev "$apart"; }
mask runs/r0-clang.txt > /tmp/st-summary-$$.ref
for f in runs/r*-*.txt counts/r*-*.txt; do
    mask $f | cmp -s - /tmp/st-summary-$$.ref || echo "$f differs: $(mask $f | diff /tmp/st-summary-$$.ref - | grep '^[<>]' | head -4 | tr '\n' '|')"
done
rm -f /tmp/st-summary-$$.ref
echo "compared $(ls runs/r*-*.txt counts/r*-*.txt | wc -l) outputs"
for c in ${builds[@]}; do
    echo "$c: $(grep -hE "$apart" runs/r*-$c.txt | sort | uniq -c | sed -E 's/^ +//' | tr '\n' ';')"
done
echo
echo "## Verification hashes (--verify)"
grep -H 'Verification Hash' verify-*.txt
if [ -d profile ]; then
    echo
    echo "## Instructions by function, millions: each function's share of its build's sampled instructions:u (profile/)"
    echo "## times the build's event count; the functions whose excess over clang's is largest"
    estimate() { # report -> function millions
        local total=$(grep -m1 'Event count' $1 | awk '{print $NF}')
        grep -v '^#' $1 | awk -v t=$total '{sub(/%/, "", $1); printf "%s %.0f\n", $3, $1 * t / 100 / 1e6}' | sort -k1,1
    }
    printf '%-28s %8s %8s %8s %6s\n' function ours clang excess ratio
    join <(estimate profile/ours-instructions.txt) <(estimate profile/clang-instructions.txt) | awk '{printf "%-28s %8d %8d %8d %6.2f\n", $1, $2, $3, $2 - $3, $2 / $3}' | sort -k4 -n -r | head -12
fi
