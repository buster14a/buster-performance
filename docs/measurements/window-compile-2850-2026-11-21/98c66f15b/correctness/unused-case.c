static int dormant_object;
static const int dormant_constant = 3;
static int dormant_function(void) { return 0; }
int inspect(int p, int ignored) {
    int a;
    int b;
    b=1;
    typedef int Local;
    return p;
}
int visible(void){return inspect(0, 1);}
