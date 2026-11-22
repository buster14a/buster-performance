from common import *
import csv,json,shutil,subprocess,sys,tarfile,time
subprocess.run([sys.executable,D/'guard.py'],check=True)
checks=['suites.py'] if not PRIOR.exists() else []
for f in checks:subprocess.run([sys.executable,D/f],check=True)
deadline=time.monotonic()+600
while not PRIOR.exists() and time.monotonic()<deadline:time.sleep(2)
assert PRIOR.exists(),PRIOR
for args in [['numerical.py','--smoke'],['stage.py'],['qualify.py'],['numerical.py'],*([['suites.py']] if not checks else [])]:
 subprocess.run([sys.executable,D/args[0],*args[1:]],check=True)
subprocess.run(['bash',D/'per-file.sh'],check=True)
subprocess.run([sys.executable,D/'package.py'],check=True)
