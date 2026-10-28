import sys, os, shutil
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mutants import M
source, name, target = sys.argv[1], sys.argv[2], sys.argv[3]
entry = [m for m in M if m[0] == name][0]
if os.path.exists(target):
    shutil.rmtree(target)
shutil.copytree(os.path.join(source, "src"), os.path.join(target, "src"))
build = open(os.path.join(source, "build.sh")).read()
assert build.count("optimization=-O3\n") == 1
open(os.path.join(target, "build.sh"), "w").write(build.replace("optimization=-O3\n", "optimization=-O1\n"))
os.chmod(os.path.join(target, "build.sh"), 0o755)
for path, old, new in entry[2]:
    p = os.path.join(target, path)
    s = open(p).read()
    assert s.count(old) == 1, (name, path, old[:60], s.count(old))
    open(p, "w").write(s.replace(old, new))
print(" ".join(entry[1]))
