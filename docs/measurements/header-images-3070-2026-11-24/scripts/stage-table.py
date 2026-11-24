import sys, re, collections
def stage(n, k):
    if k == 'k': return 'kernel'
    for pre, s in (('pp_root', 'pp'), ('pp_', 'pp'), ('file_cache', 'pp'), ('files_', 'pp'), ('tokenize', 'pp'), ('refine', 'pp'), ('intern', 'intern'), ('parse_', 'parse'), ('check_attested', 'attested'),
                   ('check_input', 'check-input'), ('type_', 'types'), ('check_program', 'check-program'), ('check_lower', 'lower'), ('check_units', 'driver'), ('check_driver', 'driver'),
                   ('check_', 'check-other'), ('tier0', 'tier0'), ('x86', 'encode'), ('object', 'object'), ('link', 'object'), ('arena', 'arena'), ('__mem', 'mem*'), ('__madvise', 'syscall-stubs'), ('madvise', 'syscall-stubs'),
                   ('__ioctl', 'syscall-stubs'), ('__open', 'syscall-stubs'), ('__libc_open', 'syscall-stubs'), ('__close', 'syscall-stubs'), ('__pwrite', 'syscall-stubs'), ('__fstat', 'syscall-stubs')):
        if n.startswith(pre): return s
    return 'other'
for f in sys.argv[1:]:
    st = collections.Counter(); tot = 0.0
    for line in open(f):
        m = re.match(r'\s+([0-9.]+)%\s+\[(.)\]\s+(\S+)', line)
        if not m: continue
        p = float(m.group(1)); st[stage(m.group(3), m.group(2))] += p; tot += p
    print(f, f'listed {tot:.1f}%')
    for s, p in st.most_common(): print(f'  {p:6.2f}%  {s}')
