struct Pair { int x, y; };
struct Both { struct Pair sides[2]; int result; };
static const int constant = 5;
static int array[] = { [4]=7, [0]=6 };
static const char string[] = "initialized";
int check(int value)
{
    int a=1,b=a+value,c;
    int local[] = {a,b,constant};
    struct Both nested = {.sides={{.x=1,.y=2},{3,4}},.result=1};
    const struct Pair *operand=&(const struct Pair){.y=b,.x=local[2]};
    const int compound=(int){(int){(int){b}}};
    __auto_type inferred=(struct Pair){.x=a,.y=b};
    c=operand->x+compound+inferred.y+nested.sides[1].y;
    return c==23 && sizeof local==3*sizeof(int) && sizeof array==5*sizeof(int) && string[0]=='i';
}
int main(void) { return !check(6); }
