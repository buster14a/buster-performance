extern int printf(const char*, ...);
int datum;
int other;
__attribute__((naked)) int put(void) {
  __asm__("movl $other, datum(%rip)\n\t"
          "movl datum(%rip), %eax\n\t"
          "ret");
}
__attribute__((naked)) int local_label(int unused) {
  __asm__("testl %edi, %edi\n\t"
          "jz 1f\n\t"
          "movl $6, %eax\n\t"
          "ret\n"
          "1: movl $4, %eax\n\t"
          "ret");
}
int main(void) {
  int got=put();
  printf("%d %d %d\n",(unsigned)got==(unsigned long)&other,local_label(0),local_label(1));
  return 0;
}
