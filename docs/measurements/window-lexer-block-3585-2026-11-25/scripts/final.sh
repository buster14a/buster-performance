#!/bin/bash
# final.sh: the products' A/B (ab-product.sh, 21 rounds), the harnesses' over three placements each (ab.sh, 9 rounds)
# and the microbenchmark (micro.sh, 5 rounds), main against the branch. One hold.
set -uo pipefail
d=$(dirname "$0")
"$d/ab-product.sh" 21 main final
"$d/ab.sh" 9 main-p0 main-p16 main-p32 final-p0 final-p16 final-p32
"$d/micro.sh" 5 main final
