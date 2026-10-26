#!/usr/bin/env python3
# lists501c.py: the confirmation campaign's procbench lists (#501), in confirm/: lists501.py's commands by main (m1 and
# m2, the same executable, v0) and the final head (fn, v3: the team with its workers' scratch arenas kept). The first
# campaign ran each variant's first case right after another variant's executable, and the variants that followed their
# own executable there ran faster (main's second run 5% on the 1-worker dynamic PIE): here each variant's block starts
# with a warm-up command (w..., left out of the analysis), the 1-worker dynamic PIE by its executable, so that every
# measured command follows a run of its own executable. Every command gets BUSTER_501_SCRATCH=free, as in the first
# campaign, which the final build doesn't read.
#   small-threads: 1 and 2,000 workers, --lanes=8 unpinned, 20 ms before each run;
#   big-threads: 102,400 workers, --lanes=8, 200 ms before each run;
#   small-one, big-one: the same on one lane pinned to CPU 2, by m1, m2 and hd;
#   small-time, big-time: the threaded ones with --time, each run's report kept (capture).
import glob
import os

D = os.environ.get('D501', os.path.expanduser('~/buster-fast-bench/perf-501-claude/confirm'))
P = os.path.dirname(D)
EVENTS = 'events=task-clock:cycles:instructions:context-switches:cpu-migrations:page-faults'
VARIANTS = [('m1', 'v0', 'free'), ('m2', 'v0', 'free'), ('fn', 'v3', 'free')]
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
    '1': objects(f'{P}/links1/buster-link-benchmark-*/objects', 4),
    '2000': objects(os.environ.get('P2000', '~/buster-fast-bench/perf-445-446-claude/links2000/buster-link-benchmark-GaN1iP/objects'), 10),
    '102400': objects(os.environ.get('P102400', '~/buster-fast-bench/perf-445-446-claude/links/buster-link-benchmark-AD5nXI/objects'), 512),
}


def command(variant, kind, workers, lanes, time, warm=False, pause=None):
    label, tree, scratch = variant
    name = f'{"w" if warm else ""}{label}-{kind}{workers}-{lanes}'
    exe = f'{P}/{tree}/build/compiler'
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
    pause = pause if pause is not None else 200 if workers == '102400' else 20
    options = f'runs=1,pause={pause},{EVENTS},var=BUSTER_501_SCRATCH={scratch}'
    if lanes == 1:
        options += ',cpu=2'
    if time:
        options += ',capture'
    return f'{name}|{options}|{line}'


def write(name, variants, workers_list, lanes, time, comment):
    lines = [f'# {comment}']
    for variant in variants:
        lines.append(command(variant, 'd', '1', lanes, time, warm=True, pause=200 if '102400' in workers_list else 20))
        for workers in workers_list:
            for kind in ('d', 's'):
                lines.append(command(variant, kind, workers, lanes, time))
    with open(f'{D}/{name}.list', 'w') as f:
        f.write('\n'.join(lines) + '\n')


write('small-threads', VARIANTS, ['1', '2000'], 8, False, '#501 confirmation: 1 and 2,000 workers on the threads, main twice and the final head')
write('big-threads', VARIANTS, ['102400'], 8, False, '#501 confirmation: 102,400 workers on the threads')
write('small-one', VARIANTS, ['1', '2000'], 1, False, '#501 confirmation: 1 and 2,000 workers on one lane, CPU 2')
write('big-one', VARIANTS, ['102400'], 1, False, '#501 confirmation: 102,400 workers on one lane, CPU 2')
write('small-time', VARIANTS, ['1', '2000'], 8, True, '#501 confirmation: --time of 1 and 2,000 workers on the threads')
write('big-time', VARIANTS, ['102400'], 8, True, '#501 confirmation: --time of 102,400 workers on the threads')
