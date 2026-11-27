int f(int x)
{
    while (x / 2 > 1) x /= 2, x--;
    for (; x / 2 > 0; x--);
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
