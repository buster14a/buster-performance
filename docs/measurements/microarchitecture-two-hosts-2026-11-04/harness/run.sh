#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# The two-host micro-architecture campaign's driver.
#
#   harness/run.sh harness/hosts/HOST.sh STEP...
#
# run from (or with ROOT set to) a run root that holds harness/, bin/compiler-*,
# corpus, self-main.i and predefines-znver5.h (README.md, "Rerun"). Steps:
#   env       the host's identity (no lock: reads sysfs, perf's catalogs, hashes)
#   validate  every variant's outputs, hashed (the objects must be identical)
#   time      whole-process wall time and rusage, 11 rotated rounds, with the
#             compiler's --time-stages reports
#   time-self the compiler's own main.c (.i), 3 rotated rounds
#   ab1049    main against main before PR #1049 (bin/compiler-pre1049-NATIVE)
#   ab3       before #1049, the #1049 merge (bin/compiler-m1049-NATIVE) and main
#   ab-self   before #1049 and main on the compiler's own main.c
#   groups    six fixed counter groups (each one perf stat group, never multiplexed)
#             per variant and workload, 5 runs
#   groups-self  the same groups for the main.c workload, 2 runs
#   sweep     every core event (user and kernel, with cycles:u and instructions:u)
#             per sweep variant on sq-c and sq-syn, 2 runs, in chunks
#   metrics   every perf metric, one perf stat -M each, native variant, 2 runs
#   profiles  leader-sampled groups, IBS ops (all and L3 misses only), LBR and
#             cycles (user and kernel) of sq-c, reduced to per-symbol tables
#   profiles-same, profiles-musl, profiles-extra  the znver4 build's profiles (the
#             same binary on both hosts), musl's cycles with the kernel's, and the
#             microcode/512-bit/store-forwarding group
#   scaling   one compile on 1..N lanes, musl's sources on 1..N lanes, and K
#             independent compiles on K cores, with package energy
#   energy    package energy, core energy and APERF/MPERF of single-core compiles
#   uncore    UMC CAS commands and L3 misses (where the host exposes them)
#   summarize the tables of every step's raw files
# Each step (or chunk of one) takes the host's lock or core grant itself, held for
# that chunk alone; no step needs another's output except summarize.
set -u
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
profile=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
shift
# shellcheck source=/dev/null
source "$profile"
ROOT=${ROOT:-$(cd "$here/.." && pwd)}
cd "$ROOT" || exit 2
OUT=results/$HOST
SCRATCH=scratch/$HOST
UARCH=$ROOT/harness/uarch
if [[ ! -x $UARCH || $ROOT/harness/uarch.c -nt $UARCH ]]; then clang -std=c17 -O2 -Wall -Wextra -o "$UARCH" "$ROOT/harness/uarch.c" -lm || exit 2; fi
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
mkdir -p "$OUT" "$SCRATCH"
# shellcheck source=workloads.sh
source "$here/workloads.sh"

log() { printf '%s %s\n' "$(date -Is)" "$*" | tee -a "$OUT/run.log" >&2; }

