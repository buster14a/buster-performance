#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# units.sh: the units the other scripts compile, made inside one hold of the lock:
#   scratch/sqlite3.i        the frozen sqlite3.c preprocessed (-E -P, the compile_time options)
#   scratch/sqlite3-spine.i  the same without its function bodies (allcore spine: each body a `;`)
#   scratch/musl.all.txt     musl's units, the first source of each base name (two units of one name would write one
#                            object), an absolute path a line
#   scratch/musl.p0.txt ...  the same dealt to 8 workers, largest first, a worker's share a file
set -u
cd "$(dirname "$0")"
. ./common.sh
out=results/units
mkdir -p "$out" scratch
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
"$compiler" -E -P "${SQLITE_OPTIONS[@]}" "$sqlite/sqlite3.c" -o scratch/sqlite3.i || status=1
./allcore spine scratch/sqlite3.i scratch/sqlite3-spine.i > "$out/spine.txt" || status=1
sha256sum scratch/sqlite3.i scratch/sqlite3-spine.i >> "$out/spine.txt"
wc -c scratch/sqlite3.i scratch/sqlite3-spine.i >> "$out/spine.txt"
: > scratch/musl.all.txt
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; echo "$f" >> scratch/musl.all.txt; fi
done
for w in 0 1 2 3 4 5 6 7; do : > "scratch/musl.p$w.txt"; done
n=0
while read -r size path; do
    echo "$path" >> "scratch/musl.p$((n % 8)).txt"
    n=$((n + 1))
done < <(xargs stat -c '%s %n' < scratch/musl.all.txt | sort -k1,1nr -k2,2)
{
    echo "units $(wc -l < scratch/musl.all.txt)"
    echo "bytes $(xargs cat < scratch/musl.all.txt | wc -c)"
    for w in 0 1 2 3 4 5 6 7; do echo "worker $w units $(wc -l < "scratch/musl.p$w.txt") bytes $(xargs cat < "scratch/musl.p$w.txt" | wc -c)"; done
    sha256sum scratch/musl.all.txt scratch/musl.p?.txt
} > "$out/musl.txt"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
