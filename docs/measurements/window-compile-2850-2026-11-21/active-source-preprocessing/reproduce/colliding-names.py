from pathlib import Path
import random,sys
r=random.Random(28509223)
out=bytearray()
near=[('same_pref'+f'{k:016x}'+'same_end').encode() for k in range(2048)]
short=[bytes([i]) for i in range(97,123)]
for row in range(70000):
 n=row%9
 if n<4:s=near[r.randrange(2048)]
 elif n==4:s=near[r.randrange(16)]+b'a'*65
 elif n==5:s=b'same_pref'+b'y'*70+b'same_end'
 elif n==6:s=r.choice(short)
 elif n==7 and row%20001<95:s=r.choice([b'sp'+bytes([92,10])+b'lice',b'cr'+bytes([92,13,10])+b'lf'])
 else:s=r.choice([b'a',b'ab',b'abc',b'abcdefg',b'abcdefgh',b'abcdefghi',b'kjihgfedcba'])
 out+=s+(b'\n' if row%13==0 else b' ')
Path(sys.argv[1]).write_bytes(out+b'\n')
