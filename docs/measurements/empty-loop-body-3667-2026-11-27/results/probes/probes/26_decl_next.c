int f(int x)
{
    while (x--);
        int y = x;
    return y;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
