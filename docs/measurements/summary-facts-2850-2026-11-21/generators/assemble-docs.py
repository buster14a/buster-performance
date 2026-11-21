#!/usr/bin/env python3
# assemble-docs.py TREE NODE-MACHINE-SECTION ONE-CORE-PATH-SECTION: the two generated sections into the tree's documents,
# each before the heading it goes before (replacing itself where it is there already), and the two sentences of the
# documents that say what is next.
import sys
tree, node_section, path_section = sys.argv[1], open(sys.argv[2]).read().rstrip('\n') + '\n\n', open(sys.argv[3]).read().rstrip('\n') + '\n\n'
def place(path, section, own, before):
    s = open(path).read()
    assert s.count(before) == 1, (path, before)
    if own in s:
        i = s.index(own)
        j = s.index(before)
        assert i < j
        s = s[:i] + s[j:]
    i = s.index(before)
    s = s[:i] + section + s[i:]
    open(path, 'w').write(s)
place(tree + '/docs/node-machine.md', node_section, "### A summary node's side facts on the window\n", '### What it says of step 2\n')
place(tree + '/docs/one-core-path.md', path_section, "## A summary node's side facts on the window\n", "## Step 4's first piece: a census of Tier 0's row\n")
p = tree + '/docs/node-machine.md'
s = open(p).read()
old = """**What is next:** a taken expression's references and events, the flip's
first piece (#2524's step 2), where the window's sweeps run in a compile and
their cost by the chunk is settled there.
"""
new = """**What is next:** a summary node's side facts, the flip's first piece
(#2524's step 2), below. The window's sweeps run in a compile after it,
where their cost by the chunk is settled.
"""
if old in s:
    s = s.replace(old, new)
assert s.count(new) == 1
old = """  operators' values, the conditionals and the commas in both. No compile
  takes any of it: a taken expression's references and events are next.
"""
new = """  operators' values, the conditionals and the commas in both, and "A summary
  node's side facts on the window" makes what the passes after the reader
  read below a root. No compile takes any of it: three holes of the earlier
  pieces' that a generator of programs found
  ([#3201](https://github.com/buster14a/buster/issues/3201),
  [#3202](https://github.com/buster14a/buster/issues/3202),
  [#3203](https://github.com/buster14a/buster/issues/3203)) and then the
  first compile that takes expressions are next.
"""
if old in s:
    s = s.replace(old, new)
assert s.count(new) == 1
open(p, 'w').write(s)
p = tree + '/docs/one-core-path.md'
s = open(p).read()
i = s.find("- **Next:** a taken expression's references and events, the flip's first piece")
if i >= 0:
    j = s.index('\n\n', i)
    s = s[:i] + "- **Next:** a summary node's side facts, the flip's first piece, below; the window's sweeps run in a compile\n  after it, where their cost by the chunk is settled." + s[j:]
assert s.count("- **Next:** a summary node's side facts, the flip's first piece, below") == 1
open(p, 'w').write(s)

