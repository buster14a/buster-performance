// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#define _GNU_SOURCE
#include "hp_common.h"

#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

bool hp_error(char error[BUSTER_HP_ERROR_CAPACITY], const char* format, ...)
{
    va_list arguments;
    va_start(arguments, format);
    vsnprintf(error, BUSTER_HP_ERROR_CAPACITY, format, arguments);
    va_end(arguments);
    return false;
}

void hp_buffer_free(HpBuffer* buffer)
{
    free(buffer->data);
    memset(buffer, 0, sizeof(*buffer));
}

bool hp_read_file(const char* path, size_t limit, HpBuffer* output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = output->data == NULL && output->size == 0 && limit > 0 && limit < SIZE_MAX;
    FILE* file = valid ? fopen(path, "rb") : NULL;
    valid = valid && file != NULL;
    size_t capacity = limit < 8192 ? limit : 8192;
    unsigned char* data = valid ? malloc(capacity + 1) : NULL;
    valid = valid && data != NULL;
    size_t used = 0;
    bool ended = false;
    while (valid && !ended)
    {
        if (used == capacity && capacity < limit)
        {
            size_t next = capacity <= limit / 2 ? capacity * 2 : limit;
            unsigned char* grown = realloc(data, next + 1);
            valid = grown != NULL;
            if (valid)
            {
                data = grown;
                capacity = next;
            }
        }
        if (valid && used == capacity)
        {
            int extra = fgetc(file);
            ended = extra == EOF && !ferror(file);
            valid = ended;
        }
        else if (valid)
        {
            size_t count = fread(data + used, 1, capacity - used, file);
            used += count;
            ended = feof(file) != 0;
            valid = !ferror(file);
        }
    }
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    if (valid)
    {
        data[used] = 0;
        output->data = data;
        output->size = used;
    }
    else
    {
        free(data);
        hp_error(error, "cannot read bounded file: %s", path);
    }
    return valid;
}

bool hp_write_file(const char* path, HpBytes bytes, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = bytes.size <= BUSTER_HP_FILE_LIMIT && (bytes.size == 0 || bytes.data != NULL);
    int descriptor = valid ? open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    valid = valid && descriptor >= 0;
    size_t offset = 0;
    while (valid && offset < bytes.size)
    {
        ssize_t written = write(descriptor, bytes.data + offset, bytes.size - offset);
        if (written < 0 && errno == EINTR)
        {
            continue;
        }
        valid = written > 0;
        if (valid)
        {
            offset += (size_t)written;
        }
    }
    if (descriptor >= 0)
    {
        valid = close(descriptor) == 0 && valid;
    }
    if (!valid)
    {
        hp_error(error, "cannot create/write new evidence: %s", path);
    }
    return valid;
}

bool hp_join_path(char output[BUSTER_HP_PATH_CAPACITY], const char* directory, const char* name, char error[BUSTER_HP_ERROR_CAPACITY])
{
    int count = snprintf(output, BUSTER_HP_PATH_CAPACITY, "%s/%s", directory, name);
    bool valid = count > 0 && count < BUSTER_HP_PATH_CAPACITY;
    if (!valid)
    {
        hp_error(error, "path exceeds bounded capacity");
    }
    return valid;
}

bool hp_mkdir_new(const char* path, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = mkdir(path, 0700) == 0;
    if (!valid)
    {
        hp_error(error, "cannot create fresh directory: %s", path);
    }
    return valid;
}

