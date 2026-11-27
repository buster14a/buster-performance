int f(int x)
{
#ifdef NOPE
    x = 2;
#else
    while (x--);
#endif
    return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
