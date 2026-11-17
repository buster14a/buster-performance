long *ring[] = { (long *)&ring, (long *)ring };
long *first(void)
{
    return ring[0];
}
int inside(void)
{
    char *own[] = { (char *)own, (char *)&own };
    return own[0] != own[1];
}
