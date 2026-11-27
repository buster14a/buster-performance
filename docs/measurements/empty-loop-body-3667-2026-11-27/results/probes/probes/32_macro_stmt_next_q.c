#define INC(v) ((v) += 1)
int f(int x)
{
    while (x--);
    INC(x);
    return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
