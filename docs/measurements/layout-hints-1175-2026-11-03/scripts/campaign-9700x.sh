#!/usr/bin/env bash
# campaign-9700x.sh REPOSITORY NAME=COMMIT...: #1175's acceptance measurement on the Ryzen 7 9700X.
# See ../ACCEPTANCE.md for the integrated pair, strict counter manifest and validation status.
#
# Builds each commit (the first is the reference: main) at four placements of its code, then counts and times them:
#
# - Placements. The checker's own code is in .text.buster_checker, which starts each unit on a page (#502), so a shift
#   of .text (`./build.sh shifts`, #509) moves it only by whole pages: its offsets in the page, which the caches and
#   the op cache see, stay. Each placement therefore starts main_unit_checker.c's part of that section SKIP bytes into
#   its page, by a line of file-scope assembly appended to that unit for the build alone (0xcc bytes, never run), and
#   moves the rest of the code with `./build.sh shifts DIR main.c SHIFT`, as #880's record did. The placements,
#   SKIP:SHIFT, are 0:0 (the code as buster ships it), 688:256, 1376:512 and 2064:768: the skips fall 0, 48, 32 and 16
#   bytes into a 64-byte line. The receipts give each executable's offsets of a few functions in their page.
# - Objects. Every object of sqlite3.c and of the 139 musl units (#182's list, in pgo-port-880-2026-11-02/logs), from
#   every executable, must be the reference's at 0:0, byte for byte.
# - Counters. At every placement, perf counts taken branches (ex_ret_brn_tkn), cycles and instructions, in user mode,
#   three times per list: sqlite3.c's -fsyntax-only and -c, and the musl units' -c, with the frozen corpus's headers
#   and predefines. scripts/counters.c summarizes them.
# - Times. time-runs times the same lists over the placements and two fresh copies of each executable.
#
#   EXCLUSIVE_TITLE="<session title>" EXCLUSIVE_LINK="<session, PR or issue>" \
#       campaign-9700x.sh ~/buster main=COMMIT head=COMMIT
#
# REPOSITORY is a buster clone that has the commits (fetch them first). Every build, each placement's counts, each
# executable's objects and the time-runs take the 9700X's lock for themselves alone (EXCLUSIVE_OWNER defaults to
# claude-1175); builds also go through `cores` where it is on PATH. DIRECTORY (CAMPAIGN_DIRECTORY, default
# ~/buster-fast-bench/claude-1175) gets tree-NAME (a detached worktree, left clean), shifts/NAME/compiler-SKIP-SHIFT and
# logs/: receipts.txt, counters-expected.txt (the planned sample grid), counters.txt (a line per run),
# perf-*.csv (unfiltered perf output), counters-summary.txt and time-runs.txt.
#
# For a dry run off the 9700X: CAMPAIGN_LOCK=env, CAMPAIGN_HOST_ARCH=native, CAMPAIGN_EVENTS (perf's events, or
# "none"), CAMPAIGN_CORPUS (the frozen corpus, tools/ci/fetch-corpus.sh's layout), CAMPAIGN_CPU (default 2),
# CAMPAIGN_RUNS (time-runs' runs, default 11) and CAMPAIGN_LANES (-c's --lanes, empty for the default).
set -euo pipefail
shopt -s inherit_errexit

[ "$#" -ge 3 ] || { sed -n '2,/^set -euo/p' "$0" | sed '$d' >&2; exit 2; }
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repository="$(cd -- "$1" && pwd -P)"
shift
R="${CAMPAIGN_DIRECTORY:-$HOME/buster-fast-bench/claude-1175}"
C="${CAMPAIGN_CORPUS:-/var/lib/buster-9700x/corpora/preprocessor-391e729af658}"
lock="${CAMPAIGN_LOCK:-$HOME/buster-fast-bench/exclusive.sh}"
arch="${CAMPAIGN_HOST_ARCH:-znver5}"
events="${CAMPAIGN_EVENTS:-instructions:u,cycles:u,ex_ret_brn_tkn:u}"
cpu="${CAMPAIGN_CPU:-2}"
runs="${CAMPAIGN_RUNS:-11}"
lanes=()
[ -z "${CAMPAIGN_LANES:-}" ] || lanes=(--lanes "$CAMPAIGN_LANES")
placements=(0:0 688:256 1376:512 2064:768)
unit=src/buster/compiler/main_unit_checker.c
musl_list="$here/../../pgo-port-880-2026-11-02/logs/musl-corpus-139.txt"
export EXCLUSIVE_OWNER="${EXCLUSIVE_OWNER:-claude-1175}"
export EXCLUSIVE_TITLE="${EXCLUSIVE_TITLE:-#1175 placement campaign: rare tests of the checker}"
export EXCLUSIVE_LINK="${EXCLUSIVE_LINK:-https://github.com/buster14a/buster/issues/1175}"
export CORES_TITLE="$EXCLUSIVE_TITLE" CORES_LINK="$EXCLUSIVE_LINK"
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
queue=()
if command -v cores > /dev/null 2>&1; then
    queue=(cores --all --)
