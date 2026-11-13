set -u
W=$HOME/buster-fast-bench/2618-claude
head -1 /var/lib/buster-9700x/owner >> $W/holds-arith.txt
E=cycles:u,instructions:u,ex_ret_brn_ind_misp:u,ex_ret_brn_misp:u,de_src_op_disp.x86_decoder:u,ex_no_retire.load_not_complete:u
cd $W/inputs
for o in 0 1 5; do
  for t in base head; do
    taskset -c 2 perf stat -r 11 -x, -e $E -o $W/arith-$t-o$o.txt $W/lua-$t-o$o arithmetic.lua > /dev/null 2>&1; echo "$t o$o status $?"
  done
done
