#!/bin/bash
# job1.sh: main (m4, e62535f) and its profile-guided build (pgo, trained on the shadow of sqlite3.c alone), then three
# rounds of time-g.sh (sqlite3.c and Lua, one hold a round), two of time-musl.sh, and profiles of cycles and of
# instruction-cache misses by address for both.
set -u
cd "$(dirname "$0")"
./build-label.sh m4 e62535f > results/m4-build.out 2>&1
./build-pgo.sh pgo e62535f train-shadow.sh > results/pgo-build.out 2>&1
for round in 1 2 3; do ./time-g.sh -r$round m4:- pgo:-; done
for round in 1 2; do ./time-musl.sh -r$round m4:- pgo:-; done
for l in m4 pgo; do
    ./hot.sh $l cycles:u cycles 20011
    ./hot.sh $l ic_tag_hit_miss.instruction_cache_miss:u icmiss 2003
    ./hot.sh $l op_cache_hit_miss.op_cache_miss:u opmiss 2003
done
date -u +%FT%TZ > results/.job1-done
