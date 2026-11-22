#!/usr/bin/env bash
# identity.sh: identity-run.sh under one hold, then the comparison.
set -uo pipefail
. "$HOME/buster-fast-bench/3022-claude/env.sh"
cd "$W"
"$LOCK" "$W/held.sh" "$W/identity-run.sh"
out="$W/identity"
sha256sum bin/base bin/head "$out"/base.o "$out"/head.o "$out"/base.stderr "$out"/head.stderr "$out"/base.stdout "$out"/head.stdout
wc -c "$out"/base.o "$out"/head.o "$out"/base.stderr "$out"/head.stderr
if cmp "$out/base.o" "$out/head.o"; then echo "objects: identical"; else echo "objects: DIFFER"; fi
if cmp "$out/base.stderr" "$out/head.stderr" && cmp "$out/base.stdout" "$out/head.stdout"; then echo "diagnostics: identical"; else echo "diagnostics: DIFFER"; fi
touch identity.done
