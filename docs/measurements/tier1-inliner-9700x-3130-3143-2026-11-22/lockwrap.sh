#!/usr/bin/env bash
# lockwrap.sh COMMAND...: ab's --lock: the 9700X's lock, with held.sh's record inside each hold.
. "$HOME/buster-fast-bench/3130-claude/env.sh"
exec "$LOCK" "$W/held.sh" "$@"
