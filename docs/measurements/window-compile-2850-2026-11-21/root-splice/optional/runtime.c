static int storage = 11;
int exposed = 9;
int fetch(int x, int y) {
    int *p;
    p = &x;
    storage = y;
    return *p + storage + exposed;
}
int main(void) { return fetch(7, 13) == 29 ? 0 : 1; }
