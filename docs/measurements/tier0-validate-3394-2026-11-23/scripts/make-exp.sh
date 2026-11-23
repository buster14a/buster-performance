#!/bin/bash
# Usage: make-exp.sh PATCH: the exp3394 tree as main + PATCH + the laps' instrumentation, built znver5, copied to ~/eX.
set -eu
cd /home/user/exp3394
git checkout -q src/
git apply "$1"
patch -p1 -s < /home/user/work3394/exp-full.patch > /dev/null 2>&1 || true
rm -f src/buster/compiler/*.rej src/buster/compiler/*.orig
python3 - <<'PYEOF'
p='src/buster/compiler/tier0.c'
s=open(p).read()
import re
m=re.search(r'\n(    valid = valid && tier0_scan_tables\([^\n]*\);)', s)
a=m.group(1)
if 'buster_3394_tm' not in s:
    s=s.replace(a,'''    const uint64_t buster_3394_tm = __rdtsc();
    __atomic_fetch_add(&buster_3394_accepts[3], buster_3394_tm - buster_3394_t0, __ATOMIC_RELAXED);
'''+a+'''
    const uint64_t buster_3394_t1 = __rdtsc();
    __atomic_fetch_add(&buster_3394_accepts[0], buster_3394_t1 - buster_3394_tm, __ATOMIC_RELAXED);''')
open(p,'w').write(s)
p='src/buster/compiler/tier0_source_benchmark.c'
s=open(p).read()
a='''        printf("backend-source: totals files=%" PRIu64 " left_out=%" PRIu64 " failures=%" PRIu64 " measurement=%s\\n", source->files, source->left_out,'''
i=s.index(a); j=s.index(';', i)
s=s[:j+1]+'''
        {
            extern void buster_3394_print(void) __attribute__((weak));
            if (buster_3394_print != 0)
            {
                buster_3394_print();
            }
        }'''+s[j+1:]
open(p,'w').write(s)
PYEOF
grep -q buster_3394_t1 src/buster/compiler/tier0.c
BUSTER_HOST_ARCH=znver5 ./build.sh --config Release 2>&1 | grep -E "error|took"
