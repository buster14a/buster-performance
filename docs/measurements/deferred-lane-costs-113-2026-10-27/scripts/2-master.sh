#!/bin/bash
# After the tests (tests.sh), the confirmation campaigns (chain.sh), then the mutants (mutants/chain.sh, a 120 s
# timeout for test-checker-deferred): one script at a time, so that this session holds the lock for one thing at a time.
D=/home/david/buster-fast-bench/113-lanes-cloud
echo $$ > "$D/master.pid"
while kill -0 "$(cat "$D/tests.pid")" 2> /dev/null; do
    sleep 5
done
"$D/chain.sh"
"$D/mutants/chain.sh" 120
echo "master done $(date -Is)" >> "$D/master.txt"
