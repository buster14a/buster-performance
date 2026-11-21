import argparse, collections, csv, itertools, pathlib, re, subprocess, tempfile
ap=argparse.ArgumentParser()
ap.add_argument("compiler",type=pathlib.Path)
ap.add_argument("out",type=pathlib.Path)
ap.add_argument("switches",nargs="*")
cfg=ap.parse_args()
pre = """int g,h,ar[4];extern int weak[2] __attribute__((weak)); int *ptr; void fn(void);
extern const char *p;
"""
atoms = {
 "string-null":'"s"==0', "string-nonnull":'"s"!=0', "rev-string-null":'0=="s"',
 "rev-void-null":'(void*)0!="s"', "object":'&g==0', "array":'ar==0', "function":'fn!=0',
 "later-object":'&g==&h', "same-object":'&g==&g', "same-displacement":'ar+2==&ar[2]',
 "different-displacement":'&ar[0]!=&ar[3]', "strong-absolute":'&g==(int*)1',
 "weak":'weak==0', "loaded-pointer":'ptr==0', "runtime-int":'g==0',"constant":'1==2'
}
values = {
 "choose":'T ? "x" : "y"', "nested":'(T ? 1:0) ? "x" : "y"',
 "and":'((T) && "k"[0]) ? "x":"y"', "or":'((T) || "k"[0]) ? "x":"y"',
 "sizeof":'sizeof(T)>0 ? "x":"y"', "unused":'0 ? (T ? "x":"y") : "z"',
 "repeat":'T ? (char *)&g : (char *)&g',
}
forms = {
 "global":'const char *out = V;',
 "local-static":'const char *f(void) {static const char *out=V; return out;}',
 "automatic":'const char *f(void) {const char *out=V; return out;}',
 "return":'const char *f(void) {return V;}',
 "aggregate":'struct S {const char *p;}; struct S s={V};',
}
stats=collections.Counter()
with tempfile.TemporaryDirectory(prefix="buster-pointer-matrix-") as root, cfg.out.open("w",newline="") as f:
 w=csv.writer(f,delimiter="\t",lineterminator="\n")
 w.writerow(("scope","condition","expression","status","typed","taken","compared","ref-diff","other-diff"))
 p=pathlib.Path(root)/"test.c"
 for (scope, form),(name,a),(expr,v) in itertools.product(forms.items(),atoms.items(),values.items()):
  p.write_text(pre+form.replace('V','('+v.replace('T','('+a+')')+')')+'\n')
  c=subprocess.run([cfg.compiler.resolve(),'measure-node-machine','--shadow','--window-rows','--passes','0',*cfg.switches,p],capture_output=True,text=True)
  typed=re.search(r'reader-time T expressions=(\d+) records=\d+ typed=\d+ taken=(\d+)',c.stdout)
  shadow=re.search(r'window summaries compared=(\d+).*?reference-differences=(\d+)',c.stdout)
  reason='ok' if c.returncode==0 else 'diff' if shadow else 'rejected'
  if c.returncode not in (0,1):raise RuntimeError((scope,name,expr,c.returncode))
  stats[reason]+=1
  w.writerow((scope,name,expr,reason,*(typed.groups() if typed else ('-','-')),*(shadow.groups() if shadow else ('-','-')),int(reason=='diff' and int(shadow[2])==0)))
print(' '.join(f'{k}={v}' for k,v in sorted(stats.items())))
