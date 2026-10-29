#!/usr/bin/env bash
# #775's calibration cases: each one's errors at -c, by this compiler (both paths) and by clang, at -march=x86-64,
# with the source path cut from each line. $1: this compiler's executable; the cases are the .c files beside this script.
set -uo pipefail
compiler="$1"
here="$(cd "$(dirname "$0")" && pwd)"
echo "clang $(clang --version | head -1)"
echo "compiler $(sha256sum "$compiler" | cut -d' ' -f1)"
for source in "$here"/c*.c; do
    name=$(basename "$source")
    theirs=$(env -u CPATH clang -std=gnu17 -march=x86-64 -w -fno-caret-diagnostics -fno-color-diagnostics -c -o /dev/null "$source" 2>&1 | grep ': error: ' | sed "s|^$source||")
    ours=$("$compiler" -std=gnu17 -march=x86-64 -w -c -o /dev/null "$source" 2>&1 | grep ': error: ' | sed "s|^$source||")
    scalar=$("$compiler" --scalar -std=gnu17 -march=x86-64 -w -c -o /dev/null "$source" 2>&1 | grep ': error: ' | sed "s|^$source||")
    if [ "$ours" = "$theirs" ] && [ "$scalar" = "$ours" ]; then verdict=same; else verdict=DIFFERENT; fi
    echo "=== $name: $verdict"
    echo "clang:"
    printf '%s\n' "${theirs:-(no error)}"
    if [ "$verdict" != same ]; then
        echo "buster:"
        printf '%s\n' "${ours:-(no error)}"
        echo "buster --scalar:"
        printf '%s\n' "${scalar:-(no error)}"
    fi
done
