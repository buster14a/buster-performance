extern int printf(const char *, ...);
static int updates(int n) {
  int x=20, sum=0;
  for(int i=0; i<n; i++) {
    x++; x--;
    for(int j=3; j>0; j--) { sum += x+j; }
    if(i&1) { x++; } else { x--; }
  }
  int before=({ x++; });
  return sum+before+x;
}
int main(void) {
  int accumulated=0;
  for(int i=0; i<12; i++) accumulated+=updates(i);
  printf("%d\n", accumulated);
  return 0;
}
