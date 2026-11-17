import subprocess, os
tree = os.path.expanduser("~/.cache/claude-2646/mut/tree")
mutants = [
    ("straight-dropped", "src/buster/compiler/tier1_emit.c",
     "            prepared.allocation.register_hints = named ? register_hints : 0;",
     "            prepared.allocation.register_hints = named && register_hints == 0 ? register_hints : 0;",
     "test-tier1-emit", "(#2646)"),
    ("straight-not-ending", "src/buster/compiler/tier1_emit.c",
     "&& source->ends[interval] == 2 * node + 1;",
     "&& (true || source->ends[interval] == 2 * node + 1);",
     "test-tier1-emit", "(#2646)"),
]
def run(cmd): return subprocess.run(cmd, shell=True, cwd=tree, capture_output=True, text=True)
for name, path, old, new, test, expect in mutants:
    full = os.path.join(tree, path); text = open(full).read()
    assert text.count(old) == 1 and text.count(new) == 0, name
    open(full, "w").write(text.replace(old, new))
    b = run("BUSTER_HOST_ARCH=native ./build.sh --config Debug 2>&1 | grep -E \"error|build.sh:\" | head -5"); print(b.stdout[-300:])
    if "published" not in b.stdout:
        print(name, "BUILD FAILED"); run("git checkout -q -- " + path); continue
    r = run("timeout 900 ./build/compiler " + test + " 2>&1")
    print(name, "KILLED" if r.returncode != 0 and expect in r.stdout else "SURVIVED " + r.stdout[-600:], flush=True)
    run("git checkout -q -- " + path)
print("clean:", run("git status --short").stdout.strip() == "")
