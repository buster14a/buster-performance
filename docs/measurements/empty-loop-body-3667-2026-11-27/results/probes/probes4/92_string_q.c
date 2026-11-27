int g(const char*);
int f(int x)
{
    while (x-- && g("a(b;c"));
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
