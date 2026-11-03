#!/bin/bash
# receipts7.sh: the host's and round 7's executables' identities, into receipts7.txt.
cd ~/buster-fast-bench/claude-628 || exit 1
{
  echo "== date"; date -u
  echo "== uname"; uname -a
  echo "== cpu"; grep -m1 "model name" /proc/cpuinfo
  echo "== cpu2 governor and epp"; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null
  echo "== clang"; clang --version | head -2
  echo "== perf"; perf --version
  echo "== trees"; for t in main-a4a2182a head-5550ad48; do printf '%s COMMIT %s\n' "$t" "$(cat $t/COMMIT)"; done
  echo "== executables"; sha256sum main-a4a2182a/build/compiler head-5550ad48/build/compiler
  echo "== input"; sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
} > receipts7.txt 2>&1
echo receipts-done
