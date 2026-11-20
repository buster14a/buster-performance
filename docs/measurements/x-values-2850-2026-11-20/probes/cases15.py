# cases15.py: the entries' values (#2850's values piece), a constant's: each class of integer constant, its own class's
# and folded to each class and to bool; a floating one's of each class; an address constant's, with and without an
# object and an offset; a member's offset; a pointer's stride of each element. One statement, or one group of
# statements of one kind, a file, with the statement after it.
P = ('struct pair { int first; long second; char third; _Bool flag; }; struct outer { struct pair inner; struct pair* link; int list[4]; };\n'
     'struct big { char pad[70000]; int far; long farther; char last; }; struct huge { char pad[4294967296]; int far; long farther; };\n'
     'extern int global; extern long global_long; extern struct outer global_outer; extern int table[8]; extern struct big global_big; extern struct huge global_huge;\n'
     'static int file_static; static long file_table[6];\n'
     'int callee(int a, long b); long wider(long a);\n')
F = P + ('int f(int a, long b, char c, short h, unsigned char u, int* p, struct outer* o, double d, _Bool t, float f, long* lp, char* cp, struct big* bp, struct huge* hp,\n'
         '      char (*rows)[4294967296], short* sp, double* dp, struct pair* pp, int (*grid)[4], void** vp)\n'
         '{ int local = 0; long wide = 0; char narrow = 0; _Bool flag = 0; double value = 0; float single = 0; int list[4]; struct outer whole; int* q = 0; static int inner_static;\n'
         '  %s\n  return local + (int)wide + narrow + flag + (int)value + (int)single + list[0] + whole.inner.first + (q != 0) + inner_static; }\n')
def S(name, statement): C(name, F % statement)
types = {'char': 'char', 'schar': 'signed char', 'uchar': 'unsigned char', 'short': 'short', 'ushort': 'unsigned short', 'int': 'int', 'uint': 'unsigned', 'long': 'long',
         'ulong': 'unsigned long', 'llong': 'long long', 'ullong': 'unsigned long long', 'bool': '_Bool'}
constants = {'zero': '0', 'one': '1', 'minus_one': '-1', 'c127': '127', 'c128': '128', 'c255': '255', 'c256': '256', 'm128': '-128', 'm129': '-129', 'c32767': '32767',
             'c32768': '32768', 'c65535': '65535', 'c65536': '65536', 'm32768': '-32768', 'm32769': '-32769', 'int_max': '2147483647', 'int_min': '(-2147483647 - 1)',
             'u31': '2147483648u', 'uint_max': '4294967295u', 'l32': '4294967296l', 'l31': '2147483648l', 'lm31': '-2147483649l', 'long_max': '9223372036854775807l',
             'long_min': '(-9223372036854775807l - 1)', 'ulong_max': '18446744073709551615ul', 'u63': '9223372036854775808ul', 'letter': "'x'", 'wide_letter': "L'x'",
             'size': 'sizeof(int)', 'cast_char': '(char)-1', 'cast_schar': '(signed char)-3', 'cast_uchar': '(unsigned char)200', 'cast_short': '(short)-2',
             'cast_ushort': '(unsigned short)40000', 'cast_cut': '(char)300', 'cast_cut_short': '(short)70000', 'long_one': '1l', 'long_minus': '-1l', 'ulong_one': '1ul',
             'unsigned_five': '5u', 'hex_high': '0xffffffff', 'hex_wide': '0xffffffffffffffff', 'hex_sign': '0x80000000', 'not_zero': '~0', 'not_zero_u': '~0u',
             'not_zero_l': '~0l', 'folded_sum': '(1 + 2 * 3)', 'folded_shift': '(1 << 31)', 'folded_long_shift': '(1l << 63)', 'enum_like': '(int)sizeof(long) - 9',
             'bool_true': '(_Bool)5', 'compare': '(3 > 2)', 'negated': '!5'}
for t, spelled in types.items():
    S('to_%s' % t, '%s v; %s local = (int)v;' % (spelled, ' '.join('v = %s;' % c for c in constants.values())))
    S('init_%s' % t, ' '.join('%s v%d = %s; local += (int)v%d;' % (spelled, i, c, i) for i, c in enumerate(constants.values())))
for name, c in constants.items():
    S('each_%s' % name, ' '.join('%s v%s = 0; v%s = %s; local += (int)v%s;' % (spelled, t, t, c, t) for t, spelled in types.items()))
    S('plain_%s' % name, 'wide = %s; local = (int)wide; u = %s; flag = %s; value = d;' % (c, c, c))
    S('return_%s' % name, 'if (a) return %s; local = a;' % c)
    S('argument_%s' % name, 'local = callee(%s, %s); wide = wider(%s);' % (c, c, c))
    S('compared_%s' % name, 'local = a == %s; wide = b < %s; flag = u != %s;' % (c, c, c))
