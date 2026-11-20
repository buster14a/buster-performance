#!/usr/bin/env python3
# apply-docs.py TREE OUT FOLLOWUP: put gen-docs.py's two sections (OUT/node-machine-section.md,
# OUT/one-core-path-section.md) into TREE's docs, each before the section that follows it (replacing an earlier copy),
# with the follow-up issue's number.
import re, sys
tree, out, followup = sys.argv[1], sys.argv[2], sys.argv[3]
for doc, section, heading, before in (('docs/node-machine.md', 'node-machine-section.md', "### The entries' values on the window\n", '### What it says of step 2\n'),
                                      ('docs/one-core-path.md', 'one-core-path-section.md', "## The entries' values on the window\n", "## Step 4's first piece: a census of Tier 0's row\n")):
    text = open('%s/%s' % (tree, doc)).read()
    new = open('%s/%s' % (out, section)).read().replace('@@followup@@', followup)
    assert new.startswith(heading), heading
    assert text.count(before) == 1, before
    if heading in text:
        a = text.index(heading); b = text.index(before)
        assert a < b
        text = text[:a] + text[b:]
    b = text.index(before)
    text = text[:b] + new.rstrip('\n') + '\n\n' + text[b:]
    open('%s/%s' % (tree, doc), 'w').write(text)
    left = sorted(set(re.findall(r'@@(\w+)@@', new)))
    assert not left, left
    print(doc, 'lines', new.count('\n'))
