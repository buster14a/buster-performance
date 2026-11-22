#!/bin/bash
# The scan of a body's tokens (90c42e997): its ticks in place and the verdicts' table; and where the machine's run goes,
# by symbol: the walk's nodes' machine alone (--front --front-types --front-tests --front-sweeps) and with the piece.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh 90c42e997
./alone-split.sh 90c42e997 7
./profile-alone.sh walk-90c42e997 90c42e997 "--front --front-types --front-tests --front-sweeps"
./profile-alone.sh alone-90c42e997 90c42e997 "--front-alone"
echo job-complete
