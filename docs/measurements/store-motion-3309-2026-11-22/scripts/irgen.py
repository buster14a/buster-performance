# A small assembler for the IR's text form: instructions named by Python objects, numbered when printed.
class V:
    def __init__(self): self.n = None
class F:
    def __init__(self, params, result):
        self.params = params; self.result = result; self.blocks = []; self.slots = []; self.cur = None
    def slot(self, size, align, type_, flags=0):
        self.slots.append((size, align, type_, flags)); return len(self.slots) - 1
    def block(self):
        b = {'ins': [], 'n': len(self.blocks)}; self.blocks.append(b); return b
    def at(self, b): self.cur = b
    def emit(self, text, *ops):
        v = V(); self.cur['ins'].append((v, text, ops)); return v
    # helpers
    def param(self, k): return self.emit('param.%s %d' % (self.params[k], k))
    def const(self, type_, value):
        width = {'i1': 1, 'i8': 8, 'i16': 16, 'i32': 32, 'i64': 64, 'f32': 32, 'f64': 64}[type_]
        return self.emit('const.%s 0x%032x' % (type_, value & ((1 << width) - 1)))
    def sym(self, s): return self.emit('symbol_addr.ptr @%d' % s)
    def stack(self, s): return self.emit('stack_addr.ptr $%d' % s)
    def load(self, type_, a, align=8, flags=''): return self.emit('load.%s {} align=%d%s' % (type_, align, (' ' + flags) if flags else ''), a)
    def store(self, a, v, align=8, flags=''): return self.emit('store.void {}, {} align=%d%s' % (align, (' ' + flags) if flags else ''), a, v)
    def bin(self, op, type_, a, b): return self.emit('%s.%s {}, {}' % (op, type_), a, b)
    def un(self, op, type_, a): return self.emit('%s.%s {}' % (op, type_), a)
    def icmp(self, a, b, pred): return self.emit('icmp.i1 {}, {} %s' % pred, a, b)
    def br(self, b): return self.emit('br.void {}', b)
    def cbr(self, c, t, e): return self.emit('cbr.void {}, {}, {}', c, t, e)
    def ret(self, v=None): return self.emit('ret.void {}', v) if v is not None else self.emit('ret.void')
    def phi(self, type_, *pairs):
        return self.emit('phi.%s ' % type_ + ', '.join('[{}, {}]' for _ in pairs), *[x for p in pairs for x in p])
    def set_phi(self, v, type_, *pairs):
        for b in self.blocks:
            for k, (vv, text, ops) in enumerate(b['ins']):
                if vv is v:
                    b['ins'][k] = (vv, 'phi.%s ' % type_ + ', '.join('[{}, {}]' for _ in pairs), tuple(x for p in pairs for x in p))
    def address(self, base, index=None, scale=1, offset=0):
        if index is None: return self.emit('address.ptr {} offset=%d' % offset, base)
        return self.emit('address.ptr {} + {} * %d offset=%d' % (scale, offset), base, index)
    def text(self):
        n = 0
        for b in self.blocks:
            for (v, t, ops) in b['ins']:
                v.n = n; n += 1
        out = ['function (%s) -> %s {' % (', '.join(self.params), self.result)]
        for k, (size, align, type_, flags) in enumerate(self.slots):
            out.append('  slot $%d size=%d align=%d type=%s flags=0x%02x' % (k, size, align, type_, flags))
        for b in self.blocks:
            out.append('b%d:' % b['n'])
            for (v, t, ops) in b['ins']:
                refs = ['%%%d' % o.n if isinstance(o, V) else 'b%d' % o['n'] for o in ops]
                out.append('  %%%d = %s' % (v.n, t.format(*refs)))
        out.append('}')
        return '\n'.join(out) + '\n'

# A counted loop `for (i = 0; i < n; i++) body(i)`: returns (function, i, body block, latch hook) pieces.
def counted(f, n, body, exit_value=None):
    pre = f.cur
    zero = f.const('i64', 0)
    header = f.block(); bodyb = f.block(); exitb = f.block()
    f.br(header)
    f.at(header)
    i = f.phi('i64', (zero, pre), (zero, pre))
    c = f.icmp(i, n, 'ult')
    f.cbr(c, bodyb, exitb)
    f.at(bodyb)
    body(i, exitb)
    one = f.const('i64', 1)
    nxt = f.bin('add', 'i64', i, one)
    latch = f.cur
    f.br(header)
    f.set_phi(i, 'i64', (zero, pre), (nxt, latch))
    f.at(exitb)
    return i
