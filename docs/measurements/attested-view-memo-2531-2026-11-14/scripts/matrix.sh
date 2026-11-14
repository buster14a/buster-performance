#!/bin/bash
c=${1:-/home/user/buster/build/compiler}
b=$HOME/.cache/claude-2531/bin
for corpus in musl glibc; do
  $b/compare.sh $c $corpus 4 "--attested=on" "--attested=off" | tail -2
  $b/compare.sh $c $corpus 1 "--attested=on -Wall -Wextra" "--attested=off -Wall -Wextra" | tail -2
  $b/compare.sh $c $corpus 4 "--attested=on -Wall -Wextra" "--scalar -Wall -Wextra" | tail -2
  $b/compare.sh $c $corpus 1 "--attested=verify -g" "--attested=off -g" | tail -2
done
