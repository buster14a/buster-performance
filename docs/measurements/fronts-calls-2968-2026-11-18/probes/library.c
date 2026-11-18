typedef unsigned long size_t;
size_t strlen(const char*);
void* memcpy(void*, const void*, size_t);
void* memset(void*, int, size_t);
int abs(int);
int f(char* p, const char* q, int a)
{
    size_t n = 0;
    int x = 0;
    n = strlen("abc");
    n = (strlen)("abc");
    n = (&strlen)("abc");
    n = (*strlen)("abc");
    (&strlen)("abc");
    (&memcpy)(p, q, 8);
    memcpy(p, q, 8);
    (&memset)(p, 0, 8);
    x = (&abs)(a);
    x = abs(a);
    (*memcpy)(p, q, 8);
    return x + (int)n;
}
