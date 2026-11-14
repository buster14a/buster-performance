#!/bin/bash
# run.sh STEP ...: one hold of the lock's work for #2531's step 3, the view (the caller takes the lock). The trees are base
# (main) and head (this branch), and any other a step names (TREE, TREE:off for --attested=off); results under results/. Pinned to CPU 2 with the address-space randomization off
# (setarch -R: one page state), as the census's record ran.
#   compare CORPUS LANES MODE [OPTION...]   head --attested=MODE against head --attested=off: status, every object, the
#                                           diagnostics; MODE's --time-stages summary
#   base CORPUS LANES [OPTION...]           base against head --attested=off and on: every object, the diagnostics
#   time CORPUS LANES ROUND                 one round: base, head off, head on, under perf stat
#   sqlite ROUND                            one round of -c sqlite3.c: base, head
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/../672-rest-claude/common.sh"
out=$here/results
mkdir -p "$out"
mapfile -t musl_sources < "$here/../672-rest-claude/scratch/musl-units.txt"
glibc_sources=("$here"/../672-rest-claude/scratch/glibc-src/*.c)
base=$here/main2/build/compiler
head=$here/f/build/compiler
step=$1
shift
units()
{
    case $1 in
    musl) printf '%s\n' "${musl_options[@]}" "${musl_sources[@]}" ;;
    glibc) printf '%s\n' "${glibc_sources[@]}" ;;
    sqlite2) printf '%s\n' "${sqlite_options[@]}" "$sqlite/sqlite3.c" "$sqlite/shell.c" ;;
    esac
}
cpus()
{
    # One lane on CPU 2; more on every CPU.
    if [ "$1" = 1 ]; then echo 2; else echo 0-15; fi
}
compile()
{
    # compile DIR COMPILER CORPUS LANES [OPTION...]: -c of the corpus into DIR (emptied), its stderr in DIR.err. Every
    # command runs in the one directory $scratch/work, moved to DIR after it, so that -g's DW_AT_comp_dir is the same.
    local dir=$1 compiler=$2 corpus=$3 lanes=$4
    shift 4
    local arguments
    mapfile -t arguments < <(units "$corpus")
    rm -rf "$dir" "$scratch/work"; mkdir -p "$scratch/work"
    (cd "$scratch/work" && setarch -R taskset -c "$(cpus "$lanes")" "$compiler" "$@" --lanes "$lanes" -c "${arguments[@]}" > /dev/null 2> "$dir.err"; echo $? > "$dir.status")
    mv "$scratch/work" "$dir"
}
same()
{
    # same A B LABEL: every object of directory A against B's, and A.err against B.err
    local a=$1 b=$2 label=$3 same=0 different=0 f
    for f in "$a"/*.o; do
        if cmp -s "$f" "$b/${f##*/}"; then same=$((same + 1)); else different=$((different + 1)); echo "$label different ${f##*/}" >> "$out/different.txt"; fi
    done
    local diagnostics=different
    # (The time-stages lines aren't diagnostics.)
    if cmp -s <(grep -v -e '^time-' -e '^attested declarations' -e '^worker-budget' "$a.err") <(grep -v -e '^time-' -e '^attested declarations' -e '^worker-budget' "$b.err"); then diagnostics=same; fi
    echo "$label: status $(cat "$a.status") and $(cat "$b.status"); objects $same the same bytes, $different different, of $(ls "$a" | wc -l) and $(ls "$b" | wc -l); diagnostics $diagnostics ($(grep -c 'warning:' "$a.err") warnings, $(grep -c 'error:' "$a.err") errors)"
}
scratch=$here/scratch
mkdir -p "$scratch"
case $step in
batch)
    # batch "STEP ARGS" ...: each step in turn, in this one hold
    for item in "$@"; do
        echo "== $item"
        # (Word splitting is the point: each item is a step and its arguments.)
        # shellcheck disable=SC2086
        "$here/run6.sh" $item
    done
    ;;
env)
    # env: the host's and the trees' identity
    {
        echo "## date"; date -u +%FT%TZ
        echo "## uname"; uname -a
        echo "## cpu"; grep -m1 'model name' /proc/cpuinfo
        echo "## governor and EPP, CPU 2"; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
        echo "## THP"; cat /sys/kernel/mm/transparent_hugepage/enabled
        echo "## tools"; clang --version | head -1; perf --version
        echo "## executables"; sha256sum "$base" "$head"
        echo "## musl units"; printf '%s\n' "${musl_sources[@]}" | sha256sum
        echo "## glibc units"; cat "${glibc_sources[@]}" | sha256sum
        echo "## head tree outside build/"; (cd "$here/head" && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum)
        echo "## base tree outside build/"; (cd "$here/base" && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum)
    } > "$out/env.txt" 2>&1
    cat "$out/env.txt"
    ;;
