#!/usr/bin/env bash
# lockwrap.sh COMMAND...: ab's --lock for the one-core runs (ab --cpu 2 pins them): the 9700X's lock, with held.sh's
# record inside each hold.
. "$HOME/buster-fast-bench/3067-claude/env.sh"
exec "$LOCK" "$W/held.sh" "$@"
