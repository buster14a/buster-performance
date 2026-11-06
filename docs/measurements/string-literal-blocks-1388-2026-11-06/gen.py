import random
random.seed(1388)
N = 1_000_000
P = 32
def write(name, prefix, piece_fn, decl="const char s[] ="):
    with open(name, "w") as f:
        f.write(decl + "\n")
        n = 0
        while n < N:
            k = min(P, N - n)
            f.write("    " + prefix + '"' + piece_fn(k) + '"\n')
            n += k
        f.write("    ;\n")
letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
write("letters.c", "", lambda k: "".join(random.choice(letters) for _ in range(k)))
write("octal.c", "", lambda k: "".join("\\%03o" % random.randrange(256) for _ in range(k)))
write("hex.c", "", lambda k: "".join("\\x%02x" % random.randrange(256) for _ in range(k)))
write("wide.c", "L", lambda k: "".join(random.choice(letters) for _ in range(k)), decl="const __WCHAR_TYPE__ s[] =")
def utf8(k):
    out = []
    for _ in range(k):
        r = random.randrange(4)
        if r == 0: c = random.choice(letters)
        elif r == 1: c = chr(random.randrange(0xA0, 0x800))
        elif r == 2: c = chr(random.choice([random.randrange(0x800, 0xD800), random.randrange(0xE000, 0xFFFE)]))
        else: c = chr(random.randrange(0x10000, 0x10FFFF))
        out.append(c)
    return "".join(out)
write("utf8.c", "u8", utf8)
# Typical C text with simple escapes and mixed content
def textish(k):
    out = []
    for _ in range(k):
        r = random.random()
        if r < 0.85: out.append(random.choice(letters + " ,.:;()-%"))
        elif r < 0.93: out.append(random.choice(["\\n", "\\t", "\\\"", "\\\\"]))
        else: out.append("\\x%02x" % random.randrange(256) + random.choice("ghijklmnopqrstuvwxyz ,.;"))
    return "".join(out)
write("text.c", "", textish)
