#!/bin/bash
# chain594.sh: after setup594.sh (its PID file), the executables' objects (setup594b.sh), then the sweep by main (v0),
# four passes.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > chain594.pid
setup=$(cat setup594.pid)
while kill -0 "$setup" 2>/dev/null; do
    sleep 5
done
./setup594b.sh
./sweep594.sh v0 4 > sweep594-v0.out 2>&1
echo "chain done $(date -Is)" >> setup594.log
