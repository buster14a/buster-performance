#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -eu
dest=$1
gen=$2
mkdir -p "$dest"
for shape in repeated distinct mixed; do
    for n in 1024 2048; do "$gen" "$shape" "$n" > "$dest/$shape-$n.s"; done
done
for n in 1 2 4 8 9 10 16 17 18 31 32 33 34; do "$gen" distinct "$n" > "$dest/small-$n.s"; done
"$gen" bare 1024 > "$dest/bare.s"
"$gen" dwarf3 34 > "$dest/dwarf3.s"
for form in explicit implicit; do
    {
        printf '.text\n.file 1 "unit.c"\n.file 1 "hidden" "unit.c"\n'
        for ((i=0; i<17; ++i)); do printf '.file %d "d%02d//" "unit.c"\n' "$((i+2))" "$i"; done
        printf '.file 19 "d07//alias.c"\n'
        if [[ $form == explicit ]]; then printf '.file 1 "d07/" "unit.c"\n'; else printf '.file 1 "d07//unit.c"\n'; fi
        printf '.file 0 "d07//" "root.c"\n.file 20 "d07//" "after.c"\n.loc 19 7 2\nnop\n.loc 20 8 2\nret\n'
    } > "$dest/fill-$form.s"
done
cat > "$dest/duplicate-zero.s" <<'ASM'
.text
.file 0 "/dup" "/dup/main.c" md5 0x0123456789abcdef0123456789abcdef
.file 1 "/dup/" "alias.c" md5 0xfedcba9876543210fedcba9876543210
.file 1 "/dup/alias.c" md5 0xfedcba9876543210fedcba9876543210
.loc 0 1
nop
.loc 1 2
ret
ASM
for ((i=2; i<=18; i++)); do printf '.file %d "other%02d" "x.c" md5 0x0123456789abcdef0123456789abcdef\n' "$i" "$i"; done >> "$dest/duplicate-zero.s"
printf '.file 19 "/dup" "again.c" md5 0x0123456789abcdef0123456789abcdef\n.loc 19 3\nnop\n' >> "$dest/duplicate-zero.s"
cat > "$dest/slashes.s" <<'ASM'
.text
.file 0 "/work" "main.c"
.file 1 "/" "one.c"
.file 2 "//" "two.c"
.file 3 "///" "three.c"
.file 4 "." "dot.c"
.file 5 "./" "dot-alias.c"
.file 6 "d/../d" "lexical.c"
.file 7 "" "empty.c"
.file 8 "d" "one.c"
.file 9 "d/" "two.c"
.file 10 "d//" "three.c"
.file 11 "d///" "four.c"
.file 12 "d/../d/" "other.c"
.file 13 "d//alias.c"
.file 14 "/single.c"
.loc 7 9
nop
.loc 13 10
ret
ASM
cat > "$dest/late-zero.s" <<'ASM'
.text
.file 1 "sub/main.c"
.file 0 "/comp" "/comp/root.c"
.file 2 "/comp/" "after.c"
.loc 1 3
nop
.loc 0 5
ret
ASM
cat > "$dest/empty-fill.s" <<'ASM'
.text
.file 1 "plain.c"
.file 2 "sub/file.c"
.file 1 "" "plain.c"
.file 0 "/" "root.c"
.file 3 "" "after.c"
.loc 1 1
nop
.loc 3 2
ret
ASM
cat > "$dest/bad-md5.s" <<'ASM'
.file 0 "/src" "main.c" md5 0x0123456789abcdef0123456789abcdef
.file 0 "/wrong" "other.c" md5 0x0123456789abcdef0123456789abcdee
.file -1 "later"
ASM
cat > "$dest/bad-priority.s" <<'ASM'
.file 1 "one.c"
.file 1 "new" "two.c" md5 0x1 junk
.file -1 "later"
ASM
cat > "$dest/bad-path.s" <<'ASM'
.file 1 "one" "unit.c"
.file 1 "other/unit.c"
.file -1 "later"
ASM
cat > "$dest/bad-occupied.s" <<'ASM'
.file 1 "unit.c"
.file 1 "alias" "other.c"
ASM
cat > "$dest/bad-zero.s" <<'ASM'
.file 0 "sub/main.c"
ASM
cat > "$dest/bad-gap.s" <<'ASM'
.text
.file 0 "/src" "root.c"
.file 2 "sub/main.c"
.loc 2 9
ret
ASM
cat > "$dest/bad-unassigned.s" <<'ASM'
.text
.file 1 "sub/main.c"
.loc 0 1
ret
ASM
for f in "$dest"/{fill-explicit,fill-implicit,duplicate-zero,slashes,late-zero,empty-fill,bad-gap,bad-unassigned}.s; do
    sed -n '/^\.section \.debug_abbrev/,$p' "$dest/small-1.s" >> "$f"
done
# With no early hidden write, both spellings of a late fill are also GNU as controls.
for form in explicit implicit; do
    sed '/^\.file 1 "hidden"/d' "$dest/fill-$form.s" > "$dest/late-fill-$form.s"
done
{
    printf '.text\n'
    for ((i=1; i<18; ++i)); do printf '.file %d "old%02d/a.c"\n' "$i" "$i"; done
    printf '.file 0 "/compilation/" "/new/main.c"\n.file 18 "/new/next.c"\n.file 19 "/compilation/" "last.c"\n'
    printf '.loc 0 1\nnop\n.loc 18 2\nnop\n.loc 19 3\nret\n'
    sed -n '/^\.section \.debug_abbrev/,$p' "$dest/small-1.s"
} > "$dest/late-compilation.s"
{
    printf '.text\n.file 0 "/src0" "main.c"\n'
    # All twelve spellings start at bucket 31 in the initial 32-slot table.
    names=(c0000 c0018 c0041 c0059 c0137 c0150 c0177 c0189 c0205 c0214 c0216 c0261)
    i=1
    for dir in "${names[@]}" "${names[@]}"; do
        printf '.file %d "%s/" "f%d.c"\n' "$i" "$dir" "$i"
        i=$((i+1))
    done
    printf '.loc 1 1\nnop\n.loc 24 2\nret\n'
    sed -n '/^\.section \.debug_abbrev/,$p' "$dest/small-1.s"
} > "$dest/collision.s"
for n in 1024 2048; do
    sed "s|^\\.file $((n-1)) .*|.file 0 \"/src0\" \"main.c\" md5 0x0123456789abcdef0123456789abcdee|" "$dest/mixed-$n.s" > "$dest/bad-large-$n.s"
done
printf '.text\nnop\n.section .note.GNU-stack,"",@progbits\n' > "$dest/no-file.s"
