static int private_source = 17;
static int private_sink = 21;
int read_private(void) { return private_source + 5; }
int sum_private(void) { return private_source + private_sink; }
void set_private(int x) { private_sink = x; }
int *address_private(void) { return &private_sink; }
int main(void) {
    int keep = read_private();
    set_private(33);
    return keep == 22 && sum_private() == 50 && *address_private() == 33 ? 0 : 1;
}
