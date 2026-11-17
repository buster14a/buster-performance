import sys
count = int(sys.argv[1]); out = sys.argv[2]
statements = [
    "if (a + b) { r += 1; }\n",
    "r += (a + b) * a;\n",
    "r += a * (a + b);\n",
    "r += a + b ? a : b;\n",
    "r += a ? a + b : b;\n",
    "r += a ? b : a + b;\n",
    "r += f2(a, a + b);\n",
]
t = "int f2(int, int);\nint wr(int a, int b)\n{\n    int big[3100] = {\n"
for e in range(3000):
    t += "a + 1,\n" if (e & 15) == 15 else "a + 1, "
t += "({ int r = 0;\n"
for s in range(count):
    t += statements[s % len(statements)]
t += "r; }) };\n    return big[0];\n}\n"
open(out, 'w').write(t)
