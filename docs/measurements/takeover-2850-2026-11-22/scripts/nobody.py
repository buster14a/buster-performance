import sys
sys.path.insert(0, '.')
from tok import tokenize
# nobody.py IN.i OUT.i: every function definition's body replaced by `;` (a `{` at file scope that follows a `)`).
src, dst = sys.argv[1:3]
data = open(src, 'rb').read()
toks = tokenize(data)
text = [data[a:b] for a, b in toks]
n = len(toks)
out = []
pos = 0
depth = 0
i = 0
bodies = 0
body_tokens = 0
while i < n:
    t = text[i]
    if t == b'{':
        if depth == 0 and i > 0 and text[i - 1] == b')':
            # its matching close
            d = 0
            j = i
            while True:
                if text[j] == b'{':
                    d += 1
                elif text[j] == b'}':
                    d -= 1
                    if d == 0:
                        break
                j += 1
            out.append(data[pos:toks[i][0]])
            out.append(b';')
            pos = toks[j][1]
            bodies += 1
            body_tokens += j - i + 1
            i = j + 1
            continue
        depth += 1
    elif t == b'}':
        depth -= 1
    i += 1
out.append(data[pos:])
open(dst, 'wb').write(b''.join(out))
print(f'bodies {bodies}, their tokens {body_tokens} of {n}')
