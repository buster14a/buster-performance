#!/usr/bin/env bash
set -u
root="$HOME/buster-fast-bench/codex-602-20261027"
cd "$root"
export EXCLUSIVE_OWNER=codex-602
export EXCLUSIVE_TITLE="Buster issue 602 qualification"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/630
lock="$HOME/buster-fast-bench/exclusive.sh"
run()
{
    local name="$1"
    shift
    EXCLUSIVE_TITLE="Buster issue 602: $name" "$lock" "$@" > "evidence/$name.log" 2>&1
    local status=$?
    printf '%s %s\n' "$name" "$status" >> evidence/status.txt
    return "$status"
}
: > evidence/status.txt
pids=()
run test-checker-head ./head/build/compiler test-checker --clang /usr/bin/clang &
pids+=("$!")
run test-types ./head/build/compiler test-types --clang /usr/bin/clang &
pids+=("$!")
run test-checker-driver ./head/build/compiler test-checker-driver --executable "$root/head/build/compiler" &
pids+=("$!")
run call-graph bash -c 'cd "$1"; ./build.sh check-call-graph' bash "$root/head" &
pids+=("$!")
valid=1
run native bash evidence/native.sh || valid=0
if [ "$valid" = 1 ]; then
    run counts bash evidence/counts.sh &
    pids+=("$!")
    run measure taskset -c 2 ./measure "$root/base/build/compiler" "$root/head/build/compiler" "$root/inputs" 6 \
        /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c &
    pids+=("$!")
fi
for pid in "${pids[@]}"; do
    wait "$pid" || true
done
printf 'complete\n' >> evidence/status.txt
test "$valid" = 1
