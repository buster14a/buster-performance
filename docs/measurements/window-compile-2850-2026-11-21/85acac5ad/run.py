from common import *
import subprocess,sys
for f in ('qualify.py','stage.py','suites.py'):subprocess.run([sys.executable,D/f],check=True)
subprocess.run(['bash',D/'per-file.sh'],check=True)
