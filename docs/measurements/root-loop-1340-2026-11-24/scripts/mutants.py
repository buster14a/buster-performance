#!/usr/bin/env python3
# #1340 part 3's fault round: one term of the quiet roots' condition, or of the order's guard, broken at a time in the
# head's tree. Usage: mutants.py list | apply NAME | revert NAME (run in the tree's root).
import sys
W = 'src/buster/compiler/c_check_common_warnings.c'
U = 'src/buster/compiler/c_check_unsequenced.c'
I = 'src/buster/compiler/c_check_ignored_result.c'
M = [
    ('evaluated', W, 'const uint64_t calm = roots & evaluated & ~reached;', 'const uint64_t calm = roots & (evaluated | lanes) & ~reached;'),
    ('reach', W, 'const uint64_t calm = roots & evaluated & ~reached;', 'const uint64_t calm = roots & evaluated & ~(reached & 0);'),
    ('comma', W, 'const bool asked = check_common_ignored_op((uint8_t)op) || op == CHECK_OP_COMMA;', 'const bool asked = check_common_ignored_op((uint8_t)op);'),
    ('call', W, '(kind & BUSTER_CHECK_ROOT_OP_CALL) != 0 && !check_common_ignored_wanted(ignored, pp, parser, input, expr).wanted;', '(kind & BUSTER_CHECK_ROOT_OP_CALL) != 0;'),
    ('place', W, '(voided || !check_common_discarded_place(parser, token));', '(voided || token != BUSTER_CHECK_NONE);'),
    ('expression-reach', W, '(kind & BUSTER_CHECK_ROOT_OP_MARKER) != 0 && facts->reach[expr] == 0 &&', '(kind & BUSTER_CHECK_ROOT_OP_MARKER) != 0 &&'),
    ('void-cast', W, 'parser->tree.roles[token] == PARSE_ROLE_CLOSE_CAST && check_common_void_cast(parser, pp, input, stream, types, token);', 'parser->tree.roles[token] == PARSE_ROLE_CLOSE_CAST;'),
    ('cast-role', W, 'const bool voided = (kind & BUSTER_CHECK_ROOT_OP_CAST) != 0 && token < parser->tokens.count &&\n                                    parser->tree.roles[token] == PARSE_ROLE_CLOSE_CAST && check_common_void_cast(parser, pp, input, stream, types, token);', 'const bool voided = (kind & BUSTER_CHECK_ROOT_OP_CAST) != 0 && token < parser->tokens.count;'),
    ('marker-class', W, '(!asked && !marker ? BUSTER_CHECK_ROOT_OP_SILENT : 0u) | (!asked && marker ? BUSTER_CHECK_ROOT_OP_MARKER : 0u) |', '(!asked ? BUSTER_CHECK_ROOT_OP_SILENT : 0u) | (!asked && marker ? BUSTER_CHECK_ROOT_OP_MARKER : 0u) |'),
    ('candidates', W, 'const uint64_t quiet = calm & ((silent & ~cast) | settled) & ~candidates;', 'const uint64_t quiet = calm & ((silent & ~cast) | settled);'),
    ('candidate-bit', W, '(classes.unsequenced[node / 64] & (UINT64_C(1) << (node % 64))) != 0 && evaluated[node] != 0;', '(classes.unsequenced[node / 64] & (UINT64_C(1) << (node % 64))) != 0 && evaluated[node] != 0 && node == 0;'),
    ('sole-inner', W, 'const uint64_t sole = tree ? (modification & ~inner) | wrapping : 0;', 'const uint64_t sole = tree ? (modification & ~(inner & 0)) | wrapping : 0;'),
    ('wrapper-inner', W, ' && (marks[operand] & BUSTER_CHECK_UNSEQ_INNER) == 0 ? bit : 0;', ' ? bit : 0;'),
    ('wrapper-modification', W, 'wrapping |= single && check_unseq_modification(graph->ops[operand]) &&', 'wrapping |= single &&'),
    ('limit-unsequenced', W, 'order.limit = pending_unsequenced < order.limit ? pending_unsequenced : order.limit;', 'order.limit = order.limit + (pending_unsequenced & 0);'),
    ('limit-integer', W, 'order.limit = next_init < next_integer ? next_init : next_integer;', 'order.limit = next_init;'),
    ('limit-initializer', W, 'order.limit = next_init < next_integer ? next_init : next_integer;', 'order.limit = next_integer;'),
    ('order-limit', W, 'while (result < graph->count && order->loud != NULL && result < order->limit && (order->loud', 'while (result < graph->count && order->loud != NULL && (order->loud'),
    ('list-limit', W, 'const uint32_t kept = loud != NULL ? (uint32_t)(loud[first >> 6] >> (first & 63)) | ~below : UINT32_MAX;', 'const uint32_t kept = loud != NULL ? (uint32_t)(loud[first >> 6] >> (first & 63)) | (~below & 0) : UINT32_MAX;'),
    ('loud-bit', W, 'loud[first >> 6] = roots & ~quiet;', 'loud[first >> 6] = roots & ~quiet & ~(roots & (0 - roots));'),
    ('inner-mark', U, 'marks[up] |= BUSTER_CHECK_UNSEQ_INNER;', 'marks[up] |= 0;'),
    ('repeats-range', U, 'check_unseq_wrapper(graph->ops[top]) && graph->operand0[top] < top &&\n                             graph->operand1[top] >= graph->count && graph->operand2[top] >= graph->count; steps += 1)', 'graph->operand0[top] < top; steps += 1)'),
    ('repeats-body', U, 'const uint32_t end = !repeats ? top + 1 : 0;', 'const uint32_t end = !repeats ? top : 0;'),
    ('named', I, 'named[name / 64] |= UINT64_C(1) << (name % 64);', 'named[name / 64] |= 0;'),
    ('builtin-table', I, 'const bool wanted = ignored != NULL && (builtin || named || (table & (BUSTER_CHECK_IGNORED_CONST | BUSTER_CHECK_IGNORED_PURE)) != 0 ||', 'const bool wanted = ignored != NULL && (builtin || named ||'),
]
def main():
    if sys.argv[1] == 'list':
        print(' '.join(m[0] for m in M)); return
    name = sys.argv[2]
    for n, f, old, new in M:
        if n == name:
            s = open(f).read()
            a, b = (old, new) if sys.argv[1] == 'apply' else (new, old)
            if sys.argv[1] == 'apply':
                assert s.count(a) >= 1, (n, s.count(a))
                s = s.replace(a, b)
            else:
                raise SystemExit('revert with git checkout')
            open(f, 'w').write(s); return
    raise SystemExit('no such mutant')
main()
