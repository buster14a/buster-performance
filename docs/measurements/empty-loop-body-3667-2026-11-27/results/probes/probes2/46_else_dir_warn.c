int f(int x)
{
#ifndef NOPE
    while (x--);
#else
    x = 2;
#endif
        return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
