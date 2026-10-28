#define BUSTER_UNIT BUSTER_UNIT_FRONTEND
#define main_unit_frontend __attribute__((unused)) static focused_unused
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    char directory[] = "/tmp/buster-643-review-XXXXXX";
    bool passed = mkdtemp(directory) != 0;
    for (uint32_t i = 0; i < BUSTER_ARRAY_LENGTH(pp_test_cases); i += 1)
    {
        if (true)
        {
            const bool oracle = strstr(pp_test_cases[i].name, "retain paint") != 0 || strstr(pp_test_cases[i].name, "pass pending") != 0 ||
                                strstr(pp_test_cases[i].name, "leave expanding") != 0;
            const bool current = pp_test_case(&pp_test_cases[i], directory, oracle);
            printf("nested invocation fixture %s: %s\n", pp_test_cases[i].name, current ? "pass" : "FAIL");
            passed = current && passed;
        }
    }
    return !passed;
}
