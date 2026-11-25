int lookup(int);
int main(void) {
    for (int n=0; n<4000; ++n) if (lookup(n) != (n*131+33)%3367) return 1;
    return lookup(-2) != -1;
}
