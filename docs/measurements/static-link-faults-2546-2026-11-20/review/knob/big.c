#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <locale.h>
#include <wchar.h>
#include <regex.h>
#include <setjmp.h>
#include <pthread.h>
#include <fnmatch.h>
#include <glob.h>
#include <signal.h>
#include <errno.h>
#include <ctype.h>
#include <stdarg.h>
#include <inttypes.h>
#include <search.h>
#include <iconv.h>

static jmp_buf jb;
static int cmp(const void* a, const void* b) { return *(const int*)a - *(const int*)b; }
static void* worker(void* arg) { int* p = arg; *p *= 2; return 0; }

int main(int argc, char** argv)
{
    setlocale(LC_ALL, "C");
    int values[8] = { 5, 3, 7, 1, 9, 2, 8, 4 };
    qsort(values, 8, sizeof(int), cmp);
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "%d %g %s %ls", values[0], sqrt(2.0) + sin(1.0) + exp(1.0), "x", L"wide");
    puts(buffer);
    regex_t re;
    if (regcomp(&re, "a+b", REG_EXTENDED) == 0) { printf("match %d\n", regexec(&re, "aaab", 0, 0, 0)); regfree(&re); }
    if (setjmp(jb) == 0) { longjmp(jb, 1); }
    pthread_t t; int n = 21; pthread_create(&t, 0, worker, &n); pthread_join(t, 0); printf("thread %d\n", n);
    printf("fnmatch %d\n", fnmatch("*.c", "big.c", 0));
    time_t now = 0; struct tm tmv; gmtime_r(&now, &tmv); strftime(buffer, sizeof(buffer), "%Y-%m-%d", &tmv); puts(buffer);
    double d = strtod("3.25", 0); long l = strtol("123", 0, 10); printf("%f %ld %" PRIu64 "\n", d, l, (uint64_t)1 << 40);
    wchar_t wb[16]; mbstowcs(wb, "hello", 16); printf("%zu\n", wcslen(wb));
    hcreate(16); ENTRY e = { "k", "v" }; hsearch(e, ENTER);
    iconv_t cd = iconv_open("UTF-8", "ASCII"); if (cd != (iconv_t)-1) iconv_close(cd);
    char* dup = strdup("abc"); printf("%s %d %d\n", dup, toupper('a'), errno); free(dup);
    signal(SIGUSR1, SIG_IGN);
    sscanf("17 x", "%d", &n); printf("%d %.3Lf\n", n, (long double)powl(2.0L, 0.5L));
    return argc > 5 ? 1 : 0;
}
