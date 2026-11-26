#!/bin/bash
# abl-fn-make.sh: measurement-only arms gating c_direct_cc.c's #3577 bail-ifs (not A1's) by enclosing function group, as
# commits on top of the head eeee61ef8 (branches abl22-fn-NAME), each built locally and held to sqlite3.c's object.
S=/tmp/claude-0/-home-user/cf3643bc-6e1c-51b2-99ca-175eb97147e4/scratchpad
C=/home/user/corpus
cd /home/user/buster || exit 1
git diff --quiet && git diff --cached --quiet || { echo "tree not clean"; exit 1; }
for g in cf:fast_cc_compile_func ex:fast_cc_expr_compile cu:fast_cc_compile_unit \
         red:fast_expr_reduce_unary,fast_expr_reduce_ternary,fast_expr_reduce_top call:fval_emit_call \
         init:fast_cc_init_local,fast_cc_init_static,fast_cc_check_static_initializer \
         bin:fval_emit_binary,fast_cc_binary_operands_quiet,fval_store,fval_emit_incdec,fval_emit_compound_assign,fval_branch \
         rest:fast_cc_check_implicit_conv_full,fval_convert_full,fsc_cast_to,fsc_apply_op,fast_cc_eval_static_const,fast_cc_completed_array,fast_cc_push_flagged_symbol,fast_cc_sequenced_again,fval_emit_va_arg,fast_cc_checked_long_double_local,fast_cc_check_main; do
  name=${g%%:*}; fns=${g#*:}
  rm -rf $S/abl-f && mkdir -p $S/abl-f/src/buster/compiler && cp src/buster/compiler/c_direct*.c $S/abl-f/src/buster/compiler/
  ABL_ONLY=c_direct_cc.c ABL_FUNCS=$fns python3 $S/abl-fn.py /home/user/buster $S/abl-f > $S/abl-fn-$name.log 2>&1 || { echo "apply $name failed"; exit 1; }
  cp $S/abl-f/src/buster/compiler/c_direct*.c src/buster/compiler/
  ./build.sh --config Release > $S/abl-fn-$name-build.log 2>&1; st=$?
  if [ $st != 0 ]; then echo "build $name failed"; grep -E "error" $S/abl-fn-$name-build.log | head -5; git checkout -q -- src/buster/compiler/; exit 1; fi
  rm -f $S/abl-bail.txt
  BUSTER_TEST_DIRECT_BAILS=$S/abl-bail.txt LLVM_PROFILE_FILE=/dev/null build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" -o $S/sq-abl-f.o
  obj="$(readelf -p .comment $S/sq-abl-f.o | grep -o 'buster[a-z -]*') $(cmp -s $S/sq-abl-f.o $S/sq-m8-head.o && echo identical || echo DIFFERS) $(cat $S/abl-bail.txt 2>/dev/null | cut -f1)"
  git checkout -q -b abl22-fn-$name 2>/dev/null || { git branch -D abl22-fn-$name > /dev/null; git checkout -q -b abl22-fn-$name; }
  BUSTER_DCO_SIGN_OFF=off git commit -q -a -m "measurement only: #3577 bail-ifs of $name ($fns) behind an opaque test"
  echo "$name $(tail -1 $S/abl-fn-$name.log) commit $(git rev-parse --short HEAD) sqlite3.c: $obj"
  git checkout -q claude/adoring-goodall-mr1480
done
