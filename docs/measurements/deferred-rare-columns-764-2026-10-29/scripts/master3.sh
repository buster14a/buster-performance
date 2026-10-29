#!/bin/bash
# #764's third chain: waits for master2b (its PID, the argument), then campaign W5 (later readings, --warm: diag9's units
# and sqlite3.c on 8 lanes with every lane, the head and main, five rounds, a round a lock hold), S5 (sqlite3.c by the
# rule, six pairs) and the head's corpus tests.
. ~/buster-fast-bench/claude-764/scripts/env.sh
while kill -0 "$1" 2>/dev/null; do sleep 10; done
"$D/scripts/queue.sh" scripts/w5.jobs logs/W5.txt 1 0 5 7 30
"$D/scripts/s5.sh" head-3b87d0c9 main-bc11fddb
"$D/scripts/corpus.sh" head-3b87d0c9
echo "master3 done $(date -Is)" >> "$D/logs/chain.txt"
