#!/bin/bash
# The measurement's summaries from its raw data (m2/, or the directory given): medians of the compile times, of the
# runs and of the counts, with each build's ratio to clang -O0's and the after tree's to the before tree's; each
# testset's time by build (speedtest1's own per-test times summed per testset in each run, then the median over the
# rounds); every run's output against clang's first round's, its timings masked and the lines that name the compiler
# or count the process's I/O set apart; and the functions whose sampled instructions changed most.
set -u
. "$(dirname "$0")/st-env.sh"
cd ${1:-$M} || exit 1
median() { sort -g | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}'; }
ratio() { awk -v a=$1 -v b=$2 'BEGIN {if (b > 0) printf "%.3f", a / b; else print "-"}'; }
builds=()
for c in ${BUILDS[@]}; do
    grep -q " $c " run.times && builds+=($c)
done
echo "## Compile times, microseconds (medians of $(grep -c "^clang sqlite3.c " compile.times))"
cut -d' ' -f1,2 compile.times | awk '!seen[$0]++' | while read c step; do
    echo "$c $step $(grep "^$c $step " compile.times | cut -d' ' -f3 | median)"
done
echo
echo "## Runs (medians of $(grep -c ' clang ' run.times)): wall us, user s, system s, TOTAL s; wall against clang's and against the before tree's same build"
wall() { awk -v c=$1 '$2 == c {print $3}' run.times | median; }
cw=$(wall clang)
for c in ${builds[@]}; do
    w=$(wall $c)
    b=-
    case $c in after*) b=$(ratio $w $(wall ${c/after/before})) ;; esac
    echo "$c $w $(awk -v c=$c '$2 == c {print $4}' run.times | median) $(awk -v c=$c '$2 == c {print $5}' run.times | median) $(awk -v c=$c '$2 == c {print $6}' run.times | tr -d s | median) $(ratio $w $cw) $b"
    echo "  wall range $(awk -v c=$c '$2 == c {print $3}' run.times | sort -n | sed -n '1p;$p' | tr '\n' ' ')"
done
echo
if [ -d counts ]; then
    echo "## Counts (medians of $(ls counts/*-clang.stat | wc -l)): instructions:u, cycles:u, IPC; instructions against clang's and the before tree's"
    count() { cat counts/*-$1.stat | grep "$2" | cut -d, -f1 | median; }
    ci=$(count clang instructions)
    for c in ${builds[@]}; do
        i=$(count $c instructions)
        y=$(count $c cycles)
        b=-
        case $c in after*) b=$(ratio $i $(count ${c/after/before} instructions)) ;; esac
        echo "$c $i $y $(ratio $i $y) $(ratio $i $ci) $b"
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
cell() { awk -v c=$1 -v s=$2 '$2 == c && $3 == s {print $4}' testsets.txt | median; }
printf '%-12s' testset; printf ' %13s' ${builds[@]}; echo "  after/before after/clang"
for set in main orm cte json fp parsenumber rtree star app reset; do
    printf '%-12s' $set
    for c in ${builds[@]}; do
        printf ' %13s' $(cell $c $set)
    done
    printf '  %12s %11s\n' $(ratio $(cell after $set) $(cell before $set)) $(ratio $(cell after $set) $(cell clang $set))
done
echo
echo "## Outputs: timings masked, against clang's round 0 (the lines naming the compiler or counting the process's I/O apart)"
apart='^-- (Compile option: (COMPILER|ATOMIC_INTRINSICS)=|Bytes (received|sent|rcvd)|Read\(\) system|Write\(\) system|Cancelled write)'
mask() { sed -E 's/ +[0-9]+\.[0-9]{3}s$//' $1 | grep -Ev "$apart"; }
reference=$(mktemp)
mask runs/r0-clang.txt > $reference
for f in runs/r*-*.txt counts/r*-*.txt; do
    mask $f | cmp -s - $reference || echo "$f differs: $(mask $f | diff $reference - | grep '^[<>]' | head -4 | tr '\n' '|')"
done
rm -f $reference
echo "compared $(ls runs/r*-*.txt counts/r*-*.txt | wc -l) outputs"
for c in ${builds[@]}; do
    echo "$c: $(grep -hE "$apart" runs/r*-$c.txt | sort | uniq -c | sed -E 's/^ +//' | tr '\n' ';')"
done
echo
echo "## Verification hashes (--verify)"
grep -H 'Verification Hash' verify-*.txt
if [ -d profile ]; then
    estimate() { # report -> function millions
        local total=$(grep -m1 'Event count' $1 | awk '{print $NF}')
        grep -v '^#' $1 | awk -v t=$total '{sub(/%/, "", $1); printf "%s %.0f\n", $3, $1 * t / 100 / 1e6}' | sort -k1,1
    }
    for pair in "after before" "after clang"; do
        set -- $pair
        echo
        echo "## Instructions by function, millions: each function's share of its build's sampled instructions:u (profile/)"
        echo "## times the build's event count; the functions whose difference between $1 and $2 is largest"
        printf '%-28s %8s %8s %8s %6s\n' function $1 $2 difference ratio
        join <(estimate profile/$1-instructions.txt) <(estimate profile/$2-instructions.txt) | awk '{d = $2 - $3; printf "%-28s %8d %8d %8d %6.2f %d\n", $1, $2, $3, d, $2 / $3, d < 0 ? -d : d}' | sort -k6 -n -r | head -12 | cut -c1-63
    done
fi
