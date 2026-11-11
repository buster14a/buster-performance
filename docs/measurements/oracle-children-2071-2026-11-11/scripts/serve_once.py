#!/usr/bin/env python3
# Sends command lines to tools/clang-server (its protocol: clang_server.cpp's header comment) and compares each with a
# spawned run in the same directory and environment, its standard input /dev/null.
# Usage: serve_once.py SERVER STREAMS REPEAT -- ARGUMENT...
import os
import struct
import subprocess
import sys

server, streams, repeat = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
arguments = sys.argv[sys.argv.index('--') + 1:]
environment = [f'{k}={v}' for k, v in os.environ.items() if k not in ('CPATH', 'C_INCLUDE_PATH')]
process = subprocess.Popen([server], stdin=subprocess.PIPE, stdout=subprocess.PIPE)


def text(value):
    data = value.encode()
    return struct.pack('=I', len(data)) + data


def receive(size):
    data = b''
    while len(data) < size:
        chunk = process.stdout.read(size - len(data))
        if not chunk:
            raise SystemExit('server ended')
        data += chunk
    return data


process.stdin.write(struct.pack('=III', 0, 2, 0))
process.stdin.flush()
status, = struct.unpack('=i', receive(4))
length, = struct.unpack('=I', receive(4))
print('server release', receive(length).decode())
child_environment = dict(kv.split('=', 1) for kv in environment)
spawned = subprocess.run(arguments, stdin=subprocess.DEVNULL, capture_output=True, env=child_environment)
for r in range(repeat):
    request = struct.pack('=III', len(arguments), streams, len(environment)) + text(os.getcwd())
    request += b''.join(text(a) for a in arguments) + b''.join(text(e) for e in environment)
    process.stdin.write(request)
    process.stdin.flush()
    status, = struct.unpack('=i', receive(4))
    got = []
    for c in range(2):
        if streams & (1 << c):
            length, = struct.unpack('=I', receive(4))
            got.append(receive(length))
        else:
            got.append(None)
    same = status == spawned.returncode and (got[0] is None or got[0] == spawned.stdout) and (got[1] is None or got[1] == spawned.stderr)
    print(f'request {r}: status {status} (spawned {spawned.returncode}), same: {same}')
    if not same:
        print('served errors:', (got[1] or b'')[:3000].decode(errors='replace'))
        print('spawned errors:', spawned.stderr[:3000].decode(errors='replace'))
process.stdin.close()
process.wait()
