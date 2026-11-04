#!/bin/bash
# receipts.sh: the host's and the measured executables' identities, into receipts.txt.
cd ~/buster-fast-bench/claude-628 || exit 1
{
  echo "== date"; date -u
  echo "== uname"; uname -a
  echo "== cpu"; grep -m1 "model name" /proc/cpuinfo
  echo "== cpu2 governor and epp"; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null
  echo "== clang"; clang --version | head -2
  echo "== perf"; perf --version
  echo "== trees"; for t in main-3ce71ec3 head-93f2085f main-dac5b770 head-67f7bf51; do printf '%s COMMIT %s\n' "$t" "$(cat $t/COMMIT)"; done
  echo "== executables"; sha256sum main-3ce71ec3/build/compiler head-93f2085f/build/compiler main-dac5b770/build/compiler head-67f7bf51/build/compiler
  echo "== input"; sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
} > receipts.txt 2>&1
echo receipts-done
