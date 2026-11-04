#!/bin/bash
# receipts6.sh: the host's and round 6's executables' identities, into receipts6.txt.
cd ~/buster-fast-bench/claude-628 || exit 1
{
  echo "== date"; date -u
  echo "== uname"; uname -a
  echo "== cpu"; grep -m1 "model name" /proc/cpuinfo
  echo "== cpu2 governor and epp"; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null
  echo "== clang"; clang --version | head -2
  echo "== perf"; perf --version
  echo "== trees"; for t in main-9a74fc37 head-d0ba7a5f; do printf '%s COMMIT %s\n' "$t" "$(cat $t/COMMIT)"; done
  echo "== executables"; sha256sum main-9a74fc37/build/compiler head-d0ba7a5f/build/compiler
  echo "== input"; sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
} > receipts6.txt 2>&1
echo receipts-done
