#!/bin/bash
# The names' table at 8 K, 16 K and 32 K buckets (0.5, 1 and 2 MB), the prototype's whole front, 51 rounds each, twice.
cd /tmp/2850-fermat
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
: > sizes.out
for turn in 1 2; do
  for build in front-b13 front-b14 front-b15; do
    ./bp-run.sh "front prototype $build" ./$build dump $S 51 2>/dev/null | grep -aE "^rounds|^pass B|SAME|DIFFERS" | sed "s/^/$build: /" >> sizes.out
  done
done
touch sizes.done
