enum A { A0, A1 };
enum B { B0, B1 };
int g(int* p, unsigned u, int i, enum A ea, enum B eb, char* s, void* v, int* q)
{
    int v1 = (i << 40);
    int v2 = (i / 0);
    int v3 = (ea == eb);
    int v4 = (char)p;
    int v5 = (u < i);
    int v6 = (i, 1);
    int v7 = (p == 1);
    int v8 = (int)3.7;
    int v9 = (i << i + 1);
    int v10 = (i & 2 == 2);
    return v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8 + v9 + v10;
}
