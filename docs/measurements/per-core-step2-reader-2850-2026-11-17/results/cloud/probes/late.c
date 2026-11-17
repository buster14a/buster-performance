struct Late;
extern struct Late late;
struct Late *early(void)
{
    return &late;
}
struct Late
{
    int x;
    int y;
};
int after(void)
{
    return late.y;
}
extern int grows[];
int before(void)
{
    return grows[0];
}
int grows[2] = { 1, 2 };
int later(void)
{
    return grows[1];
}
int twice(void)
{
    return grows[0] + late.x;
}