# The CPUs this process may run on, one per line.
affinity_cpus()
{
    local list
    list=$(taskset -pc $$ | sed 's/.*: //')
    local part
    for part in ${list//,/ }; do
        if [[ $part == *-* ]]; then seq "${part%-*}" "${part#*-}"; else echo "$part"; fi
    done
}

# One CPU per physical core of this process's affinity, comma-separated.
physical_cpus()
{
    local seen=" " cpu core out=""
    for cpu in $(affinity_cpus); do
        core=$(cat "/sys/devices/system/cpu/cpu$cpu/topology/core_id" 2>/dev/null)
        core="$(cat "/sys/devices/system/cpu/cpu$cpu/topology/physical_package_id" 2>/dev/null):$core"
        if [[ $seen != *" $core "* ]]; then seen+="$core "; out+="${out:+,}$cpu"; fi
    done
    echo "$out"
}

single_cpu() { if [[ -n ${SINGLE_CPU:-} ]]; then echo "$SINGLE_CPU"; elif [[ $HOST == zen5-9700x ]]; then echo 2; else affinity_cpus | head -1; fi; }

# Runs "$0 PROFILE --inner STEP ARG..." under the host's single-core hold, pinned.
held() { hold "$here/run.sh" "$profile" --inner "$@"; local s=$?; [[ $PAUSE -gt 0 ]] && sleep "$PAUSE"; return $s; }
held_multi() { hold_multi "$here/run.sh" "$profile" --inner-multi "$@"; local s=$?; [[ $PAUSE -gt 0 ]] && sleep "$PAUSE"; return $s; }

group_spec()
{
    case $1 in
        basic) echo "-e {cycles:u,instructions:u,cycles:k,instructions:k} -e task-clock,page-faults,minor-faults,major-faults,context-switches,cpu-migrations" ;;
        td1) echo "-e {ls_not_halted_cyc:u,de_src_op_disp.all:u,ex_ret_ops:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u}" ;;
        td2) echo "-e {ls_not_halted_cyc:u,ex_no_retire.load_not_complete:u,ex_no_retire.not_complete:u,cpu/de_no_dispatch_per_slot.no_ops_from_frontend,cmask=$TD_WIDTH/u,ex_ret_ucode_ops:u}" ;;
        br) echo "-e {instructions:u,ex_ret_brn:u,ex_ret_brn_misp:u,ex_ret_brn_tkn:u,$TD_RESYNC:u}" ;;
        fe) echo "-e {instructions:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u,op_cache_hit_miss.all_op_cache_accesses:u,bp_l1_tlb_miss_l2_tlb_miss.all:u}" ;;
        mem) echo "-e {instructions:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u,l2_cache_req_stat.ic_dc_miss_in_l2:u,ls_l1_d_tlb_miss.all:u}" ;;
    esac
}
COUNTER_GROUPS="basic td1 td2 br fe mem"

# ---------------------------------------------------------------------------
# Steps inside a hold (pinned to one CPU).

inner_validate()
{
    local v f="$OUT/validate.tsv"
    : > "$f"
    for v in $VARIANTS; do
        workload "$v" sq-c && "${WL[@]}" > "$SCRATCH/validate-$v-sq-c.log" 2>&1
        printf '%s\tsq-c\t%s\t%s\n' "$v" "$?" "$(sha256sum < "$SCRATCH/$v-sq.o" | cut -d' ' -f1)" >> "$f"
        workload "$v" sq-E && "${WL[@]}" > "$SCRATCH/validate-$v-sq-E.log" 2>&1
        printf '%s\tsq-E\t%s\t%s\n' "$v" "$?" "$(sha256sum < "$SCRATCH/$v-sq.i" | cut -d' ' -f1)" >> "$f"
        workload "$v" sq-c-default && "${WL[@]}" > "$SCRATCH/validate-$v-sq-c-default.log" 2>&1
        printf '%s\tsq-c-default\t%s\t%s\n' "$v" "$?" "$(sha256sum < "$SCRATCH/$v-sq-default.o" | cut -d' ' -f1)" >> "$f"
        workload "$v" sq-syn && "${WL[@]}" > "$SCRATCH/validate-$v-sq-syn.log" 2>&1
        printf '%s\tsq-syn\t%s\t%s\n' "$v" "$?" "$(sha256sum < "$SCRATCH/validate-$v-sq-syn.log" | cut -d' ' -f1)" >> "$f"
    done
    workload x tcc-c && "${WL[@]}" > "$SCRATCH/validate-tcc.log" 2>&1
    printf 'tcc\ttcc-c\t%s\t%s\n' "$?" "$(sha256sum < "$SCRATCH/tcc-sq.o" | cut -d' ' -f1)" >> "$f"
    cat "$f"
}

inner_time()
{
    local args=() v w
    for v in $VARIANTS; do
        for w in sq-c sq-syn sq-E; do
            workload "$v" "$w"
            args+=(--list "$v:$w" "${WL[@]}")
        done
        workload "$v" sq-c
        args+=(--list "stages-$v" "${WL[@]}" --time-stages)
    done
    workload x tcc-c
    args+=(--list "tcc:tcc-c" "${WL[@]}")
    "$UARCH" time "$OUT/time" 11 "${args[@]}"
}

