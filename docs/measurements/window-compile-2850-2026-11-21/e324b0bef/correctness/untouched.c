static int first, second;
static int helper(void) { return first + second; }
int live(int x) {
    {
        int y = x;
        return y;
    }
}
