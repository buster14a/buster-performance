set -u
W=$HOME/buster-fast-bench/2618-claude
head -1 /var/lib/buster-9700x/owner >> $W/holds-arith2.txt
cd $W/inputs
for o in 0 1; do
  for t in base head; do
    taskset -c 2 perf stat -r 11 -M PipelineL1,PipelineL2 -o $W/arith2-$t-o$o.txt $W/lua-$t-o$o arithmetic.lua > /dev/null 2>&1; echo "$t o$o status $?"
    taskset -c 2 perf stat -r 11 -x, -e cycles:u,instructions:u,ls_stlf:u,ls_bad_status2.stli_other:u,ex_ret_ops:u -o $W/arith3-$t-o$o.txt $W/lua-$t-o$o arithmetic.lua > /dev/null 2>&1; echo "$t o$o counters status $?"
  done
done
