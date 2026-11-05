#include <stdio.h>
static int f1(int x) { int y = x * 1; for (int i = 0; i < x; i += 1) { y += i ^ 1; } return y; }
static int f2(int x) { int y = x * 2; for (int i = 0; i < x; i += 1) { y += i ^ 2; } return y; }
static int f3(int x) { int y = x * 3; for (int i = 0; i < x; i += 1) { y += i ^ 3; } return y; }
static int f4(int x) { int y = x * 4; for (int i = 0; i < x; i += 1) { y += i ^ 4; } return y; }
static int f5(int x) { int y = x * 5; for (int i = 0; i < x; i += 1) { y += i ^ 5; } return y; }
static int f6(int x) { int y = x * 6; for (int i = 0; i < x; i += 1) { y += i ^ 6; } return y; }
static int f7(int x) { int y = x * 7; for (int i = 0; i < x; i += 1) { y += i ^ 7; } return y; }
static int f8(int x) { int y = x * 8; for (int i = 0; i < x; i += 1) { y += i ^ 8; } return y; }
static int f9(int x) { int y = x * 9; for (int i = 0; i < x; i += 1) { y += i ^ 9; } return y; }
static int f10(int x) { int y = x * 10; for (int i = 0; i < x; i += 1) { y += i ^ 10; } return y; }
static int f11(int x) { int y = x * 11; for (int i = 0; i < x; i += 1) { y += i ^ 11; } return y; }
static int f12(int x) { int y = x * 12; for (int i = 0; i < x; i += 1) { y += i ^ 12; } return y; }
static int f13(int x) { int y = x * 13; for (int i = 0; i < x; i += 1) { y += i ^ 13; } return y; }
static int f14(int x) { int y = x * 14; for (int i = 0; i < x; i += 1) { y += i ^ 14; } return y; }
static int f15(int x) { int y = x * 15; for (int i = 0; i < x; i += 1) { y += i ^ 15; } return y; }
static int f16(int x) { int y = x * 16; for (int i = 0; i < x; i += 1) { y += i ^ 16; } return y; }
static int f17(int x) { int y = x * 17; for (int i = 0; i < x; i += 1) { y += i ^ 17; } return y; }
static int f18(int x) { int y = x * 18; for (int i = 0; i < x; i += 1) { y += i ^ 18; } return y; }
static int f19(int x) { int y = x * 19; for (int i = 0; i < x; i += 1) { y += i ^ 19; } return y; }
static int f20(int x) { int y = x * 20; for (int i = 0; i < x; i += 1) { y += i ^ 20; } return y; }
static int f21(int x) { int y = x * 21; for (int i = 0; i < x; i += 1) { y += i ^ 21; } return y; }
static int f22(int x) { int y = x * 22; for (int i = 0; i < x; i += 1) { y += i ^ 22; } return y; }
static int f23(int x) { int y = x * 23; for (int i = 0; i < x; i += 1) { y += i ^ 23; } return y; }
static int f24(int x) { int y = x * 24; for (int i = 0; i < x; i += 1) { y += i ^ 24; } return y; }
int main(void) { int s = 0;
  s += f1(1);
  s += f2(2);
  s += f3(3);
  s += f4(4);
  s += f5(5);
  s += f6(6);
  s += f7(7);
  s += f8(8);
  s += f9(9);
  s += f10(10);
  s += f11(11);
  s += f12(12);
  s += f13(13);
  s += f14(14);
  s += f15(15);
  s += f16(16);
  s += f17(17);
  s += f18(18);
  s += f19(19);
  s += f20(20);
  s += f21(21);
  s += f22(22);
  s += f23(23);
  s += f24(24);
  printf("%d\n", s); return 0; }
