#!/bin/bash
# compare.sh CORPUS LANES "OPTIONS A" "OPTIONS B": the corpus (musl or glibc) compiled locally both ways, each in its own
# directory under the scratchpad's cmp/, then every object and the diagnostics compared.
S=/tmp/claude-0/-home-user/17548c52-aa06-599d-a6bd-e5e939dd75e5/scratchpad
corpus=$1 lanes=$2 a=$3 b=$4
compile()
{
    local dir=$1
    shift
    rm -rf "$S/cmp/$dir"
    mkdir -p "$S/cmp/$dir"
    if [ "$corpus" = musl ]; then
        (cd "$S/cmp/$dir" && bash "$S/musl.sh" --lanes "$lanes" "$@" > "$S/cmp/$dir.err" 2>&1)
    else
        (cd "$S/cmp/$dir" && /home/user/buster/build/compiler --lanes "$lanes" "$@" -c "$S"/glibc-src/*.c > "$S/cmp/$dir.err" 2>&1)
    fi
}
# shellcheck disable=SC2086
compile a $a
# shellcheck disable=SC2086
compile b $b
different=0
for f in "$S/cmp/a"/*.o; do
    cmp -s "$f" "$S/cmp/b/${f##*/}" || different=$((different + 1))
done
diagnostics=different
cmp -s <(grep -v -e '^time-' -e '^attested declarations' "$S/cmp/a.err") <(grep -v -e '^time-' -e '^attested declarations' "$S/cmp/b.err") && diagnostics=same
echo "$corpus lanes=$lanes [$a] vs [$b]: $(ls "$S/cmp/a" | wc -l) and $(ls "$S/cmp/b" | wc -l) objects, $different different; diagnostics $diagnostics ($(grep -c 'warning:' "$S/cmp/a.err") warnings)"
