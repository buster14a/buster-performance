#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "$1")
records=$(realpath -m "$2")
root=$PWD
mkdir -p "$records"
sandbox=$(mktemp -d)
cd "$sandbox"
mkdir sys
printf 'int user_header(void);\n' > u.h
printf 'int system_header(void);\n' > sys/s.h
cat > a.c <<'C'
#include "u.h"
#include <s.h>
int value(void) { return 42; }
C
cp a.c stdin.c
cat > 'a #$.c' <<'C'
#include "h\ #$.h"
int escaped(void) { return 7; }
C
: > 'h\ #$.h'
cat > 'b #$.c' <<'C'
#include "h #$.h"
int escaped(void) { return 7; }
C
: > 'h #$.h'
: > empty
successes=0
spellings=0
failures=0
compare_rule()
{
    local name=$1 channel=$2 input=$3
    shift 3
    local exe status bin
    for bin in buster clang; do
        exe=$compiler
        if [[ $bin == clang ]]; then exe=clang; fi
        rm -f result.d obj.o a.o
        status=0
        "$exe" "$@" < "$input" > "stdout-$bin" 2> "stderr-$bin" || status=$?
        printf '%d\n' "$status" > "$name-$bin.status"
        if [[ $status != 0 ]]; then echo "$name: $bin status=$status"; cat "stderr-$bin"; return 1; fi
        if [[ $channel == file ]]; then
            test ! -s "stdout-$bin"
            cp result.d "rule-$bin"
        else
            test ! -e result.d
            cp "stdout-$bin" "rule-$bin"
        fi
        test -s "rule-$bin"
        if [[ $bin == buster && -f obj.o ]]; then cp obj.o "$records/$name.o"; fi
    done
    cmp "$name-buster.status" "$name-clang.status"
    if [[ $name == *-backslash-header ]]; then
        printf '%s\n' 'o: a\ \#$$.c h\\\ \#$$.h' 'h\\\ \#$$.h:' > want-buster
        printf '%s\n' 'o: a\ \#$$.c h/\ \#$$.h' 'h/\ \#$$.h:' > want-clang
        cmp want-buster rule-buster
        cmp want-clang rule-clang
        cp rule-clang "$records/$name.clang.make"
        spellings=$((spellings+1))
    else
        if ! cmp rule-buster rule-clang; then echo "$name: exact Make output differs"; diff -u rule-clang rule-buster; return 1; fi
        successes=$((successes+1))
    fi
    cp rule-buster "$records/$name.make"
    cp "$name-buster.status" "$records/$name.status"
}
failure()
{
    local name=$1 input=$2
    shift 2
    printf 'preserve the previous rule\n' > before.d
    cp before.d result.d
    local status=0
    "$compiler" "$@" < "$input" > stdout-error 2> stderr-error || status=$?
    test "$status" -eq 1
    test ! -s stdout-error
    test -s stderr-error
    cmp before.d result.d
    printf '%d\n' "$status" > "$records/$name.status"
    cp result.d "$records/$name.make"
    failures=$((failures+1))
}
for mode in M MM MD MMD; do
    action=(-"$mode")
    channel=stdout
    if [[ $mode == MD || $mode == MMD ]]; then action+=(-c -o obj.o -MF result.d); channel=file; fi
    compare_rule "$mode-default" "$channel" empty "${action[@]}" -isystem sys a.c
    compare_rule "$mode-phony" "$channel" empty "${action[@]}" -MP -isystem sys a.c
    compare_rule "$mode-targets" "$channel" empty "${action[@]}" -MP -MT 'r$(X)' -MQ 't\ #$.o' -MT z -isystem sys a.c
    compare_rule "$mode-stdin" "$channel" stdin.c "${action[@]}" -x c -isystem sys -
    compare_rule "$mode-stdin-targets" "$channel" stdin.c "${action[@]}" -MP -MT 'r$(X)' -MQ 't #$.o' -x c -isystem sys -
    compare_rule "$mode-escaped-input" "$channel" empty "${action[@]}" -MP -MT o 'b #$.c'
    compare_rule "$mode-backslash-header" "$channel" empty "${action[@]}" -MP -MT o 'a #$.c'
    stdout_action=(-"$mode")
    if [[ $channel == file ]]; then stdout_action+=(-c -o obj.o); fi
    compare_rule "$mode-mf-stdout" stdout empty "${stdout_action[@]}" -MF - -MP -MT o -isystem sys a.c
done
printf '#include "missing.h"\n' > broken.c
failure missing empty -M -MF result.d broken.c
failure newline empty -M -MF result.d -MT $'bad\ntarget' -isystem sys a.c
printf 'int x = ;\n' > broken.c
failure bad_c empty -c -MD -MF result.d broken.c
failure bad_stdin broken.c -fsyntax-only -x c -MMD -MF result.d -
# An ordinary compile should produce identical objects whether a side depfile is requested or omitted.
"$compiler" -c -isystem sys a.c -o obj.o
cmp obj.o "$records/MD-default.o"
cp obj.o "$records/plain.o"
test "$successes:$spellings:$failures" = "28:4:4"
echo "Exact short-rule Clang matches=$successes independently pinned backslash-header spellings=$spellings failure/status/preservation cases=$failures" | tee "$records/complete"
cd "$root"
