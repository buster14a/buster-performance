# Appended to the exact build.sh prefix. All original C source and other forty objects stay unchanged.
set -eu
test "$#" -eq 2
objects=$1
directory=$2
method=${directory%/hot-*}/method
placements=$directory/placements
test ! -e "$placements"
mkdir "$placements"
test -s "$directory/normalized/allocated-proof.txt"
if [[ ! -x $method/pad-hot-assembly ]]; then
    clang -O2 -Wall -Wextra -Werror "$method/pad-hot-assembly.c" -o "$method/pad-hot-assembly"
fi
select_linker
anchor()
{
    local names=()
    mapfile -t names < <(nm "$1" | awk -v symbol="$2" '$3 == symbol {print "0x" $1}')
    test "${#names[@]}" -eq 1
    printf '%s\n' "${names[0]}"
}
for bytes in 0 704 1408 2112 2752 3456; do
    "$method/pad-hot-assembly" "$directory/normalized/checker.s" "$placements/checker-$bytes.s" "$bytes"
    if [[ $bytes == 0 ]]; then
        cmp "$directory/normalized/checker.s" "$placements/checker-$bytes.s"
        cp "$directory/normalized/compiler-zero" "$placements/compiler-$bytes"
    else
        if diff -u "$directory/normalized/checker.s" "$placements/checker-$bytes.s" > "$placements/offset-$bytes.diff"; then exit 2; else status=$?; test "$status" -eq 1; fi
        clang -c -x assembler -march=native "$placements/checker-$bytes.s" -o "$placements/checker-$bytes.o"
        linked=()
        for i in "${!sources[@]}"; do
            if [[ $i == 8 ]]; then linked+=("$placements/checker-$bytes.o"); else linked+=("$objects/$i.o"); fi
        done
        link_program "$placements/compiler-$bytes" "${linked[@]}"
    fi
    for symbol in check_input_run check_input_expressions; do
        reference=$(anchor "$directory/normalized/compiler-zero" "$symbol")
        actual=$(anchor "$placements/compiler-$bytes" "$symbol")
        test "$((actual-reference))" -eq "$bytes"
        printf '%s\t%s\t%s\t%s\t%s\n' "$bytes" "$symbol" "$reference" "$actual" "$((actual-reference))" >> "$placements/addresses.tsv"
    done
    sha256sum "$placements/compiler-$bytes" "$placements/checker-$bytes.s" >> "$placements/SHA256SUMS"
done
