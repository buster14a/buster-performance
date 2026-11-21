# The test's hand-worked suffix cases and random trials under the reference, block and flat rules (#3044).
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from rules_lib import run

def entries(inputs):
    # inputs: list of (bytes, group, alignment_log2, unit_log2)
    ents = []
    for data, g, al, ul in inputs:
        es = 1 << ul
        begin = 0
        for at in range(0, len(data), es):
            if data[at:at + es] == b'\0' * es:
                a = 1 << al
                while begin % a:
                    a //= 2
                ents.append((g, es, a, data[begin:at + es]))
                begin = at + es
    return ents

def compare(name, inputs):
    ents = entries(inputs)
    r = {rule: run(ents, rule) for rule in ('reference', 'block', 'flat')}
    line = '%s: reference size %d %s' % (name, r['reference'][0], r['reference'][1])
    for rule in ('block', 'flat'):
        same = r[rule][0] == r['reference'][0] and r[rule][1] == r['reference'][1]
        line += ' | %s %s' % (rule, 'same' if same else 'size %d %s' % (r[rule][0], r[rule][1]))
    print(line)
    return r

both = b'compiler\0piler\0'
compiler = b'compiler\0'; piler = b'piler\0'; xpiler = b'xpiler\0'
compare('1000', [(both, 1, 0, 0)])
compare('1001', [(compiler, 1, 0, 0), (piler, 2, 0, 0)])
compare('1002', [(bytes([ord('a'), 0, ord('b'), 0, 0, 0]), 3, 1, 1), (bytes([ord('b'), 0, 0, 0]), 3, 1, 1), (b'\0', 3, 0, 0), (compiler, 3, 0, 0), (b'\0', 3, 0, 0)])
compare('1003', [(both[:9], 4, 0, 0), (piler, 4, 1, 0)])
compare('1004', [(both[:9], 5, 0, 0), (xpiler, 5, 0, 0), (piler, 5, 1, 0), (piler, 5, 0, 0)])
compare('1005', [(b'piler\0compiler\0piler\0', 6, 0, 0)])
compare('1006', [(b'compiler\0piler\0piler\0', 7, 0, 0), (piler, 7, 1, 0), (piler, 7, 0, 0)])
compare('1007', [(b'compiler\0\0', 0, 0, 0)])
compare('1008', [(b'aa\0ab\0ac\0ad\0ae\0af\0ag\0ah\0ai\0aj\0ak\0', 8, 0, 0), (b'\0', 8, 5, 0)])
# examples case 1 (groups, alignment, padding, last-group suffix)
first = bytes([97, 98, 0, 120, 0, 0, 97, 98, 0]); second = bytes([97, 98, 0, 120, 0, 0]); z = b'z\0'; suffix = b'foobar\0bar\0'
compare('examples-1', [(first, 1, 3, 0), (second, 1, 4, 0), (second, 2, 0, 0), (z, 3, 0, 0), (z, 3, 4, 0), (z, 3, 3, 0), (suffix, 0xffffffff, 0, 0), (b'', 0, 31, 0)])

M = (1 << 64) - 1
class Rng:
    def __init__(self, s): self.s = s
    def next(self):
        s = self.s
        s ^= (s << 13) & M; s ^= s >> 7; s ^= (s << 17) & M
        self.s = s
        return s

def trials(seed):
    rng = Rng(seed if seed else 0x3141592653589793)
    dictionary = []
    for word in range(32):
        length = 1 if word == 0 else 1 + (word * 13) % 96
        w = bytes((ord('q') if b < 12 else 1 + (word * 17 + b * 7) % 255) for b in range(length - 1)) + b'\0'
        dictionary.append(w)
    changed = {'block': 0, 'flat': 0}; sizes = {'block': 0, 'flat': 0}; total = 0; refsize = 0
    def tally(inputs):
        nonlocal total, refsize
        ents = entries(inputs)
        ref = run(ents, 'reference')
        total += 1; refsize += ref[0]
        for rule in ('block', 'flat'):
            r = run(ents, rule)
            changed[rule] += (r[0], r[1]) != (ref[0], ref[1])
            sizes[rule] += r[0]
    for trial in range(192):
        count = rng.next() % 18
        inputs = []
        for section in range(count):
            words = rng.next() % 11
            data = b''
            for _ in range(words):
                data += dictionary[rng.next() % 32]
            g = rng.next() % 5; al = rng.next() % 7
            inputs.append((data, g, al, 0))
        tally(inputs)
    print('mixed trials: %d, changed block %d flat %d; pool bytes reference %d block %d flat %d' % (total, changed['block'], changed['flat'], refsize, sizes['block'], sizes['flat']))
    bases = []
    for base in range(3):
        bases.append(bytes((ord('a') if rng.next() & 1 else ord('b')) for _ in range(23)) + b'\0')
    changed = {'block': 0, 'flat': 0}; sizes = {'block': 0, 'flat': 0}; total = 0; refsize = 0
    for trial in range(128):
        count = rng.next() % 9
        inputs = []
        for section in range(count):
            words = rng.next() % 13
            data = b''
            for _ in range(words):
                b = rng.next() % 3; start = rng.next() % 24
                data += bases[b][start:]
            g = rng.next() % 3; al = rng.next() % 4
            inputs.append((data, g, al, 0))
        tally(inputs)
    print('suffix-chain trials: %d, changed block %d flat %d; pool bytes reference %d block %d flat %d' % (total, changed['block'], changed['flat'], refsize, sizes['block'], sizes['flat']))

trials(1)
