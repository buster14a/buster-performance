set -e
head -1 /var/lib/buster-9700x/owner >> holds.txt
{ uname -a; clang --version | head -1; perf --version; echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"; cat /home/david/buster-fast-bench/2791-claude/main/COMMIT /home/david/buster-fast-bench/2791-claude/head/COMMIT; } > identities.txt
/home/david/buster-fast-bench/2791-claude/main/build/compiler --tier1 --tier1-strict -c -o k_main.o kernels.c
/home/david/buster-fast-bench/2791-claude/head/build/compiler --tier1 --tier1-strict -c -o k_head.o kernels.c
clang -O2 -fno-vectorize -c -o k_o2.o kernels.c
clang -O0 -c -o k_o0.o kernels.c
clang -O2 -c -o bench.o bench.c
for b in main head o2 o0; do clang -o bench_$b bench.o k_$b.o; done
for b in main head o2 o0; do objdump -d --no-show-raw-insn k_$b.o > k_$b.s; done
nm -n k_main.o k_head.o > symbols.txt
sha256sum /home/david/buster-fast-bench/2791-claude/main/build/compiler /home/david/buster-fast-bench/2791-claude/head/build/compiler kernels.c bench.c k_*.o bench_* >> identities.txt
for k in null lt ge nle eq ne count equal; do for b in main head o2 o0; do taskset -c 2 ./bench_$b $k; done | sort -u | awk -v k=$k 'END { if (NR != 1) { print "outputs differ for " k; exit 1 } }'; done
echo built and checked
