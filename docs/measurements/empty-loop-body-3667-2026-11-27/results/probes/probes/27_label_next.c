int f(int x)
{
    while (x--);
      L: x += 1;
    if (x < 3) goto L;
    return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
