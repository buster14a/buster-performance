#!/usr/bin/env bash
# diff-summary.sh TREE: each #142 case of diff.sh's campaigns, a line: the case, its failure's signature (or "passed"),
# and for clang -O0, clang -O2, Tier 0 and Tier 1 each run's status and its output's SHA-256 prefix; then whether the
# runs that completed agree, and the totals.
set -u
cd ~/buster-fast-bench/claude-178-remat/diff-$1 || exit 1
for d in chunk-*/campaign-*/csmith-* chunk-*/campaign-*/yarpgen-*; do
    [ -d "$d" ] || continue
    signature=$(cat $d/failure.signature 2>/dev/null)
    line="$(basename $d) ${signature:-passed}"
    outputs=""
    for s in clang-o0 clang-o2 buster-tier0 buster-tier1; do
        status=$(grep -o '"status":"[a-z_-]*"' $d/$s-run.json 2>/dev/null | head -1 | cut -d'"' -f4)
        hash=$([ "$status" = ok ] && sha256sum < $d/$s-run.stdout | cut -c1-12 || echo -)
        line="$line $s=${status:-none}:$hash"
        [ "$hash" != - ] && outputs="$outputs $hash"
    done
    distinct=$(echo $outputs | tr ' ' '\n' | grep -v '^$' | sort -u | wc -l)
    echo "$line agree=$([ $distinct -le 1 ] && echo yes || echo NO)"
done > summary.txt
cat summary.txt
echo "cases: $(wc -l < summary.txt), passed: $(grep -c ' passed ' summary.txt), disagreeing: $(grep -c 'agree=NO' summary.txt)"
echo "Tier 1 runs that completed: $(grep -c 'buster-tier1=ok' summary.txt), Tier 0's: $(grep -c 'buster-tier0=ok' summary.txt)"
