typedef int early_fn(int);
typedef long later_fn(long, int);
extern early_fn first;
extern later_fn second;
int one(int a) { return first(a); }
struct record { unsigned id; int value; };
typedef struct record record;
typedef record *record_ptr;
extern record_ptr onward(record_ptr,int);
long two(long a) { return second(a,1); }
extern early_fn *(*choose(void))(void);
record_ptr three(record_ptr p) { return onward(p,0); }
int four(int a) { return first(a); }
