#!/bin/bash
# Regenerates the 38 synthetic units of the deferred-lane-costs-113-2026-10-27 record from their names, with that
# record's gen2.c, and checks them against its synthetic.sha256.
set -eu
cd "$(dirname "$0")"
clang -O2 -o gen2 gen2.c
for f in $(awk '$2 != "gen2.c" { print $2 }' synthetic.sha256); do
    n=${f%.c}
    kind=${n:0:1}
    rest=${n:1}
    bodies=${rest%%x*}
    rest=${rest#*x}
    stanzas=${rest%%[fs]*}
    first=""
    second=""
    if [[ $rest == *f* ]]; then first=${rest#*f}; first=${first%%s*}; fi
    if [[ $rest == *s* ]]; then second=${rest#*s}; fi
    case $kind in
        h|l|d) mode=- ;;
        b) mode=bare ;;
        x) mode=heavy ;;
    esac
    args=("$bodies" "$stanzas" "$mode")
    [ -n "$first" ] && args+=("$first")
    [ -n "$second" ] && args+=("$second")
    ./gen2 "${args[@]}" > "$f"
done
grep -v ' gen2.c$' synthetic.sha256 | sha256sum -c --quiet && echo "synthetic: 38 units match"
