#!/bin/bash
# job-object.sh: what the object's write costs -c sqlite3.c: one copy of the pull request's head (ab.sh's SAME), its
# object written to /dev/shm (the file there from the round before, so the write is in place, as a rebuild's is)
# against the same compile with /dev/shm/2873-ab-null.o a link to /dev/null. 81 rounds, twice, a hold of the lock each.
cd "$(dirname "$0")"
: > job-object.done
log=object.log
: > "$log"
for label in sqlite-file-null sqlite-file-null-again; do
    start=$(date +%s)
    SAME=1 ./lock.sh bash -c 'ln -sfn /dev/null /dev/shm/2873-ab-null.o && exec timeout -k 10 900 ./ab.sh "$0" sqlite 81 "file=$1" "null=$1"' "results/abo-$label" "$PWD/head/build/compiler" > "results/abo-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abo-$label" file null > "results/abstato-$label.txt" 2>&1
    ls -la /dev/shm/2873-ab-* >> "$log" 2>&1
done
echo done >> "$log"
echo finished > job-object.done
