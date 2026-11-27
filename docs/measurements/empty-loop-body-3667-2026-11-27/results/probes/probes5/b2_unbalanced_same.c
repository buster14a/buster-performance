#define SEP ;
#define RP )
#define LP (
int f(int x)
{
    int i;
    for (i = 0 SEP i < x SEP i++ RP ; x++ ; LP x++ ) ;
    x++;
    return x;
}
/* A window lexes the tokens before this comment: more than eighty bytes of the file follow them. */
