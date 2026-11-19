#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run from a Buster checkout. Both compilers must correspond to the revisions under comparison.
set -euo pipefail
export LC_ALL=C
base=$(realpath "$1")
head=$(realpath "$2")
out=$(realpath -m "$3")
here=$(cd "$(dirname "$0")" && pwd)
catalog=$PWD/src/buster/compiler/c_builtin_amx_leaves.inc
mkdir -p "$out"/{base,head,source}
cd "$out"
[[ $(uname -sm) == 'Linux x86_64' ]]
grep -qw avx512f /proc/cpuinfo
if grep -qi 'Ryzen 7 9700X' /proc/cpuinfo; then exit 1; fi
{
    uname -srmo
    awk -F ': ' '/^model name/{print $2;exit}' /proc/cpuinfo
    cc --version | sed -n '1p'
    llvm-objdump --version | sed -n '2p'
    readelf --version | sed -n '1p'
    printf 'Base compiler SHA-256: '; sha256sum "$base" | cut -d' ' -f1
    printf 'Head compiler SHA-256: '; sha256sum "$head" | cut -d' ' -f1
} > "$out/environment.txt"
sed -nE 's/^BUSTER_CBUILTIN_AMX\(([^,]+), "([^"]+)", ([^,]+), [0-9]+, [0-9]+, [^,]+, ([A-Z0-9]+)\)/\1 \2 \3 \4/p' "$catalog" > "$out/cases"
test "$(wc -l < "$out/cases")" = 24
for side in base head; do
    : > "$out/$side/counts.tsv"
    printf '.text\n' > "$out/$side/prefixes.S"
done
while read -r id stem family ext; do
    builtin=__builtin_ia32_${stem}_internal
    feature=amx-${ext#AMX}
    feature=${feature,,}
    [[ $feature != amx-avx512 ]] || feature+=,avx10.2
    case "$family" in
        ZERO) body="*(Tile*)out = $builtin(m, n);" ;;
        LOAD) body="*(Tile*)out = $builtin(m, n, a, stride);" ;;
        STORE) body="$builtin(m, n, out, stride, *a);" ;;
        DOT) body="*(Tile*)out = $builtin(m, n, k, *a, *b, *c);" ;;
        ROW)
            case "$stem" in
                tcvtrowd2ps) type=float ;;
                *bf16*) type=__bf16 ;;
                *2ph*) type=_Float16 ;;
                tilemovrow) type=int ;;
            esac
            body="typedef $type V __attribute__((vector_size(64))); *(V*)out = $builtin(m, n, *a, row);" ;;
        *) exit 1 ;;
    esac
    cat > "$out/source/$id.c" <<CASE
typedef int Tile __attribute__((vector_size(1024), aligned(64)));
__attribute__((target("$feature")))
void tested(void *out, const Tile *a, const Tile *b, const Tile *c, unsigned short m, unsigned short n, unsigned short k, unsigned row, unsigned long stride)
{
    $body
}
CASE
    for side in base head; do
        file=$side/$id
        "${!side}" -march=x86-64 -c "source/$id.c" -o "$file.o"
        llvm-objdump -dz --x86-asm-syntax=intel "$file.o" > "$file.asm"
        readelf -WsSr "$file.o" > "$file.elf"
        readelf -Wr "$file.o" | awk '/^Relocation section/{print $3} $3~/^R_X86_64_/{print}' > "$file.relocs"
        readelf -Ws "$file.o" | awk '$1~/^[0-9]+:$/{if ($4=="FUNC" && $8~/^\.Lbuster_builtin_/) $3="helper-size"; $1=$1; print}' > "$file.symbols"
        readelf -wF "$file.o" > "$file.frames"
        objcopy -O binary --only-section=.text "$file.o" "$file.text"
        parsed=$(gawk -v text_size="$(wc -c < "$file.text")" -f "$here/decode.awk" "$file.asm")
        read -r start init load size clearstores clearbytes stores bytes clearins ins <<< "$parsed"
        [[ $(awk '$4=="FUNC" && $8~/^\.Lbuster_builtin_/ {print $3}' "$file.elf") == "$size" ]]
        gawk -v start="$start" -v size="$size" -f "$here/frames.awk" "$file.frames" > "$file.states"
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$family" "$clearstores" "$clearbytes" "$stores" "$bytes" "$size" "$clearins" "$ins" >> "$out/$side/counts.tsv"
        dd if="$file.text" of="$file.caller-prologue" bs=1 count="$init" status=none
        dd if="$file.text" of="$file.tail" bs=1 skip="$load" status=none
        asm=$out/$side/prefixes.S
        printf '.globl prefix_%s\nprefix_%s:\n.incbin "%s.text", %d, %d\njmp captured\n' "$id" "$id" "$file" "$start" "$((load-start))" >> "$asm"
        if [[ $id == TILEZERO ]]; then
            for fault in guard reserved argument; do
                case "$fault" in
                    guard) op='movb $0,-1(%rsp)' ;;
                    reserved) op='movb $1,32(%rsp)' ;;
                    argument) op='xor %edi,%edi' ;;
                esac
                printf '.globl bad_%s\nbad_%s:\n.incbin "%s.text", %d, %d\n%s\njmp captured\n' "$fault" "$fault" "$file" "$start" "$((load-start))" "$op" >> "$asm"
            done
        fi
    done
    for suffix in caller-prologue tail states relocs symbols; do cmp "$out"/{base,head}/"$id.$suffix"; done
done < "$out/cases"
printf 'unsigned control(unsigned x) { return x + 1; }\n' > "$out/source/control.c"
sed '/__attribute__((target/d' "$out/source/TILEZERO.c" > "$out/source/refusal.c"
for side in base head; do
    dest=$out/$side
    printf '.section .note.GNU-stack,"",@progbits\n' >> "$dest/prefixes.S"
    cc -std=c17 -O2 -I"$(dirname "$catalog")" "$here/capture.c" "$here/capture.S" "$dest/prefixes.S" -o "$dest/capture"
    "$dest/capture" "$dest/configs.bin"
    "${!side}" -march=x86-64 -c source/control.c -o "$dest/control.o"
    rc=0
    "${!side}" -march=x86-64 -c source/refusal.c -o "$dest/refusal.o" > "$dest/refusal.log" 2>&1 || rc=$?
    test "$rc" = 1
    grep -q 'needs target feature amx-tile' "$dest/refusal.log"
done
cmp "$out"/{base,head}/configs.bin
cmp "$out"/{base,head}/control.o
cmp "$out"/{base,head}/refusal.log
sha256sum {base,head}/configs.bin
paste "$out"/{base,head}/counts.tsv | awk '{
    if ($1!=$10 || $2!=$11 || $3<=$12 || $4<=$13 || $5<=$14 || $6<=$15 || $7<=$16) exit 1
    print
}'
