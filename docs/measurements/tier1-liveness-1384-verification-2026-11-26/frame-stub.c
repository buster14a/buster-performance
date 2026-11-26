/* Original #1384 frame-local stub: no read of indeterminate bytes. */
void h(int);

void take(char *p)
{
    (void)p;
    h(1384);
}
