int f(int x)
{
    struct S { int a; } s = { 1 };
    while (x--);
        x += s.a;
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
