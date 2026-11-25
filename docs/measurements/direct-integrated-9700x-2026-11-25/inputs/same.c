#define CAST (void)
#define CHECK(x) (CAST (0))
#undef CAST
#define CAST (void)
static int count;
int main(void){CHECK(++count);return count;}
/*                                                                                                                                                                                                                                                           */
