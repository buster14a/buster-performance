#!/bin/bash
# job2.sh: the profile-guided build again (pgo2) at 71997da, main e62535f with BUSTER_PGO's instrumented link fixed,
# then three rounds of time-g.sh with main (m4), two of time-musl.sh, and pgo2's profiles.
set -u
cd "$(dirname "$0")"
git -C src fetch -q origin claude/determined-faraday-wul4wj
./build-pgo.sh pgo2 71997da train-shadow.sh > results/pgo2-build.out 2>&1 || { date -u +%FT%TZ > results/.job2-failed; exit 1; }
for round in 1 2 3; do ./time-g.sh -p$round m4:- pgo2:-; done
for round in 1 2; do ./time-musl.sh -p$round m4:- pgo2:-; done
./hot.sh pgo2 cycles:u cycles 20011
./hot.sh pgo2 ic_tag_hit_miss.instruction_cache_miss:u icmiss 2003
./hot.sh pgo2 op_cache_hit_miss.op_cache_miss:u opmiss 2003
date -u +%FT%TZ > results/.job2-done
