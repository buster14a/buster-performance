#!/usr/bin/env python3
# Resolves the flat front's re-pick on the reader-time series, hunk by hunk, keeping both sides.
import re, sys, pathlib

def hunks(text):
    parts = []
    pattern = re.compile(r'^<<<<<<< ours\n(.*?)^\|\|\|\|\|\|\| base\n(.*?)^=======\n(.*?)^>>>>>>> theirs\n', re.S | re.M)
    position = 0
    for match in pattern.finditer(text):
        parts.append(('text', text[position:match.start()]))
        parts.append(('hunk', match.group(1), match.group(2), match.group(3)))
        position = match.end()
    parts.append(('text', text[position:]))
    return parts

def resolve(path, resolvers):
    text = pathlib.Path(path).read_text()
    parts = hunks(text)
    out = []
    index = 0
    for part in parts:
        if part[0] == 'text':
            out.append(part[1])
        else:
            out.append(resolvers[index](part[1], part[2], part[3]))
            index += 1
    assert index == len(resolvers), (path, index, len(resolvers))
    result = ''.join(out)
    assert '<<<<<<<' not in result and '>>>>>>>' not in result and '\n=======\n' not in result, path
    pathlib.Path(path).write_text(result)
    print(path, index, 'hunks')

def once(text, old, new):
    assert text.count(old) == 1, (old, text.count(old))
    return text.replace(old, new)

root = pathlib.Path(sys.argv[1])

# docs/commands/lowering.md
def usage(ours, base, theirs):
    return once(ours, '[--front-types] [--front-sweeps]', '[--front-types] [--front-flat|--front-flat-first] [--front-sweeps]')
def bullets(ours, base, theirs):
    start = theirs.index('- `--front-flat` runs **the flat front**')
    flat = theirs[start:]
    assert theirs[:start] == base, 'the flat front changed the lines before its bullet'
    cut = ours.index('- `--front-sweeps` runs **C and X where they sit**')
    return ours[:cut] + flat + ours[cut:]
def fixtures(ours, base, theirs):
    first = 'declaration points to, whose pointer type T makes itself.'
    assert base == first + '\n' and theirs.startswith(first + ' ') and ours.startswith(first + ' C and X run at\n')
    return theirs + 'C and X run at\n' + ours[len(first + ' C and X run at\n'):]
resolve(root / 'docs/commands/lowering.md', [usage, bullets, fixtures])

# docs/node-machine.md: the flat front's section, then the reader-time sections.
def sections(ours, base, theirs):
    assert base == '' and theirs.startswith('### The front by passes\n') and ours.startswith('### C and X where they sit\n')
    return theirs + ours
resolve(root / 'docs/node-machine.md', [sections])

# c_check_node_machine_front.c: both sets of bits.
def bits(ours, base, theirs):
    assert base == ''
    return theirs + ours
resolve(root / 'src/buster/compiler/c_check_node_machine_front.c', [bits])

# c_check_node_census.c: both options; every difference fails the command.
def options(ours, base, theirs):
    assert base == '' and theirs.endswith('        }\n') and ours.endswith('        }\n')
    return theirs + ours
def failures(ours, base, theirs):
    assert 'shadow.flat_differences != 0);' in theirs
    return once(ours, 'shadow.own_differences != 0);', 'shadow.own_differences != 0 ||\n' + ' ' * 42 + 'shadow.flat_differences != 0);')
resolve(root / 'src/buster/compiler/c_check_node_census.c', [options, failures])

# c_check_node_census_test.c: both conditions.
def both(ours, base, theirs):
    assert base == ''
    return ours + theirs
def same(ours, base, theirs):
    assert theirs.endswith('                      flat;\n') and '                      swept;\n' in ours
    assert theirs[:-len('                      flat;\n')] == ours[:ours.index('                      swept;\n')]
    return once(ours, '                      swept;\n', '                      swept && flat;\n')
def boundaries(ours, base, theirs):
    assert ours.endswith('&& typed && swept;\n') and theirs.endswith('&& typed && flat;\n') and base.endswith('&& typed;\n')
    return once(ours, '&& typed && swept;\n', '&& typed && swept && flat;\n')
resolve(root / 'src/buster/compiler/c_check_node_census_test.c', [both, same, both, boundaries])
