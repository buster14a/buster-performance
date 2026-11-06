#!/usr/bin/env bash
# #1340: pre-#1049, main, the walks commit (ac819d97) and head on sq-c/sq-syn and self-syn, through tools/microarch;
# then cycles:u profiles of head's sq-c, 8 compiles on CPU 2, under the lock.
set -u
cd ~/buster-fast-bench/1340-droid || exit 2
echo $$ > run2.pid
export ROOT=$PWD/root MICROARCH_OWNER=droid-1340 MICROARCH_TITLE="droid #1340 common warnings cost" \
    MICROARCH_LINK=https://github.com/buster14a/buster/issues/1340 BUILD_ARCHES=znver5 SELF_PREPROCESSOR=znver5
H=repo/tools/microarch/hosts/zen5-9700x.sh
R=repo/tools/microarch/run.sh
status=0
"$R" "$H" setup env build-commit walks ac819d97 znver5 || status=1
if [[ $status -eq 0 ]]; then
    B="pre1049-znver5 main-znver5 walks-znver5 znver5"
    AB_NAME=ab1340b AB_BUILDS="$B" "$R" "$H" ab || status=1
    AB_NAME=ab1340b-self AB_BUILDS="$B" "$R" "$H" ab-self || status=1
    "$R" "$H" summarize || status=1
fi
if [[ $status -eq 0 ]]; then
    cd root || exit 2
    SCRATCH=scratch/zen5-9700x
    source ../repo/tools/microarch/workloads.sh
    mkdir -p ../prof2
    workload znver5 sq-c
    printf '%q ' "${WL[@]}" > ../prof2/znver5.cmd
    EXCLUSIVE_OWNER=droid-1340 EXCLUSIVE_TITLE="droid #1340 common warnings cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
        ~/buster-fast-bench/exclusive.sh bash -c '
            head -1 /var/lib/buster-9700x/owner >> ../prof2/holds.txt
            v=znver5
            LC_ALL=C taskset -c 2 perf record -q -e cycles:u -c 50021 -o ../prof2/$v.data -- bash -c "for i in 1 2 3 4 5 6 7 8; do $(cat ../prof2/$v.cmd) || exit 1; done" || exit 1
            LC_ALL=C perf report -i ../prof2/$v.data --no-children --sort sym --stdio -F sample,sym 2>/dev/null | grep -v "^#" | grep -v "^$" > ../prof2/$v.samples.txt' || status=1
    cd .. || exit 2
fi
echo "done status=$status" >> run2.done
