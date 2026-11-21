#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
label=$1; base=$2; reference=$3; control=${4:-parent}
exec 8>our-timing.lock
test -x "results/$reference/compiler" || ./build-label.sh "$reference" "$base"
test -x "results/$label/compiler" || ./build-label.sh "$label" "$base" "$label.patch"
out=$PWD/results/$label/real
mkdir -p "$out"
root=$(mktemp -d /dev/shm/buster2850-object.XXXXXXXX)
trap 'rm -f "$root/sqlite3.o"; rmdir "$root"' EXIT
sql=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
sha256sum "$sql" > "$out/source.sha256"
wc -c "$sql" > "$out/source.bytes"
for mode in "$control" off on ordinary; do
    bin=$PWD/results/$label/compiler
    [ "$mode" != "$control" ] || bin=$PWD/results/$reference/compiler
    ./lock.sh bash condition-one.sh "$label" "$mode-stages" "$root" "$bin" > "$out/$mode-stages.lock" 2>&1
done
for n in $(seq 1 7); do
    flock -x 8
    # Alternate the inner pair to observe each direction's code placement.
    modes=("$control" off on on off "$control")
    if [ $((n%2)) = 0 ]; then modes=(on "$control" off off "$control" on); fi
    i=0
    for mode in "${modes[@]}"; do
        i=$((i+1)); tag="$mode-$n-$i"
        bin=$PWD/results/$label/compiler
        [ "$mode" != "$control" ] || bin=$PWD/results/$reference/compiler
        ./lock.sh bash condition-one.sh "$label" "$tag" "$root" "$bin" > "$out/$tag.lock" 2>&1
    done
    flock -u 8
done
echo COMPLETE
