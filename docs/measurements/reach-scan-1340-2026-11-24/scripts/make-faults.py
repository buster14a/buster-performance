#!/usr/bin/env python3
# The fault round's switch (not for merge): each necessary condition of the reach filter broken in turn at run time by
# BUSTER_EXPERIMENT_REACH_FAULT=N. Edits c_check_common_reach_filter.c in place and writes the faults' list;
# `git diff` gives the patch. Arguments: the file, the list.
import sys
p = sys.argv[1]
s = open(p).read()
faults = []
def edit(old, new):
    global s
    assert s.count(old) == 1, (s.count(old), old)
    s = s.replace(old, new, 1)
def F(name):
    faults.append(name)
    return "check_reach_fault(%d)" % len(faults)

edit('''typedef struct CheckCommonReachFilter CheckCommonReachFilter;''', '''// EXPERIMENT (not for merge): the fault BUSTER_EXPERIMENT_REACH_FAULT names, read once.
static bool check_reach_fault(int fault)
{
    static int chosen = -2;
    if (chosen == -2)
    {
        const char* text = getenv("BUSTER_EXPERIMENT_REACH_FAULT");
        chosen = text != NULL ? atoi(text) : -1;
    }
    return chosen == fault;
}

typedef struct CheckCommonReachFilter CheckCommonReachFilter;''')

def mask(base, names):
    # A trait mask with one trait dropped by a fault.
    return "(char)(%s%s)" % (base, "".join(" & ~(%s ? %s : 0u)" % (F(text), trait) for trait, text in names))

# The byte tests.
edit('''    kept |= _mm512_mask_test_epi8_mask(sources, any, _mm512_set1_epi8(BUSTER_CHECK_REACH_ARM_TRAITS));''',
     '''    kept |= %s ? 0 : _mm512_mask_test_epi8_mask(sources, any, _mm512_set1_epi8(%s));''' % (F("a source's children's traits aren't asked"), mask("BUSTER_CHECK_REACH_ARM_TRAITS", [
         ("BUSTER_CHECK_TRAIT_FLOATING", "a source's floating constant isn't kept"), ("BUSTER_CHECK_TRAIT_ARMS", "a source's conditional or comma isn't kept"),
         ("BUSTER_CHECK_TRAIT_PEELED", "a source's << or conversion isn't kept"), ("BUSTER_CHECK_TRAIT_SELECT", "a source's selection isn't kept")])))
edit('''    kept |= _mm512_mask_test_epi8_mask(truths, _mm512_or_si512(any, own), _mm512_set1_epi8(BUSTER_CHECK_REACH_TRUTH_TRAITS));''',
     '''    kept |= %s ? 0 : _mm512_mask_test_epi8_mask(truths, _mm512_or_si512(%s ? _mm512_setzero_si512() : any, %s ? _mm512_setzero_si512() : own), _mm512_set1_epi8(%s));''' % (
         F("a truth context is never kept"), F("a truth context's operands aren't asked"), F("a static assertion's own node isn't asked"), mask("BUSTER_CHECK_REACH_TRUTH_TRAITS", [
         ("BUSTER_CHECK_TRAIT_FLOATING", "a truth context's floating constant isn't kept"), ("BUSTER_CHECK_TRAIT_ARMS", "a truth context's conditional isn't kept"),
         ("BUSTER_CHECK_TRAIT_PEELED", "a truth context's << or conversion isn't kept"), ("BUSTER_CHECK_TRAIT_SELECT", "a truth context's selection isn't kept")])))
edit('''                                       _mm512_set1_epi8((char)BUSTER_CHECK_REACH_DIVISOR_TRAITS));''',
     '''                                       _mm512_set1_epi8(%s));''' % mask("BUSTER_CHECK_REACH_DIVISOR_TRAITS", [
         ("BUSTER_CHECK_TRAIT_INTEGER", "a constant divisor isn't kept"), ("BUSTER_CHECK_TRAIT_CAST", "a cast divisor isn't kept"),
         ("BUSTER_CHECK_TRAIT_PEELED", "a converted divisor isn't kept"), ("BUSTER_CHECK_TRAIT_ADDRESS", "a const object's divisor isn't kept")]))
