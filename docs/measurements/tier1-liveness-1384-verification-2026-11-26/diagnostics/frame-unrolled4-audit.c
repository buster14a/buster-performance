/* Original generated #1384 fixture: frame, n=4. */
extern int g(int);
extern void h(int);
extern void h_bytes(const unsigned char *, unsigned);

int f(int a)
{
    {
        unsigned char bytes[32] = {0};
        bytes[0] = (unsigned char)((unsigned)a + 0u);
        bytes[31] = (unsigned char)0u;
        h_bytes(bytes, 32u);
        if (a == 0)
        {
            return (int)bytes[0];
        }
    }
    {
        unsigned char bytes[32] = {0};
        bytes[0] = (unsigned char)((unsigned)a + 1u);
        bytes[31] = (unsigned char)1u;
        h_bytes(bytes, 32u);
        if (a == 1)
        {
            return (int)bytes[0];
        }
    }
    {
        unsigned char bytes[32] = {0};
        bytes[0] = (unsigned char)((unsigned)a + 2u);
        bytes[31] = (unsigned char)2u;
        h_bytes(bytes, 32u);
        if (a == 2)
        {
            return (int)bytes[0];
        }
    }
    {
        unsigned char bytes[32] = {0};
        bytes[0] = (unsigned char)((unsigned)a + 3u);
        bytes[31] = (unsigned char)3u;
        h_bytes(bytes, 32u);
        if (a == 3)
        {
            return (int)bytes[0];
        }
    }
    return a;
}