inner_time_self()
{
    local args=() v
    for v in $SELF_VARIANTS; do
        workload "$v" self-syn
        args+=(--list "$v:self-syn" "${WL[@]}" --list "stages-self-$v" "${WL[@]}" --time-stages)
    done
    "$UARCH" time "$OUT/time-self" 3 "${args[@]}"
}

# Main against main before PR #1049 (aca9e53a, the merge's first parent), the
# commit that added Clang's common warnings: both builds of the host's native
# target, sq-c and sq-syn with the stage clock, 11 rotated rounds. ab3 adds the
# merge commit itself (e36740b8, bin/compiler-m1049-NATIVE) in its own directory.
inner_ab()
{
    local dir=$1; shift
    local args=() v w
    for v in "$@"; do
        for w in sq-c sq-syn; do
            workload "$v" "$w"
            args+=(--list "$v:$w" "${WL[@]}" --time-stages)
        done
    done
    "$UARCH" time "$OUT/$dir" 11 "${args[@]}"
    for v in "$@"; do
        workload "$v" sq-c
        # shellcheck disable=SC2046
        "$UARCH" stat "$OUT/$dir" "$v.sq-c.basic" 5 $(group_spec basic) -- "${WL[@]}"
        # shellcheck disable=SC2046
        "$UARCH" stat "$OUT/$dir" "$v.sq-c.br" 5 $(group_spec br) -- "${WL[@]}"
        # shellcheck disable=SC2046
        "$UARCH" stat "$OUT/$dir" "$v.sq-c.td1" 5 $(group_spec td1) -- "${WL[@]}"
    done
}

# The compiler's own main.c (.i) before #1049 and on main, with the stage clock,
# 3 rotated rounds (ab-self).
inner_ab_self()
{
    local args=() v
    for v in "pre1049-$NATIVE" "$NATIVE"; do
        workload "$v" self-syn
        args+=(--list "$v:self-syn" "${WL[@]}" --time-stages)
    done
    "$UARCH" time "$OUT/ab-self" 3 "${args[@]}"
}

inner_groups()
{
    local v=$1 runs=$2; shift 2
    local w g
    for w in "$@"; do
        workload "$v" "$w"
        for g in $COUNTER_GROUPS; do
            # shellcheck disable=SC2046
            "$UARCH" stat "$OUT/groups" "$v.$w.$g" "$runs" $(group_spec "$g") -- "${WL[@]}"
        done
    done
}

inner_sweep()
{
    local v=$1 w=$2 from=$3 to=$4
    workload "$v" "$w"
    "$UARCH" sweep "$OUT/sweep-$v-$w" "$OUT/env/core-events.txt" "$from" "$to" 2 "cycles:u,instructions:u" -- "${WL[@]}"
}

inner_metrics()
{
    local v=$1 w=$2 from=$3 to=$4
    workload "$v" "$w"
    "$UARCH" metrics "$OUT/metrics-$v-$w" "$OUT/env/metrics.txt" "$from" "$to" 2 -- "${WL[@]}"
}

