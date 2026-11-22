static int helper(int x) { return x + 1; }
static int never_called(int x) { return x - 1; }
static int only_set;
int f(int a, int unused_parameter, int *p)
{
    int local = helper(a);
    only_set = a;
    return local + *p;
}
int g(int a, int b) { int set_only; set_only = a; return b; }
