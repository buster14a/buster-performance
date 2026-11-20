#!/usr/bin/env bash
set -euo pipefail
root=$(realpath "$1")
normal=(n64 n128 units units-reversed calls calls-reversed entry-alias weak-entry weak-strong strong-weak duplicate missing no-main no-body step-limit)
for variant in head base-probe head-probe; do
    for name in "${normal[@]}"; do
        for field in status out err; do
            cmp "$root/base/$name.$field" "$root/$variant/$name.$field"
        done
    done
done
for file in "$root/native/"*; do
    cmp "$file" "$root/head/${file##*/}"
done
edges=(original first middle last first-interior aligned-interior last-interior one-past below zero max unrelated beyond-u32)
for edge in "${edges[@]}"; do
    name=edge-$edge
    for field in status out err; do
        cmp "$root/base-probe/$name.$field" "$root/head-probe/$name.$field"
    done
done
traces=("$root/base-probe/"*.trace)
[[ ${#traces[@]} == 28 ]]
for before in "${traces[@]}"; do
    after="$root/head-probe/${before##*/}"
    diff -u <(sed '/^work /d' "$before") <(sed '/^work /d' "$after")
done
for name in n64 n128; do
    echo "$name"
    for variant in base-probe head-probe; do
        trace="$root/$variant/$name.trace"
        tail -2 "$trace"
        read -r bodies symbols equalities < <(sed -n -E 's/^program bodies=([0-9]+) .*/\1/p; s/^work symbols=([0-9]+) body_equalities=([0-9]+)/\1 \2/p' "$trace" | xargs)
        [[ $bodies == "${name#n}" ]]
        if [[ $variant == base-probe ]]; then
            (( equalities == bodies * symbols ))
        else
            (( equalities == symbols ))
        fi
    done
done
for name in duplicate missing no-main no-body step-limit; do
    [[ $(cat "$root/head/$name.status") == 125 ]]
done
for edge in first middle last original; do
    [[ $(cat "$root/head-probe/edge-$edge.status") == 23 ]]
done
for edge in first-interior aligned-interior last-interior one-past below max unrelated beyond-u32; do
    [[ $(cat "$root/head-probe/edge-$edge.status") == 125 ]]
    grep -q 'body=4294967295 null=0 native_count=0 ready=0' "$root/head-probe/edge-$edge.trace"
done
[[ $(cat "$root/head-probe/edge-zero.status") == 23 ]]
grep -q 'body=4294967295 null=1 native_count=0 ready=1' "$root/head-probe/edge-zero.trace"
for pair in 'original 1' 'first 0' 'middle 2' 'last 3'; do
    read -r edge mapped <<< "$pair"
    grep -q "^symbol unit=0 id=2 body=$mapped null=0 native_count=0 ready=1$" "$root/head-probe/edge-$edge.trace"
done
normalize_suite() {
    sed -E 's@/tmp/ssa-source-[a-zA-Z0-9]+@/tmp/ssa-source-<run>@g' "$1"
}
diff -u <(normalize_suite "$root/base-correctness.txt") <(normalize_suite "$root/head-correctness.txt")
echo "All comparisons passed."
