#define CAST (void)
#define CHECK(x) (CAST (0))
#undef CAST
static int called;
static int CAST(int x){called=x+3;return called;}
int main(void){CHECK(2);return called!=3;}
/*                                                                                                                                                                                                                                                           */
