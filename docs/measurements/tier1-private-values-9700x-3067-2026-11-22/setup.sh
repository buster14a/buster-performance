#!/usr/bin/env bash
# setup.sh: the clone, the merged branch from pr3067.bundle, three worktrees (main; pr, built without the define;
# pron, built with it), and the inputs: the frozen corpus's files of the Zen 4 record's lists (checked by SHA-256)
# and Lua 5.4.8 from CI's cached archive.
set -euo pipefail
. "$HOME/buster-fast-bench/3067-claude/env.sh"
cd "$W"
if [ ! -d repo ]; then
    git clone -q https://github.com/buster14a/buster.git repo
fi
git -C repo fetch -q origin main codex/tier1-private-values-zen4
git -C repo bundle verify "$W/pr3067.bundle"
git -C repo fetch -q "$W/pr3067.bundle" codex/tier1-private-values-zen4:refs/heads/pr3067-merged
test "$(git -C repo rev-parse pr3067-merged)" = "$MERGE"
git -C repo cat-file -e "$MAIN^{commit}"
for t in main pr pron; do
    rev=$MERGE
    if [ "$t" = main ]; then rev=$MAIN; fi
    if [ ! -d "$t" ]; then
        git -C repo worktree add -q --detach "../$t" "$rev"
    fi
    test "$(git -C "$t" rev-parse HEAD)" = "$rev"
    git -C "$t" rev-parse HEAD > "$t/COMMIT"
done
# Lua 5.4.8, as the earlier records took it.
mkdir -p inputs/lua
archive="$HOME/.cache/buster/ci/downloads/4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae"
echo "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae  $archive" | sha256sum -c
tar -xzf "$archive" -C inputs/lua --strip-components=2 --wildcards 'lua-5.4.8/src/*'
ln -sfn "$CORPUS/sqlite/sqlite3.c" inputs/sqlite3.c
# The Zen 4 record's input lists, each file checked against its SHA-256 there.
for c in sqlite lua musl; do
    case $c in
        sqlite) root="$CORPUS/sqlite" ;;
        lua) root="$W/inputs/lua" ;;
        musl) root="$CORPUS/libc/musl" ;;
    esac
    awk -F '\t' -v root="$root" 'NR > 1 { print $3 "  " root "/" $1 }' "zen4-inputs/$c.inputs.tsv" | sha256sum -c --quiet
    awk -F '\t' -v root="$root" 'NR > 1 { print root "/" $1 }' "zen4-inputs/$c.inputs.tsv" > "inputs/$c.files"
    echo "$c: $(wc -l < "inputs/$c.files") files match the Zen 4 record's SHA-256"
done
touch setup.done
