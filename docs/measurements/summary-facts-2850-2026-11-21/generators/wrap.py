#!/usr/bin/env python3
# wrap.py [WIDTH] < text > text: a filled write-up's paragraphs and list items wrapped to WIDTH columns (76), as the
# documents' own are. A table's rows, a heading and a fenced block are left as they are; a list item keeps its indent,
# and its later lines are two columns in from its mark.
import re, sys, textwrap
width = int(sys.argv[1]) if len(sys.argv) > 1 else 76
def fill(text, first, rest):
    words = text.split()
    return textwrap.fill(' '.join(words), width=width, initial_indent=first, subsequent_indent=rest, break_long_words=False, break_on_hyphens=False)
out, block, fenced = [], [], False
def flush():
    if not block:
        return
    if block[0].lstrip().startswith('|') or block[0].startswith('#') or block[0].startswith('(`') and len(block) == 1 and len(block[0]) <= width:
        out.extend(block)
    else:
        items, current = [], None
        for line in block:
            m = re.match(r'^(\s*)([-*] |\d+\. )', line)
            if m:
                if current is not None:
                    items.append(current)
                indent = m.group(1)
                current = [indent + m.group(2), indent + ' ' * len(m.group(2)), line[m.end():]]
            elif current is None:
                current = ['', '', line]
            else:
                current[2] += ' ' + line.strip()
        if current is not None:
            items.append(current)
        for first, rest, text in items:
            out.append(fill(text, first, rest))
    block.clear()
for line in sys.stdin.read().split('\n'):
    if line.startswith('```'):
        flush()
        fenced = not fenced
        out.append(line)
    elif fenced:
        out.append(line)
    elif line.strip() == '':
        flush()
        out.append('')
    elif line.lstrip().startswith('|') and block and not block[0].lstrip().startswith('|'):
        flush()
        block.append(line)
    else:
        block.append(line)
flush()
sys.stdout.write('\n'.join(out))