fi

names=()
commits=()
for pair in "$@"; do
    [[ "$pair" == *=* ]] || { echo "campaign: $pair isn't NAME=COMMIT" >&2; exit 2; }
    names+=("${pair%%=*}")
    commits+=("$(git -C "$repository" rev-parse --verify "${pair#*=}^{commit}")")
done
mkdir -p "$R/logs" "$R/out" "$R/copies"
"$lock" cc -std=c17 -O2 -Wall -Wextra -Werror -o "$R/counters" "$here/counters.c"

SQLITE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
        -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
        -isystem "$C/headers/usr/include" -I"$C/sqlite")
mapfile -t units < "$musl_list"
MUSL=(-march=znver5 -x c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700
      -I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal"
      -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include"
      "${units[@]/#/$C/libc/musl/}")
syntax=(-fsyntax-only "${SQLITE[@]}" "$C/sqlite/sqlite3.c")
sqlite_c=(-c "${lanes[@]}" "${SQLITE[@]}" -o "$R/out/sqlite3.o" "$C/sqlite/sqlite3.c")
musl_c=(-c "${lanes[@]}" "${MUSL[@]}")

# The builds: a detached worktree per commit, built once per placement, its checker unit restored after each.
executables=()
for i in "${!names[@]}"; do
    name=${names[$i]}
    tree="$R/tree-$name"
    if [ -d "$tree" ]; then
        git -C "$tree" checkout -q -f --detach "${commits[$i]}"
    else
        git -C "$repository" worktree add -q --detach "$tree" "${commits[$i]}"
    fi
    mkdir -p "$R/shifts/$name"
    for placement in "${placements[@]}"; do
        skip=${placement%%:*}
        bytes=${placement#*:}
        git -C "$tree" checkout -q -- "$unit"
        if [ "$skip" != 0 ]; then
            printf '%s\n' "// campaign-9700x.sh (#1175): the checker unit's code $skip bytes into its page; a measurement build." \
                "__asm__(\".section .text.buster_checker,\\\"ax\\\",@progbits\\n\\t.skip $skip, 0xcc\\n\\t.text\");" >> "$tree/$unit"
        fi
        (cd "$tree" && "${queue[@]}" "$lock" env BUSTER_HOST_ARCH="$arch" BUSTER_DEBUG_INFO=0 \
            ./build.sh shifts "$R/build/$name" main.c "$bytes")
        cp -f "$R/build/$name/compiler-$bytes" "$R/shifts/$name/compiler-$skip-$bytes"
        executables+=("$name $skip-$bytes $R/shifts/$name/compiler-$skip-$bytes")
    done
    git -C "$tree" checkout -q -- "$unit"
done

# Receipts: the host, the tools, the commits, the executables and their code's offsets in its pages, and every
# executable's objects against the reference's at 0:0.
reference_objects="$R/objects/${names[0]}-0-0"
{
    echo "== host"
    uname -a
    grep -m1 'model name' /proc/cpuinfo
    echo "cpu$cpu governor $(cat "/sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor" 2> /dev/null)"
    echo "== tools"
    clang --version | head -1
    perf --version 2> /dev/null || echo "perf: none"
    echo "== builds"
    for i in "${!names[@]}"; do
        echo "${names[$i]} ${commits[$i]}"
    done
    echo "== executables: sha256, then the offsets in their pages of check_input_resolve_range, check_graph_run and main"
    for line in "${executables[@]}"; do
        read -r name placement path <<< "$line"
        offsets=""
        while read -r address _ symbol; do
            offsets+="$symbol=$(printf '0x%03x' $((16#$address % 4096))) "
        done < <(nm "$path" | awk '$2 ~ /^[tT]$/ && ($3 == "check_input_resolve_range" || $3 == "check_graph_run" || $3 == "main") && !seen[$3]++')
        echo "$name $placement $(sha256sum "$path" | cut -c1-16) $offsets"
    done
    echo "== objects"
    for line in "${executables[@]}"; do
        read -r name placement path <<< "$line"
        directory="$R/objects/$name-$placement"
        rm -rf "$directory"
        mkdir -p "$directory"
        (cd "$directory" && "$lock" taskset -c "$cpu" "$path" -c "${lanes[@]}" "${SQLITE[@]}" -o sqlite3.o "$C/sqlite/sqlite3.c" \
            && "$lock" taskset -c "$cpu" "$path" "${musl_c[@]}")
        if diff -r -q "$reference_objects" "$directory" > /dev/null; then
            echo "$name $placement: $(find "$directory" -name '*.o' | wc -l) objects, the reference's byte for byte"
        else
            echo "$name $placement: objects differ from ${names[0]} 0-0's"
        fi
    done
} 2>&1 | tee "$R/logs/receipts.txt"
if grep -q 'objects differ' "$R/logs/receipts.txt"; then
    echo "campaign: the executables' objects differ" >&2
    exit 1
fi

# Counters: three runs of each list at every placement of every build, the lock held for one placement's runs. perf's
# events must be user-mode ones (":u").
printf '%s\0' "${syntax[@]}" > "$R/arguments-syntax"
printf '%s\0' "${sqlite_c[@]}" > "$R/arguments-sqlite-c"
printf '%s\0' "${musl_c[@]}" > "$R/arguments-musl-c"
: > "$R/logs/counters.txt"
: > "$R/logs/counters-summary.txt"
if [ "$events" != none ]; then
    # Declare the intended grid independently of perf's output, so an absent whole event/build cannot disappear.
    IFS=, read -r -a event_names <<< "$events"
    : > "$R/logs/counters-expected.txt"
    for line in "${executables[@]}"; do
        read -r name placement path <<< "$line"
        for run in 1 2 3; do
            for mode in syntax sqlite-c musl-c; do
                for event in "${event_names[@]}"; do
                    printf '%s %s %s %s %s\n' "$name" "$placement" "$mode" "$run" "$event"
                done
            done
        done
    done > "$R/logs/counters-expected.txt"
    for line in "${executables[@]}"; do
        read -r name placement path <<< "$line"
        "$lock" bash -c '
            set -euo pipefail
            R=$1 binary=$2 name=$3 placement=$4 cpu=$5 events=$6
            for run in 1 2 3; do
                for mode in syntax sqlite-c musl-c; do
                    mapfile -d "" -t arguments < "$R/arguments-$mode"
                    (cd "$R/out" && taskset -c "$cpu" perf stat -x, -e "$events" -- "$binary" "${arguments[@]}" 2>&1 > /dev/null) |
                        tee "$R/logs/perf-$name-$placement-$mode-$run.csv" |
                        awk -F, -v b="$name" -v p="$placement" -v m="$mode" -v r="$run" \
                            '"'"'$3 ~ /:u$/ { printf "%s %s %s %s %s %s\n", b, p, m, r, $3, $1 }'"'"'
                done
            done
        ' counters "$R" "$path" "$name" "$placement" "$cpu" "$events" >> "$R/logs/counters.txt"
    done
    "$R/counters" "$R/logs/counters-expected.txt" < "$R/logs/counters.txt" | tee "$R/logs/counters-summary.txt"
fi

# time-runs over the placements and two fresh copies of each executable, the reference's 0:0 running it.
builds=()
for line in "${executables[@]}"; do
    read -r name placement path <<< "$line"
    builds+=(--build "$name" "$path")
done
(cd "$R/out" && "$lock" taskset -c "$cpu" "$R/shifts/${names[0]}/compiler-0-0" time-runs --runs "$runs" --warmups 1 --copies 2 \
    --directory "$R/copies" "${builds[@]}" --list "${syntax[@]}" --list "${sqlite_c[@]}" --list "${musl_c[@]}") 2>&1 |
    tee "$R/logs/time-runs.txt"
