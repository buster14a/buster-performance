#!/bin/bash
cd /home/user/buster-d
M=/tmp/claude-0/-home-user/6518a586-0028-5254-9ee3-c6500b72668a/scratchpad/mut-d
F=src/buster/compiler/c_check_debug.c
run() {
  name=$1; pat=$2; rep=$3
  cp $M/orig.c $F
  python3 -c "
import sys
p='$F'; s=open(p).read(); a=sys.argv[1]; b=sys.argv[2]
assert s.count(a)==1; open(p,'w').write(s.replace(a,b))" "$pat" "$rep"
  ./build.sh --config Release > $M/build-$name.log 2>&1 || { echo "$name: build failed"; return; }
  ./build/compiler test-check-debug > $M/test-$name.log 2>&1
  echo "$name: exit $? $(tail -1 $M/test-$name.log)"
}
run lines1 "_mm512_storeu_si512(kept_lines + kept, _mm512_maskz_compress_epi32(keep, packed_lines));" "_mm512_storeu_si512(kept_lines + kept, _mm512_add_epi32(_mm512_maskz_compress_epi32(keep, packed_lines), _mm512_set1_epi32(i != 0)));"
run offsets "_mm512_storeu_si512(kept_offsets + kept, _mm512_maskz_compress_epi32(keep, packed_offsets));" "_mm512_storeu_si512(kept_offsets + kept, _mm512_add_epi32(_mm512_maskz_compress_epi32(keep, packed_offsets), _mm512_set1_epi32(i != 0 ? 0x10000000 : 0)));"
run keys "_mm512_storeu_si512(kept_keys + kept, _mm512_maskz_compress_epi32(keep, packed_keys));" "_mm512_storeu_si512(kept_keys + kept, _mm512_add_epi32(_mm512_maskz_compress_epi32(keep, packed_keys), _mm512_set1_epi32(i != 0)));"
cp $M/orig.c $F
./build.sh --config Release > $M/build-restore.log 2>&1; echo restore $?
