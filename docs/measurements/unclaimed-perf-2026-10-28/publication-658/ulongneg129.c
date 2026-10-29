static const long table[] = {
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,
-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U,-5U
};
int tested(unsigned n) { return table[n % 129]; }
