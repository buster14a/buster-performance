extern int selected(void);
extern int sentinel(void);
int main(void) { return selected() == 28 && sentinel() == 3 ? 0 : 1; }
