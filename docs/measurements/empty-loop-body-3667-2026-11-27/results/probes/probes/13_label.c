int f(int x)
{
L:  while (x--);
        x += 1;
    if (x) goto L;
    return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
