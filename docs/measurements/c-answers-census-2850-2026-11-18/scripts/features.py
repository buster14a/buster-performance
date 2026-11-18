#!/usr/bin/env python3
# features.py: the census's columns (parse.py's) as the fields a rule may read, each a small integer a record.
# - WINDOW: bytes of the window as it stands: a record's operator and its line (its type's word's class, facts and kind,
#   its standing, its flags' bits, whether its payload is zero), the same of its operands, of its consumer, of its
#   consumer's other operand and first operand, and which operand of its consumer it is.
# - CONVERTED: the class and facts of the types T converted the consumer's operand to (the consumer's line has the types,
#   not their words) and of the record's own operands' conversions.
# - DOWN: C's answers for the consumer, which a round from the root down has when it reaches the record, and the record's
#   own context where its template is asked.
# - OUTSIDE: what is no byte of the window: an object's storage and declaration bits, a constant's truth, a member's
#   offset, whether a callee is called directly, an update's plan.
import numpy

CORPORA = ('sqlite', 'lua', 'musl', 'main')
OPS = ('VALUE', 'POSITIVE', 'NEGATIVE', 'NOT', 'BIT_NOT', 'ADD', 'SUBTRACT', 'MULTIPLY', 'DIVIDE', 'REMAINDER', 'SHIFT_LEFT', 'SHIFT_RIGHT', 'LESS', 'LESS_EQUAL', 'GREATER',
       'GREATER_EQUAL', 'EQUAL', 'NOT_EQUAL', 'BIT_AND', 'BIT_OR', 'BIT_XOR', 'LOGICAL_AND', 'LOGICAL_OR', 'CONDITIONAL', 'CAST', 'ADDRESS', 'DEREFERENCE', 'ASSIGN', 'COMMA',
       'SUBSCRIPT', 'SIZEOF', 'ALIGNOF', 'MEMBER', 'ARROW', 'CALL', 'INITIALIZE', 'CONVERT', 'CONDITION', 'PRE_INCREMENT', 'PRE_DECREMENT', 'POST_INCREMENT', 'POST_DECREMENT',
       'ADD_ASSIGN', 'SUBTRACT_ASSIGN', 'MULTIPLY_ASSIGN', 'DIVIDE_ASSIGN', 'REMAINDER_ASSIGN', 'SHIFT_LEFT_ASSIGN', 'SHIFT_RIGHT_ASSIGN', 'BIT_AND_ASSIGN', 'BIT_OR_ASSIGN',
       'BIT_XOR_ASSIGN', 'SELECT')
TEMPLATES = ('NONE', 'CONSTANT', 'VOID', 'ADDRESS', 'LOCAL', 'GLOBAL', 'PASS', 'DEREFERENCE', 'MEMBER', 'UNARY', 'TRUTH', 'BINARY', 'POINTER', 'STORE_LOCAL', 'STORE_GLOBAL', 'STORE',
             'BRANCH', 'DECIDED', 'SECOND', 'CALL', 'UPDATE', 'BRANCHES')


def op_name(op):
    return 'root' if op == 255 else OPS[op] if op < len(OPS) else 'op%d' % op


def template_name(t):
    return TEMPLATES[t] if t < len(TEMPLATES) else 'tpl%d' % t


def word(prefix, w, out):
    out[prefix + 'class'] = w & 0xff
    out[prefix + 'facts'] = (w >> 8) & 0xff
    out[prefix + 'kind'] = (w >> 16) & 0xff


def standing(prefix, st, ex, fl, out):
    out[prefix + 'category'] = st & 3
    out[prefix + 'constant'] = (st >> 2) & 7
    if ex is not None:
        # A payload that is no floating value's: 0 none, 1 zero, 2 another value (NodeFactsRecord.exponent).
        out[prefix + 'zero'] = numpy.where(ex == 0, 0, numpy.where(ex == 1, 1, 2))
    if fl is not None:
        out[prefix + 'bitfield'] = (fl >> 2) & 1
        out[prefix + 'effects'] = ((fl >> 4) | (fl >> 11)) & 1
        out[prefix + 'static'] = (fl >> 7) & 1
        out[prefix + 'vector'] = (fl >> 12) & 1