# Records 8 compiles of sq-c (or PROFILE_RUNS of PROFILE_WORKLOAD) under one perf
# record and reduces the samples. Leader-sampled groups use a 50,021-cycle period:
# each sample's member deltas go to the leader's address, so a long period blends
# short functions with their neighbours.
profile_one()
{
    local name=$1 v=$2; shift 2
    local dir="$OUT/profiles/$v" data="$SCRATCH/profile-$v-$name.data"
    mkdir -p "$dir"
    [[ -s $dir/$name.done ]] && return 0
    workload "$v" "${PROFILE_WORKLOAD:-sq-c}"
    local loop="" runs=${PROFILE_RUNS:-8}
    printf -v loop '%q ' "${WL[@]}"
    perf record -q -o "$data" "$@" -- bash -c "for ((i = 0; i < $runs; i++)); do $loop > /dev/null 2>&1 || exit 1; done" \
        > "$dir/$name.record.log" 2>&1
    echo "status $?" >> "$dir/$name.record.log"
    case $name in
        cycles|musl-cycles)
            perf report -i "$data" --no-children --sort dso,sym --stdio -q --percent-limit 0.05 > "$dir/$name.txt" 2>/dev/null
            perf report -i "$data" --no-children --sort dso --stdio -q > "$dir/$name-dso.txt" 2>/dev/null ;;
        lbr)
            perf script -i "$data" -F brstacksym 2>/dev/null | "$UARCH" branches - 120 > "$dir/lbr.tsv" ;;
        ibs|ibs-l3)
            perf script -i "$data" -F ip,sym,data_src,weight 2>/dev/null | "$UARCH" memory - > "$dir/$name.tsv" ;;
        *)
            perf script -i "$data" -F period,event,ip,sym 2>/dev/null | "$UARCH" symbols - > "$dir/$name.tsv" ;;
    esac
    perf report -i "$data" --header-only > "$dir/$name.header.txt" 2>/dev/null
    ls -l "$data" | awk '{print $5}' > "$dir/$name.done"
}

inner_profiles()
{
    local v=$1 part=$2
    case $part in
        a)
            profile_one cycles "$v" -e cycles -c 100003
            profile_one td1 "$v" -e "{ls_not_halted_cyc:u,de_src_op_disp.all:u,ex_ret_ops:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u}:S" -c 50021
            profile_one td2 "$v" -e "{ls_not_halted_cyc:u,ex_no_retire.load_not_complete:u,ex_no_retire.not_complete:u,instructions:u,ex_ret_brn_misp:u}:S" -c 50021 ;;
        b)
            profile_one mem "$v" -e "{cycles:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_near:u,l2_cache_req_stat.ic_dc_miss_in_l2:u,ls_l1_d_tlb_miss.all:u}:S" -c 50021
            profile_one fe "$v" -e "{cycles:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u,op_cache_hit_miss.all_op_cache_accesses:u,bp_l1_tlb_miss_l2_tlb_miss.all:u}:S" -c 50021 ;;
        c)
            profile_one ibs "$v" -e "ibs_op/cnt_ctl=1,swfilt=1/u" -d -W -c 200000
            profile_one ibs-l3 "$v" -e "ibs_op/cnt_ctl=1,swfilt=1,l3missonly=1/u" -d -W -c 4000
            profile_one lbr "$v" -j any,u -e cycles:u -c 1000003 ;;
        e)
            profile_one ucode "$v" -e "{cycles:u,ex_ret_ucode_ops:u,ex_ret_ops:u,fp_ops_retired_by_width.pack_512_uops_retired:u,ls_bad_status2.stli_other:u}:S" -c 50021 ;;
        d)
            PROFILE_WORKLOAD=musl-syn PROFILE_RUNS=2 profile_one musl-cycles "$v" -e cycles -c 100003 ;;
    esac
}

