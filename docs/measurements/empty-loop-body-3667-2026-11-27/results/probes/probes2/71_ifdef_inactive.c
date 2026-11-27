int f(int x)
{
    while (x--);
#ifdef NOPE
    x += 2;
#else
        x += 1;
#endif
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
