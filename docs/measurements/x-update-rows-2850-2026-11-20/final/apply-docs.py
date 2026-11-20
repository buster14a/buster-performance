#!/usr/bin/env python3
# apply-docs.py TREE OUT CHECKS PROBES: put gen-docs.py's two sections (OUT/node-machine-section.md, OUT/one-core-path-section.md)
# into TREE's docs, each before the section that follows it (replacing an earlier copy), with the cloud container's
# counts for U1: the compiler's own source's tapes (CHECKS/shadow, checks-rows.sh's), the fixtures' and the probes'
# (PROBES, run-probes.sh's).
import re, sys
tree, out, checks, probed = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
def one(pattern, text):
    m = re.search(pattern, text)
    assert m, pattern
    return m
own = [int(one(r"window rows expressions=\d+ records=\d+ taken=(\d+) \([\d.]+%\) their-records=\d+ \([\d.]+%\) their-entries=\d+ differences=0 ", open('%s/shadow/main--passes0--window-rows%s--list20.out' % (checks, name)).read()).group(1)) for name in ('', '-Wall-Wextra')]
assert own[0] == own[1], own
test = open(tree + '/src/buster/compiler/c_check_node_census_test.c').read()
def taken(name):
    return int(one(r"static const NodeRowsExpected %s = \{\s+\.expressions = \d+,\s+\.taken = (\d+)," % name, test).group(1))
probes = {}
for name in ('earlier', 'cases9', 'cases10', 'cases11', 'cases12'):
    lines = open('%s/%s.txt' % (probed, name)).read().splitlines()
    assert all(' status 0 ' in l and re.search(r'entries \d+ diff 0 ', l) and re.search(r'refused \d+ diff 0 ', l) for l in lines), name
    probes[name] = len(lines)
u1 = (" In the cloud\n  container the same on the three and on the compiler's own source ({:,} tapes there), with the default warnings and\n  with `-Wall -Wextra`. The rows' fixture has a line an update's case ({:,} tapes with the first piece's lines), a\n  unit of one chunk with one update has {:,}, and C's fixture {:,} more; with one of the reference's answers changed\n  for each tape the comparison counts every tape of the three. And {:,} one-statement programs, each a file of its\n  own, {:,} of them an update's cases, read as X on T's columns does."
      .format(own[0], taken('rows_expected'), taken('rows_single_expected'), taken('rows_contexts_expected'), sum(probes.values()), probes['cases9'] + probes['cases10'] + probes['cases12']))
for doc, section, heading, before in (('docs/node-machine.md', 'node-machine-section.md', "### An update's rows on the window\n", '### What it says of step 2\n'),
                                      ('docs/one-core-path.md', 'one-core-path-section.md', "## An update's rows on the window\n", "## Step 4's first piece: a census of Tier 0's row\n")):
    text = open('%s/%s' % (tree, doc)).read()
    new = open('%s/%s' % (out, section)).read().replace('@@u1_more@@', u1)
    assert new.startswith(heading), heading
    assert text.count(before) == 1, before
    if heading in text:
        a = text.index(heading); b = text.index(before)
        assert a < b
        text = text[:a] + text[b:]
    b = text.index(before)
    text = text[:b] + new.rstrip('\n') + '\n\n' + text[b:]
    open('%s/%s' % (tree, doc), 'w').write(text)
    print(doc, 'left:', sorted(set(re.findall(r'@@(\w+)@@', new))), 'lines', new.count('\n'))
print(u1)
