#!/usr/bin/env python3
# lists501.py: #501's procbench lists, from the kept objects: link-foreign as benchmark-link runs it (the command lines
# capture446.sh traced), 1, 2,000 and 102,400 workers, dynamic PIEs and static executables, by main (m1 and m2, the
# same executable, v0), the head (hd, v1), and the switch build (v2) with the workers releasing their scratch arenas
# after each operation (rl, as the head does) and keeping them (kp). Every command gets BUSTER_501_SCRATCH, free or
# keep, so that each has the same environment's size, and its executable's path and its output's are the same length
# across the variants of a case. One run per command per round, the variants outermost, so that every command follows
# the same case's command of its own variant, and procbench's rotation puts each first in turn.
#   small-threads: 1 and 2,000 workers, --lanes=8 unpinned, 20 ms before each run;
#   big-threads: 102,400 workers, --lanes=8, 200 ms before each run;
#   small-one, big-one: the same on one lane pinned to CPU 2, by m1, m2 and hd;
#   small-time, big-time: the threaded ones with --time, each run's report kept (capture).
import glob
import os

D = os.environ.get('D501', os.path.expanduser('~/buster-fast-bench/perf-501-claude'))
EVENTS = 'events=task-clock:cycles:instructions:context-switches:cpu-migrations:page-faults'
VARIANTS = [('m1', 'v0', 'free'), ('m2', 'v0', 'free'), ('hd', 'v1', 'free'), ('rl', 'v2', 'free'), ('kp', 'v2', 'keep')]
GCC = '/usr/lib/gcc/x86_64-pc-linux-gnu/16'


# A program's objects, unit_0.o to its last unit's (benchmark-link writes at least 4 units: the 1-worker program has 4).
def objects(pattern, count):
    found = glob.glob(os.path.expanduser(pattern))
    assert len(found) == 1, (pattern, found)
    units = len(glob.glob(f'{found[0]}/unit_*.o'))
    assert units == count, (pattern, units, count)
    result = [f'{found[0]}/unit_{u}.o' for u in range(count)]
    assert all(os.path.exists(p) for p in result), pattern
    return ' '.join(result)


PROGRAMS = {
    '1': objects(f'{D}/links1/buster-link-benchmark-*/objects', 4),
    '2000': objects(os.environ.get('P2000', '~/buster-fast-bench/perf-445-446-claude/links2000/buster-link-benchmark-GaN1iP/objects'), 10),
    '102400': objects(os.environ.get('P102400', '~/buster-fast-bench/perf-445-446-claude/links/buster-link-benchmark-AD5nXI/objects'), 512),
}


def command(variant, kind, workers, lanes, time):
    label, tree, scratch = variant
    name = f'{label}-{kind}{workers}-{lanes}'
    exe = f'{D}/{tree}/build/compiler'
    timed = ' --time' if time else ''
    head = f'{exe} link-foreign{timed} --hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections --lanes={lanes}'
    out = f'{D}/out/{name}'
    objs = PROGRAMS[workers]
    if kind == 'd':
        line = (f'{head} -pie -dynamic-linker /usr/lib/ld-linux-x86-64.so.2 -o {out} /usr/lib64/Scrt1.o /usr/lib64/crti.o {GCC}/crtbeginS.o '
                f'-L{GCC} -L/usr/lib64 {objs} -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed {GCC}/crtendS.o /usr/lib64/crtn.o')
    else:
        line = (f'{head} -static -o {out} /usr/lib64/crt1.o /usr/lib64/crti.o {GCC}/crtbeginT.o -L{GCC} -L/usr/lib64 {objs} '
                f'--start-group -lgcc -lgcc_eh -lc --end-group {GCC}/crtend.o /usr/lib64/crtn.o')
    pause = 200 if workers == '102400' else 20
    options = f'runs=1,pause={pause},{EVENTS},var=BUSTER_501_SCRATCH={scratch}'
    if lanes == 1:
        options += ',cpu=2'
    if time:
        options += ',capture'
    return f'{name}|{options}|{line}'


def write(name, variants, workers_list, lanes, time, comment):
    lines = [f'# {comment}']
    for variant in variants:
        for workers in workers_list:
            for kind in ('d', 's'):
                lines.append(command(variant, kind, workers, lanes, time))
    with open(f'{D}/{name}.list', 'w') as f:
        f.write('\n'.join(lines) + '\n')


write('small-threads', VARIANTS, ['1', '2000'], 8, False, '#501: 1 and 2,000 workers on the threads, every variant')
write('big-threads', VARIANTS, ['102400'], 8, False, '#501: 102,400 workers on the threads, every variant')
write('small-one', VARIANTS[:3], ['1', '2000'], 1, False, '#501: 1 and 2,000 workers on one lane, CPU 2, by main twice and the head')
write('big-one', VARIANTS[:3], ['102400'], 1, False, '#501: 102,400 workers on one lane, CPU 2, by main twice and the head')
write('small-time', VARIANTS, ['1', '2000'], 8, True, '#501: --time of 1 and 2,000 workers on the threads, every variant')
write('big-time', VARIANTS, ['102400'], 8, True, '#501: --time of 102,400 workers on the threads, every variant')
