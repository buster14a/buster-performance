#!/bin/bash
# 1378 qualification: one lock hold per round; each round runs every binary on every input once, pinned to CPU 2.
cd ~/buster-fast-bench/1378-claude
mkdir -p inputs out
gen_local() { { printf 'int g(int x) { int '; seq -s, -f 'a%.0f = x' 0 $(($1 - 1)); printf '; return a0 + a%d; }\n' $(($1 - 1)); } > inputs/local_$1.c; }
gen_file()  { { printf 'int '; seq -s, -f 'a%.0f = 0' 0 $(($1 - 1)); printf ';\nint g(void) { return a0 + a%d; }\n' $(($1 - 1)); } > inputs/file_$1.c; }
for n in 64 4000 8000 16000; do gen_local $n; gen_file $n; done
printf 'int g(int x) { int a = x, b = x + 1; return a + b; }\n' > inputs/small.c
cp main/src/buster/compiler/c_types.c inputs/ 2>/dev/null
inputs="small file_64 local_64 file_4000 local_4000 file_8000 local_8000 file_16000 local_16000"
cat > round.sh <<'R'
#!/bin/bash
round=$1; shift
for inp in $INPUTS; do
  for v in base fix main; do
    o=out/$v.$inp.$round
    t0=$EPOCHREALTIME
    taskset -c 2 ./$v/build/compiler -c --time-stages -o out/obj.o inputs/$inp.c > $o 2>&1
    rc=$?
    t1=$EPOCHREALTIME
    echo "exit $rc" >> $o
    LC_NUMERIC=C awk -v a=$t0 -v b=$t1 'BEGIN{printf "wall %.3f\n", (b-a)*1000}' >> $o
  done
done
R
chmod +x round.sh
export EXCLUSIVE_OWNER=claude-1378 EXCLUSIVE_TITLE="Solve 1378 (declarator climbs qualification)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1378
export INPUTS="$inputs"
for r in 1 2 3 4 5 6 7; do timeout 600 ~/buster-fast-bench/exclusive.sh ./round.sh $r > round-$r.log 2>&1; done
echo done > measure.done
