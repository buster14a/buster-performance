/* An emulation of glibc's assert for a ceiling measurement: the ternary form, with __func__. */
#ifndef ASSERT_EMUL_H
#define ASSERT_EMUL_H
extern void __assert_fail(const char *assertion, const char *file, unsigned int line, const char *function) __attribute__((__noreturn__));
#endif
#undef assert
#ifdef NDEBUG
# define assert(expr) ((void)0)
#else
# define assert(expr) ((expr) ? (void)0 : __assert_fail(#expr, __FILE__, __LINE__, __func__))
#endif
