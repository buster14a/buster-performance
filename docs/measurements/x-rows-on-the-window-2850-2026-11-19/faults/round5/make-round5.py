# make-round5.py: build faults-rows-5.py: round 4's faults that still apply to the tree after its survivors' changes
# (the folded bool row and the root's test removed, the listed mask without its evaluated term), and those of the
# changed lines.
src = open('faults-rows-4.py').read()
head = src[:src.index("def apply(")]
tail = src[src.index("def apply("):]
ns = {}
exec(head, ns)
old_faults = ns['faults']
tree = '/home/user/buster-x1'
ROWS = 'src/buster/compiler/c_check_node_machine_rows.c'
CENSUS = 'src/buster/compiler/c_check_node_census.c'
texts = {f: open(tree + '/' + f).read() for f in (ROWS, CENSUS)}
def applies(file, old, nth):
    n = texts[file].count(old)
    return n == 1 if nth is None else n > nth
out = []
dropped = []
changed = set()
# A fault that no longer builds on the changed code (it took a variable's only use away) is rewritten to keep it used.
rewrites = {
    'shapes-own-not-evaluated': "own = _mm512_maskz_mov_epi8(alive | ~alive, own);",
}
for name, file, old, new, nth in old_faults:
    if not applies(file, old, nth):
        dropped.append(name)
        continue
    if name in rewrites:
        new = rewrites[name]
        changed.add(name)
    out.append((name, file, old, new, nth))
kept = len(out)
def N(name, old, new, file=ROWS, nth=None):
    assert applies(file, old, nth), (name, texts[file].count(old))
    assert name not in [f[0] for f in out], name
    out.append((name, file, old, new, nth))
    changed.add(name)
FOLDED = "own = _mm512_mask_mov_epi8(own, folded, _mm512_set1_epi8(BUSTER_NODE_ROWS_FOLDED));"
N('shapes-folded-not-made', FOLDED, "own = _mm512_mask_mov_epi8(own, folded & 0, _mm512_set1_epi8(BUSTER_NODE_ROWS_FOLDED));")
N('shapes-folded-as-convert', FOLDED, "own = _mm512_mask_mov_epi8(own, folded, _mm512_set1_epi8(BUSTER_NODE_ROWS_CONVERT));")
LISTED = "masks[BUSTER_NODE_ROWS_MASK_LISTED] = later | refused | floated;"
N('shapes-listed-no-later', LISTED, "masks[BUSTER_NODE_ROWS_MASK_LISTED] = (later & 0) | refused | floated;")
N('shapes-listed-no-refused', LISTED, "masks[BUSTER_NODE_ROWS_MASK_LISTED] = later | (refused & 0) | floated;")
N('shapes-listed-no-floated', LISTED, "masks[BUSTER_NODE_ROWS_MASK_LISTED] = later | refused | (floated & 0);")
PART = "const bool listed = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, size);"
N('part-no-operand', PART, "const bool listed = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, size) & false;")
N('part-operand-record-alone', PART, "const bool listed = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, operand + (first & 0), 1);")
N('part-first-record-alone', PART, "const bool listed = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, 1);")
N('part-without-the-operand-record', PART, "const bool listed = size > 1 && node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, size - 1);")
N('part-refused-mask', PART, "const bool listed = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_REFUSED, first, size);")
VERDICT = "if (state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_TAKEN)\n        {\n            const uint32_t operand = state->operands[e];"
N('part-of-any-verdict', VERDICT, "if (state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_TAKEN || state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_REFUSED)\n        {\n            const uint32_t operand = state->operands[e];")
N('part-of-the-listed-too', VERDICT, "if (state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_TAKEN || state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_LISTED)\n        {\n            const uint32_t operand = state->operands[e];")
names = [f[0] for f in out]
assert len(names) == len(set(names)), [n for n in names if names.count(n) > 1]
body = "#!/usr/bin/env python3\n# faults-rows-5.py TREE [N]: the rows piece's fifth round's faults, on the tree after the fourth round's changes: the\n# fourth round's that still apply, then the changed lines'. With no N, check every fault applies once and print how\n# many; with N, apply fault N in TREE in place and print its name. CHANGED names the faults that are new in this round.\nimport sys\nCHANGED = " + repr(sorted(changed)) + "\nfaults = " + repr(out) + "\n" + tail
open('faults-rows-5.py.new', 'w').write(body)
print(kept, 'kept,', len(out) - kept, 'new,', len(out), 'in all;', 'dropped:', dropped)