edit('''    kept |= _mm512_mask_test_epi8_mask(dereferences, any, _mm512_set1_epi8(BUSTER_CHECK_REACH_POINTER_TRAITS));''',
     '''    kept |= _mm512_mask_test_epi8_mask(dereferences, any, _mm512_set1_epi8(%s));''' % mask("BUSTER_CHECK_REACH_POINTER_TRAITS", [
         ("BUSTER_CHECK_TRAIT_INTEGER", "a dereference's constant operand isn't kept"), ("BUSTER_CHECK_TRAIT_CAST", "a dereference's cast operand isn't kept"),
         ("BUSTER_CHECK_TRAIT_PEELED", "a dereference's converted operand isn't kept")]))
edit('''    kept |= _mm512_test_epi8_mask(families, _mm512_set1_epi8(BUSTER_CHECK_FAMILY_CALL)) & (filter->marked != NULL ? filter->marked[first >> 6] : 0);''',
     '''    kept |= _mm512_test_epi8_mask(families, _mm512_set1_epi8(BUSTER_CHECK_FAMILY_CALL)) & (filter->marked != NULL && !%s ? filter->marked[first >> 6] : 0);''' % F("a marked call isn't kept"))
edit('''    __mmask64 constants = _mm512_mask_test_epi8_mask(sources & ~kept, any, _mm512_set1_epi8(BUSTER_CHECK_TRAIT_INTEGER));''',
     '''    __mmask64 constants = %s ? 0 : _mm512_mask_test_epi8_mask(sources & ~kept, any, _mm512_set1_epi8(BUSTER_CHECK_TRAIT_INTEGER));''' % F("a source's integer constant is never asked"))
edit('''                                                 _mm512_set1_epi8(BUSTER_CHECK_TRAIT_INTEGER)) | (dereferences & ~kept);''',
     '''                                                 _mm512_set1_epi8(%s ? 0 : BUSTER_CHECK_TRAIT_INTEGER)) | (%s ? 0 : dereferences & ~kept);''' % (
         F("a subscript with a constant index is never asked"), F("a dereference's operand's type is never asked")))
edit('''    __mmask64 selfs = filter->self_assign ? source1 & ~kept : 0;''', '''    __mmask64 selfs = filter->self_assign && !%s ? source1 & ~kept : 0;''' % F("a plain x = y isn't kept for -Wself-assign"))
edit('''    __mmask64 enumerations = filter->enum_cast ? sources & ~kept : 0;''', '''    __mmask64 enumerations = filter->enum_cast && !%s ? sources & ~kept : 0;''' % F("a source's enumeration target isn't asked"))
edit('''    __mmask64 rows = filter->edges ? _mm512_mask_test_epi8_mask(listed & ~kept & ~truths, any, _mm512_set1_epi8(BUSTER_CHECK_REACH_EDGE_TRAITS)) : 0;''',
     '''    __mmask64 rows = filter->edges && !%s ? _mm512_mask_test_epi8_mask(listed & ~kept & ~truths, any, _mm512_set1_epi8(%s)) : 0;''' % (
         F("the conversion edges' rows are never asked"), mask("BUSTER_CHECK_REACH_EDGE_TRAITS", [
         ("BUSTER_CHECK_TRAIT_INTEGER", "an edge's integer constant operand isn't asked"), ("BUSTER_CHECK_TRAIT_ARMS", "an edge's conditional or comma operand isn't asked"),
         ("BUSTER_CHECK_TRAIT_SELECT", "an edge's selection operand isn't asked")])))
