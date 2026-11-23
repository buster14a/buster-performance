#!/bin/bash
# e2e.sh ROUNDS GROUP...: #1668's whole drivers: main's and the candidate's builds (main/, cand/) by time-runs, a fresh
# process each run in a Williams design's order, -c of each unit with --deferred-bodies and without (source order;
# -fsyntax-only reads every unit in source order), 11 runs a round, each GROUP (space-separated units) of a round in a
# lock hold of its own, the groups' order rotating by round, unpinned (every CPU, as a compile runs). logs/e2e.log.
set -u
D=~/buster-fast-bench/1667-claude
export EXCLUSIVE_OWNER=claude-1667 EXCLUSIVE_TITLE="buster #1668: a dominant body's unit in source order (whole drivers)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1668
if [ "${1:-}" = inner ]; then
    shift
    C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
    gnu17=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
    unset CPATH C_INCLUDE_PATH
    export SOURCE_DATE_EPOCH=1792454400
    round=$1
    shift
    mkdir -p /tmp/e2e-1667
    for unit in "$@"; do
        case "$unit" in
            sqlite) file="$C/sqlite/sqlite3.c"; options=("${gnu17[@]}") ;;
            syn/*) file="$D/synthetic/${unit#syn/}"; options=("${gnu17[@]}") ;;
            lua/*) file="$D/lua-5.4.7/src/${unit#lua/}"; options=("${gnu17[@]}" -I "$D/lua-5.4.7/src") ;;
        esac
        echo "== round $round unit $unit $(date -Is)"
        "$D/main/build/compiler" time-runs --runs 11 --build main "$D/main/build/compiler" --build cand "$D/cand/build/compiler" \
            --list -c --deferred-bodies -w -o /tmp/e2e-1667/out.o "${options[@]}" "$file" \
            --list -c -w -o /tmp/e2e-1667/out.o "${options[@]}" "$file"
        echo "exit=$? $(date -Is)"
    done
    exit 0
fi
rounds=$1
shift
groups=("$@")
for ((round = 1; round <= rounds; round++)); do
    n=${#groups[@]}
    for ((i = 0; i < n; i++)); do
        read -r -a units <<< "${groups[$(((i + round - 1) % n))]}"
        ~/buster-fast-bench/exclusive.sh "$D/scripts/e2e.sh" inner "$round" "${units[@]}" >> "$D/logs/e2e.log" 2>&1
        echo "$(date -Is) status=$? round=$round" >> "$D/logs/e2e.queue"
    done
done
echo "done $(date -Is)" >> "$D/logs/e2e.queue"
