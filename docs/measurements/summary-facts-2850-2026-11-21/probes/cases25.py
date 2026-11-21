# cases25.py: a summary node's side facts' cases (#2850), with -std=c23: a `constexpr` object's leaf, an lvalue whose
# constant is its value's and no address's, with an object: read, in a sum, a static one and a file's, by its address,
# a floating one, a condition's, an array's element; and beside them a constant that is no address's of an object's
# record (`(_Bool)&g`). One statement each in a function.
OPTIONS = ['-std=c23']
PRE = '''extern int g;
constexpr int gk = 7;
int f(int a)
{
    constexpr int k = 5;
    static constexpr int sk = 6;
    constexpr double fk = 1.5;
    constexpr int arr[2] = { 1, 2 };
    int x = 0;
    const int* q = 0;
'''
POST = '''
    return x + (q != 0);
}
'''
statements = ['x = k;', 'x = k + a;', 'x = sk;', 'x = sk + gk;', 'q = &k;', 'q = &sk;', 'x = fk > 1.0;', 'x = (_Bool)&g;', 'x = k ? a : 2;', 'if (k) x = 1;', 'x = a + gk;', 'x = arr[0];',
              'x = gk;', 'x = -k;', 'x = (char)k;', 'x = k * sk;', 'if (a < k) x = 1;', 'x = (_Bool)&g + k;', 'q = &gk;', 'x = arr[a & 1];', 'x = a ? k : sk;', 'x = !k;']
for i, statement in enumerate(statements):
    C('constexpr-%d' % i, PRE + '    ' + statement + POST)