edit('''        const uint32_t listing = others != 0 ? check_common_reach_selected(''', '''        const uint32_t listing = others != 0 && !%s ? check_common_reach_selected(''' % F("the scan's own listing is never asked: only the two classes' nodes are kept"))
# The lanes.
edit('''        const bool widening = source_width != 0 && target_width >= source_width;
        const bool field = assignment && (filter->children[node] & BUSTER_CHECK_CHILD_BIT_FIELD) != 0;''',
     '''        const bool widening = %s ? source_width != 0 : %s ? target_width >= source_width : source_width != 0 && target_width >= source_width;
        const bool field = assignment && !%s && (filter->children[node] & BUSTER_CHECK_CHILD_BIT_FIELD) != 0;''' % (
         F("a source's integer constant is taken out whatever its target's width"), F("a source's integer constant of an unknown width is taken out"),
         F("a bit-field's assignment isn't kept")))
edit('''        const uint32_t source = assignment ? graph->operand1[node] : graph->operand0[node];''',
     '''        const uint32_t source = assignment != %s ? graph->operand1[node] : graph->operand0[node];''' % F("a source is read from the other operand"))
edit('''        const bool subscript = !dereference && index < count && (filter->traits[index] & BUSTER_CHECK_TRAIT_INTEGER) != 0 && (classes & BUSTER_CHECK_CLASS_ARRAY) != 0;
        kept |= (uint64_t)(subscript || (dereference && (classes & BUSTER_CHECK_CLASS_NULLPTR) != 0) ? 1u : 0u) << lane;''',
     '''        const bool subscript = !dereference && index < count && (filter->traits[index] & BUSTER_CHECK_TRAIT_INTEGER) != 0 && (classes & BUSTER_CHECK_CLASS_ARRAY) != 0 && !%s;
        kept |= (uint64_t)(subscript || (dereference && (classes & BUSTER_CHECK_CLASS_NULLPTR) != 0 && !%s) ? 1u : 0u) << lane;''' % (
         F("a subscript of an array isn't kept"), F("a dereference of a nullptr_t operand isn't kept")))
edit('''        const uint32_t classes = check_common_reach_class(filter, row->operands[0].type) | check_common_reach_class(filter, row->operands[1].type) |
                                 check_common_reach_class(filter, row->operands[2].type);''',
     '''        const uint32_t classes = (%s ? 0 : check_common_reach_class(filter, row->operands[0].type)) | (%s ? 0 : check_common_reach_class(filter, row->operands[1].type)) |
                                 (%s ? 0 : check_common_reach_class(filter, row->operands[2].type));''' % (
         F("a row's first target isn't read"), F("a row's second target isn't read"), F("a row's third target isn't read")))
# The arguments.
edit('''        if (argument < count && (filter->enum_cast || (traits & (BUSTER_CHECK_TRAIT_INTEGER | BUSTER_CHECK_REACH_ARM_TRAITS)) != 0))''',
     '''        if (argument < count && ((filter->enum_cast && !%s) || (traits & (BUSTER_CHECK_TRAIT_INTEGER | (%s ? 0u : BUSTER_CHECK_REACH_ARM_TRAITS))) != 0))''' % (
         F("an argument without a trait isn't asked for its enumeration parameter"), F("an argument that is no integer constant isn't asked")))
edit('''            const uint32_t target_width = check_common_reach_width(filter->promoted, target);''',
     '''            const uint32_t target_width = check_common_reach_width(%s ? filter->fault_promoted : filter->promoted, target);''' % F("an argument's target's width is its promotion's alone, a prototype's parameter's forgotten"))
edit('''            const bool arms = (traits & BUSTER_CHECK_REACH_ARM_TRAITS) != 0;''',
     '''            const bool arms = (traits & %s) != 0;''' % mask("BUSTER_CHECK_REACH_ARM_TRAITS", [("BUSTER_CHECK_TRAIT_FLOATING", "an argument's floating constant isn't marked"), ("BUSTER_CHECK_TRAIT_ARMS", "an argument's conditional or comma isn't marked"),
              ("BUSTER_CHECK_TRAIT_PEELED", "an argument's << or conversion isn't marked"), ("BUSTER_CHECK_TRAIT_SELECT", "an argument's selection isn't marked")]).replace("(char)", "(uint32_t)"))
