#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# skipprofile.sh: what the skip leaves, by function, inside one hold of the lock: musl's command and the generated
# glibc units (the sources), read and skipped as skip2.sh runs them (the patched build, BUSTER_PROBE_SKIPS unset and
# set), each profiled once as profile.sh profiles a variant: the compile on CPU 2, perf on CPU 5, the leader-sampled
# work group reduced by `uarch symbols`. tools/families.py then groups each table's functions.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/skipprofile
here=$PWD
mkdir -p "$out" scratch/objects-skipprofile
probe=$PWD/src-probe/build/compiler
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sha256sum "$probe" scratch/musl.skips scratch/glibc.skips > "$out/sha256.txt"
profile()
{
    # profile LABEL SKIPS OPTIONS... UNITS...: SKIPS empty for the read run.
    local label=$1 skips=$2; shift 2
    local one
    printf -v one '%q ' taskset -c 2 "$probe" "$@"
    (
        cd scratch/objects-skipprofile || exit 1
        rm -f ./*.o
        if [[ -n $skips ]]; then export BUSTER_PROBE_SKIPS=$skips; fi
        taskset -c 5 perf record -q -o "$here/scratch/skipprofile.data" -e '{cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u}:S' -c 100003 -- bash -c "$one > /dev/null 2>&1" > "$out/$label.record.log" 2>&1
    ) || status=1
    perf script -i scratch/skipprofile.data -F period,event,ip,sym 2>> "$out/$label.record.log" | ./uarch symbols - > "$out/$label.work.tsv" || status=1
    rm -f scratch/skipprofile.data
}
mapfile -t sources < scratch/musl-units.txt
profile musl-read "" "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
profile musl-skipped "$here/scratch/musl.skips" "${musl_options[@]}" --lanes 1 -c "${sources[@]}"
mapfile -t gnames < scratch/glibc-names.txt
gsources=("${gnames[@]/#/$here/scratch/glibc-src/}"); gsources=("${gsources[@]/%/.c}")
profile glibc-read "" --lanes 1 -c "${gsources[@]}"
profile glibc-skipped "$here/scratch/glibc.skips" --lanes 1 -c "${gsources[@]}"
rm -rf scratch/objects-skipprofile
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
