# Drops exclusive.sh's waiting messages, which name other sessions' runs, from a log: each from its first line to the
# line before the next of ours ("== " or "build.sh: ").
import re, sys
for path in sys.argv[1:]:
    lines = open(path).read().split("\n")
    out, skipping, dropped = [], False, 0
    for line in lines:
        if line.startswith("exclusive.sh: waiting for the 9700X"):
            skipping = True
        elif skipping and re.match(r"^(== |build\.sh: )", line):
            skipping = False
        if skipping:
            dropped += 1
        else:
            out.append(line)
    open(path, "w").write("\n".join(out))
    print(f"{path}: {dropped} lines dropped")
