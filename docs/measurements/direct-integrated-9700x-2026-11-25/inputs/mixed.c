#define CAST (void)
#define CHECK(x) (CAST (0))
static int count;
static void fun(int flag){flag ? (void)(count=count+1) : CHECK(0);}
int main(void){fun(0);fun(1);return count!=1;}
/*                                                                                                                                                                                                                                                           */