edit('''            const bool narrowing = (traits & BUSTER_CHECK_TRAIT_INTEGER) != 0 && !(source_width != 0 && target_width >= source_width);
            const bool enumeration = filter->enum_cast &&''',
     '''            const bool narrowing = !%s && (traits & BUSTER_CHECK_TRAIT_INTEGER) != 0 && !(%s ? source_width != 0 : source_width != 0 && target_width >= source_width);
            const bool enumeration = !%s && filter->enum_cast &&''' % (
         F("an argument's integer constant is never marked"), F("an argument's integer constant is unmarked whatever its target's width"),
         F("an argument's enumeration parameter isn't marked")))
edit('''    uint8_t promoted[BUSTER_TYPE_BUILTIN_COUNT];''', '''    uint8_t promoted[BUSTER_TYPE_BUILTIN_COUNT];
    uint8_t fault_promoted[BUSTER_TYPE_BUILTIN_COUNT];''')
edit('''                filter->promoted[index] = promotes ? (uint8_t)(promoted < width ? promoted : width) : 0;''',
     '''                filter->promoted[index] = promotes ? (uint8_t)(promoted < width ? promoted : width) : 0;
                filter->fault_promoted[index] = promotes ? (uint8_t)promoted : 0;''')
# The options and the listing.
edit('''            if (enabled->sign_compare)
            {''', '''            if (enabled->sign_compare && !%s)
            {''' % F("-Wsign-compare doesn't keep the comparisons"))
edit('''                filter->families[CHECK_OP_ASSIGN] = 0;
                filter->families[CHECK_OP_INITIALIZE] = 0;
                filter->families[CHECK_OP_CONVERT] = 0;
                filter->families[CHECK_OP_CALL] = 0;
                memset(filter->families + CHECK_OP_ADD_ASSIGN, 0, CHECK_OP_DIVIDE_ASSIGN - CHECK_OP_ADD_ASSIGN + 1);''',
'''                filter->families[CHECK_OP_ASSIGN] = %s ? filter->families[CHECK_OP_ASSIGN] : 0;
                filter->families[CHECK_OP_INITIALIZE] = %s ? filter->families[CHECK_OP_INITIALIZE] : 0;
                filter->families[CHECK_OP_CONVERT] = %s ? filter->families[CHECK_OP_CONVERT] : 0;
                filter->families[CHECK_OP_CALL] = %s ? filter->families[CHECK_OP_CALL] : 0;
                if (!%s)
                {
                    memset(filter->families + CHECK_OP_ADD_ASSIGN, 0, CHECK_OP_DIVIDE_ASSIGN - CHECK_OP_ADD_ASSIGN + 1);
                }''' % (F("-Wimplicit-float-conversion doesn't keep the assignments"), F("-Wimplicit-float-conversion doesn't keep the initializations"),
                        F("-Wimplicit-float-conversion doesn't keep the conversions"), F("-Wimplicit-float-conversion doesn't keep the calls"),
                        F("-Wimplicit-float-conversion doesn't keep the compound assignments")))
edit('''                         !enabled->promotion && !enabled->int_float;''', '''                         (!enabled->promotion || %s) && (!enabled->int_float || %s);''' % (
    F("the filter applies under -Wdouble-promotion"), F("the filter applies under -Wimplicit-int-float-conversion")))
