# Appended to the exact build.sh prefix. One checker-unit assembly capture, zero-offset proof only.
set -eu
test "$#" -eq 3
objects=$1
directory=$2
original=$3
test ! -e "$directory"
mkdir "$directory"
defines=()
clang -S "${sources[8]}" -o "$directory/checker-original.s" -MJ "$directory/checker-assembly.json" \
    "${debug[@]}" "${flags[@]}" "$optimization" "${defines[@]}"
clang -c -x assembler -march=native "$directory/checker-original.s" -o "$directory/checker-zero.o"
linked=()
for i in "${!sources[@]}"; do
    if [[ $i == 8 ]]; then linked+=("$directory/checker-zero.o"); else linked+=("$objects/$i.o"); fi
done
select_linker
link_program "$directory/compiler-zero" "${linked[@]}"
sha256sum "$directory/checker-original.s" "$directory/checker-zero.o" "$directory/compiler-zero" "$original" > "$directory/zero-SHA256SUMS"
nm -n -S --defined-only "$original" > "$directory/original-symbols.txt"
nm -n -S --defined-only "$directory/compiler-zero" > "$directory/zero-symbols.txt"
readelf -Wl "$original" > "$directory/original-program-headers.txt"
readelf -Wl "$directory/compiler-zero" > "$directory/zero-program-headers.txt"
if cmp "$directory/compiler-zero" "$original"; then
    printf 'zero-offset compiler is byte-identical to the original image\n' > "$directory/zero-proof.txt"
else
    printf 'zero-offset image differs; STOP before padding/timing for section and symbol analysis\n' > "$directory/zero-proof.txt"
    exit 3
fi
