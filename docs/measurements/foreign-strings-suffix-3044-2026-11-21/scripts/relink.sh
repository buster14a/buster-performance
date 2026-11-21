#!/bin/bash
# relink.sh NEW OUTFILE: links every review/clinks directory's objects with NEW and with r2 (--merge-strings, one lane),
# runs both programs against expected.bin, and prints the .rodata sizes and the input .rodata section names.
S=/tmp/claude-0/-home-user/17ca334c-b389-40bd-9a1c-a7a69684778b/scratchpad
R2=$S/s3044/compiler-r2
new=$1; out=$2
W=$S/r3044/fix/relink
mkdir -p $W
export PATH=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH
: > $out
for d in $S/r3044/review/clinks/*/; do
  name=$(basename $d)
  objs=""
  for u in $(cat $d/units.txt) main; do objs="$objs $d/$u.o"; done
  status=ok
  for b in new r2; do
    bin=$new; [ $b = r2 ] && bin=$R2
    "$bin" link-foreign --merge-strings --lanes 1 -o $W/$name-$b $objs > $W/$name-$b.log 2>&1 || status="link-$b-failed"
    if [ -x $W/$name-$b ]; then
      $W/$name-$b > $W/$name-$b.out 2>/dev/null || status="run-$b-failed"
      cmp -s $W/$name-$b.out $d/expected.bin || status="output-$b-differs"
    fi
  done
  sz() { llvm-readelf -SW "$1" | awk '{for(i=1;i<=NF;i++) if($i==".rodata") print $(i+4)}'; }
  secs=$(llvm-readelf -SW $d/u0.o | awk '{for(i=1;i<=NF;i++) if($i ~ /^\.rodata/) print $i}' | sort -u | tr '\n' ' ')
  echo "$name $status new $((16#$(sz $W/$name-new))) r2 $((16#$(sz $W/$name-r2))) [$secs]" >> $out
done
