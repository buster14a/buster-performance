#!/bin/bash
# The refine experiment (masked loads only, the existing fallback path): build (znver5), the objects, counters against
# main (10 rounds), its profile of line-crossing loads. CPU 2.
cd ~/buster-fast-bench/1555-claude/refine && env BUSTER_HOST_ARCH=znver5 ./build.sh > ../stage5-build.log 2>&1 && cp build/compiler ../run/bin/compiler-refine || { echo "build FAILED"; exit 1; }
cd ~/buster-fast-bench/1555-claude/run
source ../main/tools/microarch/workloads.sh
SCRATCH=scratch
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
for v in main refine; do workload $v sq-c; taskset -c 2 "${WL[@]}" > /dev/null 2> scratch/$v-sq-c-objcheck.err; echo "$v exit=$?"; done
cmp scratch/main-sq.o scratch/refine-sq.o && cmp scratch/main-sq-c-objcheck.err scratch/refine-sq-c-objcheck.err && echo "sq-c: same object and diagnostics"
./counters.sh 10 main refine
./profile.sh refine ls_misal_loads.ma64:u 997
echo stage5-done