inner_energy()
{
    local cpu=$1 v loop dir="$OUT/energy"
    mkdir -p "$dir"
    perf stat -a -x, -o "$dir/idle.csv" -e power/energy-pkg/ -- sleep 3 2>/dev/null
    for v in $VARIANTS; do
        workload "$v" sq-c
        printf -v loop '%q ' "${WL[@]}"
        perf stat -a -x, -o "$dir/$v.pkg.csv" -e power/energy-pkg/ -- bash -c "for i in 1 2 3 4 5 6 7 8 9 10; do $loop > /dev/null 2>&1; done"
        perf stat -C "$cpu" -x, -o "$dir/$v.freq.csv" -e msr/aperf/,msr/mperf/,msr/tsc/,cycles,instructions -- \
            bash -c "for i in 1 2 3 4 5 6 7 8 9 10; do $loop > /dev/null 2>&1; done"
        perf stat -a --per-core -x, -o "$dir/$v.core.csv" -e power_core/energy-core/ -- bash -c "for i in 1 2 3 4 5 6 7 8 9 10; do $loop > /dev/null 2>&1; done"
    done
    grep -h -v '^#' "$dir"/*.csv | grep -v '^$' > /dev/null
}

# ---------------------------------------------------------------------------
# Steps inside a multi-core hold.

inner_scaling()
{
    local cpus=$1 dir="$OUT/scaling" n k args=()
    mkdir -p "$dir"
    echo "$cpus" > "$dir/cpus.txt"
    # One compile on N lanes and musl's sources on N lanes, rotated.
    for n in $SCALING_LANES; do
        workload "$NATIVE:$n" sq-c
        args+=(--list "sq-c-lanes$n" taskset -c "$cpus" "${WL[@]}")
        workload "$NATIVE:$n" musl-syn
        args+=(--list "musl-lanes$n" taskset -c "$cpus" "${WL[@]}")
    done
    workload "$NATIVE" sq-c-default
    args+=(--list "sq-c-default" taskset -c "$cpus" "${WL[@]}")
    "$UARCH" time "$dir" 5 "${args[@]}"
    for n in $SCALING_LANES; do
        workload "$NATIVE:$n" sq-c
        "$UARCH" stat "$dir" "sq-c-lanes$n" 3 -e task-clock,cycles:u,instructions:u,cycles:k,instructions:k,context-switches,cpu-migrations,page-faults -- taskset -c "$cpus" "${WL[@]}"
        workload "$NATIVE:$n" musl-syn
        "$UARCH" stat "$dir" "musl-lanes$n" 2 -e task-clock,cycles:u,instructions:u,cycles:k,instructions:k,context-switches,cpu-migrations,page-faults -- taskset -c "$cpus" "${WL[@]}"
    done
    # K independent single-lane compiles on K cores, each batch under package energy.
    for k in $FANOUT_WORKERS; do
        local list
        list=$(echo "$cpus" | cut -d, -f1-"$k")
        workload "$NATIVE" sq-c
        local command=("${WL[@]}")
        command[${#command[@]}-3]="$SCRATCH/fan-{i}.o"
        local r
        for r in 0 1 2 3; do
            [[ -s $dir/fanout-energy-$k.r$r.csv ]] && continue
            perf stat -a -x, -o "$dir/fanout-energy-$k.r$r.csv" -e power/energy-pkg/ -- \
                "$UARCH" fanout "$dir" "fanout$k-r$r" 1 "$list" -- "${command[@]}"
        done
    done
}

inner_uncore()
{
    local cpus=$1 dir="$OUT/uncore" v loop
    mkdir -p "$dir"
    local events="amd_umc/umc_cas_cmd.rd/,amd_umc/umc_cas_cmd.wr/,amd_umc/umc_act_cmd.all/,amd_umc/umc_mem_clk/"
    perf stat -a -x, -o "$dir/idle.csv" -e "$events" -- sleep 2
    workload "$NATIVE" sq-c
    printf -v loop '%q ' "${WL[@]}"
    perf stat -a -x, -o "$dir/single.csv" -e "$events" -- taskset -c 2 bash -c "for i in 1 2 3 4 5 6 7 8; do $loop > /dev/null 2>&1; done"
    local command=("${WL[@]}")
    command[${#command[@]}-3]="$SCRATCH/fan-{i}.o"
    perf stat -a -x, -o "$dir/fanout8.csv" -e "$events" -- "$UARCH" fanout "$dir" fanout8 2 "$cpus" -- "${command[@]}"
}

inner()
{
    local step=$1; shift
    receipt >> "$OUT/holds.txt"
    local cpu
    cpu=$(single_cpu)
    log "inner $step $* (cpu $cpu)"
    taskset -pc "$cpu" $$ > /dev/null
    case $step in
        validate) inner_validate ;;
        time) inner_time ;;
        time-self) inner_time_self ;;
        ab1049) inner_ab ab1049 "pre1049-$NATIVE" "$NATIVE" ;;
        ab3) inner_ab ab3 "pre1049-$NATIVE" "m1049-$NATIVE" "$NATIVE" ;;
        ab-self) inner_ab_self ;;
        groups) inner_groups "$@" ;;
        sweep) inner_sweep "$@" ;;
        metrics) inner_metrics "$@" ;;
        profiles) inner_profiles "$@" ;;
        energy) inner_energy "$cpu" ;;
    esac
    log "inner $step $* done"
}

inner_multi()
{
    local step=$1; shift
    receipt >> "$OUT/holds.txt"
    local cpus
    cpus=$(physical_cpus)
    log "inner-multi $step (cpus $cpus)"
    case $step in
        scaling) inner_scaling "$cpus" ;;
        uncore) inner_uncore "$cpus" ;;
    esac
    log "inner-multi $step done"
}

# ---------------------------------------------------------------------------
# Outer steps.

step_env()
{
    local dir="$OUT/env"
    mkdir -p "$dir"
    uname -a > "$dir/uname.txt"
    lscpu > "$dir/lscpu.txt"
    awk '/^$/{exit} {print}' /proc/cpuinfo > "$dir/cpuinfo-cpu0.txt"
    {
        printf 'cpu\tonline\tgovernor\tepp\tmin_khz\tmax_khz\tcur_khz\n'
        local c
        for c in /sys/devices/system/cpu/cpu[0-9]*; do
            printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "${c##*/}" "$(cat "$c/online" 2>/dev/null || echo 1)" \
                "$(cat "$c/cpufreq/scaling_governor" 2>/dev/null)" "$(cat "$c/cpufreq/energy_performance_preference" 2>/dev/null)" \
                "$(cat "$c/cpufreq/scaling_min_freq" 2>/dev/null)" "$(cat "$c/cpufreq/scaling_max_freq" 2>/dev/null)" \
                "$(cat "$c/cpufreq/scaling_cur_freq" 2>/dev/null)"
        done
    } > "$dir/cpufreq.tsv"
    {
        echo "boost $(cat /sys/devices/system/cpu/cpufreq/boost 2>/dev/null)"
        echo "thp_enabled $(cat /sys/kernel/mm/transparent_hugepage/enabled)"
        echo "thp_defrag $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
        echo "perf_event_paranoid $(cat /proc/sys/kernel/perf_event_paranoid)"
        echo "nmi_watchdog $(cat /proc/sys/kernel/nmi_watchdog)"
        echo "perf_event_max_sample_rate $(cat /proc/sys/kernel/perf_event_max_sample_rate)"
        echo "kernel_cmdline $(cat /proc/cmdline | sed 's/cryptdevice=[^ ]*//g; s/root=[^ ]*//g; s/resume=[^ ]*//g; s/rd\.luks[^ ]*//g; s/initrd=[^ ]*//g')"
        echo "loadavg $(cat /proc/loadavg)"
        echo "pmus $(ls /sys/bus/event_source/devices | tr '\n' ' ')"
    } > "$dir/settings.txt"
    free -m > "$dir/memory.txt"
    { perf --version; clang --version | head -1; tcc -v 2>&1 | head -1; bash --version | head -1; } > "$dir/tools.txt"
    sha256sum bin/compiler-* self-main.i predefines-znver5.h harness/uarch.c harness/run.sh harness/workloads.sh "$profile" > "$dir/sha256.txt"
    sha256sum corpus/MANIFESTS.sha256 corpus/sqlite/sqlite3.c >> "$dir/sha256.txt"
    perf list -j 2> /dev/null | gzip -9n > "$dir/perf-list.json.gz"
    perf list --raw-dump pmu 2>/dev/null | tr ' ' '\n' | grep -v '^$' | grep -v / | grep -v '^drm-' \
        | grep -v -x -E 'core_wide|duration_time|has_pmem|num_cores|num_cpus|num_cpus_online|num_dies|num_packages|slots|smt_on|system_time|user_time' \
        | sort -u > "$dir/core-events.txt"
    perf list -j metrics 2>/dev/null | sed -n 's/.*"MetricName": "\([^"]*\)".*/\1/p' | sort -u > "$dir/metrics.txt"
    log "env: $(wc -l < "$dir/core-events.txt") core events, $(wc -l < "$dir/metrics.txt") metrics"
}

