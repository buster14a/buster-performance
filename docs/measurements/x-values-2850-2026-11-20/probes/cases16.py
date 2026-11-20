# cases16.py: the entries' values, a store's and an update's: by name of a local, a parameter, a global and a static
# object of each class, each operator; and through an address, prefix and postfix.
P = ('struct pair { int first; long second; char third; _Bool flag; }; struct outer { struct pair inner; struct pair* link; int list[4]; };\n'
     'extern int global; extern long global_long; extern char global_char; extern double global_double; extern float global_float; extern unsigned char global_uchar;\n'
     'extern short global_short; extern int* global_pointer; extern struct outer global_outer; extern int table[8];\n'
     'static int file_int; static long file_long; static double file_double; static char file_char;\n'
     'int callee(int a, long b); long wider(long a);\n')
F = P + ('int f(int a, long b, char c, short h, unsigned char u, int* p, struct outer* o, double d, _Bool t, float f, long* lp, char* cp, unsigned long ul, unsigned short us)\n'
         '{ int local = 0; long wide = 0; char narrow = 0; double value = 0; float single = 0; int list[4]; struct outer whole; int* q = p; static int inner_static; static double inner_double;\n'
         '  %s\n  return local + (int)wide + narrow + (int)value + (int)single + list[0] + whole.inner.first + *q + inner_static + (int)inner_double; }\n')
def S(name, statement): C(name, F % statement)
names = {'local': ('local', 'int'), 'wide': ('wide', 'long'), 'narrow': ('narrow', 'char'), 'value': ('value', 'double'), 'single': ('single', 'float'), 'parameter': ('a', 'int'),
         'parameter_long': ('b', 'long'), 'parameter_char': ('c', 'char'), 'parameter_short': ('h', 'short'), 'parameter_uchar': ('u', 'unsigned char'), 'parameter_double': ('d', 'double'),
         'parameter_float': ('f', 'float'), 'parameter_ulong': ('ul', 'unsigned long'), 'parameter_ushort': ('us', 'unsigned short'), 'global': ('global', 'int'),
         'global_long': ('global_long', 'long'), 'global_char': ('global_char', 'char'), 'global_double': ('global_double', 'double'), 'global_float': ('global_float', 'float'),
         'global_uchar': ('global_uchar', 'unsigned char'), 'global_short': ('global_short', 'short'), 'file_int': ('file_int', 'int'), 'file_long': ('file_long', 'long'),
         'file_double': ('file_double', 'double'), 'file_char': ('file_char', 'char'), 'inner_static': ('inner_static', 'int'), 'inner_double': ('inner_double', 'double')}
operators = {'assign': '%s = a;', 'assign_constant': '%s = 5;', 'assign_long': '%s = b;', 'post_increment': '%s++;', 'pre_increment': '++%s;', 'post_decrement': '%s--;',
             'pre_decrement': '--%s;', 'add': '%s += a;', 'subtract': '%s -= b;', 'multiply': '%s *= a;', 'add_constant': '%s += 2;', 'add_double': '%s += d;',
             'value_post': 'wide = %s++;', 'value_pre': 'wide = --%s;', 'value_add': 'wide = (%s += 3);', 'value_assign': 'wide = (%s = a);', 'read': 'wide = (long)%s;',
             'twice': '%s++; %s--;', 'tested': 'if (%s++) local = 1;', 'argument': 'wider(%s++); wider(--%s);'}
integer_only = {'shift': '%s <<= 2;', 'shift_right': '%s >>= a;', 'and': '%s &= a;', 'or': '%s |= 4;', 'xor': '%s ^= a;', 'divide': '%s /= a;', 'remainder': '%s %%= a;'}
for name, (spelled, type_) in names.items():
    floating = type_ in ('double', 'float')
    for op, statement in list(operators.items()) + ([] if floating else list(integer_only.items())):
        S('name_%s_%s' % (name, op), statement.replace('%s', spelled).replace('%%', '%') + ' local += 1;')
places = {'dereference': '*p', 'dereference_long': '*lp', 'dereference_char': '*cp', 'member': 'o->inner.first', 'member_second': 'o->inner.second', 'member_third': 'o->inner.third',
          'link': 'o->link->first', 'link_second': 'o->link->second', 'subscript': 'p[a]', 'subscript_long': 'lp[a]', 'subscript_char': 'cp[b]', 'local_list': 'list[a]',
          'global_table': 'table[a]', 'constant_index': 'list[2]', 'global_constant_index': 'table[3]', 'local_member': 'whole.inner.first', 'local_member_second': 'whole.inner.second',
          'global_member': 'global_outer.inner.first', 'global_member_second': 'global_outer.inner.second', 'member_list': 'o->list[a]', 'cast': '*(char*)p', 'cast_subscript': '((short*)p)[a]',
          'global_pointer': '*global_pointer', 'global_pointer_index': 'global_pointer[a]', 'double_dereference': '*(double*)lp', 'float_member': '((float*)p)[2]'}
for name, place in places.items():
    for op, statement in list(operators.items()) + list(integer_only.items()):
        if op in ('add_double',) or (('double' in name or 'float' in name) and op in integer_only): continue
        S('place_%s_%s' % (name, op), statement.replace('%s', place).replace('%%', '%') + ' local += 1;')
