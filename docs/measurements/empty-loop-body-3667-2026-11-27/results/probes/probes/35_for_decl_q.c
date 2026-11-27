int f(int x)
{
    for (int i = 0; i < x; i++);
    return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
