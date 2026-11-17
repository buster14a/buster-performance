#!/usr/bin/env python3
# probe.py NAME FILE [MODE...]: fault NAME put into the copy of the tree, the Debug compiler built, and
# measure-node-machine --shadow MODE run on FILE: its status and its difference lines. The file is restored after.
import subprocess, sys, shutil
sys.path.insert(0, '/home/user/mut')
import mutants
name, probe = sys.argv[1], sys.argv[2]
modes = sys.argv[3:] or ['--front-sweeps']
found = [m for m in mutants.MUTANTS if m[0] == name]
assert len(found) == 1, name
_, f, old, new = found[0]
path = mutants.SRC + f
saved = '/home/user/mut/saved-probe.c'
shutil.copyfile(path, saved)
s = open(path).read()
assert s.count(old) == 1
open(path, 'w').write(s.replace(old, new))
build = subprocess.run(['./build.sh', '--config', 'Debug'], cwd=mutants.TREE, capture_output=True, text=True)
print('built', build.returncode == 0)
if build.returncode == 0:
    for mode in modes:
        run = subprocess.run(['./build/compiler', 'measure-node-machine', '--shadow', '--passes', '0'] + mode.split() + [probe], cwd=mutants.TREE, capture_output=True, text=True)
        print(name, mode, 'status', run.returncode)
        for l in (run.stdout + run.stderr).splitlines():
            if 'difference' in l or 'differ' in l:
                print('   ', l[:230])
shutil.copyfile(saved, path)
