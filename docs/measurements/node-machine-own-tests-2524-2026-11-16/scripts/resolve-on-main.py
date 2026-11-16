#!/usr/bin/env python3
# resolve-main.py ROOT: the hunks a re-pick of the hand-off's commits on main 3d0d56ed7 (which has buster#2871) leaves
# in c_check_node_census.c, both sides kept: ours is main's side (the operators' kernel), theirs the picked commit's.
import pathlib, re, sys
path = pathlib.Path(sys.argv[1]) / 'src/buster/compiler/c_check_node_census.c'
text = path.read_text()
pattern = re.compile(r'^<<<<<<< ours\n(.*?)^\|\|\|\|\|\|\| base\n(.*?)^=======\n(.*?)^>>>>>>> theirs\n', re.S | re.M)
count = 0
def resolve(match):
    global count
    count += 1
    ours, base, theirs = match.group(1), match.group(2), match.group(3)
    if '[--facts-packed]' in ours:
        # The usage comment: the operators' option beside the picked commit's.
        assert '[--facts-operators] [--facts-packed]' in ours and theirs.count('[--facts-packed]') == 1
        return theirs.replace('[--facts-packed]', '[--facts-operators] [--facts-packed]')
    # The command's check of its options: main's condition, then the reader's bits.
    assert ours.rstrip().endswith('BUSTER_NODE_FACTS_LOADS);') and theirs.startswith(base), (ours, base, theirs)
    return ours + theirs[len(base):]
text = pattern.sub(resolve, text)
assert '<<<<<<<' not in text and '>>>>>>>' not in text
path.write_text(text)
print('resolved', count, 'hunks')
