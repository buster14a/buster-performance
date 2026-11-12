#!/bin/bash
# stability.sh TAG EDIT: compile the checker's unit after EDIT (a sed script applied to a copy of the source tree), split, and count parts that differ from the base split p2.
set -e
tag=$1; shift
src=/tmp/claude-0/ps/work
rm -rf "$src"; mkdir -p "$src"; cp -r /home/user/buster/src "$src/"
. /tmp/claude-0/ps/edits.sh; "$1" "$src" "${@:2}"
F="-march=native -I$src/src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-pc-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -O3 -fmacro-prefix-map=$src/="
(cd $src && clang -gdwarf-4 -gline-tables-only $F -Xclang -disable-llvm-passes -emit-llvm -c src/buster/compiler/main_unit_checker.c -o /tmp/claude-0/ps/checker-$tag.bc)
mkdir -p /tmp/claude-0/ps/s-$tag
/tmp/claude-0/ps/presplit /tmp/claude-0/ps/checker-$tag.bc 48 /tmp/claude-0/ps/s-$tag --tests-optnone --spread 2
n=0; changed=""
for p in $(seq 0 48); do cmp -s /tmp/claude-0/ps/s-$tag/part$p.bc /tmp/claude-0/ps/s-base/part$p.bc || { n=$((n+1)); changed="$changed $p"; }; done
echo "$tag: $n parts changed:$changed"
