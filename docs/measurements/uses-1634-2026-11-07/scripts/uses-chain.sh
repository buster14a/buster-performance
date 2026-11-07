#!/bin/bash
# Waits for measure.sh (main's sizing), then runs the whole A/B.
cd "$HOME/buster-fast-bench/uses-claude" || exit 1
while pgrep -f '[m]easure.sh' > /dev/null; do sleep 20; done
./uses-ab.sh build shifts ir source tier1
