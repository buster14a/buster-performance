# make-round4.py: build faults-rows-4.py: round 1's faults that still apply to the new tree (those that did not build
# rewritten to keep every variable used), and the new code's.
src = open('faults-rows.py').read()
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
rewrites = {
    'shapes-loads-in-an-address-context': "const __mmask64 loads = _mm512_testn_epi8_mask(contexts, _mm512_set1_epi8(0)) &\n                                _mm512_testn_epi8_mask(facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_ADDRESS));",
    'shapes-loads-an-address-type': "const __mmask64 loads = _mm512_testn_epi8_mask(contexts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TEMPLATE_ADDRESS)) &\n                                _mm512_testn_epi8_mask(facts, _mm512_set1_epi8(0));",
    'reads-converts-own-type': "_mm512_mask_cmpneq_epi32_mask(_mm512_test_epi32_mask(targets, targets), targets, _mm512_xor_si512(types, types))",
    'reads-converts-any-context': "converts &= alive & (value_context | ~value_context);",
    'shapes-address-convert-an-lvalue': "address = _mm512_mask_add_epi8(address, (rvalue | ~rvalue) & below_u64, address, _mm512_set1_epi8(1));",
    'shapes-address-convert-any-class': "address = _mm512_mask_add_epi8(address, rvalue & (below_u64 | ~below_u64), address, _mm512_set1_epi8(1));",
    'shapes-access-no-dereference': "own = _mm512_mask_mov_epi8(own, is_member | (is_dereference & 0), load);",
    'shapes-truth-none': "own = _mm512_mask_mov_epi8(own, is_truth & 0, truth);",
    'shapes-binary-none': "own = _mm512_mask_mov_epi8(own, is_binary & 0, node_window_table(tables->binaries, codes));",
    'shapes-pointer-none': "own = _mm512_mask_mov_epi8(own, is_pointer & 0, pointer);",
    'shapes-unary-none': "own = _mm512_mask_mov_epi8(own, is_unary & 0,",
    'shapes-live-empty': "const __mmask64 live = converts & ~(empty & 0);",
    'shapes-fold-any-constant': "const __mmask64 foldable = live & is_constant & (integer_constant | ~integer_constant) & integer &",
    'shapes-fold-any-class': "const __mmask64 foldable = live & is_constant & integer_constant & (integer | ~integer) &",
    'shapes-listed-no-later': "masks[BUSTER_NODE_ROWS_MASK_LISTED] = (alive & later & 0) | refused | floated;",
    'write-operand-class-not-made': "classes[0] = _mm512_mask_mov_epi8(classes[0], _mm512_cmpeq_epi8_mask(first_sources, operand_source) & 0, operand_classes);",
    'part-no-root': "((root_masks[BUSTER_NODE_ROWS_MASK_LISTED] & root_bit & 0) != 0);\n            verdict = (uint8_t)(listed ? BUSTER_NODE_ROWS_LISTED : BUSTER_NODE_ROWS_TAKEN);",
    'part-no-operand': "const bool listed = (node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, size) & false) |\n                                ((root_masks[BUSTER_NODE_ROWS_MASK_LISTED] & root_bit) != 0);\n            verdict = (uint8_t)(listed ?",
}
out = []
changed = set()
for name, file, old, new, nth in old_faults:
    if not applies(file, old, nth):
        continue
    if name in rewrites:
        new = rewrites[name]
        changed.add(name)
    out.append((name, file, old, new, nth))
kept = len(out)
def N(name, old, new, file=ROWS, nth=None):
    assert applies(file, old, nth), (name, texts[file].count(old))
    if name in [f[0] for f in out]:
        print('already of round 1:', name)
        return
    out.append((name, file, old, new, nth))
    changed.add(name)
