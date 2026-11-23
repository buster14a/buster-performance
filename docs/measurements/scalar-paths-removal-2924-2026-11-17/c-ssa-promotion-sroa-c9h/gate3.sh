#!/bin/bash
# gate3.sh TAG ROUNDS SETTINGS...: gate2.sh's runs, all in one locked run (about 4 s a setting and configuration on the
# three corpora): ROUNDS rounds of both configurations, the settings' order turning each round; round 1's objects compared.
set -uo pipefail
D=~/buster-fast-bench/2924-c9h
tag=$1; rounds=$2; shift 2
settings=("$@")
T=$D/$tag; mkdir -p $T/ticks $T/logs
S=$T/status.txt
export EXCLUSIVE_OWNER=claude-2924-c9h EXCLUSIVE_TITLE="buster #2924: IR promotion and SROA twins (C9h)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
objects=/dev/shm/claude-2924-c9h-$tag
~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash -c '
T=$1; rounds=$2; objects=$3; shift 3; settings=("$@"); n=${#settings[@]}
for round in $(seq 1 $rounds); do
  for config in default all; do
    ordered=(); for k in $(seq 0 $((n-1))); do ordered+=("${settings[$(( (k + round) % n ))]}"); done
    '$D'/one-hold2.sh $T $config $round $objects "${ordered[@]}"
  done
done' _ $T $rounds $objects "${settings[@]}" >> $S 2>>$T/logs/lock.txt
for config in default all; do
    first=${settings[0]/:/-}
    (cd $objects/$config-$first && find . -name '*.o' | sort) > $T/logs/objects-$config.txt
    for setting in "${settings[@]:1}"; do
        name=${setting/:/-}; c=0; d=0
        while read -r f; do c=$((c+1)); cmp -s "$objects/$config-$first/$f" "$objects/$config-$name/$f" || { d=$((d+1)); echo "$config $name differs: $f" >> $T/logs/objects-differ.txt; }; done < $T/logs/objects-$config.txt
        echo "objects $config $name vs $first: $c compared, $d differ" >> $S
    done
done
rm -rf $objects
echo done >> $S
