extern int remote(void);
extern int strong_alias(void);
extern int putchar(int);
static int duplicate(void) { return 7; }
int bridge(void)
{
    putchar('N');
    return duplicate() + remote() + strong_alias();
}
