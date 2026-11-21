extern int opaque(int);
int conditions(int x, int y, int *p) {
    int sum = 0;
    if (x && y) sum = x + 3;
    if (x != y) sum += y;
    if (p && *p) sum += *p;
    while (x && y) { sum++; x--; }
    do { y--; } while (x || y);
    for (int i=0; i<sum && x; i++) x -= 2;
    if (opaque(sum) && y) return 0;
    return sum;
}