edit('''        .edges = enabled->const_int_float,''', '''        .edges = enabled->const_int_float && !%s,''' % F("the conversion edges aren't asked at all"))
edit('''                const bool member = enabled->atomic_access &&''', '''                const bool member = !%s && enabled->atomic_access &&''' % F("-Watomic-access's members aren't listed"))
edit('''                const bool precision = enabled->float_precision &&''', '''                const bool precision = !%s && enabled->float_precision &&''' % F("-Wimplicit-float-conversion's operators aren't listed"))
edit('''                const bool edged = enabled->const_int_float &&''', '''                const bool edged = !%s && enabled->const_int_float &&''' % F("the conversion edges' operators aren't listed"))
# The children's pass.
edit('''            children[parent < count ? parent : count] |= bytes[lane];''', '''            children[parent < count && !%s ? parent : count] |= bytes[lane];''' % F("no node tells its parent what it is"))
edit('''                                             _mm512_maskz_set1_epi8(fields, BUSTER_CHECK_CHILD_BIT_FIELD));''',
     '''                                             _mm512_maskz_set1_epi8(%s ? 0 : fields, BUSTER_CHECK_CHILD_BIT_FIELD));''' % F("a bit-field's lvalue doesn't tell its parent"))
# The tables: an entry cleared in a copy.
ops = [("CHECK_OP_SHIFT_LEFT", "a << has no trait"), ("CHECK_OP_CONDITIONAL", "a conditional has no trait"),
       ("CHECK_OP_CAST", "a cast has no trait"), ("CHECK_OP_COMMA", "a comma has no trait"), ("CHECK_OP_CONVERT", "a conversion has no trait"),
       ("CHECK_OP_SELECT", "a selection has no trait")]
constants = [("CHECK_CONSTANT_INTEGER", "an integer constant has no trait"), ("CHECK_CONSTANT_FLOATING", "a floating constant has no trait"),
             ("CHECK_CONSTANT_ADDRESS", "an address constant has no trait")]
lines = "    uint8_t fault_operators[128];\n    uint8_t fault_constants[16];\n    memcpy(fault_operators, check_common_reach_operator_traits, sizeof(fault_operators));\n    memcpy(fault_constants, check_common_reach_constant_traits, sizeof(fault_constants));\n"
for name, text in ops:
    lines += "    if (%s)\n    {\n        fault_operators[%s] = 0;\n    }\n" % (F(text), name)
for name, text in constants:
    lines += "    if (%s)\n    {\n        fault_constants[%s] = 0;\n    }\n" % (F(text), name)
edit('''    const __m512i low = _mm512_loadu_si512(check_common_reach_operator_traits);
    const __m512i high = _mm512_loadu_si512(check_common_reach_operator_traits + 64);
    const __m512i kinds = _mm512_broadcast_i32x4(_mm_loadu_si128((const __m128i*)check_common_reach_constant_traits));''',
lines + '''    const __m512i low = _mm512_loadu_si512(fault_operators);
    const __m512i high = _mm512_loadu_si512(fault_operators + 64);
    const __m512i kinds = _mm512_broadcast_i32x4(_mm_loadu_si128((const __m128i*)fault_constants));''')
kinds = [("BUSTER_TYPE_KIND_FLOATING", "a floating type has no class"),
         ("BUSTER_TYPE_KIND_ENUM", "an enumeration has no class"), ("BUSTER_TYPE_KIND_ARRAY", "an array has no class"),
         ("BUSTER_TYPE_KIND_NULLPTR", "nullptr_t has no class"), ("BUSTER_TYPE_KIND_ALIGNED", "an aligned typedef has no class")]
lines = "    uint8_t fault_kinds[64];\n    memcpy(fault_kinds, check_common_reach_kind_classes, sizeof(fault_kinds));\n"
for name, text in kinds:
    lines += "    if (%s)\n    {\n        fault_kinds[%s] = 0;\n    }\n" % (F(text), name)
edit('''    const __m512i table = _mm512_loadu_si512(check_common_reach_kind_classes);''', lines + '''    const __m512i table = _mm512_loadu_si512(fault_kinds);''')
open(p, "w").write(s)
with open(sys.argv[2], "w") as out:
    for i, name in enumerate(faults):
        out.write("%d\t%s\n" % (i + 1, name))
print(len(faults), "faults")
