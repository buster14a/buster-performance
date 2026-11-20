from pathlib import Path
import hashlib,json,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];tree='unsigned64';n=3144;key='model-unsigned';d=p/(key+'-stage');d.mkdir(exist_ok=True);prefix=key+'-'
assert (p/'real-unit-passed').exists()
fixed=w/'debug-evidence/stage/compilers/debug-base';exe=p/key
subprocess.run(['strip','-o',exe,w/tree/'build/compiler'],check=True)
subprocess.run(['zstd','-qf','-7','-T1','--patch-from='+str(fixed),exe,'-o',d/(key+'.patch.zst')],check=True)
(d/(key+'.sha256')).write_text(hashlib.file_digest(exe.open('rb'),'sha256').hexdigest()+'  compilers/'+key+'\n')
forms=(p/'forms.txt').read_text().splitlines()
(d/(key+'-forms.txt')).write_text('\n'.join(forms)+'\n')
def script(name,body):
 f=d/name;f.write_text('#!/usr/bin/env bash\nset -euo pipefail\ncd "$(dirname "$0")"\n'+body);f.chmod(0o755)
script('unpack-'+key+'.sh',f'''if [[ ! -x compilers/{key} ]]; then
 zstd -qdf --patch-from=compilers/debug-base {key}.patch.zst -o compilers/{key}.new
 chmod +x compilers/{key}.new
 mv compilers/{key}.new compilers/{key}
fi
sha256sum -c {key}.sha256
''')
script('check-'+key+'.sh','''mapfile -t forms <@K@-forms.txt
mkdir -p results
for round in 0 1; do
 for ((i=0;i<${#forms[@]};i++)); do
  form=${forms[(i+3*round)%${#forms[@]}]}; label="@K@-$round-${form/\\//-}"
  [[ -s results/$label.out ]] && continue
  ./when-free.sh timeout -k 2 18 taskset -c 2 ./compilers/@K@ measure-x86-zen5 --check --only "$form" >"results/$label.out.new"
  mv "results/$label.out.new" "results/$label.out"
  sleep 2.5
 done
done
'''.replace('@K@',key))
arc=p/(key+'-stage.tar.zst');subprocess.run(['tar','--zstd','-cf',arc,'-C',d,'.'],check=True)
job={'title':f'Check the committed Zen 5 costs for PR #{n} against new hardware samples','link':f'https://github.com/buster14a/buster/pull/{n}','directory':'compile-codex-01a1f5e5','archives':[str(arc.relative_to(w))],'command':f'./when-free.sh timeout -k 2 20 ./unpack-{key}.sh && ./check-{key}.sh','destination':str((p/(key+'-native')).relative_to(w)),'prefix':prefix,'extensions':['out'],'observations':2*len(forms)}
f=w/'native-jobs'/('09c3-'+key+'.new');f.write_text(json.dumps(job,indent=2)+'\n');f.replace(f.with_suffix('.json'))
