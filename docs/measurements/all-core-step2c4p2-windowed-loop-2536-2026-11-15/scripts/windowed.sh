#!/bin/bash
# windowed.sh EXE OUT [OPTIONS...]: c-testsuite's subset, main.c and the checker's fixtures by EXE's -c and by its
# --windowed-loop -c at --emit-window=1, 2048 and 0 (W = ∞), each with OPTIONS. OUT/NAME.txt a line a unit: its path, then
# for each W whether the object (or both missing), the stderr but the options' lines and the exit status are the plain
# compile's, and its windowed-loop report.
set -u
exe=$1 out=$2
shift 2
export EXTRA="$*"
mkdir -p "$out/o"
one()
{
    local name=$1 directory=$2 f=$3
    shift 3
    local b=$name.$(echo "$f" | tr '/' '_')
    (cd "$directory" && "$exe" --lanes 1 $EXTRA "$@" -c "$f" -o "$out/o/$b.p.o" 2> "$out/o/$b.p.err" < /dev/null; echo $? > "$out/o/$b.p.status")
    local line="${f#/home/user/}"
    for w in 1 2048 0; do
        (cd "$directory" && "$exe" --windowed-loop --emit-window=$w --lanes 1 $EXTRA "$@" -c "$f" -o "$out/o/$b.$w.o" 2> "$out/o/$b.$w.err" < /dev/null; echo $? > "$out/o/$b.$w.status")
        local objects=different
        cmp -s "$out/o/$b.p.o" "$out/o/$b.$w.o" && objects=same
        [ -f "$out/o/$b.p.o" ] || [ -f "$out/o/$b.$w.o" ] || objects=none
        local rest=different
        cmp -s "$out/o/$b.p.err" <(grep -vP '^(provisional-selection|windowed-loop)\t' "$out/o/$b.$w.err") && [ "$(cat "$out/o/$b.p.status")" = "$(cat "$out/o/$b.$w.status")" ] && rest=same
        line="$line	W$w $objects/$rest $(grep -P '^windowed-loop\t' "$out/o/$b.$w.err" | cut -f3)"
    done
    printf '%s\n' "$line"
    rm -f "$out/o/$b".*
}
export -f one
export exe out
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
