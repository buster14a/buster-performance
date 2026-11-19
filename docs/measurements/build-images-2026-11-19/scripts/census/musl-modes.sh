#!/usr/bin/env bash
# Times musl's 1,336 units to objects: as one command on one lane, and a process a unit one after another.
set -u
here=$(cd "$(dirname "$0")" && pwd)
T=${TIMECMD:-$here/../spawn/timecmd}
source "$here/musl-opts.sh"
compiler=${COMPILER:-/home/user/buster/build/compiler}
mapfile -t units < <(LC_ALL=C "$here/musl-units.sh")
work=/dev/shm/musl-modes.$$
mkdir -p "$work/one" "$work/each"
cd "$work/one"
echo "one command, one lane:"
"$T" "$compiler" -c --lanes 1 "${opts[@]}" "${units[@]}"
cd "$work/each"
printf '%s\n' "${units[@]}" > "$work/list"
cat > "$work/loop.sh" <<LOOP
while read -r u; do "$compiler" -c --lanes 1 $(printf '%q ' "${opts[@]}") "\$u" || exit 1; done < "$work/list"
LOOP
echo "a process a unit, one at a time:"
"$T" bash "$work/loop.sh"
echo "objects: $(ls "$work/one" | wc -l) and $(ls "$work/each" | wc -l)"
same=0; differ=0
for o in "$work/one"/*.o; do if cmp -s "$o" "$work/each/${o##*/}"; then same=$((same+1)); else differ=$((differ+1)); fi; done
echo "objects the same bytes: $same, differ: $differ"
rm -rf "$work"
