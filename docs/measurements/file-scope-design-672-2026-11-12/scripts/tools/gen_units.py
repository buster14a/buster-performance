#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# gen_units.py COUNT OUT_DIR: COUNT small C units over the host's own (glibc) headers, each including 8 of 30 common
# headers, chosen by a fixed generator, and defining two functions that call a few of what they declare: a second
# header style for the emulation beside musl's own headers (attributes on every prototype, asm labels, inline bodies).
# Original text; nothing is copied from a library.
import os, sys

HEADERS = ['stdio.h', 'stdlib.h', 'string.h', 'unistd.h', 'errno.h', 'fcntl.h', 'sys/types.h', 'sys/stat.h', 'time.h', 'signal.h', 'pthread.h',
           'math.h', 'ctype.h', 'limits.h', 'stdint.h', 'inttypes.h', 'stdarg.h', 'stddef.h', 'dirent.h', 'sys/socket.h', 'netinet/in.h',
           'arpa/inet.h', 'sys/mman.h', 'sys/wait.h', 'poll.h', 'locale.h', 'wchar.h', 'setjmp.h', 'assert.h', 'sys/time.h']
USES = {
    'stdio.h': 'r += puts(text) + snprintf(buffer, sizeof buffer, "%d", x);',
    'stdlib.h': 'r += abs(x) + atoi(text); free(malloc((size_t)(x & 15) + 1));',
    'string.h': 'r += (int)strlen(text) + memcmp(text, buffer, 1); memset(buffer, 0, sizeof buffer);',
    'unistd.h': 'r += (int)getpid() + close(-1);',
    'errno.h': 'r += errno;',
    'fcntl.h': 'r += open(text, O_RDONLY);',
    'sys/stat.h': '{ struct stat s; r += stat(text, &s) + (int)s.st_size; }',
    'time.h': 'r += (int)time((time_t*)0);',
    'signal.h': 'r += raise(0);',
    'pthread.h': 'r += (int)(pthread_self() != (pthread_t)0);',
    'math.h': 'r += (int)floor((double)x);',
    'ctype.h': 'r += isalpha(x) + toupper(x);',
    'limits.h': 'r += x == INT_MAX;',
    'stdint.h': '{ uint32_t u = (uint32_t)x; r += (int)(u >> 3); }',
    'inttypes.h': '{ intmax_t m = x; r += (int)imaxabs(m); }',
    'dirent.h': '{ DIR* d = opendir(text); r += d != (DIR*)0; }',
    'sys/socket.h': 'r += socket(AF_INET, SOCK_STREAM, 0);',
    'netinet/in.h': '{ struct in_addr a; a.s_addr = (in_addr_t)x; r += (int)a.s_addr; }',
    'arpa/inet.h': 'r += (int)htonl((uint32_t)x);',
    'sys/mman.h': 'r += munmap((void*)0, 0);',
    'sys/wait.h': 'r += (int)wait((int*)0);',
    'poll.h': 'r += poll((struct pollfd*)0, 0, 0);',
    'locale.h': 'r += setlocale(LC_ALL, text) != (char*)0;',
    'wchar.h': 'r += (int)wcslen(L"w");',
    'setjmp.h': '{ jmp_buf j; r += setjmp(j); }',
    'assert.h': 'assert(x != 12345);',
    'sys/time.h': '{ struct timeval t; r += gettimeofday(&t, (void*)0); }',
}
count, out_dir = int(sys.argv[1]), sys.argv[2]
os.makedirs(out_dir, exist_ok=True)
state = 20261112
def random():
    global state
    state = (state * 6364136223846793005 + 1442695040888963407) % (1 << 64)
    return state >> 33
for unit in range(count):
    chosen = []
    while len(chosen) < 8:
        h = HEADERS[random() % len(HEADERS)]
        if h not in chosen:
            chosen.append(h)
    lines = [f'#include <{h}>' for h in chosen]
    lines.append(f'static int helper_{unit}(int x, const char* text)')
    lines.append('{')
    lines.append('    char buffer[32];')
    lines.append('    int r = x;')
    lines.append('    buffer[0] = text[0];')
    for h in chosen:
        if h in USES and (h != 'arpa/inet.h' or 'stdint.h' in chosen) and (h != 'inttypes.h' or True):
            lines.append('    ' + USES[h])
    lines.append('    return r + buffer[0];')
    lines.append('}')
    lines.append(f'int unit_{unit}(int x, const char* text)')
    lines.append('{')
    lines.append(f'    return helper_{unit}(x, text) + {unit};')
    lines.append('}')
    open(os.path.join(out_dir, f'u{unit:04d}.c'), 'w').write('\n'.join(lines) + '\n')
