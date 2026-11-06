#!/bin/bash
# usage: one-run.sh OUT LABEL COMPILER COMPILER_SHA256 N ROUND
# One run, under the 9700X's lock, which its caller takes for this run alone (exclusive.sh via lock.sh). Fails, and
# writes a FAILED line, unless all of these hold:
# - the lock is held for it: BUSTER_9700X_HELD is 1 and the owner file's first line names EXCLUSIVE_OWNER;
# - COMPILER and the input have the pinned SHA-256s;
# - each of the N compiles (pinned to CPUs 0..N-1) exits 0 and leaves a nonempty object.
# Keeps the owner file, each compile's standard error, exit status and object, and each object's full SHA-256, in
# OUT/runs/ROUND-LABEL-N/, and appends one line to OUT/runs.txt.
set -u
out=$1; label=$2; C=$3; expected=$4; n=$5; round=$6
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
input_sha256=0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d
d=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" --lanes 1)
run=$out/runs/$round-$label-$n
failure=""
if [ -e "$run" ]; then
    failure="run directory exists"
fi
mkdir -p "$run"
cp /var/lib/buster-9700x/owner "$run/owner.txt" 2> /dev/null || failure="${failure:-no owner file}"
date -u +%Y-%m-%dT%H:%M:%S.%NZ > "$run/started.txt"
receipt=$(head -1 "$run/owner.txt" 2> /dev/null)
if [ -z "$failure" ] && [ "${BUSTER_9700X_HELD:-}" != 1 ]; then
    failure="BUSTER_9700X_HELD is not 1"
fi
if [ -z "$failure" ] && [[ "$receipt" != *" ${EXCLUSIVE_OWNER:-unset}: "* ]]; then
    failure="owner file does not name ${EXCLUSIVE_OWNER:-unset}"
fi
if [ -z "$failure" ] && [ "$(sha256sum < "$C" | cut -d' ' -f1)" != "$expected" ]; then
    failure="compiler SHA-256 differs from $expected"
fi
if [ -z "$failure" ] && [ "$(sha256sum < "$sqlite/sqlite3.c" | cut -d' ' -f1)" != "$input_sha256" ]; then
    failure="input SHA-256 differs"
fi
wall=-1
statuses=""
if [ -z "$failure" ]; then
    pids=()
    s=$(date +%s%N)
    for ((c = 0; c < n; c++)); do
        taskset -c $c "$C" "${d[@]}" -o "$run/w$c.o" 2> "$run/w$c.err" &
        pids+=($!)
    done
    for ((c = 0; c < n; c++)); do
        wait "${pids[$c]}"
        status=$?
        echo "$status" > "$run/w$c.status"
        statuses="$statuses${statuses:+,}$status"
        if [ "$status" != 0 ]; then
            failure="${failure:-compile $c exited $status}"
        fi
    done
    e=$(date +%s%N)
    wall=$((e - s))
    for ((c = 0; c < n; c++)); do
        if [ ! -s "$run/w$c.o" ]; then
            failure="${failure:-object $c missing or empty}"
        fi
    done
    (cd "$run" && sha256sum w*.o > objects.sha256 2> /dev/null)
fi
date -u +%Y-%m-%dT%H:%M:%S.%NZ > "$run/ended.txt"
verdict=ok
if [ -n "$failure" ]; then
    verdict="FAILED: $failure"
fi
printf 'round %s build %s workers %s wall_ns %s statuses %s verdict %s receipt %s\n' "$round" "$label" "$n" "$wall" "${statuses:-none}" \
    "$verdict" "$receipt" >> "$out/runs.txt"
[ -z "$failure" ]
