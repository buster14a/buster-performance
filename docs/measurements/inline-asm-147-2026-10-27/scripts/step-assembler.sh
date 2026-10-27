for t in base head head base; do echo "== $t"; taskset -c 2 $t/build/compiler benchmark-assembler; done
