#!/usr/bin/env bash
# corpora-summary.sh DIR: the tables of corpora.sh's results in DIR (corpora-HEAD/).
set -u
export LC_ALL=C
dir=$1
builds="t0 t1 t1s clang0 clang2 tcc"
# median FILE: the median and range of the numbers in FILE, one a line.
median() {
    sort -n "$1" | awk '{ v[NR] = $1 } END { if (NR == 0) { print "-"; exit } m = NR % 2 ? v[(NR + 1) / 2] : (v[NR / 2] + v[NR / 2 + 1]) / 2; printf "%.1f (%.1f-%.1f)", m / 1000, v[1] / 1000, v[NR] / 1000 }'
}
stat_of() { # FILE EVENT: perf stat -x,'s count of EVENT, in millions
    [ -f "$1" ] && awk -F, -v e="$2" '$3 ~ e { printf "%.1f", $1 / 1e6 }' "$1" || printf -- "-"
}
tmp=$(mktemp)
echo "## Lua 5.4.8: ms per run, median of 11 rounds (range); perf stat's user-space instructions and cycles (M)"
echo
for s in calls tables strings arithmetic closures; do
    printf "%s:" "$s"
    for b in $builds; do
        awk -v s=$s -v b=$b '$2 == s && $3 == b { print $4 }' $dir/lua/times.txt > $tmp
        printf " %s %s [%s, %s];" "$b" "$(median $tmp)" "$(stat_of $dir/lua/stat-$s-$b.txt instructions)" "$(stat_of $dir/lua/stat-$s-$b.txt cycles)"
    done
    echo
done
echo
echo "Lua outputs against clang -O0's: $(grep -c " same$" $dir/lua/compare.txt) same, $(grep -vc " same$" $dir/lua/compare.txt) differ"
echo "Lua static instructions (all Lua functions; the functions --tier1 compiles by Tier 1):"
cat $dir/lua/static.txt
grep -h "^tier1" $dir/lua/build-t1.txt $dir/lua/build-t1s.txt | cut -c1-120
echo
echo "## c-testsuite (220 programs)"
for b in $builds; do
    pass=$(grep -v "^empty " $dir/cts/check-$b.txt | grep -c " pass$")
    # The startup baseline: the empty program linked with -lm, as the programs link (empty-lm.sh), the median of 5 runs.
    empty=$(awk -v b=$b '$1 == b && $2 != "needs" { print $2 }' $dir/cts/empty-lm.txt | sort -n | awk '{ v[NR] = $1 } END { print v[(NR + 1) / 2] }')
    dynamic=$(awk -v e=$empty '$1 != "empty" { total += $2 - e } END { printf "%.3f", total / 1e6 }' $dir/cts/stat-$b.txt)
    static=$(awk '{ total += $2 } END { print total }' $dir/cts/static-$b.txt)
    # A round's time: the sum of its runs of the 220 programs by the build.
    awk -v b=$b '$3 == b && $2 != "empty" { t[$1] += $4 } END { for (r in t) print t[r] }' $dir/cts/times.txt > $tmp
    rounds=$(median $tmp)
    awk -v b=$b '$3 == b && $2 == "empty" { print $4 }' $dir/cts/times.txt > $tmp
    printf "%s: %d pass; dynamic instructions past the empty program's (with -lm) %s M (empty: %s); static %s; all 220 runs per round %s ms; the empty program's run %s ms\n" "$b" "$pass" "$dynamic" "$empty" "$static" "$rounds" "$(median $tmp)"
done
for b in $builds; do
    empty=$(awk -v b=$b '$1 == b && $2 != "needs" { print $2 }' $dir/cts/empty-lm.txt | sort -n | awk '{ v[NR] = $1 } END { print v[(NR + 1) / 2] }')
    awk -v e=$empty '$1 != "empty" { print $1, $2 - e }' $dir/cts/stat-$b.txt | sort > $tmp.$b
done
join $tmp.t0 $tmp.t1 | join - $tmp.t1s | join - $tmp.clang0 | join - $tmp.clang2 | join - $tmp.tcc > $tmp.all
awk '$2 >= 10000 { m += 1; for (k = 3; k <= 7; k += 1) l[k] += log(($k > 0 ? $k : 1) / $2) } END { printf "per program, the %d programs Tier 0 runs 10,000 or more instructions past startup in, geometric mean of each build against Tier 0: t1 %.3f, t1s %.3f, clang0 %.3f, clang2 %.3f, tcc %.3f\n", m, exp(l[3] / m), exp(l[4] / m), exp(l[5] / m), exp(l[6] / m), exp(l[7] / m) }' $tmp.all
echo "the programs past 100,000 (program, t0 t1 t1s clang0 clang2 tcc):"
awk '$2 >= 100000' $tmp.all | sort -k2 -n -r
rm -f $tmp.*
echo
echo "## speedtest1: ms, median of 11 rounds (range); perf stat (M); hash; static counts"
for b in $builds; do
    awk -v b=$b '$2 == b { print $3 }' $dir/st/run.times > $tmp
    printf "%s: %s [%s, %s]; %s; %s\n" "$b" "$(median $tmp)" "$(stat_of $dir/st/stat-$b.txt instructions)" "$(stat_of $dir/st/stat-$b.txt cycles)" "$(grep -h "^Verification Hash\|hash" $dir/st/verify-$b.txt 2>/dev/null | head -1)" "$(cat $dir/st/count-$b.txt 2>/dev/null)"
done
rm -f $tmp