bool hp_files_equal(const char* a, const char* b, char error[BUSTER_HP_ERROR_CAPACITY])
{
    FILE* left = fopen(a, "rb");
    FILE* right = fopen(b, "rb");
    bool valid = left != NULL && right != NULL;
    unsigned char* bytes = valid ? malloc(131072) : NULL;
    valid = valid && bytes != NULL;
    size_t count = 65536;
    while (valid && count != 0)
    {
        count = fread(bytes, 1, 65536, left);
        size_t other = fread(bytes + 65536, 1, 65536, right);
        valid = count == other && memcmp(bytes, bytes + 65536, count) == 0;
    }
    if (left != NULL)
    {
        valid = !ferror(left) && valid;
        valid = fclose(left) == 0 && valid;
    }
    if (right != NULL)
    {
        valid = !ferror(right) && valid;
        valid = fclose(right) == 0 && valid;
    }
    free(bytes);
    if (!valid)
    {
        hp_error(error, "file identity failed: %s / %s", a, b);
    }
    return valid;
}

// Same shell-free hash/copy identity mechanism as the reviewed #624 derivative.
bool hp_sha256_file(const char* path, char digest[65], char error[BUSTER_HP_ERROR_CAPACITY])
{
    int descriptors[2] = { -1, -1 };
    bool valid = pipe(descriptors) == 0;
    pid_t child = valid ? fork() : -1;
    if (child == 0)
    {
        close(descriptors[0]);
        if (dup2(descriptors[1], STDOUT_FILENO) >= 0)
        {
            if (descriptors[1] != STDOUT_FILENO)
            {
                close(descriptors[1]);
            }
            execl("/usr/bin/sha256sum", "sha256sum", "--", path, (char*)NULL);
        }
        _exit(127);
    }
    if (descriptors[1] >= 0)
    {
        close(descriptors[1]);
    }
    FILE* output = child > 0 ? fdopen(descriptors[0], "r") : NULL;
    if (output == NULL && descriptors[0] >= 0)
    {
        close(descriptors[0]);
    }
    char line[8192] = { 0 };
    valid = output != NULL && fgets(line, sizeof(line), output) != NULL && strlen(line) >= 67 && line[64] == ' ' && line[65] == ' ';
    for (size_t i = 0; valid && i < 64; i += 1)
    {
        valid = (line[i] >= '0' && line[i] <= '9') || (line[i] >= 'a' && line[i] <= 'f');
    }
    if (output != NULL)
    {
        bool ended = fgetc(output) == EOF && !ferror(output);
        valid = fclose(output) == 0 && ended && valid;
    }
    int code = -1;
    bool waited = child > 0 && hp_wait(child, &code, error);
    valid = waited && code == 0 && valid;
    if (valid)
    {
        memcpy(digest, line, 64);
        digest[64] = 0;
    }
    else
    {
        hp_error(error, "cannot establish SHA256: %s", path);
    }
    return valid;
}

void hp_arguments_free(HpArguments* arguments)
{
    free(arguments->storage);
    free(arguments->values);
    memset(arguments, 0, sizeof(*arguments));
}

bool hp_arguments_read(HpBytes input, HpArguments* arguments, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = arguments->storage == NULL && arguments->values == NULL && input.data != NULL && input.size > 1 &&
                 input.size <= BUSTER_HP_FILE_LIMIT && input.data[input.size - 1] == 0;
    size_t count = 0;
    size_t start = 0;
    for (size_t i = 0; valid && i < input.size; i += 1)
    {
        if (input.data[i] == 0)
        {
            valid = i != start && count < BUSTER_HP_ARGUMENT_LIMIT;
            count += 1;
            start = i + 1;
        }
    }
    char* storage = valid ? malloc(input.size) : NULL;
    char** values = valid ? calloc(count + 1, sizeof(*values)) : NULL;
    valid = valid && storage != NULL && values != NULL;
    if (valid)
    {
        memcpy(storage, input.data, input.size);
        size_t slot = 0;
        start = 0;
        for (size_t i = 0; i < input.size; i += 1)
        {
            if (storage[i] == 0)
            {
                values[slot++] = storage + start;
                start = i + 1;
            }
        }
        arguments->storage = storage;
        arguments->values = values;
        arguments->count = count;
    }
    else
    {
        free(storage);
        free(values);
        hp_error(error, "empty, partial or oversized NUL API output");
    }
    return valid;
}

