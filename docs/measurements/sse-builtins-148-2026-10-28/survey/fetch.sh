#!/usr/bin/env bash
# Fetches the #148 survey's upstream sources into $1, one new directory per project. Data only: nothing here runs them.
set -uo pipefail
root="$1"
mkdir -p "$root"
fetch()
{
    mkdir -p "$root/$1"
    curl -sSL --fail --retry 3 -o "$root/$1/$2" "$3" || echo "fetch failed: $3"
}
for f in stb_vorbis.c stb_image.h stb_truetype.h stb_image_write.h stb_ds.h stb_rect_pack.h stb_sprintf.h stb_image_resize2.h; do
    fetch stb "$f" "https://raw.githubusercontent.com/nothings/stb/master/$f"
done
fetch quickjs quickjs-2024-01-13.tar.xz https://bellard.org/quickjs/quickjs-2024-01-13.tar.xz
fetch xxhash xxhash.h https://raw.githubusercontent.com/Cyan4973/xxHash/v0.8.2/xxhash.h
for f in dr_flac.h dr_mp3.h dr_wav.h; do
    fetch dr_libs "$f" "https://raw.githubusercontent.com/mackron/dr_libs/master/$f"
done
for f in minimp3.h minimp3_ex.h; do
    fetch minimp3 "$f" "https://raw.githubusercontent.com/lieff/minimp3/master/$f"
done
fetch lz4 lz4.c https://raw.githubusercontent.com/lz4/lz4/v1.10.0/lib/lz4.c
fetch lz4 lz4.h https://raw.githubusercontent.com/lz4/lz4/v1.10.0/lib/lz4.h
fetch yyjson yyjson.c https://raw.githubusercontent.com/ibireme/yyjson/0.10.0/src/yyjson.c
fetch yyjson yyjson.h https://raw.githubusercontent.com/ibireme/yyjson/0.10.0/src/yyjson.h
fetch miniz miniz-3.0.2.zip https://github.com/richgel999/miniz/releases/download/3.0.2/miniz-3.0.2.zip
fetch duktape duktape-2.7.0.tar.xz https://github.com/svaarala/duktape/releases/download/v2.7.0/duktape-2.7.0.tar.xz
fetch nuklear nuklear.h https://raw.githubusercontent.com/Immediate-Mode-UI/Nuklear/master/nuklear.h
tar -xJf "$root/quickjs/quickjs-2024-01-13.tar.xz" -C "$root/quickjs"
tar -xJf "$root/duktape/duktape-2.7.0.tar.xz" -C "$root/duktape"
mkdir -p "$root/miniz/src" && bsdtar -xf "$root/miniz/miniz-3.0.2.zip" -C "$root/miniz/src" 2>/dev/null || unzip -q -o "$root/miniz/miniz-3.0.2.zip" -d "$root/miniz/src"
