#include <assert.h>
#include <stdbool.h>
#include <string.h>
static bool pp_directive_test_expected(const char* actual, const char* wanted, const char* directory, const char* path)
{
    bool same = true;
    if (*wanted == ':')
    {
        const size_t length = strlen(path);
        same = strncmp(actual, path, length) == 0;
        actual += same ? length : 0;
    }
    else
    {
        static const char trace[] = "In file included from ";
        const size_t length = strlen(directory);
        while (same && *wanted != 0)
        {
            const size_t prefix = strncmp(wanted, trace, sizeof(trace) - 1) == 0 ? sizeof(trace) - 1 : 0;
            if (strncmp(wanted + prefix, "%d/", 3) == 0)
            {
                same = strncmp(actual, wanted, prefix) == 0 && strncmp(actual + prefix, directory, length) == 0;
                if (same)
                {
                    actual += prefix + length;
                    wanted += prefix + 2;
                }
            }
            size_t line = strcspn(wanted, "\n");
            line += wanted[line] == '\n';
            same = same && strncmp(wanted, actual, line) == 0;
            if (same)
            {
                actual += line;
                wanted += line;
            }
        }
    }
    return same && strcmp(actual, wanted) == 0;
}

int main(void) {
    const char* dir="/x"; const char* path="/x/structure.c";
    const char* actual="In file included from /x/structure.c:1:\n/x/structure.h:4: error: output %% and %d/structure.c and %%d/ and /x/structure.h\n";
    const char* expected="In file included from %d/structure.c:1:\n%d/structure.h:4: error: output %% and %d/structure.c and %%d/ and /x/structure.h\n";
    assert(pp_directive_test_expected(actual,expected,dir,path));
    assert(!pp_directive_test_expected(actual,"In file included from %d/structure.h:1:\n",dir,path));
    assert(!pp_directive_test_expected(actual,"",dir,path));
    assert(pp_directive_test_expected("","",dir,path));
    assert(pp_directive_test_expected("/x/structure.c:4: error: %% and %d/\n",":4: error: %% and %d/\n",dir,path));
    assert(!pp_directive_test_expected("/x/structure.c:1: error: thing %%","%d/structure.c:1: error: thing %",dir,path));

    assert(!pp_directive_test_expected(expected,expected,dir,path));
    assert(!pp_directive_test_expected("%d/structure.h:4: error: x","%d/structure.h:4: error: x",dir,path));
    assert(!pp_directive_test_expected("In file included from %d/structure.c:1:","In file included from %d/structure.c:1:",dir,path));
    assert(!pp_directive_test_expected("/xx/structure.h:4: error: x","%d/structure.h:4: error: x",dir,path));
    assert(!pp_directive_test_expected("In fi","In file included from %d/foo:2:",dir,path));
    assert(pp_directive_test_expected("virtual.c:2: error: %d/t\n", "virtual.c:2: error: %d/t\n",dir,path));
}
