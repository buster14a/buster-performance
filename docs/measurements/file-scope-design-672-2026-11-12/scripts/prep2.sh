#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# prep2.sh: musl's units without bodies, again, inside one hold of the lock. prep.sh's first ones failed in 255 units:
# a body cut to `;` leaves musl's weak_alias() (`extern __typeof(f) g __attribute__((__weak__, __alias__("f")));`)
# naming a function the unit no longer defines, an error ("alias must point to a defined variable or function"). The
# alias attribute is cut from the body-less units' text here (287 of them in 192 units), which leaves the declaration.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$PWD/results/prep
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder2.txt"
grep -c '__alias__' scratch/musl-spine/*.i | awk -F: '{ s += $2; n += $2 != 0 } END { print s " alias attributes in " n " units, before" }' > "$out/spine-alias.txt"
sed -i -E 's/__attribute__\(\(__weak__, __alias__\("[^"]*"\)\)\)//g' scratch/musl-spine/*.i || status=1
grep -c '__alias__' scratch/musl-spine/*.i | awk -F: '{ s += $2 } END { print s " left" }' >> "$out/spine-alias.txt"
cat scratch/musl-spine/*.i | sha256sum > "$out/musl-spine.sha256"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done2"; fi
exit $status
