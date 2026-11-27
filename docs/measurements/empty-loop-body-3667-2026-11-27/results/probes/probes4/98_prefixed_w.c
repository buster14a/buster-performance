typedef int wchar_t;
int f(const wchar_t* s)
{
    for (; *s != L'x'; s++);
        return *s;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
