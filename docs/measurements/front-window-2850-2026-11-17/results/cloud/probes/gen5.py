import sys, re
groups = int(sys.argv[1]); out = sys.argv[2]
S = "a + b + a + b + a"
statements = [
    "if (%s) { r += 1; }\n" % S,
    "r += (%s) * a;\n" % S,
    "r += a * (%s);\n" % S,
    "r += %s ? a : b;\n" % S,
    "r += a ? %s : b;\n" % S,
    "r += a ? b : %s;\n" % S,
    "r += f2(a, %s);\n" % S,
]
pat = r'[A-Za-z_][A-Za-z_0-9]*|[0-9]+|\+=|\+\+|[-+*/?:;,(){}\[\]=]'
print('group tokens', sum(len(re.findall(pat, s)) for s in statements))
t = "int f2(int, int);\nint wr(int a, int b)\n{\n    int big[3100] = {\n"
for e in range(3000):
    t += "a + 1,\n" if (e & 15) == 15 else "a + 1, "
t += "({ int r = 0;\n"
for s in range(groups * len(statements)):
    t += statements[s % len(statements)]
t += "r; }) };\n    return big[0];\n}\n"
open(out, 'w').write(t)
print('bytes', len(t), 'tokens', len(re.findall(pat, t)))
