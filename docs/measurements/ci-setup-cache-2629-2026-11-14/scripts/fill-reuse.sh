#!/usr/bin/env bash
# #2629: the 9700X's fetch-performance.sh routes, timed: GitHub alone (as actions/checkout's sparse checkout did),
# then a fresh mirror's fill, then its reuse, for both pinned commits the job reads. Run under exclusive.sh.
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd)
cache=$d/cache
rm -rf "$cache" "$d"/out
mkdir -p "$d"/out
lua=(818cfbbc0be238da287c16d8e2a91fd7275cf228 docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua)
bs=(a00d16e47b6f1090b8a0424ab0dd8cb4e6016713 docs/measurements/x86-lengths-2026-10-23)
time_one()
{
    local label=$1 commit=$2 directory=$3 cachevar=$4 s e files
    s=$(date +%s%N)
    if [ "$cachevar" = none ]; then
        env -u BUSTER_CI_CACHE bash "$d/fetch-performance.sh" "$commit" "$directory" "$d/out/$label"
    else
        BUSTER_CI_CACHE=$cache bash "$d/fetch-performance.sh" "$commit" "$directory" "$d/out/$label"
    fi
    e=$(date +%s%N)
    files=$(find "$d/out/$label/$directory" -type f | wc -l)
    printf '%s\t%s\t%d\t%s\n' "$label" "${commit:0:8}" "$(( (e - s) / 1000000 ))" "$files"
}
printf 'route\tcommit\tms\tfiles\n'
for r in 1 2 3; do
    time_one "github-lua-$r" "${lua[@]}" none
    time_one "github-bs-$r" "${bs[@]}" none
done
time_one fill-lua "${lua[@]}" cache
time_one fill-bs "${bs[@]}" cache
for r in 1 2 3 4 5; do
    time_one "reuse-lua-$r" "${lua[@]}" cache
    time_one "reuse-bs-$r" "${bs[@]}" cache
done
du -sk "$cache/buster-performance.git" | awk '{ print "mirror_kib\t" $1 }'
git -C "$cache/buster-performance.git" for-each-ref --format='%(refname)' refs/pinned
