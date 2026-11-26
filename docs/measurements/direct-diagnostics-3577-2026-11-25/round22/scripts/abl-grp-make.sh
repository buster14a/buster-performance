#!/bin/bash
# abl-grp-make.sh: measurement-only arms gating one file's #3577 bail-ifs each (no A1), as commits on top of the head
# (eeee61ef8), branches abl22-lex, abl22-types, abl22-cc; each built locally to check it compiles.
S=/tmp/claude-0/-home-user/cf3643bc-6e1c-51b2-99ca-175eb97147e4/scratchpad
cd /home/user/buster || exit 1
git diff --quiet && git diff --cached --quiet || { echo "tree not clean"; exit 1; }
for g in lex:c_direct_lex.c types:c_direct_types.c cc:c_direct_cc.c; do
  name=${g%%:*}; file=${g##*:}
  rm -rf $S/abl-$name && mkdir -p $S/abl-$name/src/buster/compiler && cp src/buster/compiler/c_direct*.c $S/abl-$name/src/buster/compiler/
  ABL_ONLY=$file python3 $S/abl-grp.py /home/user/buster $S/abl-$name > $S/abl-$name.log 2>&1 || { echo "apply $name failed"; exit 1; }
  echo "$name: $(tail -1 $S/abl-$name.log)"
  cp $S/abl-$name/src/buster/compiler/c_direct*.c src/buster/compiler/
  ./build.sh --config Release > $S/abl-$name-build.log 2>&1; st=$?
  if [ $st = 0 ]; then
    git checkout -q -b abl22-$name 2>/dev/null || git checkout -q abl22-$name
    BUSTER_DCO_SIGN_OFF=off git commit -q -a -m "measurement only: #3577 bail-ifs of $file behind an opaque test"
    echo "$name commit $(git rev-parse --short HEAD)"
    cp build/compiler $S/compiler-abl-$name
    git checkout -q claude/adoring-goodall-mr1480
  else
    echo "build $name failed"; grep -E "error" $S/abl-$name-build.log | head -5
    git checkout -q -- src/buster/compiler/
    exit 1
  fi
done
