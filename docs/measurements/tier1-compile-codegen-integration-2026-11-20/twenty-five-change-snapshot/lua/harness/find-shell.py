from pathlib import Path
import subprocess,hashlib
p=Path(__file__).resolve().parent;q=p/'env';choices=[('zsh',Path('/usr/bin/zsh'))]
for pkg in ['mksh','yash','ksh','busybox']:
 d=q/pkg;d.mkdir(exist_ok=True)
 try:
  url,sha=subprocess.check_output(['pacman','-Sp','--print-format','%l\t%h',pkg],text=True,stderr=subprocess.DEVNULL).strip().split('\t')
  subprocess.run(['curl','-fsSL','--connect-timeout','5','--max-time','12',url,'-o',d/'pkg.tar.zst'],check=True)
  assert hashlib.file_digest((d/'pkg.tar.zst').open('rb'),'sha256').hexdigest()==sha
  subprocess.run(['bsdtar','-xf','pkg.tar.zst','usr/bin'],cwd=d,check=True);x=d/'usr/bin'/pkg
  if x.exists():choices.append((pkg,x))
 except (ValueError,subprocess.CalledProcessError):continue
for pkg,x in choices:
 args=['bwrap','--ro-bind','/','/','--dev','/dev','--ro-bind',x,'/usr/bin/bash','--tmpfs','/tmp','--',p/'release-clang/lua-readline',p/'shell-status.lua'];r=subprocess.run(args,capture_output=True,text=True,timeout=10);(q/(pkg+'-semantics.txt')).write_text(r.stdout+r.stderr)
 lines=r.stdout.splitlines();print(pkg,[l for l in lines if l.startswith('sh -c')],flush=True)
 if any(l.startswith('sh -c') and l.endswith('nil\texit\t129\tnil\texit\t129') for l in lines) and any(l.startswith('kill -s HUP') and l.endswith('nil\tsignal\t1\tnil\tsignal\t1') for l in lines):
  (q/'chosen').write_text(str(x)+'\n');break