def load(corpus, directory='columns'):
    raw = dict(numpy.load('%s/%s.npz' % (directory, corpus)))
    f = {}
    f['op'] = raw['op']
    word('', raw['w'], f)
    standing('', raw['st'], raw['ex'], raw['fl'], f)
    f['wide'] = (raw['st'] >> 7) & 1
    f['register'] = (raw['fl'] >> 3) & 1
    f['null'] = (raw['fl'] >> 6) & 1
    f['lop'] = raw['lop']
    word('l', raw['lw'], f)
    standing('l', raw['lst'], raw['lex'], raw['lfl'], f)
    f['rop'] = raw['rop']
    word('r', raw['rw'], f)
    standing('r', raw['rst'], raw['rex'], raw['rfl'], f)
    f['top'] = raw['top']
    standing('t', raw['tst'], None, None, f)
    f['slot'] = raw['slot']
    f['cop'] = raw['cop']
    word('c', raw['cw'], f)
    standing('c', raw['cst'], None, raw['cfl'], f)
    f['sop'] = raw['sop']
    word('s', raw['sw'], f)
    standing('s', raw['sst'], raw['sex'], raw['sfl'], f)
    f['caop'] = raw['caop']
    standing('ca', raw['cast'], raw['caex'], raw['cafl'], f)
    window = sorted(f)
    # T's conversions' types' words.
    word('cc', raw['cc'], f)
    f['ccflags'] = raw['ccf'] & 0xfff
    word('c0', raw['c0'], f)
    word('c1', raw['c1'], f)
    f['tounion'] = (raw['cf0'] >> 10) & 1
    converted = sorted(set(f) - set(window))
    # C's answers for the consumer, and the record's own from its consumer.
    f['ctpl'] = raw['ctpl']
    f['caddress'] = raw['cctx'] & 1
    f['cdiscard'] = (raw['cctx'] >> 2) & 1
    f['croot_true'] = (raw['cctx'] >> 7) & 1
    f['cbranched'] = (raw['cstate'] >> 6) & 1
    f['csense'] = (raw['cstate'] >> 5) & 1
    word('ct', raw['ctw'], f)
    f['ctnone'] = (raw['ctw'] == 0).astype(numpy.int64)
    down = sorted(set(f) - set(window) - set(converted))
    # What is no byte of the window.
    f['object'] = raw['ob']
    f['lobject'] = raw['lob']
    f['root_object'] = raw['ro']
    f['truth'] = raw['tr']
    f['member_odd'] = raw['mo']
    f['direct'] = raw['dc']
    f['plan'] = raw['up']
    outside = sorted(set(f) - set(window) - set(converted) - set(down))
    # C's answers for the record.
    a = {}
    a['evaluated'] = raw['state'] & 1
    a['address'] = raw['ctx'] & 1
    a['discard'] = (raw['ctx'] >> 2) & 1
    a['context'] = raw['ctx']
    a['target'] = raw['tw'] & 0xffff
    a['target_word'] = raw['tw']
    a['selector'] = raw['ts']
    a['same'] = raw['same']
    a['template'] = raw['tpl']
    a['state'] = raw['state'] & 0x7e
    a['depth'] = raw['depth']
    a['hook'] = raw['hk']
    root = raw['slot'] == 9
    # A record whose consumer C reached and gave a template that isn't a refusal's, or a root: one C answers for.
    answered = root | (((raw['cstate'] & 1) != 0) & (raw['ctpl'] != 254) & (raw['ctpl'] != 255) & (raw['ctpl'] != 0))
    # An evaluated record whose own template C made.
    made = ((raw['state'] & 1) != 0) & (raw['tpl'] != 254) & (raw['tpl'] != 255) & answered
    return {'raw': raw, 'f': f, 'a': a, 'root': root, 'answered': answered, 'made': made, 'window': window, 'converted': converted, 'down': down, 'outside': outside,
            'count': len(raw['op'])}
