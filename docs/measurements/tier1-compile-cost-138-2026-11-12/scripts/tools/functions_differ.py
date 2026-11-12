#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# functions_differ.py A.o B.o: the functions whose code bytes differ between two relocatable objects of one source, by
# symbol: readelf's section and symbol tables, and each function's bytes at its section's offset. Prints the count of
# functions, those of another size or other bytes, and their names.
import subprocess, sys

def read(path):
    data = open(path, 'rb').read()
    sections = {}
    for line in subprocess.run(['readelf', '-SW', path], capture_output=True, text=True).stdout.splitlines():
        line = line.strip()
        if line.startswith('[') and ']' in line:
            index = line[1:line.index(']')].strip()
            parts = line[line.index(']') + 1:].split()
            if index.isdigit() and len(parts) >= 5:
                sections[int(index)] = int(parts[3], 16)
    functions = {}
    for line in subprocess.run(['readelf', '-sW', path], capture_output=True, text=True).stdout.splitlines():
        parts = line.split()
        if len(parts) >= 8 and parts[3] == 'FUNC' and parts[6].isdigit():
            offset = sections[int(parts[6])] + int(parts[1], 16)
            size = int(parts[2], 0)
            functions[parts[7]] = data[offset:offset + size]
    return functions

def main():
    a, b = read(sys.argv[1]), read(sys.argv[2])
    names = sorted(set(a) | set(b))
    different = [n for n in names if a.get(n) != b.get(n)]
    print(f'functions {len(names)} differing {len(different)}')
    for n in different:
        print(f'{n}\t{len(a.get(n, b""))}\t{len(b.get(n, b""))}')

main()
