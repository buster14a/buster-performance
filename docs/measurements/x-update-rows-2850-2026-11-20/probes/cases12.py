# cases12.py: a row of eight entries at an expression's last record: an update's own four (`++`'s or `--`'s CONST of
# the class it is computed in, the operation, the CONVERT back to a narrow class and the store) and its value's
# conversion to bool from that narrow class (four more). Beside them, rows of six and seven, which the fault
# `length-low-bits` reads as they are.
C('initialized_bool_pre_increment_char', 'int f(char c) { _Bool told = ++c; return told; }\n')
C('initialized_bool_post_increment_char', 'int f(char c) { _Bool told = c++; return told; }\n')
C('initialized_bool_pre_decrement_short', 'int f(short s) { _Bool told = --s; return told; }\n')
C('returned_bool_pre_increment_char', '_Bool f(char c) { return ++c; }\n')
C('argument_bool_pre_increment_char', 'int g(_Bool); int f(char c) { return g(++c); }\n')
C('initialized_bool_global_char', 'char global; int f(void) { _Bool told = ++global; return told; }\n')
C('initialized_bool_through_address', 'int f(char* p) { _Bool told = ++*p; return told; }\n')
C('initialized_bool_member_char', 'struct pair { int first; long second; char third; }; int f(struct pair* o) { _Bool told = ++o->third; return told; }\n')
C('stored_bool_pre_increment_char', 'int f(char c) { _Bool told; told = ++c; return told; }\n')
C('initialized_bool_compound_char', 'int f(char c, int b) { _Bool told = c += b; return told; }\n')
C('initialized_bool_pre_increment_int', 'int f(int a) { _Bool told = ++a; return told; }\n')
C('initialized_bool_pointer_decrement', 'int f(char* p) { _Bool told = --p; return told; }\n')
