#!/usr/bin/env bash
# Packs the #1340 record (no lock needed: reads files only).
set -u
cd ~/buster-fast-bench/1340-opencode || exit 2
out=record; rm -rf $out; mkdir -p $out/microarch $out/warnings-off $out/profile $out/scripts
cp -r root2/results/zen5-9700x/ab1340 root2/results/zen5-9700x/ab1340-self root2/results/zen5-9700x/env root2/results/zen5-9700x/holds.txt root2/results/zen5-9700x/identity.txt $out/microarch/
grep -v -E '^exclusive.sh: waiting|^  (title|link|pull request):|^[0-9T:+-]+ (CI job|claude-|codex|droid|devin)' run2.log > $out/microarch/run.log
for f in root2/bin/*.commit; do printf '%s: %s\n' "$(basename $f .commit)" "$(cat $f)"; done > $out/builds.txt
(cd root2/bin && sha256sum compiler-main-znver5 compiler-znver5) > $out/builds.sha256
cp wlogs -r $out/warnings-off/logs
for p in main head; do
  perf report -i perf-${p}3.data --no-children --sort symbol --stdio 2>/dev/null | grep -v '^$' > $out/profile/$p-symbols.txt
  cp perf-${p}3.data.holds.txt $out/profile/$p-holds.txt
done
cp run1340b.sh w1340.sh prof1340.sh pack1340.sh $out/scripts/
(cd repo && git log -1 --format='repo checkout: %H %s') > $out/checkout.txt
{ uname -a; perf --version; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor; cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference; } > $out/host.txt 2>&1
tar -C $out -czf record.tgz .
echo packed
