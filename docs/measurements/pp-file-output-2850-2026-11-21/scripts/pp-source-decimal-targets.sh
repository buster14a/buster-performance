#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
until [[ -f results/digitfault/.built ]];do sleep 2;done
out=$root/digit-targets;mkdir -p "$out";cc=$root/results/digitfault/compiler
python3 - "$root" "$out/targets" <<'PY'
from pathlib import Path
import re,sys
root=Path(sys.argv[1]);source=(root/'physical-check/sqlite-default-publish.stderr').read_text()
touched={int(t) for t in re.findall(r'pp-digit-consumed: source=(\d+)',(root/'digit-check/sqlite-default-read.stderr').read_text())}
both=[(int(m[1]),int(m[2])) for m in re.finditer(r'pp-window: source=(\d+) leaf=(\d+) [^\n]+literal=1',source) if int(m[2]) in touched]
with open(sys.argv[2],'w') as f:
 for i in range(8):
  st,t=both[i*(len(both)-1)//7];print(st,t,file=f)
PY
eval "args=($sqlite_arguments)";cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
for cu in before off read;do
 p=$out/$cu;exe=$cc;[[ $cu != before ]] || exe=$root/results/before/compiler
 "$root/lock.sh" taskset -c 2 env BUSTER_TEST_SMALL_DECIMAL="$cu" "$exe" -c -o "$p.o" "${args[@]}" >"$p.out" 2>"$p.err"
 sha256sum "$p.o" >"$p.sha"; [[ $cu == before ]] || cmp "$out/before.o" "$p.o"
done
while read -r stmt leaf;do
 p=$out/fault-$leaf;
 "$root/lock.sh" taskset -c 2 env BUSTER_TEST_SMALL_DECIMAL=fault BUSTER_TEST_SMALL_DECIMAL_FAULT_AT="$leaf" "$cc" -c -o "$p.o" "${args[@]}" >"$p.out" 2>"$p.err"
 sha256sum "$p.o" >"$p.sha"
 if cmp -s "$out/before.o" "$p.o";then echo "$stmt $leaf same";else echo "$stmt $leaf changed";fi >>"$out/status"
 rm "$p.o"
done <"$out/targets"
rm "$out"/{before,off,read}.o;date -u +%FT%TZ >"$out/done"
