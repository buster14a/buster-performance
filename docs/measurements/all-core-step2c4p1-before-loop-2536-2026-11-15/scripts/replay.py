# replay.py: the census and provisional tests' sources and expectations from c_checker_driver_test.c, run by ./build/compiler.
import re,subprocess,os
src=open('src/buster/compiler/c_checker_driver_test.c').read()
def cstr(text):
    lits=re.findall(r'"((?:[^"\\]|\\.)*)"', text)
    return ''.join(bytes(l,'utf-8').decode('unicode_escape') for l in lits)
def func(name):
    a=src.index('static void '+name)
    b=src.index('\n}\n',a)
    return src[a:b]
exe='./build/compiler'
os.makedirs('/tmp/p2t/h',exist_ok=True)
f=func('check_test_driver_selection_census')
srcs={m.group(1):cstr(m.group(2)) for m in re.finditer(r'static const char (\w+)\[\] = ((?:\s*"(?:[^"\\]|\\.)*"\s*)+);', f)}
order=re.search(r'sources\[\] = \{ ([^}]*) \}', f).group(1).split(', ')
exp_block=f[f.index('expected[]['):f.index('static const char* const names')]
groups=re.findall(r'\{\s*((?:"(?:[^"\\]|\\.)*",\s*)+)\}', exp_block)
ok=True
for name,g in zip(order,groups):
    exps=[bytes(e,'utf-8').decode('unicode_escape') for e in re.findall(r'"((?:[^"\\]|\\.)*)"', g)]
    open('/tmp/p2t/h/s.c','w').write(srcs[name])
    for p in ([],['--scalar']):
        r=subprocess.run([exe,'--selection-census']+p+['-w','-c','-o','/tmp/p2t/h/s.o','/tmp/p2t/h/s.c'],capture_output=True,text=True)
        miss=[e for e in exps if e not in r.stderr]
        if miss or r.returncode: ok=False; print('census FAIL',name,p,miss[:2])
print('census', 'ok' if ok else 'failed', len(order), len(groups))
f=func('check_test_driver_provisional_selection')
srcs={m.group(1):cstr(m.group(2)) for m in re.finditer(r'static const char (\w+)\[\] = ((?:\s*"(?:[^"\\]|\\.)*"\s*)+);', f)}
order=re.search(r'sources\[\] = \{ ([^}]*) \}', f).group(1).split(', ')
debug=re.search(r'debug\[\] = \{ ([^}]*) \}', f).group(1).split(', ')
exps=[bytes(e,'utf-8').decode('unicode_escape') for e in re.findall(r'"((?:[^"\\]|\\.)*)"', f[f.index('expected[] = {'):f.index('static const char* const names')])]
ok=True
for name,dbg,e in zip(order,debug,exps):
    open('/tmp/p2t/h/p.c','w').write(srcs[name])
    g='-g' if dbg=='true' else '-w'
    for p in (['-w'],['--scalar']):
        r=subprocess.run([exe,'--provisional-selection']+p+[g,'-c','-o','/tmp/p2t/h/v.o','/tmp/p2t/h/p.c'],capture_output=True,text=True)
        r2=subprocess.run([exe]+p+[g,'-c','-o','/tmp/p2t/h/r.o','/tmp/p2t/h/p.c'],capture_output=True,text=True)
        same=open('/tmp/p2t/h/v.o','rb').read()==open('/tmp/p2t/h/r.o','rb').read()
        if r.returncode or r2.returncode or e not in r.stderr or not same: ok=False; print('provisional FAIL',name,p,repr(r.stderr[:120]),same)
print('provisional','ok' if ok else 'failed', len(order), len(exps))
