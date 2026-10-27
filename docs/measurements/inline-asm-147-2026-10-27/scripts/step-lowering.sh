for t in base head head base; do echo "== $t"; taskset -c 2 $t/build/compiler benchmark-lowering-source c-testsuite/tests/single-exec/*.c; done
