# cases11.py: a row of eight entries at an expression's last record: an address constant with an offset and its CONVERT
# (four entries of its own) converted to bool from a narrow class (four more).
P = 'struct pair { int first; long second; char third; }; struct outer { struct pair inner; }; struct outer global_outer; long global;\n'
C('initialized_bool_global_offset', P + 'int f(void) { _Bool told = (char)(long)&global_outer.inner.second; return told; }\n')
C('initialized_bool_local_offset', P + 'int f(void) { struct outer whole; _Bool told = (short)(long)&whole.inner.second; return told; }\n')
C('stored_bool_global_offset', P + 'int f(void) { _Bool told; told = (char)(long)&global_outer.inner.second; return told; }\n')
C('returned_bool', P + '_Bool f(void) { return (char)(long)&global_outer.inner.second; }\n')
C('condition', P + 'int f(void) { if ((char)(long)&global_outer.inner.second) return 1; return 0; }\n')
C('argument', P + 'int g(_Bool); int f(void) { return g((char)(long)&global_outer.inner.second); }\n')
C('initialized_bool_no_offset', P + 'int f(void) { _Bool told = (char)(long)&global; return told; }\n')
C('initialized_int_offset', P + 'int f(void) { int told = (char)(long)&global_outer.inner.second; return told; }\n')
