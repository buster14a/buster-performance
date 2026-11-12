# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# common.sh: what every script here shares; sourced from the work directory, inside a hold of the lock.
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl="$corpus/libc/musl"
compiler=$PWD/src/build/compiler
# The 9700X job's compile_time options for the frozen sqlite3.c (the system's headers).
SQLITE_OPTIONS=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite")
SQLITE_BYTES=9507037
MUSL_OPTIONS=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
# Workers' CPUs: one a physical core. CPU 2 alone has the performance governor (and its sibling, 10, is offline); the
# others run powersave with balance_performance. Nothing here changes that.
CPUS_1=2
CPUS_1B=5
CPUS_2=2,3
CPUS_4=0,1,2,3
CPUS_8=0,1,2,3,4,5,6,7
CPUS_15=0,1,2,3,4,5,6,7,8,9,11,12,13,14,15
# The cohorts' counters, a run each (allcore cohort --events: NAME@TYPE@CONFIG@MODE; type 0 the generic hardware
# events, 4 the core's raw events, 13 the msr PMU on this host). The configs are perf's own for the names, read with
# `perf stat -vv -e NAME true` here (results/env.txt has the list). At most five core counters a set: the NMI watchdog
# holds the sixth.
#   BASIC  user and kernel cycles and instructions, L2 fills from DRAM (l2_fill_rsp_src.dram_io_near, both modes), and
#          APERF and MPERF while the run was on a CPU (its frequency: the TSC's rate times their ratio)
#   TD     ls_not_halted_cyc, de_src_op_disp.all, ex_ret_ops, de_no_dispatch_per_slot.no_ops_from_frontend and
#          .backend_stalls, user
#   LAT    ls_not_halted_cyc, ex_no_retire.load_not_complete, ls_dmnd_fills_from_sys.all, .dram_io_near and .local_ccx, user
#   MEM    l2_fill_rsp_src.dram_io_near user and kernel, l2_fill_rsp_src.local_ccx user, ls_hw_pf_dc_fills.dram_io_near
#          user, ex_ret_brn_misp user
EVENTS_BASIC=cycles@0@0@u,instructions@0@1@u,cycles@0@0@k,instructions@0@1@k,l2_dram@4@100000865@a,aperf@13@1@a,mperf@13@2@a
EVENTS_TD=clk@4@76@u,dispatched@4@7aa@u,retired_ops@4@c1@u,frontend_slots@4@1000001a0@u,backend_slots@4@100001ea0@u
EVENTS_LAT=clk@4@76@u,load_not_complete@4@a2d6@u,l1_fills@4@ff43@u,l1_fills_dram@4@843@u,l1_fills_l3@4@243@u
EVENTS_MEM=l2_dram@4@100000865@u,l2_dram@4@100000865@k,l2_l3@4@100000265@u,pf_fills_dram@4@85a@u,mispredicts@4@c3@u
events_of()
{
    case $1 in
        basic) echo "$EVENTS_BASIC" ;;
        td) echo "$EVENTS_TD" ;;
        lat) echo "$EVENTS_LAT" ;;
        mem) echo "$EVENTS_MEM" ;;
        *) echo "unknown counters $1" >&2; return 1 ;;
    esac
}
# Four events: a memory controller has four counters, and a fifth made perf multiplex them (the first holds of
# 12 November counted five at 79% to 80% each, scaled; their read and write counts are estimates).
UMC=amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/,amd_umc/umc_data_slot_clks.all/,amd_umc/umc_mem_clk/
ENERGY=power/energy-pkg/
export LC_ALL=C

# cpus_of LABEL: the CPUs of a label's worker count (its last dotted part: w1, w1b, w2, w4, w8, w15).
cpus_of()
{
    case ${1##*.} in
        w1) echo "$CPUS_1" ;;
        w1b) echo "$CPUS_1B" ;;
        w2) echo "$CPUS_2" ;;
        w4) echo "$CPUS_4" ;;
        w8) echo "$CPUS_8" ;;
        w15) echo "$CPUS_15" ;;
        *) echo "unknown workers in $1" >&2; return 1 ;;
    esac
}

# strays OUT LABEL WHEN: the processes of other owners that take more than half a CPU right now, with the CPU each is on,
# appended to OUT/LABEL.strays.txt: a run the lock doesn't cover (a stray test program held a core on 12 November)
# shares a worker's CPU or its core, and the reductions leave that worker out.
strays()
{
    ps -eo psr=,pcpu=,pid=,etimes=,comm= --sort=-pcpu | awk -v when="$3" '$2 > 50 && $5 != "ps" { print when, "cpu", $1, "pcpu", $2, "pid", $3, "seconds", $4, $5 }' >> "$1/$2.strays.txt"
    return 0
}

# counted OUT LABEL COMMAND...: COMMAND under the memory controllers' and the package's counters (every CPU), into
# OUT/LABEL.umc.csv, with the strays before and after it.
counted()
{
    local out=$1 label=$2 result; shift 2
    : > "$out/$label.strays.txt"
    strays "$out" "$label" before
    perf stat -a -x, -o "$out/$label.umc.csv" -e "$UMC" -e "$ENERGY" -- "$@"
    result=$?
    strays "$out" "$label" after
    return $result
}

# sqlite_cohort OUT LABEL LOOPS UNIT [COUNTERS]: LOOPS compiles a worker of UNIT (-c --lanes 1 --time-stages) on LABEL's
# CPUs at once, each run counted (COUNTERS: basic by default) and the cohort under the memory controllers' counters;
# each run's stage report in OUT/stages/. The environment's BUSTER_ variables reach the compiler.
sqlite_cohort()
{
    local out=$1 label=$2 loops=$3 unit=$4 cpus events
    cpus=$(cpus_of "$label") || return 1
    events=$(events_of "${5:-basic}") || return 1
    mkdir -p "$out/stages" scratch
    counted "$out" "$label" ./allcore cohort --cpus "$cpus" --loops "$loops" --label "$label" --out "$out/$label.rows.tsv" --events "$events" \
        --stderr "$out/stages/$label.w%w.r%i.txt" -- "$compiler" --time-stages --lanes 1 -c "${SQLITE_OPTIONS[@]}" "$unit" -o "scratch/$label.w%w.o"
}

# idle OUT NAME SECONDS: the memory controllers' counts with nothing running.
idle()
{
    perf stat -a -x, -o "$1/$2.umc.csv" -e "$UMC" -e "$ENERGY" -- sleep "$3"
}
