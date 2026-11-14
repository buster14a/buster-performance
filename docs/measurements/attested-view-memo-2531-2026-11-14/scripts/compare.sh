#!/bin/bash
# compare.sh COMPILER CORPUS LANES "OPTIONS A" "OPTIONS B": -c of the corpus each way, in one directory name, then
# every object and the diagnostics compared.
set -u
. "$HOME/.cache/claude-2531/bin/common.sh"
compiler=$1 corpus=$2 lanes=$3 a=$4 b=$5
work=$HOME/.cache/claude-2531/work
mapfile -t musl_list < <(musl_units)
run()
{
    local dir=$1; shift
    rm -rf "$work" "$dir"; mkdir -p "$work"
    if [ "$corpus" = musl ]; then
        (cd "$work" && "$compiler" "${musl_options[@]}" "$@" --lanes "$lanes" -c "${musl_list[@]}" > /dev/null 2> "$dir.err"; echo $? > "$dir.status")
    else
        (cd "$work" && "$compiler" "$@" --lanes "$lanes" -c "${glibc_sources[@]}" > /dev/null 2> "$dir.err"; echo $? > "$dir.status")
    fi
    mv "$work" "$dir"
}
A=$HOME/.cache/claude-2531/out-a B=$HOME/.cache/claude-2531/out-b
# shellcheck disable=SC2086
run "$A" $a
# shellcheck disable=SC2086
run "$B" $b
same=0 different=0
for f in "$A"/*.o; do
    if cmp -s "$f" "$B/${f##*/}"; then same=$((same + 1)); else different=$((different + 1)); echo "different ${f##*/}"; fi
done
diag=different
if cmp -s <(grep -v -e '^time-' -e '^attested declarations' -e '^worker-budget' "$A.err") <(grep -v -e '^time-' -e '^attested declarations' -e '^worker-budget' "$B.err"); then diag=same; fi
echo "$corpus lanes=$lanes [$a] vs [$b]: status $(cat "$A.status") $(cat "$B.status"); objects same=$same different=$different of $(ls "$A" | wc -l)/$(ls "$B" | wc -l); diagnostics $diag ($(grep -c 'warning:' "$A.err") warnings, $(grep -c 'error:' "$A.err") errors)"
grep -h '^attested declarations' "$A.err" "$B.err" | head -2
