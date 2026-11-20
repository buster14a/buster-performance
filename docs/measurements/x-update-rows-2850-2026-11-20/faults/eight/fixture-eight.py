#!/usr/bin/env python3
# fixture-eight.py TREE [PINS]: the rows' fixture's line for a row of eight entries at an expression's last record.
# The line the second round added (an address constant's own four entries, then a cast's CONVERT and a narrow class's
# conversion to bool: rows of four and five) made none, and the third round's `length-low-bits` survived it; an update's
# does (a narrow destination's `++`, its value converted to bool). PINS: "entries written words lines updates".
import sys
tree = sys.argv[1]
path = tree + '/src/buster/compiler/c_check_node_census_test.c'
s = open(path).read()
old = ('    // A row of eight entries, an expression\'s last record\'s: an address constant\'s with its offset and its CONVERT,\n'
       '    // converted to bool from a narrow class.\n'
       '    "    _Bool told = (char)(long)&global_outer.inner.second;\\n"\n')
assert s.count(old) == 1, s.count(old)
s = s.replace(old, '')
anchor = ('    "    wide += local += a;\\n"\n'
          '    // What it lists: a bool\'s update, whose result is tested; and a postfix update through an address whose\n')
assert s.count(anchor) == 1, s.count(anchor)
new = ('    "    wide += local += a;\\n"\n'
       '    // A row of eight entries, an expression\'s last record\'s: a narrow destination\'s `++` (its CONST, the operation,\n'
       '    // the CONVERT back and the store) whose value is converted to bool from its narrow class (four more).\n'
       '    "    _Bool told = ++c;\\n"\n'
       '    // What it lists: a bool\'s update, whose result is tested; and a postfix update through an address whose\n')
s = s.replace(anchor, new)
if len(sys.argv) > 2:
    entries, written, words, lines, updates = sys.argv[2].split()
    pins = ('        .entries = 4817,\n        .listed_update = 132,\n        .listed_branches = 1,\n        .listed_conversion = 10,\n        .listed_floating = 2,\n'
            '        .written = 5816,\n        .words = 330,\n        .lines = 614,\n        .updates = 408,\n')
    assert s.count(pins) == 1, s.count(pins)
    s = s.replace(pins, '        .entries = %s,\n        .listed_update = 132,\n        .listed_branches = 1,\n        .listed_conversion = 10,\n        .listed_floating = 2,\n'
                        '        .written = %s,\n        .words = %s,\n        .lines = %s,\n        .updates = %s,\n' % (entries, written, words, lines, updates))
open(path, 'w').write(s)
print('edited', path)
