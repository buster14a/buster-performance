// Original actual-module qualification entry. Only module-home linkage differs in the overlay.
#define _GNU_SOURCE
#define BUSTER_UNIT 99
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
_Static_assert(BUSTER_HOST_VECTOR == KR_EXPECT_HOST_VECTOR, "actual host path");

int main(int argc, char** argv)
{
    int result = 1;
    if (argc >= 3 && strcmp(argv[1], "--qualify-atomic") == 0)
    {
        const bool epoch = oracle_epoch_begin();
        CheckTest test = { 0 };
        char directory[] = "/tmp/buster-659-types-XXXXXX";
        const bool ready = mkdtemp(directory) != NULL;
        check_test_expect(&test, ready, "bounded K&R atomic directory");
        if (ready)
        {
            const char* target = argc == 4 ? argv[3] : argv[0];
            check_test_driver_kr_policy(&test, argv[2], target, directory, false);
            check_test_driver_kr_policy(&test, argv[2], target, directory, true);
            if (argc != 4)
            {
                check_test_source_extensions(&test, argv[2]);
                check_test_program_source(&test,
                    "struct T{int a,b,c;};int take(x)_Atomic(struct T) x;{struct T v=x;return v.a+v.b*3+v.c*7;}"
                    "int f(a,b,c,p,d)_Atomic(short) a;_Atomic(unsigned char) b;_Atomic(float) c;_Atomic(int*) p;float d;"
                    "{a+=2;b+=3;c+=0.5f;return a+b+(int)(c*10+d*10)+*p;}"
                    "int tested(int n){struct T t={n&127,5,7};int v=n&63;return f(65539,259,1.25,&v,3.7)+take(t);}",
                    "kr-parenthesized-atomic-and-promoted-parameters", argv[2]);
            }
        }
        rmdir(directory);
        printf("659 parenthesized atomic host_vector=%u: %llu checks, %llu failures\n", BUSTER_HOST_VECTOR,
               (unsigned long long)test.checks, (unsigned long long)test.failures);
        oracle_epoch_end(epoch);
        result = test.failures != 0;
    }
    else
    {
        result = run_check_command_mode(argc - 1, argv + 1, true, true);
    }
    return result;
}
