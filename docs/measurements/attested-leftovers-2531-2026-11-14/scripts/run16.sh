#!/bin/bash
# run16.sh STEP ...: #2531's leftovers on the 9700X (the caller takes the lock). Trees under this directory; results/.
#   thp TREE ROUND WAY...    musl's command, one lane, CPU 2, setarch -R: thp_fault_alloc, faults and cycles each WAY
#                            (on, noview: BUSTER_ATTESTED_NO_VIEW=1 with the probe patch, off)
#   kthp TREE WAY            perf record -e cycles:k -g of the command WAY; samples in huge-page and base-page faults by the
#                            user code that touched the page (thpattr.py)
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/../672-rest-claude/common.sh"
out=$here/results
scratch=$here/scratch
mkdir -p "$out" "$scratch"
mapfile -t musl_sources < "$here/../672-rest-claude/scratch/musl-units.txt"
step=$1
shift
way_options()
{
    case $1 in
    on) echo "--attested=on" ;;
    noview) echo "--attested=on" ;;
    unitbase) echo "--attested=on" ;;
    keptparse) echo "--attested=on" ;;
    keepprogram) echo "--attested=on" ;;
    keepprogramoff) echo "--attested=off" ;;
    off) echo "--attested=off" ;;
    esac
}
way_env()
{
    case $1 in
    noview) echo "BUSTER_ATTESTED_NO_VIEW=1" ;;
    keepprogramoff) echo "BUSTER_PROBE_NO_PROGRAM_DISCARD=1" ;;
    unitbase) echo "BUSTER_PROBE_UNIT_BASE=1" ;;
    keptparse) echo "BUSTER_PROBE_KEPT_PARSE=1" ;;
    keepprogram) echo "BUSTER_PROBE_NO_PROGRAM_DISCARD=1" ;;
    *) echo "BUSTER_ATTESTED_UNSET=1" ;;
    esac
}
case $step in
thp)
    tree=$1 round=$2
    shift 2
    for way in "$@"; do
        rm -rf "$scratch/w"; mkdir -p "$scratch/w"
        before=$(awk '/^thp_fault_alloc /{print $2}' /proc/vmstat)
        (cd "$scratch/w" && env "$(way_env "$way")" setarch -R taskset -c 2 perf stat -x, -o "$out/stat16-thp-$tree$way-$round.csv" -e 'cycles:u,cycles:k,instructions:u' -e task-clock,page-faults -- \
            "$here/$tree/build/compiler" "${musl_options[@]}" $(way_options "$way") --lanes 1 -c "${musl_sources[@]}" > /dev/null 2> "$scratch/w.err")
        after=$(awk '/^thp_fault_alloc /{print $2}' /proc/vmstat)
        echo "$tree $way round $round: thp_fault_alloc $((after - before)); $(grep page-faults "$out/stat16-thp-$tree$way-$round.csv" | cut -d, -f1) faults; cycles:k $(grep cycles:k "$out/stat16-thp-$tree$way-$round.csv" | cut -d, -f1)" | tee -a "$out/thp16.txt"
    done
    rm -rf "$scratch/w"
    ;;
kthp)
    tree=$1 way=$2
    rm -rf "$scratch/w"; mkdir -p "$scratch/w"
    (cd "$scratch/w" && env "$(way_env "$way")" setarch -R taskset -c 2 perf record -q -e cycles:k -F 20000 -g -o "$scratch/k9.data" -- \
        "$here/$tree/build/compiler" "${musl_options[@]}" $(way_options "$way") --lanes 1 -c "${musl_sources[@]}" > /dev/null 2>&1)
    perf script -i "$scratch/k9.data" -F comm,sym,dso,ip --comm compiler 2> /dev/null | python3 "$here/thpattr.py" > "$out/kthp9-$tree$way.txt"
    cat "$out/kthp9-$tree$way.txt"
    rm -rf "$scratch/w" "$scratch/k9.data"
    ;;
esac
