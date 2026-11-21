extern int consume(char *, int);
int dynamic_address(int count)
{
    char local[count];
    char *target;
    target = local;
    local[count - 1] = 41;
    return consume(target, count);
}
int fixed_address(int count)
{
    char local[24];
    char *target;
    target = local;
    local[count - 1] = 41;
    return consume(target, count);
}
int pointer_address(int count)
{
    char local[24];
    char *p = local;
    char **target;
    target = &p;
    local[count - 1] = 41;
    return consume(*target, count);
}
