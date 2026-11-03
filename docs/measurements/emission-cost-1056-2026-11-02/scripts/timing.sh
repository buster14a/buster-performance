# Whole -c processes over the builds placements and copies (#509): base, head, and base again as the floor.
# ab takes the lock for each round (one time-runs process); do not run this under the lock.
set -e
source ~/buster-fast-bench/1056-claude/common.sh
mkdir -p $root/run && cd $root/run
builds=()
for b in base:base head:head base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$root/shifts/${b#*:}/compiler-$s"); done
done
$root/head/build/compiler ab --rounds 3 --cpu 2 --lock $lock $root/head/build/compiler \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list "${sqlite_options[@]}" -o $root/run/sqlite3.o --list -c "${musl_flags[@]}" "${musl_files[@]}"
echo TIMING-DONE
