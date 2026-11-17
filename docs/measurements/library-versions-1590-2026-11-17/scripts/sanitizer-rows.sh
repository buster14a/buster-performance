#!/bin/bash
M=/tmp/claude-0/-home-user/6e7265f8-11c8-5a94-9c81-5c376796b20a/scratchpad/mutants
export PATH=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH
cd $M/tree
for v in none address memory thread; do
  s=$(date +%s)
  BUSTER_HOST_ARCH=x86-64 BUSTER_SANITIZER=$v nice -n 10 ./build.sh --config Release > $M/build-x86-$v.log 2>&1 || { echo "$v: BUILD FAILED"; continue; }
  out=$(BUSTER_HOST_ARCH=x86-64 BUSTER_SANITIZER=$v ./build.sh print-output --config Release 2>/dev/null)
  cp "$out" $M/compiler-x86-$v
  X=$M/compiler-x86-$v
  R=$M/reports-$v
  rm -rf $R; mkdir -p $R
  sym=$(command -v llvm-symbolizer)
  export ASAN_SYMBOLIZER_PATH="$sym" MSAN_SYMBOLIZER_PATH="$sym"
  export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$R/report"
  export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$R/report"
  export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$sym:log_path=$R/report"
  export TSAN_OPTIONS="halt_on_error=1:exitcode=86:second_deadlock_stack=1:external_symbolizer_path=$sym:log_path=$R/report"
  export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$sym:log_path=$R/report"
  timeout 3600 nice -n 10 $X test-foreign --cross-check > $M/rows-$v-foreign.log 2>&1; f=$?
  timeout 3600 nice -n 10 $X test-checker-driver --executable $X --part 2/8 --in-process > $M/rows-$v-driver.log 2>&1; d=$?
  echo "$v ($(( $(date +%s) - s )) s): test-foreign exit $f ($(grep -a "versions:" $M/rows-$v-foreign.log)); driver part 2/8 exit $d ($(grep -a 'checker-driver: .* checks' $M/rows-$v-driver.log)); reports: $(ls $R | wc -l)"
done
echo done
