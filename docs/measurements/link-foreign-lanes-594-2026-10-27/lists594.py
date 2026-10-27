#!/usr/bin/env python3
# lists594.py: #594's sweep, procbench lists of link-foreign as benchmark-link runs it, from benchmark-link's kept
# objects (setup594.sh): programs of 1 to 102,400 workers, each kind, on 1 lane pinned to CPU 2 (benchmark-link's one
# thread), on 1 lane unpinned, and on 2, 3, 4, 6 and 8 lanes unpinned (its threads' way), each run with --time and its
# report kept (capture). One run per command per round; every command of a program follows the same program's last.
#   sweep-small: the programs of up to 5,000 workers, 20 ms before each run;
#   sweep-big: those of 10,000 workers and more, 200 ms before each (benchmark-link's pause past 4 MB of output).
import glob
import os
import sys

D = os.environ.get('D594', os.path.expanduser('~/buster-fast-bench/perf-594-claude'))
TREE = sys.argv[1] if len(sys.argv) > 1 else 'v0'
EVENTS = 'events=task-clock:cycles:instructions:context-switches:cpu-migrations:page-faults'
GCC = '/usr/lib/gcc/x86_64-pc-linux-gnu/16'
SMALL = ['1-8', '2000-8', '2000-64', '5000-64']
BIG = ['10000-64', '20000-64', '40000-64', '102400-64']
KINDS = ['d', 's', 'p', 'l']
WAYS = ['1p', '1', '2', '3', '4', '6', '8']


# A program's objects: the executables' (links/N-F-exec, setup594b.sh) or, for a shared library, the shared kind's
# (links/N-F), which benchmark-link generates otherwise.
def objects(program, kind):
    suffix = '' if kind == 'l' else '-exec'
    found = glob.glob(f'{D}/links/{program}{suffix}/buster-link-benchmark-*/objects')
    assert len(found) == 1, (program, found)
    units = len(glob.glob(f'{found[0]}/unit_*.o'))
    result = [f'{found[0]}/unit_{u}.o' for u in range(units)]
    assert all(os.path.exists(p) for p in result), program
    return ' '.join(result)


def command(tree, kind, program, way):
    name = f'{kind}{program}-{way}'
    exe = f'{D}/{tree}/build/compiler'
    lanes = '1' if way == '1p' else way
    head = f'{exe} link-foreign --time --hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections --lanes={lanes}'
    out = f'{D}/out/{tree}-{name}'
    objs = objects(program, kind)
    dynamic_libraries = '-lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed'
    group = '--start-group -lgcc -lgcc_eh -lc --end-group'
    if kind == 'd':
        line = (f'{head} -pie -dynamic-linker /usr/lib/ld-linux-x86-64.so.2 -o {out} /usr/lib64/Scrt1.o /usr/lib64/crti.o {GCC}/crtbeginS.o '
                f'-L{GCC} -L/usr/lib64 {objs} {dynamic_libraries} {GCC}/crtendS.o /usr/lib64/crtn.o')
    elif kind == 's':
        line = (f'{head} -static -o {out} /usr/lib64/crt1.o /usr/lib64/crti.o {GCC}/crtbeginT.o -L{GCC} -L/usr/lib64 {objs} '
                f'{group} {GCC}/crtend.o /usr/lib64/crtn.o')
    elif kind == 'p':
        line = (f'{head} -static -pie --no-dynamic-linker -z text -o {out} /usr/lib64/rcrt1.o /usr/lib64/crti.o {GCC}/crtbeginS.o -L{GCC} -L/usr/lib64 {objs} '
                f'{group} {GCC}/crtendS.o /usr/lib64/crtn.o')
    else:
        line = (f'{head} -shared -o {out} /usr/lib64/crti.o {GCC}/crtbeginS.o -L{GCC} -L/usr/lib64 {objs} '
                f'{dynamic_libraries} {GCC}/crtendS.o /usr/lib64/crtn.o')
    big = program in BIG
    options = f'runs=1,pause={200 if big else 20},{EVENTS},capture'
    if way == '1p':
        options += ',cpu=2'
    return f'{tree}-{name}|{options}|{line}'


def write(name, programs, comment):
    lines = [f'# {comment}']
    for program in programs:
        for kind in KINDS:
            for way in WAYS:
                lines.append(command(TREE, kind, program, way))
    with open(f'{D}/{name}.list', 'w') as f:
        f.write('\n'.join(lines) + '\n')


write(f'sweep-small-{TREE}', SMALL, f'#594: --time of 1 to 5,000 workers on 1 to 8 lanes, by {TREE}')
write(f'sweep-big-{TREE}', BIG, f'#594: --time of 10,000 to 102,400 workers on 1 to 8 lanes, by {TREE}')
