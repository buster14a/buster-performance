#!/bin/bash
cd "$(dirname "$0")"
./bp.sh build.sh probe3
for r in 1 2; do ./bp.sh run3.sh batch "perunit musl i r$r probe3" "perunit glibc i r$r probe3"; done
