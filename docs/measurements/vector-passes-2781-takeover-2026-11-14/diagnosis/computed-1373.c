int printf(const char*,...);typedef unsigned long size_t;static int calls;
void*memcpy(void*d,const void*s,size_t n){calls+=1;char*a=d;const char*b=s;while(n--)*a++=*b++;return d;}
void*memmove(void*d,const void*s,size_t n){calls+=10;char*a=d;const char*b=s;if(a<b)while(n--)*a++=*b++;else while(n--)a[n]=b[n];return d;}
int abs(int x){calls+=100;return x<0?-x:x;}long labs(long x){calls+=1000;return x<0?-x:x;}
double fabs(double x){calls+=10000;return x<0?-x:x;}double copysign(double x,double y){calls+=100000;return (y<0)!=(x<0)?-x:x;}
int main(void){char a[48],b[48];for(int i=0;i<48;i++){a[i]=(char)('a'+i%26);b[i]='.';}volatile size_t n=4;volatile int v=-3;volatile double d=-2.5;
memcpy(b,a,8);memcpy(b+8,a,n);memcpy(b+12,a+5,33);memmove(b+1,b,12);memmove(b+30,b+29,n);memmove(b+3,b+4,32);
int r=abs(v)+(int)labs(v)*10;double f=fabs(d)+copysign(1.0,d);printf("%d %d %.1f %.45s\n",calls,r,f,b);return 0;}