bool hp_record_arguments(const char* path, const char* const* arguments, char error[BUSTER_HP_ERROR_CAPACITY])
{
    size_t size = 0;
    bool valid = true;
    size_t count = 0;
    while (valid && arguments[count] != NULL)
    {
        size_t length = strlen(arguments[count]) + 1;
        valid = count < BUSTER_HP_ARGUMENT_LIMIT && length <= SIZE_MAX - size;
        size += valid ? length : 0;
        count += 1;
    }
    unsigned char* data = valid ? malloc(size != 0 ? size : 1) : NULL;
    valid = valid && data != NULL;
    size_t offset = 0;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        size_t length = strlen(arguments[i]) + 1;
        memcpy(data + offset, arguments[i], length);
        offset += length;
    }
    if (valid)
    {
        valid = hp_write_file(path, (HpBytes){ data, size }, error);
    }
    free(data);
    return valid;
}

static int hp_open_capture(const char* path)
{
    int descriptor = open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600);
    int result = descriptor;
    if (descriptor >= 0 && descriptor < 3)
    {
        result = fcntl(descriptor, F_DUPFD_CLOEXEC, 3);
        close(descriptor);
    }
    return result;
}

pid_t hp_spawn(const char* const* arguments, const char* directory, const char* stdout_path, const char* stderr_path, char error[BUSTER_HP_ERROR_CAPACITY])
{
    pid_t child = fork();
    if (child == 0)
    {
        int out = hp_open_capture(stdout_path);
        int err = strcmp(stdout_path, stderr_path) == 0 ? out : hp_open_capture(stderr_path);
        bool ready = (directory == NULL || chdir(directory) == 0) && out >= 0 && err >= 0 && dup2(out, STDOUT_FILENO) >= 0 && dup2(err, STDERR_FILENO) >= 0;
        if (out >= 0 && out != STDOUT_FILENO && out != STDERR_FILENO)
        {
            close(out);
        }
        if (err >= 0 && err != out && err != STDOUT_FILENO && err != STDERR_FILENO)
        {
            close(err);
        }
        if (ready)
        {
            execv(arguments[0], (char* const*)arguments);
        }
        _exit(127);
    }
    if (child < 0)
    {
        hp_error(error, "cannot fork child");
    }
    return child;
}

bool hp_wait(pid_t child, int* code, char error[BUSTER_HP_ERROR_CAPACITY])
{
    int status = -1;
    pid_t waited = -1;
    do
    {
        waited = child > 0 ? waitpid(child, &status, 0) : -1;
    } while (child > 0 && waited < 0 && errno == EINTR);
    bool valid = waited == child && child > 0;
    *code = valid && WIFEXITED(status) ? WEXITSTATUS(status) : valid && WIFSIGNALED(status) ? 128 + WTERMSIG(status) : -1;
    if (!valid)
    {
        hp_error(error, "cannot wait for direct child");
    }
    return valid;
}

bool hp_run(const char* const* arguments, const char* directory, const char* stem, bool split_stderr, int* code, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char record[BUSTER_HP_PATH_CAPACITY];
    char out[BUSTER_HP_PATH_CAPACITY];
    char err[BUSTER_HP_PATH_CAPACITY];
    char status_path[BUSTER_HP_PATH_CAPACITY];
    *code = -1;
    int lengths[] = { snprintf(record, sizeof(record), "%s.argv.nul", stem), snprintf(out, sizeof(out), "%s.stdout", stem),
        snprintf(err, sizeof(err), "%s.%s", stem, split_stderr ? "stderr" : "stdout"), snprintf(status_path, sizeof(status_path), "%s.status", stem) };
    bool valid = true;
    for (size_t i = 0; i < sizeof(lengths) / sizeof(lengths[0]); i += 1)
    {
        valid = lengths[i] > 0 && lengths[i] < BUSTER_HP_PATH_CAPACITY && valid;
    }
    if (!valid)
    {
        hp_error(error, "operation evidence path exceeds bounded capacity");
    }
    valid = valid && hp_record_arguments(record, arguments, error);
    pid_t child = valid ? hp_spawn(arguments, directory, out, err, error) : -1;
    valid = valid && child > 0 && hp_wait(child, code, error);
    if (child > 0)
    {
        char text[40];
        int size = snprintf(text, sizeof(text), "%d\n", *code);
        bool recorded = size > 0 && (size_t)size < sizeof(text) && hp_write_file(status_path, (HpBytes){ (unsigned char*)text, (size_t)size }, error);
        valid = recorded && valid;
    }
    if (valid && *code != 0)
    {
        valid = hp_error(error, "child failed (%d); evidence retained: %s", *code, stem);
    }
    return valid;
}

