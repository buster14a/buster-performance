int f(int x)
{
L:  x++;
    while (x--);
      x += 1;
    if (x < 2) goto L;
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