floats = {'zero': '0.0', 'minus_zero': '-0.0', 'one': '1.0', 'minus_one': '-1.0', 'half': '0.5', 'tenth': '0.1', 'big': '1e300', 'small': '1e-300', 'max': '1.7976931348623157e308',
          'min': '2.2250738585072014e-308', 'denormal': '5e-324', 'float_max': '3.4028235e38', 'past_float': '1e39', 'odd': '16777217.0', 'third': '(1.0 / 3.0)',
          'f_zero': '0.0f', 'f_minus_zero': '-0.0f', 'f_one': '1.5f', 'f_tenth': '0.1f', 'f_minus': '-0.1f', 'f_denormal': '1e-45f', 'f_max': '3.4028235e38f', 'f_odd': '16777217.0f',
          'f_min': '1.17549435e-38f', 'hex': '0x1.8p3', 'hex_f': '0x1.fffffep127f', 'inf': '__builtin_inf()', 'minus_inf': '-__builtin_inf()', 'inf_f': '__builtin_inff()',
          'huge': '__builtin_huge_val()', 'nan': '__builtin_nan("")', 'nan_f': '__builtin_nanf("")', 'nan_payload': '__builtin_nan("0x1234")', 'nans': '__builtin_nans("")',
          'nans_f': '__builtin_nansf("")', 'minus_nan': '-__builtin_nan("")', 'long_double': '2.5l', 'long_double_zero': '0.0l', 'integer': '3', 'integer_big': '16777217',
          'integer_exact': '16777216', 'cast_int': '(double)7', 'cast_float': '(float)2.5', 'cast_double': '(double)1.5f', 'sum': '(0.5 + 0.25)', 'product': '(3.0f * 0.5f)'}
for name, c in floats.items():
    S('double_%s' % name, 'value = %s; local = a;' % c)
    S('float_%s' % name, 'single = %s; local = a;' % c)
    S('float_both_%s' % name, 'double v = %s; float w = %s; value = v + w; single = (float)(d * %s);' % (c, c, c))
    S('float_compared_%s' % name, 'local = d < %s; flag = f == %s; if (d > %s) local = 1;' % (c, c, c))
    S('float_return_%s' % name, 'if (a) return (int)(d + %s); value = d;' % c)
    S('float_argument_%s' % name, 'value = __builtin_fabs(%s) + d; local = callee((int)%s, 2);' % (c, c))
addresses = {'local': 'q = &local;', 'global': 'q = &global;', 'file_static': 'q = &file_static;', 'inner_static': 'q = &inner_static;', 'list2': 'q = &list[2];', 'table3': 'q = &table[3];',
             'table0': 'q = &table[0];', 'file_table': 'lp = &file_table[4];', 'member_local': 'lp = &whole.inner.second;', 'member_global': 'lp = &global_outer.inner.second;',
             'first_member_local': 'q = &whole.inner.first;', 'first_member_global': 'q = &global_outer.inner.first;', 'list_decay': 'q = list;', 'table_decay': 'q = table;',
             'sixteen': 'q = (int*)16;', 'null_cast': 'q = (int*)0;', 'null': 'q = 0;', 'minus_one': 'cp = (char*)-1;', 'high': 'cp = (char*)0xffffffff00000000;',
             'string': 'cp = (char*)"text";', 'string_offset': 'cp = (char*)"text" + 2;', 'string_element': 'cp = (char*)&"text"[1];', 'offset_of': 'lp = &((struct pair*)0)->second;',
             'offset_of_cast': 'wide = (long)&((struct pair*)0)->third;', 'cast_long': 'wide = (long)&table[5];', 'cast_local': 'wide = (long)&list[1];', 'cast_int': 'local = (int)(long)&global;',
             'function': 'int (*fp)(int, long) = callee; local = fp(a, b);', 'function_address': 'int (*fp)(int, long) = &callee; local = fp(a, b);',
             'global_list': 'q = &global_outer.list[3];', 'char_offset': 'cp = (char*)&global + 1;', 'table_sum': 'q = table + 2;', 'table_difference': 'q = &table[7] - 3;',
             'before': 'q = &table[2] - 5;', 'far_member': 'q = &global_big.far;', 'farther_member': 'lp = &global_big.farther;', 'huge_member': 'q = &global_huge.far;',
             'huge_farther': 'lp = &global_huge.farther;', 'local_plus': 'q = &local + 1;', 'whole': 'struct outer* w = &whole; local = w->inner.first;',
             'global_whole': 'struct outer* w = &global_outer; local = w->inner.first;', 'link': 'struct pair** l = &whole.link; local = (*l)->first;',
             'bool_address': 'flag = &global;', 'compared_address': 'local = q == &global; flag = p != &table[2];', 'address_difference': 'wide = &table[5] - &table[2];',
             'address_argument': 'local = callee(a, (long)&global); wide = wider((long)&table[3]);', 'return_address': 'if (a) return (int)(long)&table[6]; local = a;'}
