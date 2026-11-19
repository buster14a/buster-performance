#!/usr/bin/env bash
set -euo pipefail
linker=$(realpath "$1")
inputs=$(realpath "$2")
out=$3
mkdir -p "$out"
out=$(realpath "$out")
cd "$inputs"
for kind in libgcc ordinary unique duplicate malformed probe; do
    args=(--lanes 1 -static --merge-strings)
    case "$kind" in
        libgcc) args+=(entry.o libgcc-popcount.o); expected=8 ;;
        ordinary|unique) args+=(entry.o libgcc-popcount.o "$kind.o"); expected=8 ;;
        duplicate) args+=(first.o second.o); expected=42 ;;
        malformed) args+=(entry.o libgcc-popcount.o malformed.o); expected=1 ;;
        probe)
            args=(--lanes 1 -pie --merge-strings "$(cc -print-file-name=Scrt1.o)" "$(cc -print-file-name=crti.o)" "$(cc -print-file-name=crtbeginS.o)" probe.o "$(cc -print-libgcc-file-name)" -L/usr/lib/x86_64-linux-gnu -lc "$(cc -print-file-name=crtendS.o)" "$(cc -print-file-name=crtn.o)")
            expected=0 ;;
    esac
    link_status=0
    "$linker" link-foreign "${args[@]}" -o "$out/$kind.elf" 2>"$out/$kind.err" || link_status=$?
    printf 'CASE %s link=%s\n' "$kind" "$link_status"
    cat "$out/$kind.err"
    if [ "$kind" = malformed ]; then
        test "$link_status" -ne 0
        test ! -e "$out/$kind.elf"
    else
        test "$link_status" = 0
        status=0
        "$out/$kind.elf" > "$out/$kind.stdout" || status=$?
        printf 'RUN %s status=%s ' "$kind" "$status"
        sha256sum "$out/$kind.elf"
        test "$status" = "$expected"
        if [ "$kind" = probe ]; then cmp "$out/$kind.stdout" expected-probe; fi
    fi
done
