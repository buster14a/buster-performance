#!/usr/bin/env python3
# views-edit.py TREE: an experiment on C on the window's loop (not for a pull request as it stands): what a record is
# as an operand becomes two "view" bytes a record, made once a block where the block is the block before; a step
# gathers two of them for its first operands and one for its second, where it gathered six and four of the records'
# raw bytes, and each of the operands' masks is one test of a view's bit. The consumer's code's gather goes (`&x` is
# its class's), and the columns' pointers are read once.
import sys
p = sys.argv[1] + '/src/buster/compiler/c_check_node_machine_window.c'
t = open(p).read()
def rep(old, new, count=1):
    global t
    assert t.count(old) == count, (t.count(old), old[:90])
    t = t.replace(old, new)
def take(start):
    global t
    lines = t.split('\n')
    found = [i for i, line in enumerate(lines) if line.strip().startswith(start)]
    assert len(found) == 1, (len(found), start)
    lines.pop(found[0])
    t = '\n'.join(lines)
rep("""static void node_contexts_tables(NodeContextsTables* tables)
{
    memset(tables, 0, sizeof(*tables));
""", """// EXPERIMENT (views). A record as an operand, two bytes: its type's aggregate's, pointer's and atomic facts at their
// own bits, the pointer's bit for an array's or a function's kind too, a number's class, and of its standing an integer
// constant, any constant, and an lvalue whose constant is an address; and its operator's (not a name's leaf; a `!`; an
// `&&` or an `||`) with its flags' object's, symbol's and register's bits at their own.
#define BUSTER_NODE_CONTEXTS_VIEW_AGGREGATE 0x01u
#define BUSTER_NODE_CONTEXTS_VIEW_SCALAR 0x02u
#define BUSTER_NODE_CONTEXTS_VIEW_INTEGER 0x04u
#define BUSTER_NODE_CONTEXTS_VIEW_POINTER 0x08u
#define BUSTER_NODE_CONTEXTS_VIEW_CONSTANT 0x10u
#define BUSTER_NODE_CONTEXTS_VIEW_PLACED_LVALUE 0x20u
#define BUSTER_NODE_CONTEXTS_VIEW_ATOMIC 0x40u
#define BUSTER_NODE_CONTEXTS_VIEW2_OPERATOR 0x01u
#define BUSTER_NODE_CONTEXTS_VIEW2_NOT 0x02u
#define BUSTER_NODE_CONTEXTS_VIEW2_OBJECT 0x04u
#define BUSTER_NODE_CONTEXTS_VIEW2_SYMBOL 0x08u
#define BUSTER_NODE_CONTEXTS_VIEW2_LOGICAL 0x10u
#define BUSTER_NODE_CONTEXTS_VIEW2_REGISTER 0x80u
_Static_assert(BUSTER_NODE_CONTEXTS_VIEW_AGGREGATE == BUSTER_CHECK_LOWER_TYPE_AGGREGATE && BUSTER_NODE_CONTEXTS_VIEW_POINTER == BUSTER_CHECK_LOWER_TYPE_POINTER &&
               BUSTER_NODE_CONTEXTS_VIEW_ATOMIC == BUSTER_CHECK_LOWER_TYPE_ATOMIC && BUSTER_NODE_CONTEXTS_VIEW2_OBJECT == BUSTER_NODE_CONTEXTS_OBJECT &&
               BUSTER_NODE_CONTEXTS_VIEW2_SYMBOL == BUSTER_NODE_CONTEXTS_SYMBOL && BUSTER_NODE_CONTEXTS_VIEW2_REGISTER == BUSTER_NODE_CONTEXTS_REGISTER,
               "a view's bits of a type's facts and of the flags are at the facts' and the flags' own");
typedef struct NodeViewsX NodeViewsX;
struct NodeViewsX
{
    _Alignas(64) uint8_t kinds[64];
    _Alignas(64) uint8_t classes[64];
    _Alignas(64) uint8_t standings[64];
    _Alignas(64) uint8_t operators[64];
};
static NodeViewsX node_views_x;

static void node_views_x_tables(void)
{
    for (uint32_t i = 0; i < 64; i += 1)
    {
        const uint32_t constant = (i >> 2) & 7;
        const uint32_t kind = i & BUSTER_NODE_CONTEXTS_CLASS_KIND;
        node_views_x.kinds[i] = i >= BUSTER_TYPE_KIND_ARRAY && i <= BUSTER_TYPE_KIND_FUNCTION ? BUSTER_NODE_CONTEXTS_VIEW_POINTER : 0;
        node_views_x.classes[i] = i >= BUSTER_TYPED_CLASS_I8 && i <= BUSTER_TYPED_CLASS_F64 ? BUSTER_NODE_CONTEXTS_VIEW_SCALAR : 0;
        node_views_x.standings[i] = (uint8_t)((constant == CHECK_CONSTANT_INTEGER ? BUSTER_NODE_CONTEXTS_VIEW_INTEGER : 0) | (constant != 0 ? BUSTER_NODE_CONTEXTS_VIEW_CONSTANT : 0) |
                                              ((i & 0x1f) == ((CHECK_CONSTANT_ADDRESS << 2) | CHECK_LVALUE) ? BUSTER_NODE_CONTEXTS_VIEW_PLACED_LVALUE : 0));
        node_views_x.operators[i] = (uint8_t)((kind != BUSTER_NODE_CONTEXTS_CLASS_VALUE ? BUSTER_NODE_CONTEXTS_VIEW2_OPERATOR : 0) | (i == BUSTER_NODE_CONTEXTS_CLASS_TRUTH ? BUSTER_NODE_CONTEXTS_VIEW2_NOT : 0) |
                                              (kind == BUSTER_NODE_CONTEXTS_CLASS_LOGICAL ? BUSTER_NODE_CONTEXTS_VIEW2_LOGICAL : 0));
    }
}

// The views of 64 records, from their operators' classes and their five bytes.
static inline __attribute__((always_inline)) void node_window_views(__m512i operators, __m512i type_classes, __m512i facts, __m512i kinds, __m512i standings, __m512i flags, __m512i* one,
                                                                  __m512i* two)
{
    const __m512i by_kind = _mm512_permutexvar_epi8(kinds, _mm512_load_si512(node_views_x.kinds));
    const __m512i by_class = _mm512_permutexvar_epi8(type_classes, _mm512_load_si512(node_views_x.classes));
    const __m512i by_standing = _mm512_permutexvar_epi8(standings, _mm512_load_si512(node_views_x.standings));
    const __m512i by_operator = _mm512_permutexvar_epi8(operators, _mm512_load_si512(node_views_x.operators));
    const __m512i typed = _mm512_ternarylogic_epi64(facts, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_AGGREGATE | BUSTER_NODE_CONTEXTS_VIEW_POINTER | BUSTER_NODE_CONTEXTS_VIEW_ATOMIC), by_kind, 0xEA);
    *one = _mm512_ternarylogic_epi64(typed, by_class, by_standing, 0xFE);
    *two = _mm512_ternarylogic_epi64(flags, _mm512_set1_epi8((char)(BUSTER_NODE_CONTEXTS_VIEW2_OBJECT | BUSTER_NODE_CONTEXTS_VIEW2_SYMBOL | BUSTER_NODE_CONTEXTS_VIEW2_REGISTER)), by_operator, 0xEA);
}

static void node_contexts_tables(NodeContextsTables* tables)
{
    memset(tables, 0, sizeof(*tables));
    node_views_x_tables();
""")
start = t.index("    const uint32_t blocks = (count + 63) / 64;\n")
end_marker = "                                                                             _mm512_set1_epi8(CHECK_CONSTANT_INTEGER << 2));\n"
end = t.index(end_marker) + len(end_marker)
old_block = t[start:end]
# The far lanes' two loops stay as they are: take them from the old text.
far_start = old_block.index("            for (uint64_t pending = far_up; pending != 0; pending &= pending - 1)\n")
far_end = old_block.index("            consumer_classes = _mm512_mask_loadu_epi8(consumer_classes, far_up, far_bytes[BUSTER_NODE_CONTEXTS_FAR_CONSUMER_CLASS]);\n")
far_loops = old_block[far_start:far_end]
new_block = """    const uint32_t blocks = (count + 63) / 64;
    // The columns' pointers, read once: a store through a byte's pointer may be to any of them for all the compiler
    // knows, and it read them again each step.
    const uint8_t* const column_classes = state->window_c_classes;
    const uint8_t* const column_facts = state->window_c_facts;
    const uint8_t* const column_kinds = state->window_c_kinds;
    const uint8_t* const column_standings = state->window_c_standings;
    const uint8_t* const column_flags = state->window_c_flags;
    uint8_t* const column_templates = state->window_c_templates;
    uint8_t* const column_contexts = state->window_c_contexts;
    uint8_t* const column_sources = state->window_c_sources;
    uint8_t* const column_reasons = state->window_c_reasons;
    uint64_t* const column_masks = state->window_c_masks;
    const __m512i low_seven = _mm512_set1_epi8(0x7f);
    // The last block's operators' classes and its views, which the first step reads as its own: a block's are made
    // where it is the block before.
    __m512i classes = zero;
    __m512i own_one = zero;
    __m512i own_two = zero;
    if (blocks != 0)
    {
        const uint32_t last = (blocks - 1) * 64;
        classes = node_window_table(tables->classes, _mm512_and_si512(_mm512_loadu_si512(front->ops + last), low_seven));
        node_window_views(classes, _mm512_loadu_si512(column_classes + last), _mm512_loadu_si512(column_facts + last), _mm512_loadu_si512(column_kinds + last),
                          _mm512_loadu_si512(column_standings + last), _mm512_loadu_si512(column_flags + last), &own_one, &own_two);
    }
    for (uint32_t block = blocks; block != 0; block -= 1)
    {
        const uint32_t x = (block - 1) * 64;
        // The block before's bytes, read with this block's: an operand's are in either. The first block has none
        // before it and reads itself there, which no lane's operand's place names.
        const uint32_t back = x != 0 ? x - 64 : 0;
        const __m512i type_classes = _mm512_loadu_si512(column_classes + x);
        const __m512i facts = _mm512_loadu_si512(column_facts + x);
        const __m512i kinds = _mm512_loadu_si512(column_kinds + x);
        const __m512i standings = _mm512_loadu_si512(column_standings + x);
        const __m512i flags = _mm512_loadu_si512(column_flags + x);
        // Its consumer's operator's class, through its distance forward, and its operands' views, through their
        // distances back.
        __mmask64 near_up = 0;
        __mmask64 far_up = 0;
        const __m512i at_up = node_window_consumers(front->window_ups + x, front->ups + x, &near_up, &far_up);
        __m512i consumer_classes = _mm512_maskz_permutex2var_epi8(near_up, classes, at_up, next_classes);
        // `&x`'s operand is its record's neighbour: its consumer's class is in reach, and is read before a far
        // consumer's.
        const __mmask64 addressed = _mm512_cmpeq_epi8_mask(_mm512_and_si512(consumer_classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_KIND)),
                                                           _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_ADDRESS));
        __mmask64 near_left = 0;
        __mmask64 far_left = 0;
        __mmask64 near_right = 0;
        __mmask64 far_right = 0;
        const __m512i at_left = node_window_reach(front->window_left + x, &near_left, &far_left);
        const __m512i at_right = node_window_reach(front->window_right + x, &near_right, &far_right);
        // The far lanes of the records the kernel placed alone: another record's distances may be of records that are
        // not here (a waiting value a chunk's end kept without its row), and its answers are read by no one. A second
        // operand before the block before is a conditional's alone, whose third operand's records lie between: every
        // operator with a case here has its last operand's record right before its own. It reads as no operand.
        const __mmask64 placed = _mm512_test_epi8_mask(flags, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_PLACED));
        far_up &= placed;
        far_left &= placed;
        const __m512i previous_operators = node_window_table(tables->classes, _mm512_and_si512(_mm512_loadu_si512(front->ops + back), low_seven));
        __m512i previous_one = zero;
        __m512i previous_two = zero;
        node_window_views(previous_operators, _mm512_loadu_si512(column_classes + back), _mm512_loadu_si512(column_facts + back), _mm512_loadu_si512(column_kinds + back),
                          _mm512_loadu_si512(column_standings + back), _mm512_loadu_si512(column_flags + back), &previous_one, &previous_two);
        __m512i left_one = node_window_operands(at_left, near_left, previous_one, own_one);
        __m512i left_two = node_window_operands(at_left, near_left, previous_two, own_two);
        const __m512i right_one = node_window_operands(at_right, near_right, previous_one, own_one);
        // A consumer past the block after (its template is its own block's step's, stored), an operand before the
        // block before: their bytes by loads, a record at a time, into the frame's block, and a far operand's views
        // from them. A control's root far from its condition is most.
        if (__builtin_expect((far_up | far_left) != 0, 0))
        {
""" + far_loops + """            consumer_classes = _mm512_mask_loadu_epi8(consumer_classes, far_up, far_bytes[BUSTER_NODE_CONTEXTS_FAR_CONSUMER_CLASS]);
            __m512i far_one = zero;
            __m512i far_two = zero;
            node_window_views(node_window_table(tables->classes, _mm512_load_si512(far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CODE])), _mm512_load_si512(far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CLASS]),
                              _mm512_load_si512(far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FACTS]), _mm512_load_si512(far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_KIND]),
                              _mm512_load_si512(far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_STANDING]), _mm512_load_si512(far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FLAGS]), &far_one, &far_two);
            left_one = _mm512_mask_mov_epi8(left_one, far_left, far_one);
            left_two = _mm512_mask_mov_epi8(left_two, far_left, far_two);
            far_count += (uint64_t)_mm_popcnt_u64(far_up) + (uint64_t)_mm_popcnt_u64(far_left);
            near_left |= far_left;
        }
        // What its consumer says of it: its place among the consumer's operands, and whether the consumer takes that
        // operand for its address.
        const __m512i places = _mm512_min_epu8(_mm512_loadu_si512(front->places + x), _mm512_set1_epi8(1));
        const __mmask64 first_place = _mm512_testn_epi8_mask(places, places);
        const __mmask64 address = first_place & _mm512_test_epi8_mask(consumer_classes, _mm512_set1_epi8((char)BUSTER_NODE_CONTEXTS_CLASS_PLACE));
        const __m512i consumer_kinds = _mm512_and_si512(consumer_classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_KIND));
        const __mmask64 consumer_logical = _mm512_cmpeq_epi8_mask(consumer_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_LOGICAL));
        const __mmask64 consumer_truth = _mm512_cmpeq_epi8_mask(consumer_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_TRUTH));
        const __mmask64 callee = first_place & _mm512_cmpeq_epi8_mask(consumer_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_CALL));
        // Its operands, as bits of their views. A record with no operand reads a view of zeros: no pointer, no scalar,
        // tested, a name's leaf with no object, no constant.
        const __mmask64 left_pointer = _mm512_test_epi8_mask(left_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_POINTER));
        const __mmask64 right_pointer = _mm512_test_epi8_mask(right_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_POINTER));
        const __mmask64 left_atomic = _mm512_test_epi8_mask(left_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_ATOMIC));
        const __m512i scalars = _mm512_set1_epi8(BUSTER_TYPED_CLASS_F64 - BUSTER_TYPED_CLASS_I8);
        const __m512i i8 = _mm512_set1_epi8(BUSTER_TYPED_CLASS_I8);
        const __mmask64 left_scalar = _mm512_test_epi8_mask(left_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_SCALAR));
        const __mmask64 right_scalar = _mm512_test_epi8_mask(right_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_SCALAR));
        const __mmask64 left_tested = _mm512_testn_epi8_mask(left_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_AGGREGATE));
        const __mmask64 right_tested = _mm512_testn_epi8_mask(right_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_AGGREGATE));
        const __mmask64 left_named = _mm512_testn_epi8_mask(left_two, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW2_OPERATOR));
        const __mmask64 left_object = _mm512_test_epi8_mask(left_two, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW2_OBJECT));
        const __mmask64 named = near_left & left_named & left_object;
        const __mmask64 named_global = _mm512_test_epi8_mask(left_two, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW2_SYMBOL));
        const __mmask64 left_register = _mm512_test_epi8_mask(left_two, _mm512_set1_epi8((char)BUSTER_NODE_CONTEXTS_VIEW2_REGISTER));
        const __mmask64 left_logical = _mm512_test_epi8_mask(left_two, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW2_LOGICAL));
        const __mmask64 left_not = _mm512_test_epi8_mask(left_two, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW2_NOT));
        const __mmask64 left_variable = _mm512_testn_epi8_mask(left_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_CONSTANT));
        const __mmask64 left_placed = _mm512_test_epi8_mask(left_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_PLACED_LVALUE));
        const __mmask64 right_constant = _mm512_test_epi8_mask(right_one, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_VIEW_INTEGER));
"""
t = t[:start] + new_block + t[end:]
for line in ("const __m512i consumer_kinds = ", "const __mmask64 consumer_logical = ", "const __mmask64 consumer_truth = ", "const __mmask64 callee = ",
             "const __mmask64 left_logical = ", "const __mmask64 left_not = ", "const __mmask64 left_variable = ", "const __mmask64 left_placed = ", "const __mmask64 left_object = ",
             "const __mmask64 left_register = ", "const __mmask64 left_named = "):
    # Each is now twice: the new block's and the old one further down; drop the later.
    lines = t.split('\n')
    found = [i for i, text in enumerate(lines) if text.strip().startswith(line)]
    assert len(found) == 2, (len(found), line)
    lines.pop(found[1])
    t = '\n'.join(lines)
rep("    __m512i next_codes = zero;\n", "")
rep("        next_codes = codes;\n        next_classes = classes;\n        next_keys = keys;\n", "        next_classes = classes;\n        next_keys = keys;\n        classes = previous_operators;\n        own_one = previous_one;\n        own_two = previous_two;\n")
rep("        _mm512_storeu_si512(state->window_c_contexts + x, ", "        _mm512_storeu_si512(column_contexts + x, ")
rep("        _mm512_storeu_si512(state->window_c_reasons + x, class_kinds);", "        _mm512_storeu_si512(column_reasons + x, class_kinds);")
rep("        _mm512_storeu_si512(state->window_c_templates + x, templates);", "        _mm512_storeu_si512(column_templates + x, templates);")
rep("        _mm512_storeu_si512(state->window_c_sources + x, sources);", "        _mm512_storeu_si512(column_sources + x, sources);")
rep("        uint64_t* masks = state->window_c_masks + BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(block - 1);", "        uint64_t* masks = column_masks + BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(block - 1);")
open(p, 'w').write(t)
