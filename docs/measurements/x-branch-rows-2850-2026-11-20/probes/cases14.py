# cases14.py: a tested value that might have a conversion of its own before its test (a decay, a qualifier's or an
# atomic's read, a bit-field, a class past double's), one statement at a time, with the statement after it in the same
# function: a row whose entries' number were not its shape's would move the rows after it in its eight records.
P = ('struct pair { int first; long second; char third; _Bool flag; }; struct outer { struct pair inner; struct pair* link; int list[4]; };\n'
     'struct bits { unsigned bit : 1; _Bool flag : 1; int wide : 7; long far : 40; }; enum color { RED, GREEN };\n'
     'extern int global; extern struct outer global_outer; int callee(int a, long b); extern const _Bool global_flag; extern int global_list[8];\n')
F = P + 'int f(int a, long b, char c, short h, unsigned char u, int* p, struct outer* o, double d, _Bool t, float f, const _Bool cb, const struct outer* co, unsigned long ul) { int local = 0; long wide = 0; %s return local + (int)wide; }\n'
def S(name, statement): C(name, F % statement)
values = {
    'local_array': ('int arr[4]; arr[0] = a;', 'arr'), 'member_array': ('', 'o->list'), 'global_member_array': ('', 'global_outer.list'), 'global_array': ('', 'global_list'),
    'row': ('int grid[2][2]; grid[0][0] = a;', 'grid[a]'), 'pointed_array': ('int (*pa)[4] = &o->list;', '*pa'),
    'function': ('', 'callee'), 'function_pointer': ('int (*fp)(int, long) = callee;', 'fp'), 'function_pointed': ('int (*fp)(int, long) = callee;', '*fp'),
    'volatile_bool': ('volatile _Bool vb = t;', 'vb'), 'atomic_bool': ('_Atomic _Bool ab = t;', 'ab'), 'global_const_bool': ('', 'global_flag'),
    'const_char': ('const char cc = c;', 'cc'), 'const_short': ('const short cs = h;', 'cs'), 'const_long': ('const long cl = b;', 'cl'), 'const_double': ('const double cd = d;', 'cd'),
    'const_pointer': ('int* const cp = p;', 'cp'), 'volatile_int': ('volatile int vi = a;', 'vi'), 'atomic_int': ('_Atomic int ai = a;', 'ai'), 'volatile_char': ('volatile char vc = c;', 'vc'),
    'bitfield': ('struct bits bits = { 0 }; bits.bit = a;', 'bits.bit'), 'bitfield_bool': ('struct bits bits = { 0 }; bits.flag = t;', 'bits.flag'),
    'bitfield_wide': ('struct bits bits = { 0 }; bits.wide = a;', 'bits.wide'), 'bitfield_far': ('struct bits bits = { 0 }; bits.far = b;', 'bits.far'),
    'enum': ('enum color e = GREEN;', 'e'), 'cast_bool': ('', '(_Bool)a'), 'cast_const_bool': ('', '(const _Bool)a'), 'cast_const_char': ('', '(const char)a'),
    'compound_literal': ('', '(int){a}'), 'compound_literal_bool': ('', '(const _Bool){t}'), 'long_double': ('long double ld = d;', 'ld'), 'int128': ('__int128 big = a;', 'big'),
    'complex': ('_Complex double z = d;', 'z'), 'assign_bool': ('', '(t = a)'), 'assign_const_read': ('', '(t = cb)'), 'bool_and_mask': ('', '(t & cb)'), 'bool_equal': ('', 'cb == t'),
    'const_bool_member_pointed': ('', 'co->link->flag'), 'pointer_to_const_bool': ('const _Bool* pb = &cb;', '*pb'), 'subscript_const_bool': ('const _Bool flags[2] = { 1, 0 };', 'flags[a]'),
    'unsigned_short': ('unsigned short us = (unsigned short)a;', 'us'), 'signed_char': ('signed char sc = (signed char)a;', 'sc'), 'unsigned': ('unsigned un = (unsigned)a;', 'un'),
    'float': ('', 'f'), 'wchar': ('__WCHAR_TYPE__ w = a;', 'w'), 'char16': ('__CHAR16_TYPE__ c16 = (__CHAR16_TYPE__)a;', 'c16'),
}
for name, (declaration, value) in values.items():
    S('first_%s' % name, '%s if (%s && a) local = 1;' % (declaration, value))
    S('second_%s' % name, '%s if (a || %s) local = 1;' % (declaration, value))
    S('negated_%s' % name, '%s if (a && !%s) local = 1;' % (declaration, value))
    S('do_%s' % name, '%s do { local++; } while (local < 3 && %s);' % (declaration, value))
    S('both_%s' % name, '%s if (%s || !%s) local = 1; wide = local + 1; b = wide * 2;' % (declaration, value, value))
