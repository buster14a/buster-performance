#!/bin/bash
# 786-claude: the campaign's receipts as one tar on standard output: every run's output, the logs with the lock's
# waiting messages taken out, the trees' revisions and patches, every link's SHA-256 and the host.
set -eu
cd ~/buster-fast-bench/786-claude
mkdir -p receipts
{
    uname -srm
    grep -m1 "model name" /proc/cpuinfo
    clang --version | head -1
    perf --version
    echo "cpu2 governor: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null)"
    echo "cpu2 energy preference: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null)"
} > receipts/host.txt
for tree in old main head1 head2 head3; do
    [ -d "$tree" ] && echo "$tree $(git -C "$tree" rev-parse HEAD)"
done > receipts/revisions.txt
sha256sum shifts-*/compiler-* > receipts/executables.sha256
sha256sum head1.patch head2.patch head3.patch > receipts/patches.sha256
for log in base.log c1.log c2.log p2.log s1.log setup.log head1.log head2.log head3.log; do
    [ -f "$log" ] && grep -v -e '^exclusive.sh: waiting for the 9700X' -e '^  title: ' -e '^  link: ' -e '^  pull request: ' "$log" > "receipts/$log"
done
tar -cf - receipts base c1 c2 p2 s1 head1.patch head2.patch head3.patch
