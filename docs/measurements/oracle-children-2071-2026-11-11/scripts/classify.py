#!/usr/bin/env python3
# Classifies the clang processes an `strace -f -e trace=execve,clone,clone3,fork,vfork` log shows: each successful
# execve whose program is clang, by its arguments and by the programs that led to it: the programs its process ran
# before it (a shell or env that execs clang, a wrapper script) or, if none, the one its parent ran.
# Usage: classify.py TRACE
import re
import sys
from collections import Counter

line_re = re.compile(r'^(\d+)\s+(.*)$')
exec_re = re.compile(r'execve\("([^"]*)", \[(.*)\], .*\) = 0')
clone_re = re.compile(r'^(clone3?|fork|vfork)\(.*\) = (\d+)')
resumed_re = re.compile(r'^<\.\.\. (clone3?|fork|vfork) resumed>.*\) = (\d+)')

parent = {}
program = {}
chain = {}
pending = {}
runs = []
for raw in open(sys.argv[1], errors='replace'):
    m = line_re.match(raw)
    if not m:
        continue
    pid = int(m.group(1))
    rest = m.group(2)
    c = clone_re.search(rest) or resumed_re.search(rest)
    if c:
        child = int(c.group(2))
        parent[child] = pid
        program[child] = program.get(pid, '?')
        continue
    # An execve that strace splits around another process's call: its arguments on the first line, its result on
    # the resumed one.
    if 'execve(' in rest and rest.endswith('<unfinished ...>'):
        pending[pid] = rest[:-len('<unfinished ...>')].rstrip()
        continue
    if rest.startswith('<... execve resumed>'):
        rest = pending.pop(pid, '') + rest[len('<... execve resumed>'):]
    e = exec_re.search(rest)
    if e:
        path = e.group(1)
        argv = re.findall(r'"((?:[^"\\]|\\.)*)"', e.group(2))
        before = chain.get(pid, [])
        chain[pid] = before + [path]
        if path.endswith('/clang') or path.endswith('/clang-23'):
            by = before[-1] if before else program.get(parent.get(pid), '?')
            runs.append((argv, by))
        program[pid] = path


def kind(argv, by):
    text = ' '.join(argv)
    if by.endswith('/env') or by.endswith('/sh') or by.endswith('/bash') or by.endswith('/dash'):
        return "through sh and env (the predefines' shell commands): " + ' '.join(argv[1:4])
    if 'clang-release' in by or 'trampoline' in by or 'clang-release' in text:
        return "through the release fixture's wrapper script"
    if by == '/proc/self/exe':
        return "a nested run of the test's executable (the location option's checks): " + ' '.join(argv[1:4])
    if '-dumpversion' in argv:
        return "the client's release check (-dumpversion)"
    if '--version' in argv:
        return '--version (the reference report)'
    if '-print-stats' in argv:
        return "directives: clang's guard count (-E -o /dev/null -Xclang -print-stats)"
    if '-fno-color-diagnostics' in argv:
        return "directives: clang's diagnostics (-E -o /dev/null)"
    if '-fmacro-backtrace-limit=0' in argv and '-nostdinc' in argv:
        return "system warnings: clang's diagnostics"
    if '-fmacro-backtrace-limit=0' in argv:
        return "history: clang's diagnostics"
    if argv[1:4] == ['-E', '-P', '-std=gnu17']:
        return "directives: the guards' text (-E -P)"
    if not by.endswith('compiler'):
        return 'started by ' + by + ': ' + ' '.join(argv[1:4])
    return 'other: ' + ' '.join(argv[1:6])


counts = Counter(kind(argv, by) for argv, by in runs)
for name, n in sorted(counts.items(), key=lambda item: (-item[1], item[0])):
    print(f'{n:6d}  {name}')
print(f'{sum(counts.values()):6d}  clang processes')