compare)
    corpus=$1 lanes=$2 mode=$3
    shift 3
    label="$corpus lanes=$lanes $mode${*:+ $*}"
    compile "$scratch/a" "$head" "$corpus" "$lanes" --attested=off "$@"
    compile "$scratch/b" "$head" "$corpus" "$lanes" --attested="$mode" --time-stages "$@"
    { same "$scratch/b" "$scratch/a" "$label"; grep '^attested declarations' "$scratch/b.err"; grep 'attested declaration' "$scratch/b.err" | grep -v '^attested declarations' | head -5; } | tee -a "$out/compare.txt"
    rm -rf "$scratch/a" "$scratch/b"
    ;;
base)
    corpus=$1 lanes=$2
    shift 2
    label="$corpus lanes=$lanes base${*:+ $*}"
    compile "$scratch/a" "$base" "$corpus" "$lanes" "$@"
    compile "$scratch/b" "$head" "$corpus" "$lanes" --attested=off "$@"
    compile "$scratch/c" "$head" "$corpus" "$lanes" "$@"
    { same "$scratch/b" "$scratch/a" "$label: head off against base"; same "$scratch/c" "$scratch/a" "$label: head on against base"; } | tee -a "$out/compare.txt"
    rm -rf "$scratch/a" "$scratch/b" "$scratch/c"
    ;;
scalar)
    # scalar CORPUS LANES [OPTION...]: head --attested=on against head --scalar, the oracle: every object, the diagnostics
    corpus=$1 lanes=$2
    shift 2
    label="$corpus lanes=$lanes on against --scalar${*:+ $*}"
    compile "$scratch/a" "$head" "$corpus" "$lanes" --scalar "$@"
    compile "$scratch/b" "$head" "$corpus" "$lanes" "$@"
    same "$scratch/b" "$scratch/a" "$label" | tee -a "$out/compare.txt"
    rm -rf "$scratch/a" "$scratch/b"
    ;;
small)
    # small ROUND: one round of a small unit's process (-c of a function over stdio.h) 50 times: base, head
    round=$1
    printf '#include <stdio.h>\nint main(void) { return puts("small") < 0; }\n' > "$scratch/small.c"
    for way in base head; do
        compiler=$head
        if [ "$way" = base ]; then compiler=$base; fi
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        (cd "$scratch/t" && setarch -R taskset -c 2 perf stat -r 50 -x, -o "$out/stat-small-$way-$round.csv" -e 'cycles:u,instructions:u,cycles:k,instructions:k' -e task-clock,page-faults -- "$compiler" -c "$scratch/small.c" > /dev/null 2>&1)
    done
    rm -rf "$scratch/t"
    ;;
time)
    # time CORPUS LANES ROUND TREE[:off]...: one round, each tree in turn under perf stat
    corpus=$1 lanes=$2 round=$3
    shift 3
    mapfile -t arguments < <(units "$corpus")
    for way in "$@"; do
        tree=${way%%:*}
        mode=()
        if [ "$way" != "$tree" ]; then mode=(--attested=off); fi
        compiler=$here/$tree/build/compiler
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        start=$EPOCHREALTIME
        (cd "$scratch/t" && setarch -R taskset -c "$(cpus "$lanes")" perf stat -x, -o "$out/stat-$corpus-$lanes-${way/:/}-$round.csv" -e 'cycles:u,instructions:u,cycles:k,instructions:k' -e task-clock,page-faults -- "$compiler" "${mode[@]}" --lanes "$lanes" -c "${arguments[@]}" > /dev/null 2>&1)
        end=$EPOCHREALTIME
        echo "$start $end" | awk '{ printf "%.1f\n", ($2 - $1) * 1000 }' > "$out/wall-$corpus-$lanes-${way/:/}-$round.txt"
    done
    rm -rf "$scratch/t"
    ;;
