#!/usr/bin/env python3
# pins.py TEST_C: the rows' fixtures' pins (NodeRowsExpected in c_check_node_census_test.c), a line "STRUCT.FIELD = N"
# each: what test-checker's part 5 requires of each fixture's run.
import re, sys
t = open(sys.argv[1]).read()
for m in re.finditer(r'    static const NodeRowsExpected (\w+) = \{(.*?)\n    \};', t, re.S):
    for f in re.finditer(r'(?:\.(\w+)|\[(\w+)\]) = (\d+),', m.group(2)):
        print('%s.%s = %s' % (m.group(1), f.group(1) or f.group(2), f.group(3)))
