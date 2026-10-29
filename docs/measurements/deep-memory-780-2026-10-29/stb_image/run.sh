#!/usr/bin/env bash
# #780 with #759: stb_image's -c with -march=native by this compiler (both paths) and by clang -O0, each linked with a
# driver clang compiles, which decodes every image as 8-bit, 16-bit and float pixels, with the file's channels and as
# RGBA, and prints each decode's size and FNV-1a hash. $1: the compiler; the unit and stb's directory are the #759
# record's survey's (survey/units/stb_image.c, survey/fetch.sh).
set -uo pipefail
B="$1"
U=/home/david/.cache/claude-148-units
C=/home/david/.cache/claude-148-corpora
mkdir -p images
magick -size 333x217 plasma:fractal -seed 7 images/base.png
magick images/base.png -sampling-factor 4:2:0 -quality 85 images/s420.jpg
magick images/base.png -sampling-factor 4:4:4 -quality 92 images/s444.jpg
magick images/base.png -sampling-factor 4:2:2 -quality 75 images/s422.jpg
magick images/base.png -interlace JPEG -quality 80 images/progressive.jpg
magick images/base.png -colorspace Gray -quality 90 images/gray.jpg
magick images/base.png -depth 16 images/deep16.png
magick images/base.png -alpha set -channel A -evaluate set 60% images/alpha.png
magick images/base.png -colors 64 images/paletted.png
magick images/base.png images/base.bmp
magick images/base.png images/base.gif
magick images/base.png -resize 1021x701! -quality 88 images/large.jpg
cp /usr/share/doc/cachyos-packageinstaller/1.jpg images/system1.jpg
cp /usr/share/doc/libsndfile/libsndfile.jpg images/system2.jpg
sha256sum images/*
"$B" -c -march=native --verify -I"$C/stb" -o ours.o "$U/stb_image.c"; echo "ours status $?"
"$B" --scalar -c -march=native --verify -I"$C/stb" -o ours-scalar.o "$U/stb_image.c"; echo "ours scalar status $?"
cmp ours.o ours-scalar.o && echo "both paths: same object"
env -u CPATH clang -O0 -march=native -c -I"$C/stb" -o clang.o "$U/stb_image.c"; echo "clang status $?"
env -u CPATH clang -O2 -c -o driver.o driver.c && cc -o ours.exe driver.o ours.o -lm && cc -o clang.exe driver.o clang.o -lm
./ours.exe images/* > ours.txt; echo "ours run $?"
./clang.exe images/* > clang.txt; echo "clang run $?"
cmp ours.txt clang.txt && echo "every decode identical: $(wc -l < ours.txt) lines"
for f in stbi__idct_simd stbi__YCbCr_to_RGB_simd; do
    gdb -q -batch -ex "break $f" -ex run -ex 'bt 2' --args ./ours.exe images/s420.jpg 2>&1 | grep -E "^Breakpoint 1, |^#[01] "
done