profile)
    # profile CORPUS WAY LABEL [TREE]: perf record of TREE's (head by default) --attested=WAY on one lane, its symbols'
    # shares into results/
    corpus=$1 way=$2 label=$3 tree=${4:-head}
    mapfile -t arguments < <(units "$corpus")
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -c 200003 -o "$scratch/perf.data" -- "$here/$tree/build/compiler" --attested="$way" --lanes 1 -c "${arguments[@]}" > /dev/null 2>&1)
    perf report -i "$scratch/perf.data" --no-children --sort symbol --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | head -150 > "$out/profile-$corpus-$way-$label.txt"
    head -40 "$out/profile-$corpus-$way-$label.txt"
    rm -rf "$scratch/t" "$scratch/perf.data"
    ;;
callgraph)
    # callgraph CORPUS WAY LABEL [TREE]: perf record with DWARF call graphs of TREE's (head by default) --attested=WAY on one
    # lane: the symbols by inclusive share, and memset's callers, into results/
    corpus=$1 way=$2 label=$3 tree=${4:-head}
    mapfile -t arguments < <(units "$corpus")
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -c 1000003 --call-graph dwarf,8192 -o "$scratch/perf.data" -- "$here/$tree/build/compiler" --attested="$way" --lanes 1 -c "${arguments[@]}" > /dev/null 2>&1)
    perf report -i "$scratch/perf.data" --children --sort symbol --stdio -g none 2> /dev/null | grep -v '^#' | grep -v '^$' | head -120 > "$out/callgraph-$corpus-$way-$label-children.txt"
    perf report -i "$scratch/perf.data" --no-children --sort symbol --stdio -g caller,0.5,callee,function,percent --symbols=__memset_avx512_unaligned_erms 2> /dev/null | grep -v '^#' | grep -v '^$' | head -150 > "$out/callgraph-$corpus-$way-$label-memset.txt"
    head -60 "$out/callgraph-$corpus-$way-$label-children.txt"
    rm -rf "$scratch/t" "$scratch/perf.data"
    ;;
calls)
    # calls CORPUS WAY LABEL [TREE]: perf record of the calls' branch records (-j call) of TREE's --attested=WAY on one lane:
    # the calls into memset by their callers, into results/
    corpus=$1 way=$2 label=$3 tree=${4:-head}
    mapfile -t arguments < <(units "$corpus")
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -c 200003 -j call,u -o "$scratch/perf.data" -- "$here/$tree/build/compiler" --attested="$way" --lanes 1 -c "${arguments[@]}" > /dev/null 2>&1)
    perf report -i "$scratch/perf.data" --sort symbol_from,symbol_to --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | grep -i 'memset' | head -40 > "$out/calls-$corpus-$way-$label-memset.txt"
    cat "$out/calls-$corpus-$way-$label-memset.txt"
    rm -rf "$scratch/t" "$scratch/perf.data"
    ;;
callers)
    # callers CORPUS WAY LABEL PATTERN [TREE]: perf record of the calls' branch records (-j call) of TREE's --attested=WAY on
    # one lane: the calls whose source or target matches PATTERN, by caller and callee, into results/
    corpus=$1 way=$2 label=$3 pattern=$4 tree=${5:-head}
    mapfile -t arguments < <(units "$corpus")
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -c 200003 -j call,u -o "$scratch/perf.data" -- "$here/$tree/build/compiler" --attested="$way" --lanes 1 -c "${arguments[@]}" > /dev/null 2>&1)
    perf report -i "$scratch/perf.data" --sort symbol_from,symbol_to --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | grep -E "$pattern" | head -60 > "$out/callers-$corpus-$way-$label.txt"
    cat "$out/callers-$corpus-$way-$label.txt"
    rm -rf "$scratch/t" "$scratch/perf.data"
    ;;
probe)
    # probe CORPUS WAY LABEL [TREE]: TREE's (probe by default) --attested=WAY on one lane with BUSTER_PROBE_PHASES=1: the last
    # unit's sums of the phases' TSC ticks, into results/
    corpus=$1 way=$2 label=$3 tree=${4:-probe}
    mapfile -t arguments < <(units "$corpus")
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && BUSTER_PROBE_PHASES=1 setarch -R taskset -c 2 "$here/$tree/build/compiler" --attested="$way" --lanes 1 -c "${arguments[@]}" 2>&1 > /dev/null | grep '^PROBE' | tail -1 > "$out/probe-$corpus-$way-$label.txt")
    cut -c1-200 "$out/probe-$corpus-$way-$label.txt"
    rm -rf "$scratch/t"
    ;;
