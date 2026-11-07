#!/bin/bash
cd ~/buster-fast-bench/777-claude-cloud
scripts/ab.sh thead tmain t763 synth lua musl sqlite
scripts/tests.sh thead
