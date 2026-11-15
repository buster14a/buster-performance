#!/bin/bash
# provisional.sh EXE OUT: c-testsuite's subset, main.c and the checker's fixtures by EXE's -c and --provisional-selection -c;
# OUT/NAME.txt a line a unit: its path, whether the objects are the same bytes (or both missing), both exit statuses, whether
# both stderr are the same but for the option's line, and the option's report.
set -u
exe=$1 out=$2
EXTRA=${EXTRA:-}
mkdir -p "$out/o"
one()
{
    local name=$1 directory=$2 f=$3
    shift 3
    local b=$name.$(echo "$f" | tr '/' '_')
    (cd "$directory" && "$exe" --lanes 1 $EXTRA "$@" -c "$f" -o "$out/o/$b.p.o" 2> "$out/o/$b.p.err" < /dev/null; echo $? > "$out/o/$b.p.status")
    (cd "$directory" && "$exe" --provisional-selection --lanes 1 $EXTRA "$@" -c "$f" -o "$out/o/$b.v.o" 2> "$out/o/$b.v.err" < /dev/null; echo $? > "$out/o/$b.v.status")
    local objects=different
    cmp -s "$out/o/$b.p.o" "$out/o/$b.v.o" && objects=same
    [ -f "$out/o/$b.p.o" ] || [ -f "$out/o/$b.v.o" ] || objects=none
    local errs=different
    cmp -s "$out/o/$b.p.err" <(grep -vP '^provisional-selection\t' "$out/o/$b.v.err") && errs=same
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "${f#/home/user/}" "$objects" "$(cat "$out/o/$b.p.status")" "$(cat "$out/o/$b.v.status")" "$errs" "$(grep -P '^provisional-selection\t' "$out/o/$b.v.err" | tr '\t' ' ')"
    rm -f "$out/o/$b".*
}
export -f one
export exe out EXTRA
run()
{
    local name=$1 directory=$2 files=$3
    shift 3
    xargs -P "$(nproc)" -I{} bash -c 'one "$@"' _ "$name" "$directory" {} "$@" < "$files" | sort > "$out/$name.txt"
}
sed -n 's|^\([0-9][0-9]*\)$|/home/user/buster/build/c-testsuite/tests/single-exec/\1.c|p' /home/user/buster/tests/c-testsuite/subset.txt > "$out/ct.files"
echo /home/user/buster/src/buster/compiler/main.c > "$out/main.files"
find /home/user/buster/tests/checker -name "*.c" | sort > "$out/checker.files"
run ct /home/user/buster/build/c-testsuite "$out/ct.files"
run main /home/user/buster "$out/main.files" -march=native -Isrc -fwrapv -funsigned-char
run checker /home/user/buster "$out/checker.files"
