# Keep only the line shapes the #1399 scripts and the tests print; drop exclusive.sh's lock messages and any
# other holder's command text. Usage: keep_own_lines.py SRC_DIR DST_DIR
import os, re, sys
COMMON = [
    r"^ +[0-9]+ +[0-9.]+ +[0-9]+ +[0-9]+ +[a-z_][a-z0-9_-]* +[^ ]+$",  # ps: psr pcpu pid etimes user comm
    r"^PSR %CPU +PID ELAPSED USER +COMMAND$",
    r"^[0-9.]+ [0-9.]+ [0-9.]+ [0-9]+/[0-9]+ [0-9]+$",                 # /proc/loadavg
    r"^DONE$",
]
SHAPES = {
    "ab": [r"^base [0-9a-f]{40} head [0-9a-f]{40}( head2 [0-9a-f]{40})?$", r"^[0-9a-f]{64}  [a-z0-9]+/build/compiler$",
           r"^(head2 )?sqlite3\.c --tier1 --lanes=1 object", r"^objects (identical|DIFFER)", r"^head2 (sqlite3|object)",
           r"^round [0-9]+$", r"^(base|head|head2) [0-9]+,,instructions:u,", r"^[a-z0-9-]+ (ok|FAIL):", r"^build failed$",
           r"^ +[0-9.]+%  \[\.\] "],
    "profile": [r"^ +[0-9.]+%  ", r"^run [0-9]+ [0-9]+us$", r"^== srcline"],
    "instr": [r"^[A-Za-z_0-9.]+ +[+-][0-9.]+M$", r"^== (base|head) tier1 srclines", r"^# symbol: ", r"^ +[0-9.]+%  "],
    "syms": [r"^ *[0-9]+ [A-Za-z_0-9.]+$"],
    "srclines": [r"^ +[0-9.]+%  \[\.\] "],
    "test": [r"^test-tier1-", r"^tier1[ -]", r"^allocation certificates", r"^check lanes", r"^worker budget",
             r"^  (backend startup|programs|squeezes|unstarted|address space|scratch|rule|lanes|order|budget|driver|exit helper|[a-z ]+ emissions?): "],
}


def kind(name):
    if name.startswith("ab"):
        return "ab"
    if name.startswith("profile"):
        return "profile"
    if name.startswith("instr"):
        return "instr"
    if name.endswith("isyms.txt"):
        return "syms"
    if name.startswith("srclines"):
        return "srclines"
    if name.startswith("t_") or name.startswith("t2_"):
        return "test"
    raise SystemExit("unknown file " + name)


src, dst = sys.argv[1], sys.argv[2]
for name in sorted(os.listdir(src)):
    pats = [re.compile(p) for p in COMMON + SHAPES[kind(name)]]
    kept = dropped = 0
    with open(os.path.join(src, name), errors="replace") as f, open(os.path.join(dst, name), "w") as out:
        for line in f:
            line = line.rstrip("\n")
            if any(p.search(line) for p in pats) and not re.search(r"^  (title|link|pull request): ", line):
                out.write(line + "\n")
                kept += 1
            else:
                dropped += 1
    print(f"{name}: kept {kept}, dropped {dropped}")
