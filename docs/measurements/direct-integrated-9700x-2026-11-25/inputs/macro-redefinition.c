#define CAST (void)
#define CHECK(x) (CAST (0))
#undef CAST
#define CAST record_call

static int called;
static int record_call(int x) { called = x + 31; return called; }
int main(void) { CHECK(0); return called == 31 ? 0 : 1; }

/* Keep the invocation in the lexer's full SIMD window.
   Padding follows the program so the direct path sees the same invocation well before the end
   of the source, independently of the C source representation of the closing brace. */
