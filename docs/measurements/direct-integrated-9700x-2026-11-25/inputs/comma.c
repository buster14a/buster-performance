#define CAST (void)
#define CHECK(x) (CAST (0))
static int count;
int main(void){(count=count+1), CHECK(0);return count!=1;}
/*                                                                                                                                                                                                                                                           */
