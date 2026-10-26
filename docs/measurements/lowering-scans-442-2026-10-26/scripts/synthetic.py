#!/usr/bin/env python3
# #442: synthetic units for the generated names' scale, written to DIR: block-scope statics (a made name each,
# "fN.counter"), the same with an asm label taking every made name first (each made name then gets ".N"), file-scope
# compound literals (".compoundliteral", then ".compoundliteral.N"), and plain functions and globals (no made name),
# each with COUNT definitions. Usage: synthetic.py DIR COUNT
import sys, os
d, n = sys.argv[1], int(sys.argv[2])
os.makedirs(d, exist_ok=True)
def write(name, body):
    open(os.path.join(d, name), 'w').write(body)
write(f'statics-{n}.c', ''.join(f'int f{i}(void) {{ static int counter = {i}; return ++counter; }}\n' for i in range(n)) +
      'int main(void) { int s = 0;\n' + ''.join(f'    s += f{i}();\n' for i in range(n)) + '    return s & 1; }\n')
write(f'collisions-{n}.c', ''.join(f'int taken{i} __asm__("f{i}.counter") = {i};\n' for i in range(n)) +
      ''.join(f'int f{i}(void) {{ static int counter = {i}; return ++counter + taken{i}; }}\n' for i in range(n)) +
      'int main(void) { int s = 0;\n' + ''.join(f'    s += f{i}();\n' for i in range(n)) + '    return s & 1; }\n')
write(f'literals-{n}.c', ''.join(f'int* p{i} = (int[]){{ {i}, {i + 1} }};\n' for i in range(n)) +
      'int main(void) { int s = 0;\n' + ''.join(f'    s += p{i}[1];\n' for i in range(n)) + '    return s & 1; }\n')
write(f'plain-{n}.c', ''.join(f'int g{i} = {i};\nint f{i}(void) {{ return ++g{i}; }}\n' for i in range(n)) +
      'int main(void) { int s = 0;\n' + ''.join(f'    s += f{i}();\n' for i in range(n)) + '    return s & 1; }\n')
