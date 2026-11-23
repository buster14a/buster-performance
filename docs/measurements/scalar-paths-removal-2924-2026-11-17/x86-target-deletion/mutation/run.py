import subprocess, sys, json
# usage: run.py TREE FILE MUTANTS.json TESTCMD...
tree, path, spec = sys.argv[1], sys.argv[2], sys.argv[3]
tests = json.load(open(spec))
muts = tests['mutants']; cmds = tests['tests']
full = tree + '/' + path
orig = open(full).read()
for name, old, new in muts:
    assert orig.count(old) == 1, (name, orig.count(old))
    open(full, 'w').write(orig.replace(old, new))
    try:
        b = subprocess.run('./build.sh', cwd=tree, shell=True, capture_output=True, text=True)
        if b.returncode != 0:
            print(name, 'BUILD-FAIL', flush=True); continue
        killed = []
        for c in cmds:
            r = subprocess.run(c, cwd=tree, shell=True, capture_output=True, text=True, timeout=1200)
            if r.returncode != 0: killed.append(c)
        print(name, 'KILLED by ' + '; '.join(killed) if killed else 'SURVIVED', flush=True)
    finally:
        open(full, 'w').write(orig)
subprocess.run('./build.sh', cwd=tree, shell=True, capture_output=True)
