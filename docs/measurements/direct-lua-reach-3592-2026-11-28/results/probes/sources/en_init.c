enum E {A,B}; int t(int c) { enum E e = c ? A : B; return e; }
