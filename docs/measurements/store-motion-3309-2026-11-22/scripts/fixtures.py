import os, struct, sys
from irgen import F, counted
A, B, T, U, V, W, G, CALLEE = 1, 2, 3, 4, 5, 6, 7, 9
out = sys.argv[1]
os.makedirs(out, exist_ok=True)
def write(name, f):
    open(os.path.join(out, name + '.ir'), 'w').write(f.text())
def f64(x): return struct.unpack('<Q', struct.pack('<d', x))[0]
def f32(x): return struct.unpack('<I', struct.pack('<f', x))[0]

# The lowering's field address: the symbol's i64 (made outside the loop), then inttoptr, address + const * 1, ptrtoint, inttoptr.
def field(f, base_i64, offset):
    c = f.const('i64', offset)
    p = f.un('inttoptr', 'ptr', base_i64)
    a = f.address(p, c, 1, 0)
    x = f.un('ptrtoint', 'i64', a)
    return f.un('inttoptr', 'ptr', x)

# basic: A += i; B ^= A (A read again).
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    a = f.sym(A); v = f.load('i64', a); s = f.bin('add', 'i64', v, i); f.store(f.sym(A), s)
    b = f.sym(B); w = f.load('i64', b); r = f.load('i64', f.sym(A)); x = f.bin('xor', 'i64', w, r); f.store(f.sym(B), x)
counted(f, n, body)
f.ret(f.load('i64', f.sym(B)))
write('basic', f)

# conditional: if (i & 1) A += 3; else B -= A.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    one = f.const('i64', 1); bit = f.bin('and', 'i64', i, one); zero = f.const('i64', 0); c = f.icmp(bit, zero, 'ne')
    then = f.block(); other = f.block(); join = f.block()
    f.cbr(c, then, other)
    f.at(then); v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, f.const('i64', 3))); f.br(join)
    f.at(other); w = f.load('i64', f.sym(B)); f.store(f.sym(B), f.bin('sub', 'i64', w, f.load('i64', f.sym(A)))); f.br(join)
    f.at(join)
counted(f, n, body)
f.ret(f.bin('add', 'i64', f.load('i64', f.sym(A)), f.load('i64', f.sym(B))))
write('conditional', f)

# nested: for r: { for n: A += j ^ r; B += A; }: the outer loop takes both keys.
f = F(['i64', 'i64'], 'i64'); f.at(f.block()); rows = f.param(0); n = f.param(1)
def outer(r, ex):
    def inner(j, ex2):
        v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, f.bin('xor', 'i64', j, r)))
    counted(f, n, inner)
    w = f.load('i64', f.sym(B)); f.store(f.sym(B), f.bin('add', 'i64', w, f.load('i64', f.sym(A))))
counted(f, rows, outer)
f.ret(f.load('i64', f.sym(B)))
write('nested', f)

# nested-call: the outer loop calls; the inner one is taken, its preheader inside the outer loop.
f = F(['i64', 'i64'], 'i64'); f.at(f.block()); rows = f.param(0); n = f.param(1)
def outer(r, ex):
    def inner(j, ex2):
        v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, f.bin('xor', 'i64', j, r)))
    counted(f, n, inner)
    f.emit('call.i64 @%d({}) fixed=(i64) variadic=0' % CALLEE, r)
counted(f, rows, outer)
f.ret(f.load('i64', f.sym(A)))
write('nested-call', f)

# fields: T's i32 at 8, i64 at 16 and f64 at 24, through the lowering's chains from a ptrtoint made before the loop.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
base = f.un('ptrtoint', 'i64', f.sym(T))
def body(i, ex):
    p = field(f, base, 8); v = f.load('i32', p, 4); t = f.un('trunc', 'i32', i); s = f.bin('add', 'i32', v, t); f.store(field(f, base, 8), s, 4)
    q = field(f, base, 16); w = f.load('i64', q); f.store(field(f, base, 16), f.bin('xor', 'i64', w, f.un('sext', 'i64', f.load('i32', field(f, base, 8), 4))))
    d = field(f, base, 24); x = f.load('f64', d); f.store(field(f, base, 24), f.bin('fadd', 'f64', x, f.const('f64', f64(1.25))))
counted(f, n, body)
f.ret(f.load('i64', field(f, base, 16)))
write('fields', f)