annotate)
    # annotate CORPUS WAY LABEL TREE SYMBOL...: perf record of TREE's --attested=WAY on one lane, then each SYMBOL's
    # instructions of at least 0.4% of its samples, into results/
    corpus=$1 way=$2 label=$3 tree=$4
    shift 4
    mapfile -t arguments < <(units "$corpus")
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -c 200003 -o "$scratch/perf.data" -- "$here/$tree/build/compiler" --attested="$way" --lanes 1 -c "${arguments[@]}" > /dev/null 2>&1)
    for symbol in "$@"; do
        echo "## $symbol"
        perf annotate -i "$scratch/perf.data" --stdio --no-source -s "$symbol" 2> /dev/null | awk -F: '$1+0 >= 0.4' | head -80
    done > "$out/annotate-$corpus-$way-$label.txt"
    wc -l "$out/annotate-$corpus-$way-$label.txt"
    rm -rf "$scratch/t" "$scratch/perf.data"
    ;;
trees)
    # trees CORPUS LANES ROUND TREE...: one round of each TREE's compile of the corpus (its default --attested), in turn,
    # under perf stat, and from eight lanes on with its wall time
    corpus=$1 lanes=$2 round=$3
    shift 3
    mapfile -t arguments < <(units "$corpus")
    for way in "$@"; do
        # (TREE:off runs TREE with --attested=off, recorded as TREEoff.)
        tree=${way%%:*}
        mode=()
        label=$tree
        if [ "$way" != "$tree" ]; then mode=(--attested="${way#*:}"); label=$tree${way#*:}; fi
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        start=$EPOCHREALTIME
        (cd "$scratch/t" && setarch -R taskset -c "$(cpus "$lanes")" perf stat -x, -o "$out/stat-$corpus-$lanes-$label-$round.csv" -e 'cycles:u,instructions:u,cycles:k,instructions:k' -e task-clock,page-faults -- "$here/$tree/build/compiler" "${mode[@]}" --lanes "$lanes" -c "${arguments[@]}" > /dev/null 2>&1)
        end=$EPOCHREALTIME
        echo "$start $end" | awk '{ printf "%.1f\n", ($2 - $1) * 1000 }' > "$out/wall-$corpus-$lanes-$label-$round.txt"
    done
    rm -rf "$scratch/t"
    ;;
gone)
    # gone CORPUS SET WAY LABEL TREE: the probe tree TREE's --attested=WAY of the design record's preprocessed units
    # (../672-rest-claude/scratch/CORPUS-SET: SET i, as they are, or live, the emulation's skipped tokens gone) as one
    # command on CPU 2, with BUSTER_PROBE_ATTESTED=1 and --time-stages: the probe's sums and the attested declarations'
    # counts, into results/gone-CORPUS-SET-WAY-LABEL.txt.
    corpus=$1 set=$2 way=$3 label=$4 tree=$5
    record=$here/../672-rest-claude/scratch
    mapfile -t names < "$record/$corpus-names.txt"
    gunits=("${names[@]/#/$record/$corpus-$set/}"); gunits=("${gunits[@]/%/.i}")
    goptions=()
    if [ "$corpus" = musl ]; then goptions=(-std=c99 -nostdinc -ffreestanding); fi
    rm -rf "$scratch/g"; mkdir -p "$scratch/g"
    (cd "$scratch/g" && BUSTER_PROBE_ATTESTED=1 setarch -R taskset -c 2 "$here/$tree/build/compiler" "${goptions[@]}" --attested="$way" --time-stages --lanes 1 -c "${gunits[@]}" 2>&1 > /dev/null |
        grep -E '^PROBE|^attested declarations' > "$out/gone-$corpus-$set-$way-$label.txt")
    rm -rf "$scratch/g"
    cut -c1-200 "$out/gone-$corpus-$set-$way-$label.txt"
    ;;
sqlite)
    round=$1
    for way in base head; do
        compiler=$head
        if [ "$way" = base ]; then compiler=$base; fi
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        (cd "$scratch/t" && setarch -R taskset -c 2 perf stat -x, -o "$out/stat-sqlite-$way-$round.csv" -e 'cycles:u,instructions:u,cycles:k,instructions:k' -e task-clock,page-faults -- "$compiler" "${sqlite_options[@]}" -c "$sqlite/sqlite3.c" > /dev/null 2>&1)
    done
    rm -rf "$scratch/t"
    ;;
esac
