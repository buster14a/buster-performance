#define testcase(X)
int f(int x)
{
    while (x--);
    testcase(x);
    return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