# types: i8 and i16 in T, a ptr in T, an i32 that is all of W, an f64 and an f32 in G.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    a8 = f.address(f.sym(T), None, 1, 40); v8 = f.load('i8', a8, 1); f.store(f.address(f.sym(T), None, 1, 40), f.bin('add', 'i8', v8, f.const('i8', 7)), 1)
    a16 = f.address(f.sym(T), None, 1, 42); v16 = f.load('i16', a16, 2); f.store(f.address(f.sym(T), None, 1, 42), f.bin('mul', 'i16', v16, f.const('i16', 3)), 2)
    ap = f.address(f.sym(T), None, 1, 48); vp = f.load('ptr', ap); q = f.address(vp, None, 1, 8); f.store(f.address(f.sym(T), None, 1, 48), q)
    w = f.load('i32', f.sym(W), 4); f.store(f.sym(W), f.bin('add', 'i32', w, f.un('trunc', 'i32', i)), 4)
    d = f.load('f64', f.sym(G)); f.store(f.sym(G), f.bin('fadd', 'f64', d, f.const('f64', f64(0.5))))
    g = f.address(f.sym(G), None, 1, 8); s = f.load('f32', g, 4); f.store(f.address(f.sym(G), None, 1, 8), f.bin('fmul', 'f32', s, f.const('f32', f32(1.5))), 4)
counted(f, n, body)
f.ret(f.un('zext', 'i64', f.load('i32', f.sym(W), 4)))
write('types', f)

# unknown-load: A += p[i & 3]: a load through a parameter, which may be A itself; memory is current, so A is taken.
f = F(['ptr', 'i64'], 'i64'); f.at(f.block()); p = f.param(0); n = f.param(1)
def body(i, ex):
    k = f.bin('and', 'i64', i, f.const('i64', 3)); e = f.load('i64', f.address(p, k, 8, 0)); v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, e))
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('unknown-load', f)

# two-exits: A += i; if (A > k) break; B += A.
f = F(['i64', 'i64'], 'i64'); f.at(f.block()); n = f.param(0); k = f.param(1)
def body(i, ex):
    v = f.load('i64', f.sym(A)); s = f.bin('add', 'i64', v, i); f.store(f.sym(A), s)
    c = f.icmp(f.load('i64', f.sym(A)), k, 'ugt'); rest = f.block(); f.cbr(c, ex, rest)
    f.at(rest); w = f.load('i64', f.sym(B)); f.store(f.sym(B), f.bin('add', 'i64', w, f.load('i64', f.sym(A))))
counted(f, n, body)
f.ret(f.bin('xor', 'i64', f.load('i64', f.sym(A)), f.load('i64', f.sym(B))))
write('two-exits', f)

# do-while: one block, tested at its end.
f = F(['i64'], 'i64'); b0 = f.block(); f.at(b0); n = f.param(0); zero = f.const('i64', 0)
loop = f.block(); done = f.block(); f.br(loop); f.at(loop)
i = f.phi('i64', (zero, b0), (zero, b0))
v = f.load('i64', f.sym(A)); s = f.bin('add', 'i64', v, i); f.store(f.sym(A), s)
w = f.load('i64', f.sym(B)); f.store(f.sym(B), f.bin('xor', 'i64', w, f.load('i64', f.sym(A))))
nxt = f.bin('add', 'i64', i, f.const('i64', 1)); c = f.icmp(nxt, n, 'ult'); f.cbr(c, loop, done)
f.set_phi(i, 'i64', (zero, b0), (nxt, loop))
f.at(done); f.ret(f.load('i64', f.sym(B)))
write('do-while', f)

# key-limit: six i64 keys of T in one loop; four are taken.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    for k in range(6):
        v = f.load('i64', f.address(f.sym(T), None, 1, 8 * k)); f.store(f.address(f.sym(T), None, 1, 8 * k), f.bin('add', 'i64', v, f.bin('add', 'i64', i, f.const('i64', k))))
counted(f, n, body)
f.ret(f.load('i64', f.address(f.sym(T), None, 1, 40)))
write('key-limit', f)

# slots: the lowered form, its locals in slots: for (i = 0; i < n; i++) { A += i; B ^= A; }.
f = F(['i32'], 'i64'); sn = f.slot(4, 4, 'i32'); si = f.slot(4, 4, 'i32')
b0 = f.block(); f.at(b0); an = f.stack(sn); ai = f.stack(si); f.store(an, f.param(0), 4)
b1 = f.block(); f.br(b1); f.at(b1); f.store(ai, f.const('i32', 0), 4)
b2 = f.block(); b3 = f.block(); b4 = f.block(); f.br(b2)
f.at(b2); c = f.icmp(f.load('i32', ai, 4), f.load('i32', an, 4), 'lt'); f.cbr(c, b3, b4)
f.at(b3)
v = f.load('i64', f.sym(A), 1); s = f.bin('add', 'i64', v, f.un('sext', 'i64', f.load('i32', ai, 4))); f.store(f.sym(A), s, 1)
w = f.load('i64', f.sym(B), 1); f.store(f.sym(B), f.bin('xor', 'i64', w, f.load('i64', f.sym(A), 1)), 1)
f.store(ai, f.bin('add', 'i32', f.load('i32', ai, 4), f.const('i32', 1)), 4); f.br(b2)
f.at(b4); f.ret(f.load('i64', f.sym(B), 1))
write('slots', f)

