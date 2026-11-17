#!/bin/bash
# job.sh LABEL PATCH [READINGS]: buster#2850's step 2, the fact words' kernel at reader time (--front-facts), on main
# 178c9e2. LABEL is main with PATCH (the sources of buster#2894, buster#2890 and the piece against main).
#   1. The kernel at reader time: READINGS readings in turn a corpus (default 5).
#   2. The same with the census's tests and C and X there (--front-tests), for the share of the records the kernel
#      makes in the expressions the whole machine takes: one reading a corpus.
#   3. T alone at reader time on the lean front (--front-types --front-lean): READINGS readings in turn.
cd "$(dirname "$0")"
label=$1; patch=$2; readings=${3:-5}
main=178c9e2606fb086025126d6f2521098342c75773
./build-label.sh "$label" $main "$patch" || exit 1
./turns.sh "" "$readings" "sqlite3 lua musl" "$label facts --shadow --passes 0 --front-facts" "$label types-lean --shadow --passes 0 --front-types --front-lean" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "$label facts-tests --shadow --passes 0 --front-facts --front-tests" || exit 1
echo job finished
