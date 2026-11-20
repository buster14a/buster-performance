from pathlib import Path
import re,subprocess
w=Path(__file__).resolve().parent;repo=w/'eighteen-candidate';p=w/'eighteen-evidence';f=repo/'src/buster/compiler/tier1_emit_cfg.c';s=f.read_text()
matches=list(re.finditer(r'^<<<<<<< HEAD\n(.*?)^=======\n(.*?)^>>>>>>> [^\n]+\n',s,re.M|re.S));assert len(matches)==2
one,two=matches;ours,theirs=one.group(1,2)
at=ours.index('    const uint64_t capacity');before=theirs[:theirs.index('    const uint64_t capacity')];old='tier1_emit_cfg_x87_copy_records(function, input, emitted->prepared.x87_count) + tier1_emit_cfg_x87_node_records(plan, emitted->prepared.x87_count)';assert old in ours
first=ours[:at]+before+ours[at:].replace(old,'x87_copies + x87_nodes')
start=two.group(2).index('    // Each x87 phi copy')
second='    const uint32_t vector_constants = extra.literals;\n'+two.group(2)[start:].replace('+ vector_constants + x87_references','+ extra.references + x87_references')
s=s[:two.start()]+second+s[two.end():];s=s[:one.start()]+first+s[one.end():];f.write_text(s)
with (p/'capacity-resolution.diff').open('w') as h:subprocess.run(['git','-C',repo,'diff','--cc','--','src/buster/compiler/tier1_emit_cfg.c'],stdout=h,check=True)
subprocess.run(['git','-C',repo,'add','src/buster/compiler/tier1_emit_cfg.c'],check=True);subprocess.run(['git','-C',repo,'commit','--no-edit'],check=True)
head=subprocess.check_output(['git','-C',repo,'rev-parse','HEAD'],text=True).strip()
subprocess.run(['git','-C',w/'buster','worktree','add','--detach','../eighteen-asan',head],check=True)
(p/'control.txt').write_text('3804c5e7b9468772d22209774843f06aabd70990\n');(p/'candidate.txt').write_text(head+'\n')
for name in ['build.sh','qualify.sh','sanitize.sh','compare-common.py']:
 (p/name).write_text((w/'fifteen-evidence'/name).read_text().replace('fifteen','eighteen').replace('pull/3133','pull/3136'))
