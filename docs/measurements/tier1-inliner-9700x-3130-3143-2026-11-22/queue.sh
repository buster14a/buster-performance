#!/usr/bin/env bash
# queue.sh: the builds, tests, object identity and A/B in order, each step its own hold(s) of the lock.
set -uo pipefail
. "$HOME/buster-fast-bench/3130-claude/env.sh"
cd "$W"
echo $$ > queue.pid
step() { echo "== step $* $(date -u -Iseconds)"; "$@"; echo "== step $1 exit $? $(date -u -Iseconds)"; }
step ./build-one.sh w3130 Develop 3130-develop
step ./tests.sh w3130 3130-develop
step ./build-one.sh w3143 Develop 3143-develop
step ./tests.sh w3143 3143-develop
step ./build-one.sh main Release main-release
step ./build-one.sh w3130 Release 3130-release
step ./build-one.sh w3143 Release 3143-release
step ./identity.sh
step ./ab.sh 6
touch queue.done
