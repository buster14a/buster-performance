int f(int x, int y)
{
    if (y) { y = 2; } else { y = 3; }
    for (; x; x--);
          x += y;
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
