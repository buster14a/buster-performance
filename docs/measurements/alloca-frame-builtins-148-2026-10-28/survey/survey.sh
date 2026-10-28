#!/usr/bin/env bash
# The #148 survey: each unit by this compiler's -c and by clang -c, printing ours' first error. $1: compiler, $2: out dir.
set -uo pipefail
compiler="$1"
out="$2"
mkdir -p "$out"
C=/home/david/.cache/claude-148-corpora
U=/home/david/.cache/claude-148-units
Q=$C/quickjs/quickjs-2024-01-13
unit()
{
    local name="$1"; shift
    local ours clangs
    timeout 120 "$compiler" -c -o "$out/$name.o" "$@" > "$out/$name.ours.txt" 2>&1; ours=$?
    timeout 120 clang -c -w -o "$out/$name.clang.o" "$@" > "$out/$name.clang.txt" 2>&1; clangs=$?
    printf '%-22s ours %3d clang %3d  %s\n' "$name" "$ours" "$clangs" "$(grep -m1 -E 'error|fatal' "$out/$name.ours.txt" | cut -c 1-170)"
}
for f in stb_image stb_truetype stb_image_write stb_ds stb_rect_pack; do unit "$f" -I$C/stb $U/$f.c; done
unit stb_vorbis $C/stb/stb_vorbis.c
unit xxhash -I$C/xxhash $U/xxhash.c
for f in dr_flac dr_mp3 dr_wav; do unit "$f" -I$C/dr_libs $U/$f.c; done
for f in minimp3 minimp3_ex; do unit "$f" -I$C/minimp3 $U/$f.c; done
unit nuklear -I$C/nuklear $U/nuklear.c
unit lz4 $C/lz4/lz4.c
unit yyjson $C/yyjson/yyjson.c
unit miniz $C/miniz/src/miniz.c
unit duktape $C/duktape/duktape-2.7.0/src/duktape.c
for f in cutils libbf libregexp libunicode quickjs quickjs-libc qjs; do
    unit "quickjs-$f" -D_GNU_SOURCE '-DCONFIG_VERSION="2024-01-13"' -DCONFIG_BIGNUM $Q/$f.c
done
