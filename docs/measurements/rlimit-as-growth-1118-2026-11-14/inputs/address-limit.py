# Writes address-limit.c: buster's check_test_driver_address_limit fixture (#1118), 2,000 structures, typedefs and functions.
with open('address-limit.c', 'w') as f:
    for i in range(2000):
        f.write("struct s%u { int a; long b; char c[%u]; struct s%u* next; };\n" % (i, i % 13 + 1, i))
        f.write("typedef struct s%u t%u;\n" % (i, i))
        f.write("long f%u(t%u* p, int x)\n{\n    long y = (long)x * %u + p->a;\n    if (y > p->b)\n    {\n        p->b = y;\n    }\n" % (i, i, i))
        f.write("    return p->next != 0 ? p->b + p->c[0] : y;\n}\n")
    f.write("int main(void)\n{\n    t0 v = { 0 };\n    return (int)f0(&v, 1) - 1;\n}\n")
