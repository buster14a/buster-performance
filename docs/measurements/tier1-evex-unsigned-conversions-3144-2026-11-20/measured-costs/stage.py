from pathlib import Path
import hashlib,json,shutil,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];s=p/'stage';s.mkdir(exist_ok=True);forms=['VCVTUSI2SS_X_X_RM64/REGISTER','VCVTUSI2SD_X_X_RM64/REGISTER']
def script(name,body):
 f=s/name;f.write_text('#!/usr/bin/env bash\nset -euo pipefail\ncd "$(dirname "$0")"\n'+body);f.chmod(0o755)
(p/'forms.txt').write_text('\n'.join(forms)+'\n')
if sys.argv[1]=='forms':
 a=w/'unsigned-cost-forms/src/buster/compiler/x86_zen5_rows.c';text=a.read_text().rstrip();assert all("X("+form.replace("/",", ")+"," not in text for form in forms);a.write_text(text+' '+chr(92)+'\n'+(' '+chr(92)+'\n').join('    X('+f.replace('/',', ')+', U, U, U, U, U, U, U, 0x00, 0x00, 0x00)' for f in forms)+'\n')
else:
 fixed=w/'debug-evidence/stage/compilers/debug-base';binary=p/'unsigned-costs';subprocess.run(['strip','-o',binary,w/'unsigned-cost-forms/build/compiler'],check=True);subprocess.run(['zstd','-qf','-7','-T1','--patch-from='+str(fixed),binary,'-o',s/'unsigned-costs.patch.zst'],check=True);(s/'unsigned-costs.sha256').write_text(hashlib.file_digest(binary.open('rb'),'sha256').hexdigest()+'  compilers/unsigned-costs\n');shutil.copy2(p/'forms.txt',s/'unsigned-forms.txt')
 script('unpack-unsigned-costs.sh','''if [[ ! -x compilers/unsigned-costs ]]; then
 zstd -qdf --patch-from=compilers/debug-base unsigned-costs.patch.zst -o compilers/unsigned-costs.new
 chmod +x compilers/unsigned-costs.new
 mv compilers/unsigned-costs.new compilers/unsigned-costs
fi
sha256sum -c unsigned-costs.sha256
''')
 script('confirm-unsigned-costs.sh','''mapfile -t forms <unsigned-forms.txt
mkdir -p results
for round in 0 1 2 3; do
 for ((i=0;i<2;i++)); do
  form=${forms[(i+round)%2]}; label="unsigned-cost-$round-${form/\\//-}"
  [[ -s results/$label.out ]] && continue
  ./when-free.sh timeout -k 2 18 taskset -c 2 ./compilers/unsigned-costs measure-x86-zen5 --only "$form" >"results/$label.out.new"
  mv "results/$label.out.new" "results/$label.out"
  sleep 2.5
 done
done
''')
 arc=p/'stage.tar.zst';subprocess.run(['tar','--zstd','-cf',arc,'-C',s,'.'],check=True);job={'title':'Measure the native unsigned qword scalar conversion register forms on Zen 5','link':'https://github.com/buster14a/buster/issues/2829','directory':'compile-codex-01a1f5e5','archives':[str(arc.relative_to(w))],'command':'./when-free.sh timeout -k 2 22 ./unpack-unsigned-costs.sh && ./confirm-unsigned-costs.sh','destination':str((p/'native').relative_to(w)),'prefix':'unsigned-cost-','extensions':['out'],'observations':8};f=w/'native-jobs/09c0-unsigned-costs.new';f.write_text(json.dumps(job,indent=2)+'\n');f.replace(f.with_suffix('.json'))
