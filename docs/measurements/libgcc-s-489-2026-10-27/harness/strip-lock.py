# Copies a log without the shared lock's "waiting" message, which quotes the lock's current owner (other sessions'
# and CI jobs' commands, titles and links): every line before the command's own first line, which must start with
# that message. Usage: strip-lock.py INPUT OUTPUT
import re, sys
first = re.compile(r"^(The dynamic runtime|The shared library|benchmark-link:|-lm:|Output lanes:|run 1 list|build\.sh:| Performance counter stats)")
lines = open(sys.argv[1]).read().splitlines(keepends=True)
start = next((i for i, l in enumerate(lines) if first.match(l)), None)
if start is None:
    # A command that printed nothing of its own before failing: keep its last line, its error.
    start = len(lines) - 1
if lines[start].startswith(" Performance counter stats") and start > 0 and lines[start - 1].strip() == "":
    start -= 1
assert start == 0 or lines[0].startswith("exclusive.sh: waiting"), sys.argv[1]
open(sys.argv[2], "w").writelines(lines[start:])
