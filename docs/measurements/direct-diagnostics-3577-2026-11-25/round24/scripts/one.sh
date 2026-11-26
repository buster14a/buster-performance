#!/bin/bash
# One file: default -c vs --no-direct -c. Prints: CLASS<TAB>direct-status<TAB>full-status<TAB>objects<TAB>file
P=$1; f=$2; t=$(mktemp -d)
timeout 60 "$P" -c "$f" -o "$t/a.o" > "$t/a.txt" 2>&1; sa=$?
timeout 60 "$P" --no-direct -c "$f" -o "$t/b.o" > "$t/b.txt" 2>&1; sb=$?
obj=none
if [ -f "$t/a.o" ] && [ -f "$t/b.o" ]; then cmp -s "$t/a.o" "$t/b.o" && obj=same || obj=differs; elif [ -f "$t/a.o" ]; then obj=direct-only; elif [ -f "$t/b.o" ]; then obj=full-only; fi
if [ "$sa" = "$sb" ] && cmp -s "$t/a.txt" "$t/b.txt"; then cls=SAME; else cls=DIFF; fi
first=$(grep -m1 -o '\(error\|warning\): .*' "$t/b.txt" | head -c 200)
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$cls" "$sa" "$sb" "$obj" "$f" "$first"
rm -rf "$t"
