from pathlib import Path
import csv,json,shutil,subprocess
d=Path(__file__).resolve().parent;w=d.parent;s=d/'stage';(s/'programs').mkdir(parents=True,exist_ok=True);src=d/'loops';cases=list(csv.DictReader((src/'programs.tsv').open(),delimiter='\t'));selected=[r for r in cases if r['kind'] in ('u64-f32','u64-f64') and r['padding'] in ('0','32') and r['compiler'] in ('base','head')];assert len(selected)==16
for r in selected:shutil.copy2(src/'programs'/r['program'],s/'programs'/r['program'])
(s/'unsigned64-settings.tsv').write_text(''.join('\t'.join([r['program'],r['sha256'],r['expected']])+'\n' for r in selected))
def script(f,txt):
 p=s/f;p.write_text('#!/usr/bin/env bash\nset -euo pipefail\ncd "$(dirname "$0")"\n'+txt);p.chmod(0o755)
script('measure-unsigned64.sh','''label=$1; program=$2; state=$3
expected=$(awk -F '\\t' -v name="$program" '$1==name {print $3}' unsigned64-settings.tsv)
signature=$(awk -F '\\t' -v name="$program" '$1==name {print $2}' unsigned64-settings.tsv)
[[ $(sha256sum "programs/$program" | cut -d' ' -f1) == "$signature" ]]
mkdir -p results
{ date -u -Iseconds; cat /proc/loadavg; } > "results/$label.load"
LC_ALL=C taskset -c 2 perf stat --no-big-num -x ';' -e cycles:u,instructions:u,branches:u,branch-misses:u,task-clock -o "results/$label.stat.new" -- "./programs/$program" 1024 "$state" > "results/$label.stdout"
[[ -n "$expected" && $(cat "results/$label.stdout") == "$expected" ]]
{ date -u -Iseconds; cat /proc/loadavg; } >> "results/$label.load"
mv "results/$label.stat.new" "results/$label.stat"
''')
script('confirm-unsigned64.sh','''kinds=(u64-f32 u64-f64)
for rep in 0 1 2 3; do
 for ((i=0;i<4;i++)); do
  pos=$(((i+3*rep)%4)); kind=${kinds[pos%2]}; pad=$((32*((pos/2)%2))); dirty=0; unroll=8
  vars=(base head); if (( (i+rep)%2 )); then vars=(head base); fi
  for v in "${vars[@]}"; do
   label="unsigned64-run-$rep-$kind-u$unroll-p$pad-d$dirty-$v"
   [[ -s results/$label.stat ]] && continue
   ./when-free.sh timeout -k 2 8 ./measure-unsigned64.sh "$label" "$kind-$unroll-$v-$pad" "$dirty"
   sleep 2.5
  done
 done
done
''')
archive=d/'stage.tar.zst';subprocess.run(['tar','--zstd','-cf',archive,'-C',s,'.'],check=True)
j={'title':'Check unsigned qword to float and double on Zen 5 across two placements','link':'https://github.com/buster14a/buster/issues/2829','directory':'unsigned64ate-codex-01a1f5e5','archives':['unsigned64-evidence/stage.tar.zst'],'command':'./confirm-unsigned64.sh','destination':'unsigned64-evidence/native','prefix':'unsigned64-run-','extensions':['stat','load','stdout'],'observations':32};tmp=w/'native-jobs/09c1-unsigned-runtime.new';tmp.write_text(json.dumps(j,indent=2)+'\n');tmp.replace(tmp.with_suffix('.json'))
