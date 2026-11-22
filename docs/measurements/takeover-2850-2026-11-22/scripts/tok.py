import re, sys
# A C tokenizer for a preprocessed file: yields (start, end) byte offsets of each token; line markers are skipped.
TOKEN = re.compile(rb'''
    (?P<ws>[ \t\r\n\f\v]+)
  | (?P<str>(?:u8|u|U|L)?"(?:[^"\\\n]|\\.)*")
  | (?P<chr>(?:u8|u|U|L)?'(?:[^'\\\n]|\\.)*')
  | (?P<num>\.?[0-9](?:[eEpP][+-]|[0-9a-zA-Z_.])*)
  | (?P<id>[A-Za-z_$][A-Za-z0-9_$]*)
  | (?P<punct>\.\.\.|<<=|>>=|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||\*=|/=|%=|\+=|-=|&=|\^=|\|=|\#\#|[\[\](){}.&*+\-~!/%<>^|?:;=,\#])
''', re.X)
def tokenize(data):
    out = []
    pos = 0
    n = len(data)
    line_start = True
    while pos < n:
        if line_start and data[pos:pos + 1] == b'#':
            end = data.find(b'\n', pos)
            pos = n if end < 0 else end + 1
            continue
        m = TOKEN.match(data, pos)
        if m is None:
            raise SystemExit(f'no token at {pos}: {data[pos:pos + 40]!r}')
        if m.lastgroup == 'ws':
            line_start = b'\n' in m.group() or (line_start and True)
            if b'\n' in m.group():
                # the next non-space character starts a line only if it follows a newline with spaces alone
                tail = m.group().rsplit(b'\n', 1)[1]
                line_start = True
            pos = m.end()
            continue
        line_start = False
        out.append((m.start(), m.end()))
        pos = m.end()
    return out
if __name__ == '__main__':
    data = open(sys.argv[1], 'rb').read()
    toks = tokenize(data)
    print(len(toks))
    for i in map(int, sys.argv[2:]):
        s = b' '.join(data[a:b] for a, b in toks[max(0, i - 2):i + 12])
        print(i, s.decode('latin1'))
