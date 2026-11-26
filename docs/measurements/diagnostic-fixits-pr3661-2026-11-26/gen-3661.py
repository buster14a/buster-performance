print('#define MATCH_ASSIGN(n) (n) = 3')
for number in range(512):
    condition = 'MATCH_ASSIGN(n)' if number % 2 else 'n = 3'
    print(f'int diagnostic_{number}(int n) {{')
    print(f'    if ({condition}) n += 2;')
    print('    (void)("abc" + n);')
    print('    return n;')
    print('}')
