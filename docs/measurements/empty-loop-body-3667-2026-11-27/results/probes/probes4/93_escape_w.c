int f(const char* s)
{
    while (*s && *s != '\'' && *s != '\n') s++, s--, s++;
    for (; *s != '\n'; s++);
        return *s;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
