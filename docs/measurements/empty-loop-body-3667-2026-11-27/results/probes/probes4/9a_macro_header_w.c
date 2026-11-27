#define LIM(v) ((v) * 2)
#define ONE 1
int f(int x, int y)
{
    for (x = ONE; x < LIM(y); x++);
        return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
