/*
** The author disclaims copyright to this source code.  In place of
** a legal notice, here is a blessing:
**
**    May you do good and not evil.
**    May you find forgiveness for yourself and forgive others.
**    May you share freely, never taking more than you give.
*/
// Adapted from sqlite3LogEst's GCC_VERSION<5004000 normalization loops,
// frozen sqlite3.c SHA2560a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d,
// lines38497-38498. Retains the two loop bodies; standalone u64 input/output,
// y starts at0 rather than40, and returns the loop contribution without the table.
unsigned long source_loop(unsigned long x)
{
    unsigned long y = 0;
    while (x > 255)
    {
        y += 40;
        x >>= 4;
    }
    while (x > 15)
    {
        y += 10;
        x >>= 1;
    }
    return y;
}
