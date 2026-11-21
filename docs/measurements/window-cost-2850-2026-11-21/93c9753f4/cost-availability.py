from pathlib import Path
import re,subprocess,sys
compiler,src,log=sys.argv[1:4]
rows=[]
for name,flags in [('default',[]),('wall',['-Wall','-Wextra']),('everything',['-Weverything','-Wno-c++-compat'])]:
    r=subprocess.run([compiler,'measure-node-machine','--shadow','--window-rows','--passes','0','--list','3',*flags,src],capture_output=True)
    s=r.stdout.decode()
    assert r.returncode==0 and 'event id=72 option=-Wavailability expressions=1' in s and 'taken-there-and-refused-by-the-census=0' in s
    diag=subprocess.run([compiler,'-fsyntax-only','-fno-caret-diagnostics',*flags,src],capture_output=True)
    lines=[l for l in diag.stderr.decode().splitlines() if '-Wavailability]' in l]
    assert diag.returncode==0 and len(lines)==1
    rows.append(name+' event=72 expressions=1 unsound=0 status=0 '+lines[0].split('warning:',1)[1])
Path(log).write_text('\n'.join(rows)+'\n')
