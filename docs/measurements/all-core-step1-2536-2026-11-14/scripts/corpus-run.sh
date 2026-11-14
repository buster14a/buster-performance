#!/bin/bash
# corpus-run.sh COMPILER OUT NAME DIRECTORY TAG EXTRA WINDOW OPTIONS...: OUT/NAME.files' sources each to an object in
# OUT/NAME/TAG, from DIRECTORY, with EXTRA, WINDOW and OPTIONS; each one's status in OUT/NAME/TAG.status.
compiler=$1 out=$2 name=$3 directory=$4 tag=$5 extra=$6 window=$7
shift 7
cd "$directory" || exit 1
mkdir -p "$out/$name/$tag"
: > "$out/$name/$tag.status"
while read -r f; do
    base=$(basename "$f" .c)
    timeout 120 "$compiler" $extra $window --lanes 1 "$@" -c "$f" -o "$out/$name/$tag/$base.o" 2> "$out/$name/$tag/$base.err" < /dev/null
    echo "$? $base" >> "$out/$name/$tag.status"
done < "$out/$name.files"
