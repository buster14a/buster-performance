# Appended to the exact build.sh prefix. No compiler source is compiled; only padding assembly is new.
set -eu
test "$#" -eq 3
object_directory=$1
directory=$2
original=$3
test ! -e "$directory"
mkdir "$directory"
select_linker
linked=()
for i in "${!sources[@]}"; do linked+=("$object_directory/$i.o"); done
link_program "$directory/compiler-reference" "${linked[@]}"
cmp "$directory/compiler-reference" "$original"
readelf -SW "$object_directory/2.o" > "$directory/frontend-sections.txt"
anchor()
{
    local names=()
    if [[ $2 == parse_translation_unit ]]; then
        mapfile -t names < <(nm "$1" | awk '$2 == "T" && $3 == "parse_translation_unit" {print "0x" $1}')
    else
        mapfile -t names < <(nm "$1" | awk '$3 == "check_input_run" {print "0x" $1}')
    fi
    test "${#names[@]}" -eq 1
    printf '%s\n' "${names[0]}"
}
for bytes in 0 704 1408 2112 2752 3456; do
    link_shifted "$directory/compiler-$bytes" 2 "$bytes"
    for symbol in check_input_run parse_translation_unit; do
        reference=$(anchor "$directory/compiler-reference" "$symbol")
        actual=$(anchor "$directory/compiler-$bytes" "$symbol")
        test "$((actual - reference))" -eq "$bytes"
        printf '%s\t%s\t%s\t%s\t%s\n' "$bytes" "$symbol" "$reference" "$actual" "$((actual-reference))" >> "$directory/addresses.tsv"
    done
done
objcopy --dump-section ".text=$directory/reference.text" "$directory/compiler-reference" "$directory/extract-copy.elf"
objcopy --dump-section ".text=$directory/zero.text" "$directory/compiler-0" "$directory/extract-copy.elf"
cmp "$directory/reference.text" "$directory/zero.text"
rm "$directory/extract-copy.elf"
sha256sum "$directory"/compiler-* > "$directory/compiler-SHA256SUMS"
