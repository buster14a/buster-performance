int f(int x)
{
    switch (x) {
    case 0: x = 3;
        while (x--);
    case 1: x += 1;
    }
    return x;
}
/* trailing comment long enough that the window lexer runs over the text before it: 0123456789 0123456789 */
