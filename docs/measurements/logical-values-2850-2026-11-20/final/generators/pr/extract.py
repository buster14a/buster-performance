#!/usr/bin/env python3
# extract.py FILE START [END]: the text of FILE after the line that starts with START and before the one that starts
# with END (to the file's end without one): a part of a generated section, for another write-up to hold the same words.
import sys
lines = open(sys.argv[1]).read().split('\n')
start = next(i for i, l in enumerate(lines) if l.startswith(sys.argv[2]))
end = next((i for i, l in enumerate(lines) if i > start and len(sys.argv) > 3 and l.startswith(sys.argv[3])), len(lines))
print('\n'.join(lines[start + 1:end]).strip('\n'))
