#!/bin/bash
# The record's identities on the 9700X, under the host's lock: the host, its tools and CPU 2's settings, and the
# SHA-256 and times of the three measured executables and of the input.
cd ~/buster-fast-bench/cc137-claude
export EXCLUSIVE_OWNER=claude-137 EXCLUSIVE_TITLE="solve #137's remaining work (record: identities)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/137
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh bash -c "
uname -a
grep -m1 'model name' /proc/cpuinfo
clang --version | head -1
perf --version
echo \"cpu2 governor: \$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor), EPP: \$(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)\"
echo \"cpu10 online: \$(cat /sys/devices/system/cpu/cpu10/online)\"
sha256sum qf2/build/compiler lb3/build/compiler cq3/build/compiler $S/sqlite3.c
stat -c '%y %s %n' qf2/build/compiler lb3/build/compiler cq3/build/compiler
for t in qf2 lb3 cq3; do echo \"\$t: \$(tail -1 \$t/build.log)\"; done
" > hostinfo.out 2>&1
echo "status $?" >> hostinfo.out