# unread: A = i (never read in the loop) stays; B += i is taken.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    f.store(f.sym(A), i)
    w = f.load('i64', f.sym(B)); f.store(f.sym(B), f.bin('add', 'i64', w, i))
counted(f, n, body)
f.ret(f.load('i64', f.sym(B)))
write('unread', f)

# other-symbols: a store to an unlisted symbol and an indexed store to T beside A's key: neither is A's bytes.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    v = f.load('i64', f.sym(A)); s = f.bin('add', 'i64', v, i); f.store(f.sym(A), s)
    f.store(f.address(f.sym(U), None, 1, 8), s)
    k = f.bin('and', 'i64', i, f.const('i64', 7)); e = f.address(f.sym(T), k, 8, 0); f.store(e, f.bin('add', 'i64', f.load('i64', e), f.load('i64', f.sym(A))))
    u = f.load('i64', f.address(f.sym(U), None, 1, 16)); f.store(f.address(f.sym(U), None, 1, 16), f.bin('add', 'i64', u, i))
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('other-symbols', f)

# met-loads: T[2] += T[i & 3] and an i32 read of A's high half beside A's key: loads that meet a key read memory.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    k = f.bin('and', 'i64', i, f.const('i64', 3)); e = f.load('i64', f.address(f.sym(T), k, 8, 0))
    v = f.load('i64', f.address(f.sym(T), None, 1, 16)); f.store(f.address(f.sym(T), None, 1, 16), f.bin('add', 'i64', v, e))
    h = f.load('i32', f.address(f.sym(A), None, 1, 4), 4); w = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', f.bin('mul', 'i64', w, f.const('i64', 0x100000003)), f.un('zext', 'i64', h)))
counted(f, n, body)
f.ret(f.bin('xor', 'i64', f.load('i64', f.sym(A)), f.load('i64', f.address(f.sym(T), None, 1, 16))))
write('met-loads', f)

# refuse-call: a call in the loop may read and write A.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, i))
    f.emit('call.i64 @%d({}) fixed=(i64) variadic=0' % CALLEE, i)
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('refuse-call', f)

# refuse-volatile: a volatile access of A beside its plain ones.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, i))
    w = f.load('i64', f.sym(A), 8, 'volatile'); f.store(f.sym(A), f.bin('mul', 'i64', w, f.const('i64', 3)), 8, 'volatile')
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('refuse-volatile', f)

# refuse-fence: a fence in the loop.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, i)); f.emit('fence.void seq_cst')
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('refuse-fence', f)

# refuse-unknown-store: a store through a parameter, which may be A.
f = F(['ptr', 'i64'], 'i64'); f.at(f.block()); p = f.param(0); n = f.param(1)
def body(i, ex):
    v = f.load('i64', f.sym(A)); s = f.bin('add', 'i64', v, i); f.store(f.sym(A), s)
    f.store(p, f.bin('add', 'i64', f.load('i64', p), f.load('i64', f.sym(A))))
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('refuse-unknown-store', f)

# refuse-indexed: T[i & 7] += 1 beside T's key at 16.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    k = f.bin('and', 'i64', i, f.const('i64', 7)); e = f.address(f.sym(T), k, 8, 0); f.store(e, f.bin('add', 'i64', f.load('i64', e), f.const('i64', 1)))
    v = f.load('i64', f.address(f.sym(T), None, 1, 16)); f.store(f.address(f.sym(T), None, 1, 16), f.bin('xor', 'i64', v, f.bin('add', 'i64', i, f.const('i64', 5))))
counted(f, n, body)
f.ret(f.load('i64', f.address(f.sym(T), None, 1, 16)))
write('refuse-indexed', f)

# refuse-overlap: A as an i64 and its high half as an i32.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', f.bin('mul', 'i64', v, f.const('i64', 0x100000003)), i))
    h = f.address(f.sym(A), None, 1, 4); w = f.load('i32', h, 4); f.store(f.address(f.sym(A), None, 1, 4), f.bin('xor', 'i32', w, f.un('trunc', 'i32', f.bin('add', 'i64', i, f.const('i64', 9)))), 4)
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('refuse-overlap', f)

