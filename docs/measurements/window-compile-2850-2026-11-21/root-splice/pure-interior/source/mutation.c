extern int sink(int, int);
static int slots[2 + 3];
static int *zero_pointer = 1 - 1;
int constant(int n){
  static const int constant = 5 + 2;
  slots[2 - 1] = sink(n, (2 + 3));
  return n + (3 * 9) + (5 + 2) + (zero_pointer != 0) + constant;
}
_Static_assert(3+4==7, "integer constant expression");
