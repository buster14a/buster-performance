#!/usr/bin/env bash
# After queue5.sh (PID $1): where -c of the asm-heavy file spends its user cycles, on CPU 2, in one hold (about 5 s).
cd ~/buster-fast-bench/asm-147-claude || exit 1
while kill -0 "$1" 2> /dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly lowering (#147, #126)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > step-profile.sh <<'STEP'
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
drive=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}")
for f in asm plain; do
    taskset -c 2 perf record -q -e cycles:u -c 200003 -o profile-$f.data -- bash -c "for i in \$(seq 30); do head/build/compiler -c ${drive[*]} bench/$f.c -o /dev/null; done" > /dev/null 2>&1
done
STEP
~/buster-fast-bench/exclusive.sh ./timed.sh bash step-profile.sh > step-profile.log 2>&1
echo "step profile $? $(tail -1 step-profile.log)"
for f in asm plain; do perf report -i profile-$f.data --no-children --comm compiler --sort symbol --stdio 2> /dev/null | grep -v "^#" | grep -v "^$" > profile-$f.txt; done
echo done