LINED = "alive & (is_member | is_truth | (is_constant & has_object))"
N('reads-no-member', LINED, "alive & ((is_member & 0) | is_truth | (is_constant & has_object))")
N('reads-no-truth', LINED, "alive & (is_member | (is_truth & 0) | (is_constant & has_object))")
N('reads-no-address', LINED, "alive & (is_member | is_truth | (is_constant & has_object & 0))")
N('reads-lined-not-evaluated', LINED, "(alive | ~alive) & (is_member | is_truth | (is_constant & has_object))")
N('reads-lined-no-object', LINED, "alive & (is_member | is_truth | (is_constant & (has_object | ~has_object)))")
N('reads-lined-any-template', LINED, "alive & (is_member | is_truth | ((is_constant | ~is_constant) & has_object))")
N('reads-converts-not-evaluated', "converts &= alive;", "converts &= alive | ~alive;")
N('reads-words-of-void-too', "const uint64_t read_words = converts & ~voided;", "const uint64_t read_words = converts & ~(voided & 0);")
N('reads-far-inverted', "record->member_offset != 0 ?", "record->member_offset == 0 ?")
N('reads-local-inverted', "machine->object_symbols[object < machine->object_count ? object : 0] == 0;", "machine->object_symbols[object < machine->object_count ? object : 0] != 0;")
for template in ('BRANCH', 'DECIDED', 'SECOND', 'UPDATE', 'BRANCHES'):
    N('table-later-%s' % template.lower(), "tables->templates[NODE_MACHINE_TEMPLATE_%s] = BUSTER_NODE_ROWS_LATER;" % template, "tables->templates[NODE_MACHINE_TEMPLATE_%s] = 0;" % template)
