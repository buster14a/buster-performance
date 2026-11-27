int f(int x)
{
    if (x) {
        for (; x; x--);
    return x;
    }
    return 0;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
