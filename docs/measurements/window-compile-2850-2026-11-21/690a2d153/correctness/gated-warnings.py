import itertools
import os
import pathlib
import re
import subprocess
import sys
import tempfile

compiler = os.path.abspath(sys.argv[1])
clang = os.environ.get('BUSTER_CLANG', 'clang')
fixture = os.path.abspath(sys.argv[2])
pattern = re.compile(rb'^node-window: taken=(\d+) ordinary-nodes-replaced=(\d+) summary-nodes=(\d+) graph-nodes=(\d+)$', re.M)
rows = []
with tempfile.TemporaryDirectory() as tmp:
    for lang, mode, policy, lanes in itertools.product(('gnu17', 'c23'), ('-fsyntax-only', '-c'), ('-Wall', '-Werror', '-w'), ('1', '3')):
        outputs = []
        for i, driver in enumerate((clang, compiler, compiler)):
            output_path = pathlib.Path(tmp, f'{i}.o')
            if output_path.exists():
                output_path.unlink()
            args = [driver, '-std='+lang, '-fno-caret-diagnostics','-Wall','-Wextra',policy,mode,fixture,'-o',str(output_path)]
            if i:
                args += ['--lanes',lanes]
            if i == 2:
                args += [sys.argv[3]]
            p = subprocess.run(args, capture_output=True)
            outputs.append((p.returncode,p.stderr,output_path.read_bytes() if output_path.exists() else b''))
        same = outputs[0][:2] == outputs[1][:2] == outputs[2][:2]
        same_object = outputs[1][2] == outputs[2][2]
        s = subprocess.run([compiler, '-std='+lang, '-fno-caret-diagnostics','-Wall','-Wextra',policy,mode,fixture,'-o',str(pathlib.Path(tmp,'stats.o')),'--lanes',lanes,sys.argv[3],'--time-stages'],capture_output=True)
        m = pattern.search(s.stderr)
        counts = tuple(map(int,m.groups())) if m else None
        if not same:
            print('DIAGNOSTIC DIFFERENCE', lang, mode, policy, lanes)
            for result in outputs: print(result[0], result[1].decode())
        rows.append((lang,mode,policy,lanes,same,same_object,counts))
for row in rows:
    print(*row)
print('diagnostic/status mismatches',sum(not r[4] for r in rows),'object mismatches',sum(not r[5] for r in rows),'missing counter',sum(r[6] is None for r in rows),'zero taken',sum(r[6] is not None and r[6][0] == 0 for r in rows))