step_sweep()
{
    local v w n from
    n=$(wc -l < "$OUT/env/core-events.txt")
    for v in $SWEEP_VARIANTS; do
        for w in ${SWEEP_WORKLOADS:-sq-c sq-syn}; do
            for ((from = 0; from < n; from += SWEEP_CHUNK)); do
                if [[ -f $OUT/sweep-$v-$w/sweep/$(printf '%04d' $((from + SWEEP_CHUNK < n ? from + SWEEP_CHUNK - 1 : n - 1))).r1.status ]]; then continue; fi
                log "sweep $v $w $from"
                held sweep "$v" "$w" "$from" $((from + SWEEP_CHUNK))
            done
        done
    done
}

step_metrics()
{
    local w n from
    n=$(wc -l < "$OUT/env/metrics.txt")
    for w in ${METRIC_WORKLOADS:-sq-c sq-syn}; do
        for ((from = 0; from < n; from += METRIC_CHUNK)); do
            if [[ -f $OUT/metrics-$NATIVE-$w/metrics/$(printf '%04d' $((from + METRIC_CHUNK < n ? from + METRIC_CHUNK - 1 : n - 1))).r1.status ]]; then continue; fi
            log "metrics $w $from"
            held metrics "$NATIVE" "$w" "$from" $((from + METRIC_CHUNK))
        done
    done
}

