#!/usr/bin/env python3
# lists594d.py: #594's confirmation, procbench lists of link-foreign as benchmark-link runs it, from the kept objects
# (setup594.sh, setup594b.sh), by main (v0) and the head (v1), each kind, one run per command per round. The variants:
#   m1, h1: --lanes=1 pinned to CPU 2 (benchmark-link's one thread), by main and the head;
#   mu, hu: main's default (one lane) and the head's --lanes=1, on every CPU (unpinned), as a plain command runs;
#   hd, hp: the head's default, unpinned (benchmark-link's threads now) and pinned to CPU 2;
#   m8, h8: --lanes=8, unpinned (benchmark-link's threads before #594).
# A run's time depends on the runs before it (the clock and the caches of the cores they woke), so the lists keep the
# variants they compare behind runs of their kind: one lane's variants in lists of their own, alternating pinned and
# unpinned so that each follows the other placement's block, and the lanes' in lists of theirs. Each variant's block
# starts with a warm-up command of its own executable (w..., left out), as #501's confirmation did.
#   one: benchmark-link's programs of 1 and 2,000 workers, m1 mu h1 hd hp hu, 20 ms before each run (the default takes
#        one lane there);
#   eight: the same programs, m8 h8;
#   big-one: 102,400 workers, m1 mu h1 hu, 200 ms before each run;
#   big-eight: 102,400 workers, m8 hd h8 (the default takes 8 lanes there);
#   mid: 5,000 to 40,000 workers, hu h1 hd h8, 200 ms (the default takes 2 to 8 lanes);
#   time: hd and hu with --time, 1 to 10,000 workers, 20 ms.
import glob
import os

D = os.environ.get('D594', os.path.expanduser('~/buster-fast-bench/perf-594-claude'))
EVENTS = 'events=task-clock:cycles:instructions:context-switches:cpu-migrations:page-faults'
GCC = '/usr/lib/gcc/x86_64-pc-linux-gnu/16'
KINDS = ['d', 's', 'p', 'l']
# label: tree, lanes option ('' for the default), pinned
VARIANTS = {
    'm1': ('v0', '--lanes=1', True),
    'mu': ('v0', '', False),
    'm8': ('v0', '--lanes=8', False),
    'h1': ('v1', '--lanes=1', True),
    'hu': ('v1', '--lanes=1', False),
    'h8': ('v1', '--lanes=8', False),
    'hd': ('v1', '', False),
    'hp': ('v1', '', True),
}


def objects(program, kind):
    suffix = '' if kind == 'l' else '-exec'
    found = glob.glob(f'{D}/links/{program}{suffix}/buster-link-benchmark-*/objects')
    assert len(found) == 1, (program, found)
    units = len(glob.glob(f'{found[0]}/unit_*.o'))
    result = [f'{found[0]}/unit_{u}.o' for u in range(units)]
    assert all(os.path.exists(p) for p in result), program
    return ' '.join(result)


def command(label, variant, kind, program, pause, time=False):
    tree, lanes, pinned = variant
    name = f'{label}-{kind}{program}'
    exe = f'{D}/{tree}/build/compiler'
    option = f' {lanes}' if lanes else ''
    timed = ' --time' if time else ''
    head = f'{exe} link-foreign{timed} --hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections{option}'
    # The outputs' paths are the same length for every variant of a case.
    out = f'{D}/outd/{label}-{kind}{program}'
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
    options = f'runs=1,pause={pause},{EVENTS}'
    if pinned:
        options += ',cpu=2'
    if time:
        options += ',capture'
    return f'{name}|{options}|{line}'


def write(name, labels, programs, pause, comment, time=False):
    lines = [f'# {comment}']
    for label in labels:
        variant = VARIANTS[label]
        lines.append(command(f'w{label}', variant, KINDS[0], programs[0], pause))
        for program in programs:
            for kind in KINDS:
                lines.append(command(label, variant, kind, program, pause, time))
    with open(f'{D}/confirm-{name}.list', 'w') as f:
        f.write('\n'.join(lines) + '\n')


SMALL = ['1-8', '2000-8']
write('one', ['m1', 'mu', 'h1', 'hd', 'hp', 'hu'], SMALL, 20, '#594: 1 and 2,000 workers on one lane, pinned and unpinned in turn')
write('eight', ['m8', 'h8'], SMALL, 20, '#594: 1 and 2,000 workers on 8 lanes')
write('big-one', ['m1', 'mu', 'h1', 'hu'], ['102400-64'], 200, '#594: 102,400 workers on one lane, pinned and unpinned in turn')
write('big-eight', ['m8', 'hd', 'h8'], ['102400-64'], 200, '#594: 102,400 workers on 8 lanes, the default among them')
write('mid', ['hu', 'h1', 'hd', 'h8'], ['5000-64', '10000-64', '20000-64', '40000-64'], 200, '#594: 5,000 to 40,000 workers, the head')
write('time', ['hd', 'hu'], ['1-8', '2000-8', '5000-64', '10000-64'], 20, '#594: --time of the head, by default and on one lane', time=True)
