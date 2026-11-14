#!/bin/bash
cd "$(dirname "$0")"
b=./bp.sh
$b run2.sh batch "census musl head" "census glibc head"
$b run2.sh batch "profile musl on head-u head" "profile musl on base-u base"
$b run2.sh batch "kprofile musl head head" "kprofile musl base base"
$b run2.sh batch "profile glibc on head-u head" "profile glibc on base-u base"
./bp.sh build.sh s4
./bp.sh run4.sh warm s4
./bp.sh run4.sh ppucompare s4
for r in 1 2 3 4 5; do
    ./bp.sh run4.sh ppu $r s4 none memo
    ./bp.sh run4.sh sqlite $r s4 none memo
done
