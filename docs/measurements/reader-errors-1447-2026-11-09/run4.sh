#!/bin/bash
D=~/buster-fast-bench/1447-claude-invalid
cd $D
export EXCLUSIVE_OWNER=claude-1447-atomic-tag
export EXCLUSIVE_TITLE="#1447: tags in _Atomic/typeof specifiers, out-of-line group scan"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1891
until grep -q TIMES-DONE times-enum.txt 2>/dev/null; do sleep 20; done
cat > measure4.sh <<'IN'
#!/bin/bash
D=~/buster-fast-bench/1447-claude-invalid
taskset -c 2 base/build/compiler time-runs --runs 11 --warmups 2 --build base $D/base/build/compiler --build atomic $D/atomic/build/compiler --build atomic2 $D/atomic2/compiler \
  --list -fsyntax-only $D/sqlite3.c \
  --list -fsyntax-only -march=znver5 -I$D/base/src -fwrapv -funsigned-char -fno-strict-aliasing $D/base/src/buster/compiler/main.c > times-atomic2.txt 2>&1
for t in base:base/build/compiler atomic:atomic/build/compiler atomic2:atomic2/compiler; do
  n=${t%%:*}; b=${t#*:}
  taskset -c 2 perf record -q -e instructions:u -c 20000 -o perf-$n.data $b -fsyntax-only $D/sqlite3.c
done
echo TIMES-DONE >> times-atomic2.txt
IN
chmod +x measure4.sh
~/buster-fast-bench/exclusive.sh ./measure4.sh
for n in base atomic atomic2; do perf report -i perf-$n.data --no-children --sort symbol --stdio -q 2>/dev/null | head -60 > report-$n.txt; done
