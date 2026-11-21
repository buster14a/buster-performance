"""Exercise the admitted expression across action lanes/chunk boundaries, ordinary fallback and both tiers."""
from pathlib import Path
import collections
import hashlib
import itertools
import os
import re
import subprocess
import sys
import tempfile

cc = Path(sys.argv[1]).resolve()
working = Path(sys.argv[2]).resolve()
working.mkdir(exist_ok=True, parents=True)
stats = collections.Counter()
body = r'''#define DROP(x) ((void)(x))
int observe(int seed) {
    int state = seed;
    PADDING
    ((void)71); DROP(__LINE__); (void)99;
    if (state & 1) { DROP(56); state += 1; } else { (void)27; state -= 1; }
    for (state += 3; state < 8; state++) { (void)18; }
    int other = ({ DROP(95); state + 3; });
    (void)(state++);
    (void)(state, other);
    return state * other + seed;
}
int main(void) { return observe(10) != EXPECTED || observe(4) != SECONDEXPECTED; }
'''
def score(x):
    state = x+1 if x & 1 else x-1
    state=max(8, state+3)
    return (state+1)*(state+3)+x

body=body.replace('SECONDEXPECTED',str(score(4))).replace('EXPECTED',str(score(10)))
with (working/'boundaries.tsv').open('w') as rows:
    print('shift\ttier\tdebug\tadmitted\tsize\tsha256', file=rows)
    for shift, tier, debug in itertools.product([0,1,2,3,4,5,7,8,15,16,31,32,62,63,64,65,126,127,128,250,251,252,253,254,255,256,257,258,259,510,511,512,513,1022,1023,1024], [0,1], [False,True]):
        folder = working/'unit'
        folder.mkdir(exist_ok=True)
        path=folder/'source.c'
        exe=folder/'exe'
        obj=folder/'unit.o'
        path.write_text(body.replace('PADDING', 'state += 0;\n'*shift))
        flags=['--lanes','1','-std=gnu17','-Wall','-Wextra','-Wno-unused-value']
        if tier: flags.append('--tier1')
        if debug: flags.append('-g')
        output = []
        for opts in ([],['--node-window']):
            obj.unlink(missing_ok=True)
            r=subprocess.run([cc,*flags,*opts,'-c',path,'-o',obj],capture_output=True)
            output.append((r.returncode,r.stdout,r.stderr,obj.read_bytes() if obj.exists() else b''))
        assert output[0] == output[1] and output[0][0] == 0, (shift,tier,debug,[x[:3] for x in output])
        z=subprocess.run([cc,*flags,'--node-window','--time-stages','-c',path,'-o',obj],capture_output=True,check=True)
        m=re.search(rb'node-window: taken=(\d+)',z.stderr)
        assert m is not None or debug, (shift,tier,debug,z.stderr)
        n=int(m[1]) if m is not None else 0
        # The return has arithmetic over locals. All admissions in this file come from void-literal statements.
        stats['positive_tests' if n else 'zero_admissions'] += 1
        if not debug: assert n>0, (shift,tier,debug)
        subprocess.run(['cc',obj,'-o',exe],check=True,capture_output=True)
        subprocess.run([exe],check=True)
        stats['executions']+=1
        print(shift,tier,int(debug),n,len(output[0][3]),hashlib.sha256(output[0][3]).hexdigest(),sep='\t',file=rows)
print(dict(stats),flush=True)
