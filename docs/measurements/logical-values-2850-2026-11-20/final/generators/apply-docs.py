#!/usr/bin/env python3
# apply-docs.py TREE NODE_MACHINE_SECTION ONE_CORE_SECTION: the two generated sections into TREE's design pages, each
# before the heading it goes in front of (an earlier copy of the section is replaced).
import re, sys
tree, node, one = sys.argv[1:4]
def place(path, section_path, title, before):
    text = open(path).read()
    section = open(section_path).read().rstrip('\n') + '\n\n'
    assert section.startswith(title + '\n'), section[:80]
    start = text.find('\n' + title + '\n')
    end = text.index('\n' + before + '\n')
    if start != -1:
        assert start < end
        text = text[:start + 1] + text[end + 1:]
        end = text.index('\n' + before + '\n')
    text = text[:end + 1] + section + text[end + 1:]
    open(path, 'w').write(text)
place(tree + '/docs/node-machine.md', node, "### An operator's value and a comma on the window", "### What it says of step 2")
place(tree + '/docs/one-core-path.md', one, "## An operator's value and a comma on the window", "## Step 4's first piece: a census of Tier 0's row")