bool hp_prepare_environment(const char* toolchain, char error[BUSTER_HP_ERROR_CAPACITY])
{
    static const char* cleared[] = { "CPATH", "C_INCLUDE_PATH", "CPLUS_INCLUDE_PATH", "LIBRARY_PATH", "CFLAGS", "CXXFLAGS", "CPPFLAGS", "LDFLAGS",
        "BUSTER_HOST_RUNTIME", "BUSTER_FUZZ_AVAILABLE", "BUSTER_FUZZ_ENTRY", "BUSTER_SANITIZER_OPTIMIZATION",
        "CCC_OVERRIDE_OPTIONS", "COMPILER_PATH", "GCC_EXEC_PREFIX", "LD_PRELOAD", "LD_AUDIT" };
    bool valid = true;
    for (size_t i = 0; i < sizeof(cleared) / sizeof(cleared[0]); i += 1)
    {
        valid = unsetenv(cleared[i]) == 0 && valid;
    }
    char resource[BUSTER_HP_PATH_CAPACITY];
    char library[BUSTER_HP_PATH_CAPACITY];
    char executable[BUSTER_HP_PATH_CAPACITY];
    char* previous = getenv("PATH");
    size_t previous_size = previous != NULL ? strlen(previous) : 0;
    char* path = previous_size <= SIZE_MAX - BUSTER_HP_PATH_CAPACITY ? malloc(previous_size + BUSTER_HP_PATH_CAPACITY) : NULL;
    valid = path != NULL && hp_join_path(resource, toolchain, "lib/clang/23", error) &&
            hp_join_path(library, toolchain, "lib", error) && hp_join_path(executable, toolchain, "bin", error) && valid;
    if (valid)
    {
        int length = snprintf(path, previous_size + BUSTER_HP_PATH_CAPACITY, "%s:%s", executable, previous != NULL ? previous : "/usr/bin:/bin");
        valid = length > 0 && (size_t)length < previous_size + BUSTER_HP_PATH_CAPACITY;
    }
    static const char* names[] = { "BUSTER_HOST_ARCH", "BUSTER_DEBUG_INFO", "BUSTER_SANITIZER", "BUSTER_LINKER", "LC_ALL", "LC_NUMERIC", "SOURCE_DATE_EPOCH" };
    static const char* values[] = { "znver5", "0", "none", "/usr/bin/wild", "C", "C", "1792454400" };
    for (size_t i = 0; valid && i < sizeof(names) / sizeof(names[0]); i += 1)
    {
        valid = setenv(names[i], values[i], 1) == 0;
    }
    if (valid)
    {
        valid = setenv("PATH", path, 1) == 0 && setenv("LD_LIBRARY_PATH", library, 1) == 0 && setenv("BUSTER_CLANG_RESOURCE_DIR", resource, 1) == 0;
    }
    free(path);
    if (!valid)
    {
        hp_error(error, "cannot establish scoped producer environment");
    }
    return valid;
}

