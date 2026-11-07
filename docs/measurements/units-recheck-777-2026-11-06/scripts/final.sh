#!/bin/bash
# The rest of #777's re-check after measure.sh: profile.sh, attribute.sh's corpora, peaks.sh, each a hold of its own.
cd $(dirname $0)
./profile.sh tmain t763
./attribute.sh tmain t763 lua synth musl
./peaks.sh tmain t763
echo final-finished
