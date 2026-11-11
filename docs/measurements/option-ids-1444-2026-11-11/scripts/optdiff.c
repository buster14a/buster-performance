// #1444 item 5: differential check of the option matching. Runs two builds of the compiler (base, head) on the same
// command lines and compares exit status, standard output, standard error and any -o output byte for byte.
//   optdiff BASE HEAD WORKDIR SPELLINGS [RANDOM_LINES [SEED]]
// SPELLINGS has one option spelling per line (c_option_table.c's). Each spelling gives its forms (alone, with a separate
// value, joined values, one character more, one less, with "=1"), each placed in command templates that reach every
// argument loop: -E (-P, -dM, -M), -fsyntax-only, -c, the information probes, as a value of -o and past --. Then
// RANDOM_LINES command lines of one to four random forms each, for the families whose last option decides.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/wait.h>

#define MAX_FORMS 8192
#define MAX_ARGS 64

typedef struct Form Form;
struct Form
{
    char* words[2];
    int count;
};

typedef struct Run Run;
struct Run
{
    int status;
    char* out;
    size_t out_length;
    char* err;
    size_t err_length;
    char* file;
    size_t file_length;
    bool file_exists;
};

static char* read_file(const char* path, size_t* length, bool* exists)
{
    char* result = NULL;
    *length = 0;
    *exists = false;
    FILE* f = fopen(path, "rb");
    if (f != NULL)
    {
        *exists = true;
        size_t capacity = 4096;
        result = malloc(capacity);
        size_t n;
        while ((n = fread(result + *length, 1, capacity - *length, f)) > 0)
        {
            *length += n;
            if (*length == capacity)
            {
                capacity *= 2;
                result = realloc(result, capacity);
            }
        }
        fclose(f);
    }
    return result;
}

