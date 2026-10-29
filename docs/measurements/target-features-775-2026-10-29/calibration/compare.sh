#!/usr/bin/env bash
# Future calibration capture for this record's sources and known acceptance classes.
# Usage: compare.sh COMPILER NEW_RECEIPT_DIRECTORY. Never overwrite historical receipts.
# compare-legacy.sh is the byte-preserved script that produced results*.txt; see ../README.md.
set -euo pipefail
if [ "$#" -ne 2 ]; then
    echo "usage: $0 COMPILER NEW_RECEIPT_DIRECTORY" >&2
    exit 2
fi
compiler=$(realpath -- "$1")
clang=$(command -v clang)
here=$(cd "$(dirname "$0")" && pwd)
sources=("$here"/c*.c)
if [ "${#sources[@]}" -ne 18 ]; then
    echo "expected the record's complete set of 18 sources" >&2
    exit 2
fi
receipts=$2
if [ ! -x "$compiler" ] || [ ! -x "$clang" ]; then
    echo "both compiler executables must exist" >&2
    exit 2
fi
mkdir -- "$receipts"
summary="$receipts/summary.txt"
sha256sum "$compiler" "$clang" "$0" "${sources[@]}" "$here"/expected/*.errors > "$receipts/identities.sha256"
"$clang" --version > "$receipts/clang-version.txt" 2>&1
failures=0

# Save the exact command, full combined output and the command's own exit status before filtering.
# A rejected source must exit 1 with an error, not merely return some nonzero status or empty text.
capture()
{
    local name=$1 label=$2 expected=$3 source=$4
    shift 4
    local prefix="$receipts/$name.$label" status
    printf '%q ' "$@" > "$prefix.command"
    printf '\n' >> "$prefix.command"
    if "$@" > "$prefix.output" 2>&1; then
        status=0
    else
        status=$?
    fi
    printf '%s\n' "$status" > "$prefix.status"
    awk -v source="$source" 'index($0, ": error: ") {
        if (index($0, source) == 1) print substr($0, length(source) + 1); else print
    }' "$prefix.output" > "$prefix.errors"
    local valid=yes
    if [ "$status" -ne "$expected" ] ||
       { [ "$expected" -eq 0 ] && [ -s "$prefix.errors" ]; } ||
       { [ "$expected" -eq 1 ] && [ ! -s "$prefix.errors" ]; }; then
        valid=no
        case_invalid=1
    fi
    printf 'expected_status=%s actual_status=%s valid=%s\n' "$expected" "$status" "$valid" > "$prefix.acceptance"
}

for source in "${sources[@]}"; do
    name=$(basename "$source")
    expected_clang=1
    expected_buster=1
    expected_relation=same
    case "$name" in
        c2.c|c3.c|c6.c|c7.c|c8.c) expected_clang=0; expected_buster=0 ;;
        c4.c) expected_buster=0; expected_relation=different ;; # documented semantic-analysis gap, #839
        c12.c) expected_relation=different ;; # documented choice of missing feature
        c1.c|c5.c|c10.c|c11.c|c13.c|c14.c|c15.c|c16.c|c17.c|c18.c|c19.c) ;;
        *) echo "no recorded acceptance class for $name" >&2; exit 2 ;;
    esac
    case_invalid=0
    capture "$name" clang "$expected_clang" "$source" env -u CPATH "$clang" -std=gnu17 -march=x86-64 -w -fno-caret-diagnostics -fno-color-diagnostics -c -o /dev/null "$source"
    capture "$name" buster "$expected_buster" "$source" "$compiler" -std=gnu17 -march=x86-64 -w -c -o /dev/null "$source"
    capture "$name" scalar "$expected_buster" "$source" "$compiler" --scalar -std=gnu17 -march=x86-64 -w -c -o /dev/null "$source"
    if [ "$case_invalid" -ne 0 ]; then
        verdict=INVALID
    elif ! cmp -s "$receipts/$name.buster.errors" "$receipts/$name.scalar.errors"; then
        verdict=DIFFERENT
    elif cmp -s "$receipts/$name.clang.errors" "$receipts/$name.buster.errors"; then
        if [ "$expected_relation" = same ]; then verdict=same; else verdict=UNEXPECTED_MATCH; fi
    elif [ "$expected_relation" = different ] &&
         cmp -s "$receipts/$name.clang.errors" "$here/expected/$name.clang.errors" &&
         { [ "$expected_buster" -eq 0 ] || cmp -s "$receipts/$name.buster.errors" "$here/expected/$name.buster.errors"; }; then
        verdict=EXPECTED_DIFFERENCE
    else
        verdict=DIFFERENT
    fi
    printf '=== %s: %s (expected clang=%s buster=%s scalar=%s, diagnostics=%s)\n' \
        "$name" "$verdict" "$expected_clang" "$expected_buster" "$expected_buster" "$expected_relation" >> "$summary"
    case "$verdict" in same|EXPECTED_DIFFERENCE) ;; *) failures=$((failures + 1)) ;; esac
done
printf 'Unexpected cases: %s\n' "$failures" >> "$summary"
cat "$summary"
[ "$failures" -eq 0 ]
