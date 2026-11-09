#!/bin/bash
. $(dirname "$0")/env.sh
mkdir -p $T
for pair in "$MAIN cb608c1f616f8fe26234bcaaa869caccc571de63" "$HEAD 4a2dd72cb5a58f688fd51c1462b9172708c14b68"; do
    set -- $pair
    if [ ! -d $T/$1 ]; then
        git clone -q https://github.com/buster14a/buster.git $T/$1 && git -C $T/$1 fetch -q origin 4a2dd72cb5a58f688fd51c1462b9172708c14b68 checker/1447-segment-tier0 && git -C $T/$1 checkout -q $2 && echo $2 > $T/$1/COMMIT
    fi
    echo "$1 $(git -C $T/$1 rev-parse HEAD)"
done
