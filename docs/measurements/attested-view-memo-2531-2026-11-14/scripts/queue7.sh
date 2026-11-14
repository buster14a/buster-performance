#!/bin/bash
cd "$(dirname "$0")"
./bp.sh build.sh s4b
./bp.sh run4.sh warm s4b
./bp.sh run4.sh ppucompare s4b
for r in 1 2 3 4 5; do
    ./bp.sh run4.sh ppu $r s4b none memo
    ./bp.sh run4.sh sqlite $r s4b none memo
done
