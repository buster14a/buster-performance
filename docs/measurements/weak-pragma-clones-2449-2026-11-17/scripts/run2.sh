#!/bin/bash
# Waits for the first base build (started by builds.sh before its wrapper was stopped), then builds both trees at their
# pinned commits (an up-to-date tree builds in seconds) and measures.
cd ~/buster-fast-bench/2449-claude
while kill -0 1335240 2>/dev/null; do sleep 5; done
./builds.sh && ./measure.sh
