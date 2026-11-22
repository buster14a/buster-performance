#!/usr/bin/env bash
# lockwrap6.sh COMMAND...: ab's --lock for the six-core runs: the 9700X's lock, then CPUs 2 to 7 (one thread of each of
# six physical cores), with held.sh's record inside each hold.
. "$HOME/buster-fast-bench/3067-claude/env.sh"
exec "$LOCK" taskset -c 2-7 "$W/held.sh" "$@"
