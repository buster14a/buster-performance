#!/bin/bash
# One lock hold around one command: lock.sh LOG COMMAND... Inside the hold it prints a receipt, the lock's owner line
# (this hold's), with the time, then runs the command; exclusive.sh's own messages (waits, busy processes) go to
# LOG.stderr, which the record keeps only as counts.
log=$1; shift
EXCLUSIVE_OWNER=claude-1549 EXCLUSIVE_TITLE="#1549 call initializers in place" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1549 \
    ~/buster-fast-bench/exclusive.sh bash -c 'printf "receipt %s held: %s\n" "$(date -Is)" "$(head -1 /var/lib/buster-9700x/owner)"; exec "$@"' receipt "$@" 2>> "$log.stderr"
