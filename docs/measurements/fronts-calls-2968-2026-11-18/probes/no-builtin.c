typedef unsigned long size_t;
void* memset(void*, int, size_t);
void* memcpy(void*, const void*, size_t);
size_t strlen(const char*);
int k0(int, int);
int before(char* p, int a)
{
    memset(p, 0, 8);
    k0(a, a);
    return (int)strlen("abc");
}
__attribute__((no_builtin("memset"))) int named(char* p, const char* q, int a)
{
    memset(p, 0, 8);
    memcpy(p, q, 8);
    k0(a, a);
    return (int)strlen("abc");
}
int between(char* p, int a)
{
    memset(p, 0, 8);
    k0(a, a);
    return a;
}
__attribute__((no_builtin)) int every(char* p, const char* q, int a)
{
    memset(p, 0, 8);
    memcpy(p, q, 8);
    (&memset)(p, 0, 8);
    k0(a, a);
    return (int)strlen("abc");
}
int after(char* p, int a)
{
    memset(p, 0, 8);
    k0(a, a);
    return (int)strlen(p);
}
