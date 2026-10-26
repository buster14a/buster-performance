struct __attribute__((packed)) P { char c; int w; };
void take(void*);
void* give(void*);
int f(struct P*p, int n)
{
    int a=__builtin_constant_p(take(&p->w));
    int b=_Generic(take(&p->w),default:0);
    int c=__builtin_choose_expr(0,(take(&p->w),1),0);
    int d=__builtin_object_size(give(&p->w),0);
    unsigned long e=sizeof(int[(take(&p->w),n)]);
    unsigned long g=sizeof(take(&p->w));
    unsigned long h=sizeof(__builtin_memcpy(&p->w,0,4));
    __typeof__(give(&p->w)) v;
    return a+b+c+d+e+g+h;
}
