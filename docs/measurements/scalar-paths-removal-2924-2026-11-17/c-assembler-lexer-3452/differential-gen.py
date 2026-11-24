import random, sys
r = random.Random(int(sys.argv[1]))
def piece():
    k = r.randrange(11)
    if k >= 9:
        tail = r.choice(['"', 'q"', '\n', '"\\"'])
        return '.ascii "' + "p" * r.randrange(0, 70) + "\\" * r.randrange(0, 140) + tail + '"\n'
    if k == 0:
        body = "".join(r.choice(['a', 'b', '\\\\', '\\', '"', ' ', 'x'*r.randrange(1,70), '\\"', '\\\\\\']) for _ in range(r.randrange(0, 12)))
        return '.ascii "' + body + '"\n'
    if k == 1:
        return "# " + "c" * r.randrange(0, 140) + "\n"
    if k == 2:
        return "/* " + "".join(r.choice(["x", "\n", "*", "/", " " * r.randrange(1, 70)]) for _ in range(r.randrange(0, 8))) + " */ nop\n"
    if k == 3:
        return "nop // tail " + "y" * r.randrange(0, 90) + "\n"
    if k == 4:
        return "movl $" + str(r.randrange(100)) + "/2, %eax\n"
    if k == 5:
        return " " * r.randrange(0, 64) + "nop\n"
    if k == 6:
        return '.string "' + "z" * r.randrange(0, 130) + '\\n"\n'
    if k == 7:
        return "addq $" + str(r.randrange(1000)) + ", %rax\n"
    return "\n"
src = ".text\n" + "".join(piece() for _ in range(r.randrange(1, 40)))
tail = r.randrange(8)
if tail == 0: src += '.ascii "open'
if tail == 1: src += '/* open\n comment'
if tail == 2: src += '.ascii "ends with backslash\\'
if tail == 3: src += 'nop\n\x80\n'
if tail == 4: src += '.ascii "a\\\nb"\n'
sys.stdout.write(src)
