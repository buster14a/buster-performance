#!/usr/bin/env bash
# #569's switch campaign on the 9700X, after queue.sh: head with switch-569.diff, whose BUSTER_569_VALIDATE picks the
# lowering's validation (the vector path, the scalar validator, or none) in one executable. Each step its own hold.
set -u
source "$(dirname "$0")/common.sh"
cd "$D" || exit 1
step() { echo "== $* $(date +%T)"; }
step build switch
(cd "$D/switch" && BUSTER_DEBUG_INFO=0 "$LOCK" ./build.sh 2>&1 | tail -2)
step objects
for m in "${modes[@]}"; do
    BUSTER_569_VALIDATE=$m "$LOCK" taskset -c 2 "$D/switch/build/compiler" "${options[@]}" -o "$D/sqlite3-switch-$m.o" && sha256sum "$D/sqlite3-switch-$m.o"
done
step stages
for m in "${modes[@]}"; do
    BUSTER_569_VALIDATE=$m "$LOCK" taskset -c 2 "$D/switch/build/compiler" measure-compile --runs 11 -- "${options[@]}" > "$D/stages-$m.txt" 2>&1
    echo "stages $m status $?"
done
step rounds
"$LOCK" "$D/campaign/rounds.sh"
step done
