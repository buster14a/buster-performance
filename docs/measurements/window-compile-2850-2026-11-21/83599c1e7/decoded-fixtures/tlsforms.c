extern __thread int external; static __thread int local; __thread int visible; int f(void){return external+local+visible;} int *g(void){return &local;}
