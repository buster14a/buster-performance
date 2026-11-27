int f(int x, int y)
{
    for (; y; y--) for (; x; x--);
        x += 1;
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
