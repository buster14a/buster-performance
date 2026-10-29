#!/bin/bash
# Sends main's and the head's trees (git archive of named commits, each with a COMMIT file) and the scripts to the 9700X.
# Usage: send.sh MAIN_COMMIT HEAD_COMMIT
set -e
main=$1
head=$2
cd /home/david/.cache/claude-221/wt-141
B='~/buster-fast-bench/tier1-select-141-claude'
mn=main-$(git rev-parse --short=8 $main)
hn=head-$(git rev-parse --short=8 $head)
tailscale ssh david@benchpress "mkdir -p $B/trees/$mn $B/trees/$hn $B/m && echo $mn > $B/main.name && echo $hn > $B/head.name"
git archive $main | tailscale ssh david@benchpress "tar xf - -C $B/trees/$mn && echo $(git rev-parse $main) > $B/trees/$mn/COMMIT"
git archive $head | tailscale ssh david@benchpress "tar xf - -C $B/trees/$hn && echo $(git rev-parse $head) > $B/trees/$hn/COMMIT"
tar cf - -C /home/david/.cache/claude-221/bench141 env.sh all.sh | tailscale ssh david@benchpress "tar xf - -C $B && chmod +x $B/*.sh && ls -la $B $B/trees"
