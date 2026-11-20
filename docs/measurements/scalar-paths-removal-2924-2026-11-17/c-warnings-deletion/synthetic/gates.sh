#!/bin/bash
# #2924 C12c-2: the warnings' twins (bit 12) on synthetic units the gate's lists never reach (synth.py): typo correction
# (60 units of 3,000 globals and 50 misspelled uses), -Wexcessive-regsave (60 units of 200 functions with 8 calls each)
# and selections (60 units of 2,000 _Generic expressions). -fsyntax-only -ferror-limit=0 -Wall, the 60 units of a kind
# one command: ab, three rounds, around time-runs (three runs) of no bit, bit 12 and no bit again, under the lock, CPU 2;
# then stderr of no bit and bit 12 compared.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
G=$D/../c12c
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the warnings on synthetic units, C12c-2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
until grep -qx done logs-u/status.txt 2>/dev/null; do sleep 30; done
mkdir -p logs-s
: > logs-s/status.txt
out=/dev/shm/claude-2924-c12w-synth
BUILDS=(--build none "$G/compilers/compiler-areas0" --build bit12 "$G/compilers/compiler-areas4096" --build none-again "$G/compilers/again/compiler-areas0")
for kind in typo regsave generic; do
    args=(-fsyntax-only -ferror-limit=0 -Wall "$D/synth/$kind"/*.c)
    for b in 0 4096; do
        $L timeout -k 5 600 taskset -c 2 "$G/compilers/compiler-areas$b" "${args[@]}" > /dev/null 2> "logs-s/stderr-$kind-$b.txt"
        echo "stderr $kind areas$b: $? $(wc -l < logs-s/stderr-$kind-$b.txt) lines" >> logs-s/status.txt
    done
    cmp -s "logs-s/stderr-$kind-0.txt" "logs-s/stderr-$kind-4096.txt" && echo "stderr $kind: same" >> logs-s/status.txt || echo "stderr $kind: DIFFER" >> logs-s/status.txt
    rm -rf "$out"; mkdir -p "$out"
    (cd "$out" && "$G/compilers/main" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$G/compilers/main" \
        -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs-s/time-$kind.log" 2>&1)
    echo "time $kind: $?" >> logs-s/status.txt
done
rm -rf "$out"
echo done >> logs-s/status.txt
