int f(int x)
{
    _Static_assert(1, "one");
    while (x--);
      x += 1;
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
