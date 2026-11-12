#!/bin/bash
# The compiler built by itself, one step a hold of the 9700X's lock (lock.sh). Stage 1 is the `src` clone's Release
# build; a tier is t0 (the default tier) or t1 (--tier1). The units' options are the build's (./build.sh
# print-compile-flags without debug information) less -O3, -Wall and -Werror, as tools/ci/selfhost.c takes them.
#   selfbuild.sh compile TIER JOBS    every unit of ./build.sh print-sources by stage 1, JOBS at once, into
#                                     scratch/self/TIER: each unit's wall time, and the step's
#   selfbuild.sh unit TIER UNIT LANES one unit alone, as an edit of it would compile it (LANES: a number, or default)
#   selfbuild.sh link TIER            stage 2: the build's own link command with every unit's object replaced by TIER's
#   selfbuild.sh hybrid TIER UNIT     the build's own link with UNIT's object alone replaced by TIER's
#   selfbuild.sh speed NAME...        time-runs of -c sqlite3.c by stage 1's linked file (unbaked, as the others are) and
#                                     each named executable of scratch/self, and whether their objects are the same bytes
# Results in results/self. D overrides the directory, STAGE1 the tree (for trying the script elsewhere).
set -u
export LC_ALL=C
self=$(realpath "$0")
d=${D:-$HOME/buster-fast-bench/2040-claude}
tree=${STAGE1:-$d/src}
out=$d/results/self
scratch=$d/scratch/self
mkdir -p "$out" "$scratch"
stage1=$tree/build/compiler
ninja_tree=$(dirname "$(dirname "$(cd "$tree" && ./build.sh print-output | tail -1)")")
step=$1
shift
holder() { head -1 /var/lib/buster-9700x/owner > "$out/$1.holder.txt" 2> /dev/null || true; }
flags()
{
    local flag
    cd "$tree" || exit 2
    while IFS= read -r -d '' flag; do
        case $flag in -O3|-Wall|-Werror) ;; *) printf '%s\n' "$flag" ;; esac
    done < <(BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
}
tier_flag() { case $1 in t0) ;; t1) echo --tier1 ;; *) echo "unknown tier $1" >&2; exit 2 ;; esac; }
TIMEFORMAT='%R %U %S'
case $step in
    one)
        # compile's worker: TIER SOURCE.
        tier=$1; source=$2; name=$(basename "$source" .c)
        mapfile -t options < <(flags)
        cd "$tree" || exit 2
        { time "$stage1" $(tier_flag "$tier") "${options[@]}" -c -o "$scratch/$tier/$name.o" "$source" > "$scratch/$tier/$name.log" 2>&1; } 2> "$scratch/$tier/$name.time"
        echo "$name $(tail -1 "$scratch/$tier/$name.time") rc=$? $(stat -c %s "$scratch/$tier/$name.o" 2> /dev/null)" >> "$out/compile-$tier-j$SELF_JOBS.txt"
        ;;
    compile)
        tier=$1; jobs=$2
        holder "compile-$tier-j$jobs"
        rm -rf "$scratch/$tier"; mkdir -p "$scratch/$tier"; rm -f "$out/compile-$tier-j$jobs.txt"
        cd "$tree" || exit 2
        export SELF_JOBS=$jobs D=$d STAGE1=$tree
        { time ./build.sh print-sources | xargs -0 -n 1 -P "$jobs" "$self" one "$tier"; } 2> "$out/compile-$tier-j$jobs.time"
        echo "all $(tail -1 "$out/compile-$tier-j$jobs.time") units=$(wc -l < "$out/compile-$tier-j$jobs.txt") failed=$(grep -c -v 'rc=0' "$out/compile-$tier-j$jobs.txt")" >> "$out/compile-$tier-j$jobs.txt"
        ;;
    unit)
        tier=$1; unit=$2; lanes=$3
        holder "unit-$tier-$unit-$lanes"
        mapfile -t options < <(flags)
        lane=()
        [ "$lanes" = default ] || lane=(--lanes "$lanes")
        mkdir -p "$scratch/unit"
        cd "$tree" || exit 2
        { time "$stage1" "${lane[@]}" $(tier_flag "$tier") "${options[@]}" -c -o "$scratch/unit/$unit-$tier-$lanes.o" "src/buster/compiler/$unit.c" > "$out/unit-$tier-$unit-$lanes.log" 2>&1; } 2> "$out/unit-$tier-$unit-$lanes.time"
        echo "unit $unit $tier lanes=$lanes $(tail -1 "$out/unit-$tier-$unit-$lanes.time") rc=$?" >> "$out/units.txt"
        ;;
    link|hybrid)
        tier=$1; unit=${2:-}
        name=$([ "$step" = link ] && echo "stage2-$tier" || echo "hybrid-$unit-$tier")
        holder "$name"
        command=$(ninja -C "$ninja_tree" -f build-Release.ninja -t commands Release/compiler.link | tail -1)
        command=${command#*&& }
        rewritten=""
        for word in $command; do
            case $word in
                CMakeFiles/buster_*.c.o) object=$(basename "$word" .c.o) ;;
                Release/codegen/*/native.o) object=$(basename "$(dirname "$word")") ;;
                *) object="" ;;
            esac
            if [ -n "$object" ] && { [ "$step" = link ] || [ "$object" = "$unit" ]; }; then
                word=$scratch/$tier/$object.o
            fi
            rewritten="$rewritten $word"
        done
        rewritten=${rewritten/-o Release\/compiler.link/-o $scratch/$name}
        printf '%s\n' "$rewritten" > "$out/$name.command.txt"
        cd "$ninja_tree" || exit 2
        { time bash -c "$rewritten" > "$out/$name.log" 2>&1; } 2> "$out/$name.time"
        echo "$name $(tail -1 "$out/$name.time") rc=$? $(stat -c %s "$scratch/$name" 2> /dev/null)" >> "$out/links.txt"
        ;;
    speed)
        holder speed
        sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
        options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
        cp "$ninja_tree/Release/compiler.link" "$scratch/stage1"
        builds=(--build stage1 "$scratch/stage1")
        for name in "$@"; do builds+=(--build "$name" "$scratch/$name"); done
        cd "$scratch" || exit 2
        for name in stage1 "$@"; do
            "$scratch/$name" "${options[@]}" -o "$scratch/sqlite-$name.o" > "$out/sqlite-$name.log" 2>&1
            echo "$name rc=$? $(sha256sum < "$scratch/sqlite-$name.o" 2> /dev/null | cut -c1-16)" >> "$out/speed-objects.txt"
        done
        taskset -c 2 "$stage1" time-runs --runs 7 "${builds[@]}" --list "${options[@]}" -o "$scratch/runs.o" > "$out/speed.txt" 2>&1
        echo "status $?" >> "$out/speed.txt"
        ;;
    *) echo "unknown step $step" >&2; exit 2 ;;
esac
