enum A { A0, A1 };
enum B { B0, B1 };
struct F { unsigned f : 3; int n; };
void use(struct F);
int g(int a, int b, int c, unsigned u, unsigned char uc, signed char sc, _Bool bb, enum A ea, enum B eb, struct F* sf, int* p, int i, float fl)
{
    int x = 0;
    int arr[4];
    x = ea == eb; // refuse: enum-mix
    x = ea | eb; // refuse: enum-mix
    x = ea == A1; // take
    x = a & b == c; // refuse: parentheses
    if (a = b) x = 1; // refuse: parentheses
    x = a < b < c; // refuse: parentheses
    signed char narrow = 200; // refuse: constant
    short small = 40000; // refuse: constant
    int whole = 1.5; // refuse: constant
    whole = 2.5; // refuse: constant
    fl = a ? fl : 16777217; // refuse: constant
    x = a << 40; // refuse: constant
    x = -1 << 3; // refuse: constant
    x = u < 0; // refuse: constant
    x = uc == -1; // refuse: constant
    x = sc > 127; // refuse: constant
    x = bb > 1; // refuse: constant
    x = bb == 2; // refuse: constant
    x = arr[4]; // refuse: constant
    x = sf->f == 9; // refuse: bit-field
    x = __extension__ (a + b); // refuse: operator
    a == i++; // refuse: unused-value
    use(*sf); // refuse: aggregate-value
    p[i++] = i; // refuse: unsequenced
    x = i + i++; // refuse: unsequenced
    i = i++; // refuse: unsequenced
    return x + narrow + small + whole + sf->n; // take
}
int* h(void)
{
    int a[2];
    return a; // refuse: return-address
}
int* k(void)
{
    int a = 0;
    return &a; // refuse: return-address
}
int m(int i)
{
    return i + i++; // refuse: unsequenced
}