N('shapes-later-of-none', "const __mmask64 later = _mm512_cmpeq_epi8_mask(own, _mm512_set1_epi8(BUSTER_NODE_ROWS_LATER));", "const __mmask64 later = _mm512_cmpeq_epi8_mask(own, _mm512_set1_epi8(BUSTER_NODE_ROWS_LATER - 1));")
N('shapes-offset-of-a-floating-field', "_mm512_test_epi8_mask(standings, _mm512_set1_epi8((char)BUSTER_NODE_MACHINE_OFFSET));", "_mm512_test_epi8_mask(standings, _mm512_set1_epi8((char)BUSTER_NODE_MACHINE_FLOATING));")
N('shapes-offset-always', "const __mmask64 offset = _mm512_test_epi8_mask(standings, _mm512_set1_epi8((char)BUSTER_NODE_MACHINE_OFFSET));", "const __mmask64 offset = _mm512_test_epi8_mask(standings, _mm512_set1_epi8((char)0xff));")
N('shapes-addressed-any-constant', "const __mmask64 addressed = is_constant & address_constant;", "const __mmask64 addressed = is_constant & (address_constant | ~address_constant);")
N('shapes-addressed-any-template', "const __mmask64 addressed = is_constant & address_constant;", "const __mmask64 addressed = (is_constant | ~is_constant) & address_constant;")
N('shapes-words-not-masked', "const __m512i to_classes = _mm512_maskz_loadu_epi8(worded, state->window_x_targets + x);", "const __m512i to_classes = _mm512_loadu_si512(state->window_x_targets + x);")
FOLDABLE = "const __mmask64 foldable = converts & is_constant & integer_constant &"
N('shapes-fold-any-template', FOLDABLE, "const __mmask64 foldable = converts & (is_constant | ~is_constant) & integer_constant &")
N('shapes-fold-any-constant', FOLDABLE, "const __mmask64 foldable = converts & is_constant & (integer_constant | ~integer_constant) &")
N('shapes-fold-none', FOLDABLE, "const __mmask64 foldable = converts & is_constant & integer_constant & 0 &")
N('shapes-fold-a-bit-int', "& _mm512_testn_epi8_mask(to_facts, _mm512_set1_epi8((char)BUSTER_CHECK_LOWER_TYPE_BIT_INT));", "& _mm512_testn_epi8_mask(to_facts, _mm512_set1_epi8(0));")
N('shapes-folded-keeps-conversion', "const __mmask64 converted = converts & ~folded;", "const __mmask64 converted = converts & ~(folded & 0);")
MOVED = "const __mmask64 moved = converted & ~same_class;"
N('shapes-moved-same-class', MOVED, "const __mmask64 moved = converted & ~(same_class & 0);")
N('shapes-moved-of-the-folded', MOVED, "const __mmask64 moved = converts & ~same_class;")
REFUSED = "const __mmask64 refused = converted & _mm512_cmpge_epu8_mask(_mm512_max_epu8(classes, to_classes), _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80));"
N('shapes-refused-none', REFUSED, "const __mmask64 refused = converted & _mm512_cmpge_epu8_mask(_mm512_max_epu8(classes, to_classes), _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80)) & 0;")
N('shapes-wide-source-alone', REFUSED, "const __mmask64 refused = converted & _mm512_cmpge_epu8_mask(_mm512_max_epu8(classes, classes), _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80));")
N('shapes-wide-target-alone', REFUSED, "const __mmask64 refused = converted & _mm512_cmpge_epu8_mask(_mm512_max_epu8(to_classes, to_classes), _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80));")
N('shapes-wide-from-i128', REFUSED, "const __mmask64 refused = converted & _mm512_cmpge_epu8_mask(_mm512_max_epu8(classes, to_classes), _mm512_set1_epi8(BUSTER_TYPED_CLASS_I128));")
CONV = "__m512i conversion = _mm512_maskz_mov_epi8(moved, _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_TYPED_DISCARD), valued, _mm512_set1_epi8(BUSTER_NODE_ROWS_CONVERT)));"
N('shapes-conversion-same-class', CONV, "__m512i conversion = _mm512_maskz_mov_epi8(moved | converted, _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_TYPED_DISCARD), valued, _mm512_set1_epi8(BUSTER_NODE_ROWS_CONVERT)));")
N('shapes-conversion-none', CONV, "__m512i conversion = _mm512_maskz_mov_epi8(moved & 0, _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_TYPED_DISCARD), valued, _mm512_set1_epi8(BUSTER_NODE_ROWS_CONVERT)));")
N('shapes-convert-to-void', CONV, "__m512i conversion = _mm512_maskz_mov_epi8(moved, _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_TYPED_DISCARD), valued | ~valued, _mm512_set1_epi8(BUSTER_NODE_ROWS_CONVERT)));")
N('shapes-discard-to-any', CONV, "__m512i conversion = _mm512_maskz_mov_epi8(moved, _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_TYPED_DISCARD), valued & 0, _mm512_set1_epi8(BUSTER_NODE_ROWS_CONVERT)));")
BOOL = "conversion = _mm512_mask_mov_epi8(conversion, converted & to_bool,"
N('shapes-bool-none', BOOL, "conversion = _mm512_mask_mov_epi8(conversion, converted & to_bool & 0,")
N('shapes-bool-of-another-class-alone', BOOL, "conversion = _mm512_mask_mov_epi8(conversion, moved & to_bool,")
N('shapes-bool-of-the-folded', BOOL, "conversion = _mm512_mask_mov_epi8(conversion, converts & to_bool,")
N('shapes-bool-to-any', BOOL, "conversion = _mm512_mask_mov_epi8(conversion, converted & (to_bool | ~to_bool),")
OBJECT = "address = _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_NODE_ROWS_ADDRESS), has_object, address);"
N('shapes-address-object-always', OBJECT, "address = _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_NODE_ROWS_ADDRESS), has_object | ~has_object, address);")
N('shapes-address-object-never', OBJECT, "address = _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_NODE_ROWS_ADDRESS), has_object & 0, address);")
N('shapes-address-global-as-local', "__m512i address = _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_NODE_ROWS_ADDRESS + 6), local,", "__m512i address = _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_NODE_ROWS_ADDRESS + 2), local,")
N('shapes-address-local-as-global', "local, _mm512_set1_epi8(BUSTER_NODE_ROWS_ADDRESS + 2));", "local, _mm512_set1_epi8(BUSTER_NODE_ROWS_ADDRESS + 6));")
names = [f[0] for f in out]
assert len(names) == len(set(names)), [n for n in names if names.count(n) > 1]
body = "#!/usr/bin/env python3\n# faults-rows-4.py TREE [N]: the rows piece's fourth round's faults, on the tree after the third round's changes: the\n# first round's that still apply (those that did not build rewritten to keep every variable used), then the new code's.\n# With no N, check every fault applies once and print how many; with N, apply fault N in TREE in place and print its\n# name. CHANGED names the faults that are new or rewritten in this round.\nimport sys\nCHANGED = " + repr(sorted(changed)) + "\nfaults = " + repr(out) + "\n" + tail
open('faults-rows-4.py', 'w').write(body)
print(kept, 'kept,', len(out) - kept, 'new,', len(out), 'in all;', len(changed), 'new or rewritten')
