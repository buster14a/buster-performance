head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/1374-opencode/results/holds.txt
unset CPATH C_INCLUDE_PATH
cd /home/david/buster-fast-bench/1374-opencode/head-8570c6bb
for r in 1 2 3; do
  for tree in base head; do
    c=$([ $tree = base ] && echo /home/david/buster-fast-bench/1374-opencode/base-c3fcc7e2/build/compiler || echo /home/david/buster-fast-bench/1374-opencode/head-8570c6bb/build/compiler)
    s=$(date +%s%N)
    taskset -c 2 $c --lanes 1 -c -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_STRONG -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-pc-linux-gnu\" -DBUSTER_HOST_STATIC=1 -O3  -o /home/david/buster-fast-bench/1374-opencode/out/main-$tree.o src/buster/compiler/main.c
    status=$?
    e=$(date +%s%N)
    echo "main $tree $r $(( (e - s) / 1000 )) us status $status"
  done
done
size /home/david/buster-fast-bench/1374-opencode/out/main-base.o /home/david/buster-fast-bench/1374-opencode/out/main-head.o
