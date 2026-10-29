#!/bin/bash
# Writes a campaign's jobs: A2's 43 units in A2's order (4-jobsA.txt's), each a line "UNIT PASSES RUN...", 24 passes
# (12 for sqlite3.c). Arguments: OUTPUT RUN...
out="$1"
shift
: > "$out"
for unit in 00200 00204 00182 sqlite l16x19f192 l16x38f192 l16x38f384 l16x77f384 l16x5f384 l16x10f384 l16x19f384 l16x10f192 l8x38f384 l4x38f384 \
            d2x1f384s288 d2x1f480s240 d16x19f384s288 d16x19f384s192 00213 h16x1 h16x2 h16x5 h16x10 h16x19 h16x38 h16x77 h16x154 h2x40 h2x80 h2x160 \
            h2x240 h2x320 h2x480 h64x1 h64x3 h64x10 b16x5 b16x19 b16x77 x16x10 x16x19 x16x38 x16x77; do
    passes=24
    if [ "$unit" = sqlite ]; then
        passes=12
    fi
    echo "$unit $passes $*" >> "$out"
done
