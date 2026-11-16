#!/bin/bash
# trim.sh FILE...: cut each "exclusive.sh: waiting for the 9700X, held by: ..." line of a run's output to its first 200
# characters. The lock prints its holder's whole command, which for another session's job was a line of 100 KB; what
# the record keeps of it is that the run waited, and for whom.
for f in "$@"; do
    if grep -q '^exclusive.sh: waiting' "$f"; then
        awk '/^exclusive.sh: waiting/ { print substr($0, 1, 200) " [cut]"; next } { print }' "$f" > "$f.cut" && mv "$f.cut" "$f"
    fi
done