static bool hp_digest_text(const char* text)
{
    bool valid = strlen(text) == 64;
    for (size_t i = 0; valid && i < 64; i += 1)
    {
        valid = (text[i] >= '0' && text[i] <= '9') || (text[i] >= 'a' && text[i] <= 'f');
    }
    return valid;
}

bool hp_verify_sources(const char* tree, const char* manifest, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBuffer bytes = { 0 };
    bool valid = hp_read_file(manifest, 4 * 1024 * 1024, &bytes, error) && bytes.size > 0 && memchr(bytes.data, 0, bytes.size) == NULL;
    char* cursor = (char*)bytes.data;
    size_t rows = 0;
    size_t capacity = bytes.size / 67 + 1;
    char** names = valid ? calloc(capacity, sizeof(*names)) : NULL;
    char* canonical_tree = valid ? realpath(tree, NULL) : NULL;
    valid = valid && names != NULL && canonical_tree != NULL;
    while (valid && cursor != NULL && *cursor != 0)
    {
        char* end = strchr(cursor, '\n');
        if (end != NULL)
        {
            *end = 0;
        }
        valid = strlen(cursor) > 66 && cursor[64] == ' ' && cursor[65] == ' ';
        char* name = valid ? cursor + 66 : NULL;
        if (valid)
        {
            cursor[64] = 0;
            valid = hp_digest_text(cursor) && name[0] != '/' && name[0] != 0 && strstr(name, "..") == NULL && rows < capacity;
            for (size_t i = 0; valid && i < rows; i += 1)
            {
                valid = strcmp(names[i], name) != 0;
            }
            if (valid)
            {
                names[rows] = name;
            }
        }
        char path[BUSTER_HP_PATH_CAPACITY];
        char actual[65];
        struct stat state;
        valid = valid && hp_join_path(path, canonical_tree, name, error) && lstat(path, &state) == 0 && S_ISREG(state.st_mode);
        char* resolved = valid ? realpath(path, NULL) : NULL;
        valid = valid && resolved != NULL && strcmp(resolved, path) == 0 &&
                hp_sha256_file(path, actual, error) && strcmp(cursor, actual) == 0;
        free(resolved);
        rows += 1;
        cursor = end != NULL ? end + 1 : NULL;
    }
    valid = rows > 0 && valid;
    free(canonical_tree);
    free(names);
    hp_buffer_free(&bytes);
    if (!valid)
    {
        hp_error(error, "source manifest/file identity failed");
    }
    return valid;
}

bool hp_validate_flags(const HpArguments* flags, char error[BUSTER_HP_ERROR_CAPACITY])
{
    static const char* accepted[] = { "-march=znver5", "-Isrc", "-fwrapv", "-funsigned-char", "-fno-strict-aliasing", "-Wall", "-Werror",
        "-DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\"", "-O3" };
    bool valid = true;
    unsigned march = 0;
    unsigned optimization = 0;
    for (size_t i = 0; valid && i < flags->count; i += 1)
    {
        const char* value = flags->values[i];
        march += strcmp(value, "-march=znver5") == 0;
        optimization += strcmp(value, "-O3") == 0;
        bool known = false;
        for (size_t j = 0; j < sizeof(accepted) / sizeof(accepted[0]); j += 1)
        {
            known |= strcmp(value, accepted[j]) == 0;
        }
        valid = known;
    }
    valid = valid && march == 1 && optimization == 1;
    if (!valid)
    {
        hp_error(error, "unqualified host/C flags");
    }
    return valid;
}

void hp_json_string(FILE* output, HpString text)
{
    fputc('"', output);
    for (size_t i = 0; i < text.size; i += 1)
    {
        unsigned char value = (unsigned char)text.data[i];
        if (value == '"' || value == '\\')
        {
            fputc('\\', output);
            fputc(value, output);
        }
        else if (value < 32 || value >= 127)
        {
            fprintf(output, "\\u%04x", value);
        }
        else
        {
            fputc(value, output);
        }
    }
    fputc('"', output);
}