# refuse-bounds: an i64 at W, an object of 4 bytes.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    v = f.load('i64', f.sym(W), 4); f.store(f.sym(W), f.bin('add', 'i64', v, i), 4)
counted(f, n, body)
f.ret(n)
write('refuse-bounds', f)

# refuse-preheader: the header has two predecessors outside the loop.
f = F(['i64', 'i64'], 'i64'); b0 = f.block(); f.at(b0); n = f.param(0); k = f.param(1); zero = f.const('i64', 0); one = f.const('i64', 1)
ba = f.block(); bb = f.block(); header = f.block(); bodyb = f.block(); exitb = f.block()
f.cbr(f.icmp(k, zero, 'ne'), ba, bb)
f.at(ba); f.br(header)
f.at(bb); f.br(header)
f.at(header); i = f.phi('i64', (zero, ba), (one, bb), (zero, ba)); f.cbr(f.icmp(i, n, 'ult'), bodyb, exitb)
f.at(bodyb); v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, i)); nxt = f.bin('add', 'i64', i, one); f.br(header)
f.set_phi(i, 'i64', (zero, ba), (one, bb), (nxt, bodyb))
f.at(exitb); f.ret(f.load('i64', f.sym(A)))
write('refuse-preheader', f)

# refuse-irreducible: a counted loop whose body is a cycle of two blocks entered at either.
f = F(['i64', 'i64'], 'i64'); f.at(f.block()); n = f.param(0); k = f.param(1)
cnt = f.slot(8, 8, 'i64'); ca = f.stack(cnt)
def body(i, ex):
    zero = f.const('i64', 0); f.store(ca, zero)
    x = f.block(); y = f.block(); done = f.block()
    f.cbr(f.icmp(f.bin('and', 'i64', f.bin('add', 'i64', k, i), f.const('i64', 1)), zero, 'ne'), x, y)
    f.at(x); v = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', v, f.const('i64', 3)))
    c1 = f.load('i64', ca); f.store(ca, f.bin('add', 'i64', c1, f.const('i64', 1))); f.cbr(f.icmp(f.load('i64', ca), f.const('i64', 3), 'ult'), y, done)
    f.at(y); w = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('xor', 'i64', w, f.const('i64', 5)))
    c2 = f.load('i64', ca); f.store(ca, f.bin('add', 'i64', c2, f.const('i64', 1))); f.cbr(f.icmp(f.load('i64', ca), f.const('i64', 3), 'ult'), x, done)
    f.at(done)
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('refuse-irreducible', f)

# refuse-type: an i128 of T.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    v = f.load('i128', f.sym(T), 16); f.store(f.sym(T), f.bin('add', 'i128', v, f.un('zext', 'i128', i)), 16)
counted(f, n, body)
f.ret(f.load('i64', f.sym(T)))
write('refuse-type', f)

# refuse-unlisted: a key of a symbol the options don't list.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    v = f.load('i64', f.sym(U)); f.store(f.sym(U), f.bin('add', 'i64', v, i))
counted(f, n, body)
f.ret(f.load('i64', f.sym(U)))
write('refuse-unlisted', f)

# refuse-many: 64 bytes of T and A, 65 keys in one loop.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    for k in range(64):
        v = f.load('i8', f.address(f.sym(T), None, 1, k), 1); f.store(f.address(f.sym(T), None, 1, k), f.bin('add', 'i8', v, f.const('i8', k + 1)), 1)
    w = f.load('i64', f.sym(A)); f.store(f.sym(A), f.bin('add', 'i64', w, i))
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('refuse-many', f)

# refuse-chain: A's address through more copies than the walk follows.
f = F(['i64'], 'i64'); f.at(f.block()); n = f.param(0)
def body(i, ex):
    a = f.sym(A)
    for k in range(30):
        a = f.un('copy', 'ptr', a)
    v = f.load('i64', a); f.store(a, f.bin('add', 'i64', v, i))
counted(f, n, body)
f.ret(f.load('i64', f.sym(A)))
write('refuse-chain', f)

# callee: A += x; returns A. The refused loops' callee, symbol 9.
f = F(['i64'], 'i64'); f.at(f.block()); x = f.param(0)
v = f.load('i64', f.sym(A)); s = f.bin('add', 'i64', v, f.bin('mul', 'i64', x, f.const('i64', 3))); f.store(f.sym(A), s); f.ret(s)
write('callee', f)
print('written')
