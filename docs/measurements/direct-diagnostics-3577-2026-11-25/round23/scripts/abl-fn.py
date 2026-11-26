#!/usr/bin/env python3
# abl-all.py REPO SRC_DIR [SKIP_FILE]: measurement-only ablation of every check this branch added (#3577 round 22).
# Each `if` the branch added whose body bails (fast_cc_bail / fast_pp_bail) gets an opaque never-true test in front of
# its condition (BUSTER_ABLX: a volatile byte that is 0), so the condition is no longer evaluated; main's own checks and
# the branch's bookkeeping stay. Lines listed in SKIP_FILE (file:line, the head's numbering) are left alone. Prints each
# gated site. Run on a pristine copy of the head's sources, before abl-a1.py, whose lines it skips by text.
import re, subprocess, sys

repo, src_dir = sys.argv[1], sys.argv[2]
skip = set()
if len(sys.argv) > 3:
    for line in open(sys.argv[3]):
        line = line.strip()
        if line and not line.startswith('#'):
            skip.add(line)
import os
files = ['c_direct_lex.c', 'c_direct_types.c', 'c_direct_cc.c', 'c_direct.c']
only = set(os.environ.get('ABL_ONLY', ','.join(files)).split(','))
funcs = set(f for f in os.environ.get('ABL_FUNCS', '').split(',') if f)
def enclosing(lines, n):
    stop = {'__attribute__', 'aligned', 'noinline', 'cold', 'hot', 'always_inline', 'section', 'used', 'unused', 'flatten'}
    best = None
    for i in range(n - 1, -1, -1):
        if lines[i] == '{' and i > 0:
            j = i - 1
            while j > 0 and (lines[j].startswith(' ') or lines[j] == ''):
                j -= 1
            names = [x for x in re.findall(r'(\w+)\s*\(', lines[j]) if x not in stop]
            if names:
                return names[0]
    return best
# A1's lines (abl-a1.py's first arguments) are A1's to gate.
a1_text = open(__file__.replace('abl-fn.py', 'abl-a1.py')).read()

def added_lines(f):
    out = subprocess.run(['git', '-C', repo, 'diff', '-U0', 'origin/main...HEAD', '--', 'src/buster/compiler/' + f],
                         capture_output=True, text=True).stdout
    added = set()
    for m in re.finditer(r'^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@', out, re.M):
        start = int(m.group(1)); count = int(m.group(2)) if m.group(2) is not None else 1
        added.update(range(start, start + count))
    return added

def strip_code(s):
    # Blank out string and character literals and // comments so parentheses inside them don't count.
    s = re.sub(r'"(\\.|[^"\\])*"', lambda m: '"' + ' ' * (len(m.group(0)) - 2) + '"', s)
    s = re.sub(r"'(\\.|[^'\\])*'", lambda m: "'" + ' ' * (len(m.group(0)) - 2) + "'", s)
    i = s.find('//')
    return s if i < 0 else s[:i] + ' ' * (len(s) - i)

indent = lambda s: len(s) - len(s.lstrip(' '))
total = 0
for f in files:
    path = src_dir + '/src/buster/compiler/' + f
    lines = open(path).read().split('\n')
    added = added_lines(f) if f in only else set()
    gated = set()
    for n in sorted(added):
        text = lines[n - 1]
        if '_bail(' not in text:
            continue
        # The controlling if: on this line before the bail, or the nearest line above (within 14) that starts with
        # `if (` or `else if (` at a smaller indentation.
        target = None
        m = re.search(r'\b(else\s+)?if\s*\(', strip_code(text))
        if m and m.start() < text.find('_bail('):
            target = n
        else:
            for k in range(n - 1, max(0, n - 15), -1):
                t = lines[k - 1]
                if t.strip() == '' or t.strip().startswith('//'):
                    continue
                if re.match(r'^\s*(\}\s*)?(else\s+)?if\s*\(', t) and indent(t) < indent(text):
                    target = k
                    break
                # A bail in an else branch is the path the if's condition doesn't take: gating the if would take it.
                if re.match(r'^\s*(\}\s*)?else\s*(\{|$)', t) and indent(t) < indent(text):
                    break
                if re.match(r'^\s*(for|while|switch|do)\b', t) and indent(t) < indent(text):
                    break
        if target is None or target in gated or target not in added or ('%s:%d' % (f, target)) in skip:
            continue
        if funcs and enclosing(lines, target) not in funcs:
            continue
        t = lines[target - 1]
        if 'BUSTER_ABL' in t or t.strip() in a1_text:
            continue
        # Find `if (` on the target line and its matching `)` (possibly on a later line).
        clean = strip_code(t)
        m = re.search(r'\bif\s*\(', clean)
        if m is None:
            continue
        open_col = m.end() - 1
        depth = 0; end = None
        for li in range(target - 1, min(len(lines), target + 12)):
            c = strip_code(lines[li])
            start_col = open_col if li == target - 1 else 0
            for ci in range(start_col, len(c)):
                if c[ci] == '(':
                    depth += 1
                elif c[ci] == ')':
                    depth -= 1
                    if depth == 0:
                        end = (li, ci)
                        break
            if end is not None:
                break
        if end is None:
            continue
        li, ci = end
        # Insert the closing parenthesis first (it may be on the same line as the opening one).
        lines[li] = lines[li][:ci] + ')' + lines[li][ci:]
        lines[target - 1] = lines[target - 1][:open_col + 1] + 'BUSTER_ABLX && (' + lines[target - 1][open_col + 1:]
        gated.add(target)
        print('gated %s:%d  %s' % (f, target, t.strip()[:110]))
    total += len(gated)
    if f == 'c_direct_lex.c':
        # The opaque test, before the first use (c_direct_lex.c is the unity build's first direct-path file).
        i = next(k for k, l in enumerate(lines) if l.startswith('typedef struct FastTok FastTok;'))
        lines.insert(i, 'static volatile uint8_t buster_ablx_never = 0;\n#define BUSTER_ABLX (buster_ablx_never != 0)')
    open(path, 'w').write('\n'.join(lines))
print('gated %d sites' % total)
