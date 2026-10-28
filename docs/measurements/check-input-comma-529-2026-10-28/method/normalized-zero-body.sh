# Appended to the exact build.sh prefix. No C-unit compilation: reuse the captured assembly.
set -eu
test "$#" -eq 3
objects=$1
directory=$2
original=$3
method=${directory%/hot-*}/method
test ! -e "$directory/normalized"
mkdir "$directory/normalized"
if [[ ! -x $method/normalize-x87-self-add ]]; then
    clang -O2 -Wall -Wextra -Werror "$method/normalize-x87-self-add.c" -o "$method/normalize-x87-self-add"
    clang -O2 -Wall -Wextra -Werror "$method/elf-alloc-equal.c" -o "$method/elf-alloc-equal-strict"
fi
"$method/normalize-x87-self-add" "$directory/checker-original.s" "$directory/normalized/checker.s" > "$directory/normalized/transform.stdout" 2> "$directory/normalized/transform.stderr"
if diff -u "$directory/checker-original.s" "$directory/normalized/checker.s" > "$directory/normalized/assembly.diff"; then exit 2; else status=$?; test "$status" -eq 1; fi
clang -c -x assembler -march=native "$directory/normalized/checker.s" -o "$directory/normalized/checker.o"
linked=()
for i in "${!sources[@]}"; do
    if [[ $i == 8 ]]; then linked+=("$directory/normalized/checker.o"); else linked+=("$objects/$i.o"); fi
done
select_linker
link_program "$directory/normalized/compiler-zero" "${linked[@]}"
"$method/elf-alloc-equal-strict" "$original" "$directory/normalized/compiler-zero" --debug-only > "$directory/normalized/allocated-proof.txt"
cmp -n 64 "$original" "$directory/normalized/compiler-zero"
nm -n -S --defined-only "$directory/normalized/compiler-zero" > "$directory/normalized/symbols.txt"
cmp "$directory/original-symbols.txt" "$directory/normalized/symbols.txt"
readelf -Wl "$directory/normalized/compiler-zero" > "$directory/normalized/program-headers.txt"
cmp "$directory/original-program-headers.txt" "$directory/normalized/program-headers.txt"
sha256sum "$directory/normalized/checker.s" "$directory/normalized/checker.o" "$directory/normalized/compiler-zero" > "$directory/normalized/SHA256SUMS"
