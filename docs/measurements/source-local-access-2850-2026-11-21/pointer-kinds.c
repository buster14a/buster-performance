struct cell { long data; };
struct other { long data; };
extern int invoke(int);
extern int consume(const void *);
extern struct cell single;
extern const struct other array[4];
extern const struct cell preserved;
extern int ordinary(int, char);
void *address(void) { return &single; }
const void *array_conversion(void) { return array; }
const void *address_const(void) { return &preserved; }
int direct(int x) { return invoke(x); }
int arguments(void) { return consume(array) + consume(&single); }
int another(int x) { return ordinary(x, (char)x); }