step_summarize()
{
    local d
    for d in "$OUT"/time "$OUT"/time-self "$OUT"/groups "$OUT"/sweep-* "$OUT"/metrics-* "$OUT"/scaling; do
        [[ -d $d ]] && "$UARCH" summarize "$d"
    done
    "$UARCH" stages "$OUT"/time/logs/stages-"$NATIVE".r*.log > "$OUT/stages-$NATIVE.tsv"
    local v
    for v in $VARIANTS; do
        "$UARCH" stages "$OUT"/time/logs/stages-"$v".r*.log > "$OUT/stages-$v.tsv"
    done
    for v in $SELF_VARIANTS; do
        ls "$OUT"/time-self/logs/stages-self-"$v".r*.log > /dev/null 2>&1 && "$UARCH" stages "$OUT"/time-self/logs/stages-self-"$v".r*.log > "$OUT/stages-self-$v.tsv"
    done
}

if [[ ${1:-} == --inner ]]; then
    shift
    inner "$@"
    exit $?
elif [[ ${1:-} == --inner-multi ]]; then
    shift
    inner_multi "$@"
    exit $?
fi

for step in "$@"; do
    log "step $step"
    case $step in
        env) step_env ;;
        validate) held validate ;;
        time) held time ;;
        time-self) held time-self ;;
        ab1049) held ab1049 ;;
        ab3) held ab3 ;;
        ab-self) held ab-self ;;
        profiles-musl) held profiles "$NATIVE" d ;;
        profiles-pre) held profiles "pre1049-$NATIVE" a ;;
        profiles-extra) held profiles "$NATIVE" e; [[ $NATIVE != znver4 ]] && held profiles znver4 e ;;
        groups)
            first=1
            for v in $VARIANTS; do
                if [[ $first == 1 ]]; then
                    first=0
                    held groups "$v" 5 sq-c sq-syn sq-E
                    hold "$here/run.sh" "$profile" --inner groups tcc 5 tcc-c
                else
                    held groups "$v" 5 sq-c sq-syn sq-E
                fi
            done ;;
        groups-self) for v in $SELF_VARIANTS; do held groups "$v" 2 self-syn; done ;;
        sweep) step_sweep ;;
        metrics) step_metrics ;;
        profiles) for part in a b c d; do held profiles "$NATIVE" "$part"; done ;;
        profiles-same) for part in a b c; do held profiles znver4 "$part"; done ;;
        scaling) held_multi scaling ;;
        energy) held energy ;;
        uncore) [[ $UNCORE == 1 ]] && held_multi uncore ;;
        summarize) step_summarize ;;
        *) log "unknown step $step" ;;
    esac
done
