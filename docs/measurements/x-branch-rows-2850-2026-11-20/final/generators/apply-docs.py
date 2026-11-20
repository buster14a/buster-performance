#!/usr/bin/env python3
# apply-docs.py TREE OUT: put gen-docs.py's two sections (OUT/node-machine-section.md, OUT/one-core-path-section.md)
# into TREE's docs, each before the section that follows it (replacing an earlier copy), with the fixtures' counts for
# B1 (the test's pins in TREE).
import re, sys
tree, out = sys.argv[1], sys.argv[2]
def one(pattern, text):
    m = re.search(pattern, text)
    assert m, pattern
    return m
test = open(tree + '/src/buster/compiler/c_check_node_census_test.c').read()
def taken(name):
    return int(one(r"static const NodeRowsExpected %s = \{\s+\.expressions = \d+,\s+\.taken = (\d+)," % name, test).group(1))
b1 = (" The rows' fixture has a line a\n  pattern ({:,} tapes with the pieces' before), a unit of one chunk with one condition and no update has {:,}, one with\n  one update {:,}, and C's fixture {:,} more; with one of the reference's answers changed for each tape the comparison\n  counts every tape of the four."
      .format(taken('rows_expected'), taken('rows_branch_expected'), taken('rows_single_expected'), taken('rows_contexts_expected')))
for doc, section, heading, before in (('docs/node-machine.md', 'node-machine-section.md', "### The branches' rows on the window\n", '### What it says of step 2\n'),
                                      ('docs/one-core-path.md', 'one-core-path-section.md', "## The branches' rows on the window\n", "## Step 4's first piece: a census of Tier 0's row\n")):
    text = open('%s/%s' % (tree, doc)).read()
    new = open('%s/%s' % (out, section)).read().replace('@@b1_more@@', b1)
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
print(b1)
