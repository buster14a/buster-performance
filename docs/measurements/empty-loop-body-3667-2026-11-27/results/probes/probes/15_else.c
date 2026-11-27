int f(int x, int y)
{
    if (y) x = 1;
    else while (x--);
        x += 1;
    return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
