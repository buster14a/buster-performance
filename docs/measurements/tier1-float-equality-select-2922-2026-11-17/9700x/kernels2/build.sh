set -e
head -1 /var/lib/buster-9700x/owner >> holds.txt
{ uname -a; clang --version | head -1; perf --version; echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"; for b in base final always; do echo "$b $(cat /home/david/buster-fast-bench/2922-claude/$b/COMMIT)"; done; } > identities.txt
for b in base final always; do /home/david/buster-fast-bench/2922-claude/$b/build/compiler --tier1 --tier1-strict -c -o k_$b.o kernels.c; done
clang -O2 -fno-vectorize -c -o k_o2.o kernels.c
clang -O2 -c -o bench.o bench.c
for b in base final always o2; do clang -o bench_$b bench.o k_$b.o; done
for b in base final always o2; do objdump -d --no-show-raw-insn k_$b.o > k_$b.s; done
nm -n k_base.o k_final.o k_always.o  > symbols.txt
sha256sum /home/david/buster-fast-bench/2922-claude/base/build/compiler /home/david/buster-fast-bench/2922-claude/final/build/compiler /home/david/buster-fast-bench/2922-claude/always/build/compiler  kernels.c bench.c k_*.o bench_* >> identities.txt
for k in null best equal sum lt eq ne; do for b in base final always o2; do taskset -c 2 ./bench_$b $k; done | sort -u | awk -v k=$k 'END { if (NR != 1) { print "outputs differ for " k; exit 1 } }'; done
echo built and checked
