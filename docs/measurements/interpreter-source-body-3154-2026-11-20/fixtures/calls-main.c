extern int bridge(void);
extern int strong_alias(void);
extern int strong_target(void);
extern int (*published)(void);
extern int absent_3154(void) __attribute__((weak));
static int duplicate(void) { return 3; }
static int (*empty)(void);
int main(void)
{
    int (*alias)(void) = strong_alias;
    if (absent_3154 || empty || published != strong_target || alias() != 17)
    {
        return 1;
    }
    return duplicate() + published() + bridge();
}
