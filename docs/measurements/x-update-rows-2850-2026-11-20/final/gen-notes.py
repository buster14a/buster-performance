#!/usr/bin/env python3
# gen-notes.py TREE OUT: the result note for #2850 and the pull request's body's measured parts, from the design's
# sections in TREE's docs (gen-docs.py's, put there by apply-docs.py): no number is typed here.
import re, sys
tree, out = sys.argv[1], sys.argv[2]
docs = open(tree + '/docs/node-machine.md').read()
section = docs[docs.index("### An update's rows on the window\n"):docs.index('### What it says of step 2\n')]
one = open(tree + '/docs/one-core-path.md').read()
short = one[one.index("## An update's rows on the window\n"):one.index("## Step 4's first piece: a census of Tier 0's row\n")]
def between(text, start, end):
    a = text.index(start); b = text.index(end, a)
    return text[a:b].strip('\n')
def flat(text):
    # A paragraph a line, as GitHub renders a line break in a comment.
    lines = []
    for block in re.split(r'\n(?=- \*\*|\| |\n)', text):
        lines.append(block if block.lstrip().startswith('|') else re.sub(r'\n +', ' ', block).replace('\n', ' ') if not block.startswith('|') else block)
    return '\n'.join(lines)
short_table = between(short, '| | `sqlite3.c` | Lua | musl |', '\n\n### Against its gates')
gates = between(section, '- **U1, exact', '\n\n**What stays')
builds_table = between(section, '| build |', '\n\n- **A shape chosen')
builds_notes = between(section, '- **A shape chosen', '\n\n**Measured.**')
measured = between(section, '| | `sqlite3.c` | Lua | musl |', '\n\n**Against its gates.**')
means = between(short, '### What it means\n', '\n- **Next:**').split('\n', 1)[1].strip('\n')
open(out + '/gates.md', 'w').write(flat(gates) + '\n')
open(out + '/short-table.md', 'w').write(short_table + '\n')
open(out + '/measured-table.md', 'w').write(measured + '\n')
open(out + '/builds-table.md', 'w').write(builds_table + '\n')
open(out + '/builds-notes.md', 'w').write(flat(builds_notes) + '\n')
open(out + '/means.md', 'w').write(flat(means) + '\n')
stays = between(section, '**What stays a record at a time, and why.**', '\n\n**What is next:**').split('**', 2)[2].strip()
lists = between(section, '**What it lists.**', '\n\n**A sweep and a loop of their own**').split('**', 2)[2].strip()
open(out + '/stays.md', 'w').write(flat(stays) + '\n')
short_gates = between(short, '### Against its gates\n', '\n\n### What stays').split('\n', 1)[1].strip('\n')
open(out + '/short-gates.md', 'w').write(flat(short_gates) + '\n')
open(out + '/lists.md', 'w').write(flat(lists) + '\n')
print('written; placeholders left:', sorted(set(re.findall(r'@@(\w+)@@', section + short))))
