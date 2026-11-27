int f(int x)
{
    while (x--);
#define Y 1
      return x + Y;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
