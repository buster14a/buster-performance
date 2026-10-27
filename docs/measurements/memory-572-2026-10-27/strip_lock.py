#!/usr/bin/env python3
# Removes exclusive.sh's waiting messages from a log. A message is a line starting with "exclusive.sh: ", then, when the
# holder's command spans lines, its other lines, ended by the owner's "  title:", "  link:" and "  pull request:" lines:
# where such a line follows within 40 lines, with no other message, round heading or step heading ("=== ") between, the
# message runs through the last of them; otherwise it is the one line. A perf stat log (its file name perf*.log), whose
# messages' first lines the run's own filter dropped already, keeps only perf stat's CSV lines and the round headings.
# #528's record's filter, with step headings added for #572's logs.
import os, re, sys
path = sys.argv[1]
lines = open(path, errors="replace").read().splitlines(keepends=True)
owner = ("  title:", "  link:", "  pull request:")
if re.match(r"perf.*\.log$", os.path.basename(path)):
    out = [l for l in lines if re.match(r"== round |[0-9.]+,|<not ", l)]
else:
    out = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith("exclusive.sh: "):
            end = i
            for j in range(i + 1, min(len(lines), i + 41)):
                if lines[j].startswith("exclusive.sh: ") or lines[j].startswith("== round ") or lines[j].startswith("=== "):
                    break
                if lines[j].startswith(owner):
                    end = j
                    while end + 1 < len(lines) and lines[end + 1].startswith(owner):
                        end += 1
                    break
            i = end + 1
            continue
        out.append(line)
        i += 1
sys.stdout.write("".join(out))
