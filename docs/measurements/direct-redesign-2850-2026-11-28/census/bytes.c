// A census of a C source's bytes by class and of its raw tokens, as text alone shows them (no preprocessing).
// Scalar and plain on purpose: it is an oracle for the counts, not a kernel.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

static int is_ident_start(uint8_t c) { return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || c == '$'; }
static int is_digit(uint8_t c) { return c >= '0' && c <= '9'; }
static int is_ident(uint8_t c) { return is_ident_start(c) || is_digit(c); }

int main(int argc, char** argv)
{
    if (argc < 2) { fprintf(stderr, "usage: bytes FILE\n"); return 2; }
    int fd = open(argv[1], O_RDONLY);
    struct stat st;
    if (fd < 0 || fstat(fd, &st) != 0) { perror("open"); return 1; }
    size_t n = (size_t)st.st_size;
    const uint8_t* s = mmap(NULL, n, PROT_READ, MAP_PRIVATE, fd, 0);
    uint64_t b_block = 0, b_line = 0, b_space = 0, b_newline = 0, b_ident = 0, b_number = 0, b_string = 0, b_char = 0, b_punct = 0, b_other = 0;
    uint64_t t_ident = 0, t_number = 0, t_string = 0, t_char = 0, t_punct = 0;
    uint64_t n_block = 0, n_line = 0, lines = 0, directives = 0, splices = 0;
    uint64_t dir_define = 0, dir_if = 0, dir_include = 0, dir_endif = 0, dir_else = 0, dir_other = 0, dir_bytes = 0;
    uint64_t ident_len_hist[65] = { 0 };
    uint64_t block_events[65] = { 0 };   // 64-byte blocks by how many "decision" bytes they hold (/ " ' # \ and non-ASCII)
    uint64_t blocks_all_comment = 0;
    uint8_t* cls = malloc(n + 1);
    size_t i = 0;
    int bol = 1;
    while (i < n)
    {
        uint8_t c = s[i];
        if (c == '\n') { cls[i] = 'n'; b_newline++; lines++; i++; bol = 1; continue; }
        if (c == ' ' || c == '\t' || c == '\r' || c == '\f' || c == '\v') { cls[i] = ' '; b_space++; i++; continue; }
        if (c == '\\' && i + 1 < n && s[i + 1] == '\n') { cls[i] = ' '; cls[i + 1] = 'n'; splices++; b_space++; b_newline++; lines++; i += 2; continue; }
        if (c == '/' && i + 1 < n && s[i + 1] == '*')
        {
            size_t j = i + 2;
            while (j + 1 < n && !(s[j] == '*' && s[j + 1] == '/')) { if (s[j] == '\n') { lines++; } j++; }
            j = j + 2 <= n ? j + 2 : n;
            memset(cls + i, 'C', j - i);
            b_block += j - i; n_block++; i = j; continue;
        }
        if (c == '/' && i + 1 < n && s[i + 1] == '/')
        {
            size_t j = i + 2;
            while (j < n && s[j] != '\n') { j++; }
            memset(cls + i, 'L', j - i);
            b_line += j - i; n_line++; i = j; continue;
        }
        if (c == '#' && bol)
        {
            // a directive: its name
            size_t j = i + 1;
            while (j < n && (s[j] == ' ' || s[j] == '\t')) { j++; }
            size_t k = j;
            while (k < n && is_ident(s[k])) { k++; }
            size_t len = k - j;
            directives++;
            if (len == 6 && memcmp(s + j, "define", 6) == 0) { dir_define++; }
            else if ((len == 2 && memcmp(s + j, "if", 2) == 0) || (len == 5 && memcmp(s + j, "ifdef", 5) == 0) || (len == 6 && memcmp(s + j, "ifndef", 6) == 0) || (len == 4 && memcmp(s + j, "elif", 4) == 0)) { dir_if++; }
            else if (len == 7 && memcmp(s + j, "include", 7) == 0) { dir_include++; }
            else if (len == 5 && memcmp(s + j, "endif", 5) == 0) { dir_endif++; }
            else if (len == 4 && memcmp(s + j, "else", 4) == 0) { dir_else++; }
            else { dir_other++; }
            // its line's bytes (with splices)
            size_t e = i;
            while (e < n && !(s[e] == '\n' && !(e > 0 && s[e - 1] == '\\'))) { e++; }
            dir_bytes += e - i;
        }
        bol = 0;
        if (is_ident_start(c))
        {
            size_t j = i + 1;
            while (j < n && is_ident(s[j])) { j++; }
            memset(cls + i, 'i', j - i);
            b_ident += j - i; t_ident++; ident_len_hist[j - i < 64 ? j - i : 64]++; i = j; continue;
        }
        if (is_digit(c) || (c == '.' && i + 1 < n && is_digit(s[i + 1])))
        {
            size_t j = i + 1;
            while (j < n && (is_ident(s[j]) || s[j] == '.' || ((s[j] == '+' || s[j] == '-') && (s[j - 1] == 'e' || s[j - 1] == 'E' || s[j - 1] == 'p' || s[j - 1] == 'P')))) { j++; }
            memset(cls + i, 'd', j - i);
            b_number += j - i; t_number++; i = j; continue;
        }
        if (c == '"' || c == '\'')
        {
            size_t j = i + 1;
            while (j < n && s[j] != c && s[j] != '\n') { if (s[j] == '\\' && j + 1 < n) { j++; } j++; }
            j = j < n ? j + 1 : n;
            memset(cls + i, c == '"' ? 's' : 'c', j - i);
            if (c == '"') { b_string += j - i; t_string++; } else { b_char += j - i; t_char++; }
            i = j; continue;
        }
        if (c >= 0x21 && c < 0x7f)
        {
            // punctuators: longest match of the common ones
            size_t len = 1;
            if (i + 2 < n && ((c == '<' && s[i + 1] == '<' && s[i + 2] == '=') || (c == '>' && s[i + 1] == '>' && s[i + 2] == '=') || (c == '.' && s[i + 1] == '.' && s[i + 2] == '.'))) { len = 3; }
            else if (i + 1 < n)
            {
                uint8_t d = s[i + 1];
                if ((c == '-' && (d == '>' || d == '-' || d == '=')) || (c == '+' && (d == '+' || d == '=')) || (c == '&' && (d == '&' || d == '=')) || (c == '|' && (d == '|' || d == '=')) ||
                    (c == '<' && (d == '<' || d == '=')) || (c == '>' && (d == '>' || d == '=')) || ((c == '=' || c == '!' || c == '*' || c == '/' || c == '%' || c == '^') && d == '=') || (c == '#' && d == '#')) { len = 2; }
            }
            memset(cls + i, 'p', len);
            b_punct += len; t_punct++; i += len; continue;
        }
        cls[i] = '?'; b_other++; i++;
    }
    // 64-byte blocks: decision bytes and whole-comment blocks
    for (size_t b = 0; b + 64 <= n; b += 64)
    {
        unsigned events = 0, comment = 0;
        for (unsigned k = 0; k < 64; k++)
        {
            uint8_t c = s[b + k];
            events += c == '/' || c == '"' || c == '\'' || c == '#' || c == '\\' || c >= 0x80;
            comment += cls[b + k] == 'C' || cls[b + k] == 'L';
        }
        block_events[events]++;
        blocks_all_comment += comment == 64;
    }
    uint64_t tokens = t_ident + t_number + t_string + t_char + t_punct;
    printf("bytes %zu lines %llu\n", n, (unsigned long long)lines);
    printf("bytes: block-comment %llu (%.1f%%) line-comment %llu (%.1f%%) space %llu (%.1f%%) newline %llu (%.1f%%)\n",
           (unsigned long long)b_block, 100.0 * b_block / n, (unsigned long long)b_line, 100.0 * b_line / n, (unsigned long long)b_space, 100.0 * b_space / n, (unsigned long long)b_newline, 100.0 * b_newline / n);
    printf("bytes: ident %llu (%.1f%%) number %llu (%.1f%%) string %llu (%.1f%%) char %llu (%.1f%%) punct %llu (%.1f%%) other %llu\n",
           (unsigned long long)b_ident, 100.0 * b_ident / n, (unsigned long long)b_number, 100.0 * b_number / n, (unsigned long long)b_string, 100.0 * b_string / n,
           (unsigned long long)b_char, 100.0 * b_char / n, (unsigned long long)b_punct, 100.0 * b_punct / n, (unsigned long long)b_other);
    printf("comments: block %llu line %llu; splices %llu\n", (unsigned long long)n_block, (unsigned long long)n_line, (unsigned long long)splices);
    printf("raw tokens %llu: ident %llu (%.1f%%) number %llu (%.1f%%) string %llu char %llu punct %llu (%.1f%%); bytes a token %.2f; code bytes a token %.2f\n",
           (unsigned long long)tokens, (unsigned long long)t_ident, 100.0 * t_ident / tokens, (unsigned long long)t_number, 100.0 * t_number / tokens, (unsigned long long)t_string,
           (unsigned long long)t_char, (unsigned long long)t_punct, 100.0 * t_punct / tokens, (double)n / tokens, (double)(b_ident + b_number + b_string + b_char + b_punct) / tokens);
    printf("directives %llu (define %llu, if/ifdef/ifndef/elif %llu, include %llu, endif %llu, else %llu, other %llu), their lines' bytes %llu\n",
           (unsigned long long)directives, (unsigned long long)dir_define, (unsigned long long)dir_if, (unsigned long long)dir_include, (unsigned long long)dir_endif,
           (unsigned long long)dir_else, (unsigned long long)dir_other, (unsigned long long)dir_bytes);
    uint64_t cum = 0;
    printf("identifier lengths (cumulative %%):");
    for (unsigned k = 1; k <= 64; k++)
    {
        cum += ident_len_hist[k];
        if (k == 1 || k == 2 || k == 4 || k == 8 || k == 12 || k == 16 || k == 20 || k == 24 || k == 32 || k == 64) { printf(" <=%u:%.1f", k, 100.0 * cum / t_ident); }
    }
    printf("; mean %.2f\n", (double)b_ident / t_ident);
    uint64_t blocks = n / 64;
    printf("64-byte blocks %llu: all comment %llu (%.1f%%); with 0 decision bytes %llu (%.1f%%), 1: %llu, 2: %llu, 3+: %llu\n", (unsigned long long)blocks,
           (unsigned long long)blocks_all_comment, 100.0 * blocks_all_comment / blocks, (unsigned long long)block_events[0], 100.0 * block_events[0] / blocks,
           (unsigned long long)block_events[1], (unsigned long long)block_events[2], (unsigned long long)(blocks - block_events[0] - block_events[1] - block_events[2]));
    return 0;
}
