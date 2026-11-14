#!/bin/bash
# queue1.sh: step 3's view against main: correctness, then rounds; each line one hold of the lock.
cd "$(dirname "$0")"
b=./bp.sh
$b run.sh env
$b run.sh batch "compare musl 1 on" "compare glibc 1 on" "compare musl 8 on" "compare glibc 8 on"
$b run.sh batch "compare musl 1 on -Wall -Wextra" "compare glibc 1 on -Wall -Wextra" "scalar musl 8 -Wall -Wextra" "scalar glibc 8 -Wall -Wextra"
$b run.sh batch "compare musl 1 verify -g" "compare glibc 8 verify -g" "base musl 1" "base glibc 1" "compare sqlite2 1 on"
for r in 1 2 3 4 5 6 7; do
    $b run.sh batch "time musl 1 $r base:off base head" "time glibc 1 $r base:off base head"
done
for r in 1 2 3 4 5; do
    $b run.sh batch "time musl 8 $r base head" "time glibc 8 $r base head" "sqlite $r" "small $r"
done
for r in 1 2; do
    $b run.sh batch "gone musl i on p$r probe" "gone musl live off p$r probe" "gone glibc i on p$r probe" "gone glibc live off p$r probe"
done