static Run run(const char* executable, char** arguments, int count, const char* directory)
{
    Run result = { 0 };
    char out_path[4096];
    char err_path[4096];
    char file_path[4096];
    snprintf(out_path, sizeof(out_path), "%s/stdout", directory);
    snprintf(err_path, sizeof(err_path), "%s/stderr", directory);
    snprintf(file_path, sizeof(file_path), "%s/out.o", directory);
    unlink(file_path);
    pid_t child = fork();
    if (child == 0)
    {
        int in = open("/dev/null", O_RDONLY);
        int out = open(out_path, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        int err = open(err_path, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        dup2(in, 0);
        dup2(out, 1);
        dup2(err, 2);
        if (chdir(directory) != 0)
        {
            _exit(126);
        }
        char* argv[MAX_ARGS + 2];
        argv[0] = (char*)executable;
        for (int i = 0; i < count; i += 1)
        {
            argv[i + 1] = arguments[i];
        }
        argv[count + 1] = NULL;
        execv(executable, argv);
        _exit(127);
    }
    int status = 0;
    waitpid(child, &status, 0);
    result.status = status;
    bool exists;
    result.out = read_file(out_path, &result.out_length, &exists);
    result.err = read_file(err_path, &result.err_length, &exists);
    result.file = read_file(file_path, &result.file_length, &result.file_exists);
    return result;
}

// --time-stages's report times the run: its digits and points are masked.
static void mask_times(Run* r)
{
    for (size_t i = 0; i < r->err_length; i += 1)
    {
        r->err[i] = (r->err[i] >= '0' && r->err[i] <= '9') || r->err[i] == '.' || r->err[i] == ' ' ? '#' : r->err[i];
    }
    size_t used = 0;
    for (size_t i = 0; i < r->err_length; i += 1)
    {
        if (!(r->err[i] == '#' && used > 0 && r->err[used - 1] == '#'))
        {
            r->err[used++] = r->err[i];
        }
    }
    r->err_length = used;
}

static bool timed(char** arguments, int count)
{
    bool result = false;
    for (int i = 0; i < count; i += 1)
    {
        result |= strcmp(arguments[i], "--time-stages") == 0;
    }
    return result;
}

static bool same(const Run* a, const Run* b)
{
    return a->status == b->status && a->out_length == b->out_length && memcmp(a->out, b->out, a->out_length) == 0 && a->err_length == b->err_length &&
           memcmp(a->err, b->err, a->err_length) == 0 && a->file_exists == b->file_exists && a->file_length == b->file_length &&
           (a->file_length == 0 || memcmp(a->file, b->file, a->file_length) == 0);
}

static void release(Run* r)
{
    free(r->out);
    free(r->err);
    free(r->file);
}

static Form forms[MAX_FORMS];
static int form_count;

static void add(const char* a, const char* b)
{
    if (form_count < MAX_FORMS)
    {
        forms[form_count].words[0] = strdup(a);
        forms[form_count].words[1] = b != NULL ? strdup(b) : NULL;
        forms[form_count].count = b != NULL ? 2 : 1;
        form_count += 1;
    }
}

// The templates: TOKEN "F" is the form's words.
static const char* const templates[][12] = {
    { "-E", "-P", "empty.c", "F", NULL },
    { "-E", "-dM", "empty.c", "F", NULL },
    { "-fsyntax-only", "empty.c", "F", NULL },
    { "F", "-fsyntax-only", "empty.c", NULL },
    { "-c", "tiny.c", "-o", "out.o", "F", NULL },
    { "F", "--version", NULL },
    { "-dumpmachine", "F", NULL },
    { "-fsyntax-only", "empty.c", "-o", "F", NULL },
    { "-fsyntax-only", "empty.c", "--", "F", NULL },
    { "-M", "empty.c", "F", NULL },
    { "-fsyntax-only", "F", NULL },
};

static uint64_t state = 0x9e3779b97f4a7c15ull;

static uint64_t next_random(void)
{
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return state;
}

int main(int argc, char** argv)
{
    if (argc < 5)
    {
        fprintf(stderr, "usage: optdiff BASE HEAD WORKDIR SPELLINGS [RANDOM_LINES [SEED]]\n");
        return 2;
    }
    const char* base = argv[1];
    const char* head = argv[2];
    const char* directory = argv[3];
    const long random_lines = argc > 5 ? strtol(argv[5], NULL, 10) : 0;
    state = argc > 6 ? strtoull(argv[6], NULL, 10) | 1 : state;
    FILE* spellings = fopen(argv[4], "r");
    char line[512];
    while (spellings != NULL && fgets(line, sizeof(line), spellings) != NULL)
    {
        line[strcspn(line, "\n")] = 0;
        size_t length = strlen(line);
        if (length == 0)
        {
            continue;
        }
        char buffer[600];
        add(line, NULL);
        add(line, "v");
        snprintf(buffer, sizeof(buffer), "%sx", line);
        add(buffer, NULL);
        if (length > 2)
        {
            snprintf(buffer, sizeof(buffer), "%.*s", (int)length - 1, line);
            add(buffer, NULL);
        }
        if (line[length - 1] == '=')
        {
            snprintf(buffer, sizeof(buffer), "%s1", line);
            add(buffer, NULL);
            snprintf(buffer, sizeof(buffer), "%snative", line);
            add(buffer, NULL);
            snprintf(buffer, sizeof(buffer), "%snone", line);
            add(buffer, NULL);
        }
        else
        {
            snprintf(buffer, sizeof(buffer), "%s=1", line);
            add(buffer, NULL);
        }
    }
    printf("%d forms from %s\n", form_count, argv[4]);
    long runs = 0;
    long differences = 0;
    char* arguments[MAX_ARGS];
    for (int f = 0; f < form_count; f += 1)
    {
        for (size_t t = 0; t < sizeof(templates) / sizeof(templates[0]); t += 1)
        {
            int count = 0;
            for (int w = 0; templates[t][w] != NULL; w += 1)
            {
                if (strcmp(templates[t][w], "F") == 0)
                {
                    for (int k = 0; k < forms[f].count; k += 1)
                    {
                        arguments[count++] = forms[f].words[k];
                    }
                }
                else
                {
                    arguments[count++] = (char*)templates[t][w];
                }
            }
            Run a = run(base, arguments, count, directory);
            Run b = run(head, arguments, count, directory);
            if (timed(arguments, count))
            {
                mask_times(&a);
                mask_times(&b);
            }
            runs += 1;
            if (!same(&a, &b))
            {
                differences += 1;
                if (differences <= 40)
                {
                    printf("DIFFERENCE:");
                    for (int i = 0; i < count; i += 1)
                    {
                        printf(" '%s'", arguments[i]);
                    }
                    printf(" (status %d/%d, stdout %zu/%zu, stderr %zu/%zu)\n", a.status, b.status, a.out_length, b.out_length, a.err_length, b.err_length);
                }
            }
            release(&a);
            release(&b);
        }
    }
    printf("forms: %ld command lines, %ld differences\n", runs, differences);
    long random_differences = 0;
    static const char* const heads[][4] = {
        { "-E", "-dM", "empty.c", NULL },
        { "-fsyntax-only", "empty.c", NULL, NULL },
        { "-c", "tiny.c", "-o", "out.o" },
        { "-E", "-P", "empty.c", NULL },
    };
    for (long r = 0; r < random_lines; r += 1)
    {
        int count = 0;
        const uint64_t h = next_random() % 4;
        for (int w = 0; w < 4 && heads[h][w] != NULL; w += 1)
        {
            arguments[count++] = (char*)heads[h][w];
        }
        const int n = 1 + (int)(next_random() % 4);
        for (int k = 0; k < n; k += 1)
        {
            const Form* form = &forms[next_random() % (uint64_t)form_count];
            for (int w = 0; w < form->count; w += 1)
            {
                arguments[count++] = form->words[w];
            }
        }
        Run a = run(base, arguments, count, directory);
        Run b = run(head, arguments, count, directory);
        if (timed(arguments, count))
        {
            mask_times(&a);
            mask_times(&b);
        }
        if (!same(&a, &b))
        {
            random_differences += 1;
            if (random_differences <= 40)
            {
                printf("DIFFERENCE:");
                for (int i = 0; i < count; i += 1)
                {
                    printf(" '%s'", arguments[i]);
                }
                printf(" (status %d/%d, stdout %zu/%zu, stderr %zu/%zu)\n", a.status, b.status, a.out_length, b.out_length, a.err_length, b.err_length);
            }
        }
        release(&a);
        release(&b);
    }
    printf("random: %ld command lines, %ld differences\n", random_lines, random_differences);
    return differences + random_differences != 0;
}
