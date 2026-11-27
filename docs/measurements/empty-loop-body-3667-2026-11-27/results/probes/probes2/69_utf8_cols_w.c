int f(int x)
{
/* é */ while (x--);
          return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
