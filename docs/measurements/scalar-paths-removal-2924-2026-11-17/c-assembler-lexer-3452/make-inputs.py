# The #3452 lexer gate's synthetic inputs: 20,000 strings (or comments, each before a nop) of N bytes,
# N = 1, 2, 4, ..., 256. string-N: N letters; escape-N: "ab\\cd\n" (8 bytes, two escapes) N/8 times, or
# "ab" cut to N bytes below 8; comment-N: "# " and N letters.
import sys, os
out = sys.argv[1]
letters = "abcdefghij" * 26
for n in (1, 2, 4, 8, 16, 32, 64, 128, 256):
    with open(os.path.join(out, f"string-{n}.s"), "w") as f:
        f.write(".data\n" + f'.ascii "{letters[:n]}"\n' * 20000)
    body = "ab\\\\cd\\n" * (n // 8) if n >= 8 else "ab"[:n]
    with open(os.path.join(out, f"escape-{n}.s"), "w") as f:
        f.write(".data\n" + f'.ascii "{body}"\n' * 20000)
    with open(os.path.join(out, f"comment-{n}.s"), "w") as f:
        f.write(".text\n" + f"# {letters[:n]}\nnop\n" * 20000)
