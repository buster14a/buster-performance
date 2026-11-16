#!/bin/bash
# tokens.sh LABEL CORPUS: the corpus's preprocessed tokens, as `-c --time-stages` reports them a file (its time-process
# tokens line), in ONE hold of the lock; a line a file and the sum in results/LABEL/tokens-CORPUS.txt.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; name=$2
out=$PWD/results/$label
options=$(corpus_options "$name")
corpus_files "$name" > scratch/files-$name.txt
./lock.sh bash -c "
    mkdir -p /dev/shm/claude-2874-o
    while read -r f; do
        b=\${f##*/}
        t=\$(taskset -c 2 $out/compiler --time-stages -c $options \"\$f\" -o /dev/shm/claude-2874-o/\${b%.c}.o 2>&1 > /dev/null | awk '\$1 == \"time-process\" && \$2 == \"tokens\" { print \$3 }')
        echo \"\${t:-failed} \$f\"
    done < scratch/files-$name.txt" > "$out/tokens-$name.txt" 2>&1
awk '$1 ~ /^[0-9]+$/ { sum += $1; files += 1 } $1 == "failed" { failed += 1 } END { print "tokens", sum, "files", files, "failed", failed + 0 }' "$out/tokens-$name.txt" | tee -a "$out/tokens-$name.txt"