for name, statement in addresses.items():
    S('address_%s' % name, '%s local += a;' % statement)
members = {'first': 'local = o->inner.first;', 'second': 'wide = o->inner.second;', 'third': 'narrow = o->link->third;', 'list': 'local = o->list[2];', 'store': 'o->inner.second = b;',
           'link_store': 'o->link->third = c;', 'local_first': 'local = whole.inner.first;', 'local_second': 'wide = whole.inner.second;', 'global_second': 'wide = global_outer.inner.second;',
           'global_list': 'local = global_outer.list[3];', 'flag': 'flag = o->inner.flag;', 'far': 'local = bp->far;', 'farther': 'bp->farther = b;', 'last': 'narrow = bp->last;',
           'huge': 'local = hp->far;', 'huge_farther': 'hp->farther = b;', 'global_far': 'local = global_big.far;', 'global_huge': 'wide = global_huge.farther;',
           'address': 'lp = &o->inner.second;', 'far_address': 'lp = &bp->farther;', 'huge_address': 'lp = &hp->farther;', 'chain': 'local = o->link->first + o->inner.first;',
           'dot_arrow': 'wide = (*o).inner.second;', 'pointed_pair': 'wide = pp->second; narrow = pp->third;', 'indexed_member': 'wide = pp[a].second; narrow = pp[2].third;',
           'member_index': 'local = o->list[a]; o->list[a] = local;', 'union_member': 'union both { int whole; float part; long wide; } un; un.whole = a; single = un.part;'}
for name, statement in members.items():
    S('member_%s' % name, '%s local += a;' % statement)
pointers = {'char': ('cp', 'narrow'), 'short': ('sp', 'h'), 'int': ('p', 'local'), 'long': ('lp', 'wide'), 'double': ('dp', 'value'), 'pair': ('pp', None), 'outer': ('o', None),
            'grid': ('grid', None), 'rows': ('rows', None), 'void_pointer': ('vp', None), 'big': ('bp', None), 'huge': ('hp', None)}
for name, (pointer, value) in pointers.items():
    S('stride_sum_%s' % name, 'void* r = %s + a; local = r != 0;' % pointer)
    S('stride_difference_%s' % name, 'void* r = %s - a; local = r != 0;' % pointer)
    S('stride_swapped_%s' % name, 'void* r = a + %s; local = r != 0;' % pointer)
    S('stride_long_%s' % name, 'void* r = %s + b; void* s = %s - b; local = r != s;' % (pointer, pointer))
    S('stride_constant_%s' % name, 'void* r = %s + 3; void* s = %s - 2; local = r != s;' % (pointer, pointer))
    S('stride_address_%s' % name, 'void* r = &%s[a]; local = r != 0;' % pointer)
    S('stride_distance_%s' % name, 'wide = (%s + a) - %s; local = a;' % (pointer, pointer))
    for update in ('%s++;', '++%s;', '%s--;', '--%s;', '%s += a;', '%s -= a;', '%s += 2;', '%s -= b;'):
        S('stride_update_%s_%s' % (name, update.replace('%s', 'x').replace(' ', '').replace(';', '').replace('+', 'p').replace('-', 'm').replace('=', 'e')), (update % pointer) + ' local = a;')
    S('stride_update_value_%s' % name, 'void* r = %s++; void* s = --%s; local = r != s;' % (pointer, pointer))
    if value is not None:
        S('stride_subscript_%s' % name, '%s = %s[a]; local = a;' % (value, pointer))
        S('stride_store_%s' % name, '%s[a] = %s; local = a;' % (pointer, value))
        S('stride_walk_%s' % name, '%s = *%s++; *%s++ = %s; local = a;' % (value, pointer, pointer, value))
        S('stride_kept_%s' % name, '%s[a]++; %s = %s[b]--; local = a;' % (pointer, value, pointer))
