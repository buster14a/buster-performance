#!/usr/bin/env bash
# queue.sh: setup, the Develop builds and their tests (define off, then on), the Release builds, object identity and
# the A/B in order, each build, test shard and timed process its own hold of the lock.
set -uo pipefail
. "$HOME/buster-fast-bench/3067-claude/env.sh"
cd "$W"
echo $$ > queue.pid
step() { echo "== step $* $(date -u -Iseconds)"; "$@"; local s=$?; echo "== step $1 exit $s $(date -u -Iseconds)"; return $s; }
test -f setup.done || exit 1
step ./build-one.sh pr Develop off-develop "" || exit 1
step ./tests.sh pr off-develop
step ./build-one.sh pron Develop on-develop "$DEFINE" || exit 1
step ./tests.sh pron on-develop
step ./build-one.sh pr Release off-release "" || exit 1
step ./build-one.sh pron Release on-release "$DEFINE" || exit 1
step ./build-one.sh main Release main-on-release "$DEFINE" || exit 1
cp "$HOME/buster-fast-bench/3130-claude/bin/main-release" bin/main-release
echo "49902798fde7941661006057c6841bb624bf787084ce784dea413a6906c8fea3  bin/main-release" | sha256sum -c || exit 1
step ./identity.sh
step ./ab.sh 6
touch queue.done
