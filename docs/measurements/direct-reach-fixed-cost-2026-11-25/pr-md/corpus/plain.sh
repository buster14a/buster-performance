#!/bin/bash
# plain.sh COMPILER FILE: the unit's plain -c status by the default driver and by --no-direct, "FILE<TAB>default/full"
P=$1; f=$2
t=$(mktemp -d /dev/shm/plain.XXXXXX)
a=$(cd "$t" && timeout 120 "$P" -c "$f" -o "$t/a.o" > /dev/null 2>&1 < /dev/null; echo $?)
b=$(cd "$t" && timeout 120 "$P" --no-direct -c "$f" -o "$t/b.o" > /dev/null 2>&1 < /dev/null; echo $?)
printf '%s\t%s/%s\n' "$f" "$a" "$b"
rm -rf "$t"
