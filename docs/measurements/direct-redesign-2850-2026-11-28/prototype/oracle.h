// The oracle for the front prototype: c_direct's own token stream for a unit (dumped by the instrumented harness),
// each token's place in the main file's text, the macros' bindings in order, and from them the events: the places
// where the main file's text stops being its own tokens (a directive, a macro's expansion, a header's tokens).
#ifndef FRONT_ORACLE_H
#define FRONT_ORACLE_H

#include "ref.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#define PROV_NONE UINT32_C(0xffffffff)

typedef struct OracleEvent OracleEvent;
struct OracleEvent
{
    uint32_t stop;        // the first byte of the main file's text that isn't the stream's own token (or blank)
    uint32_t resume;      // where the text's own tokens go on
    uint32_t out_begin;   // the stream's tokens that the event made: [out_begin, out_end)
    uint32_t out_end;
    uint32_t bind_begin;  // the bindings its directives made: [bind_begin, bind_end)
    uint32_t bind_end;
};

typedef struct OracleBind OracleBind;
struct OracleBind
{
    uint32_t directive;   // the main file's directive that made it: its '#' offset + 1; 0 before the main file
    uint8_t undef;
    uint8_t mode;         // FastMacro.fast_mode
    uint8_t kind;         // FastMacro.fast_kind
    uint8_t is_func;      // a function-like macro: its name without a '(' after it is an identifier
    uint32_t data;        // FastMacro.fast_data
    uint32_t name;        // offsets into `text`
    uint32_t name_length;
    uint32_t replacement;
    uint32_t replacement_length;
};

typedef struct OracleIdent OracleIdent;
struct OracleIdent
{
    uint32_t name;
    uint32_t length;
    uint8_t kw_kind;
    uint8_t pp_kw;
    uint8_t macro_bit;
    uint8_t stop_bit;
};

typedef struct Oracle Oracle;
struct Oracle
{
    const uint8_t* src;
    size_t src_size;
    uint8_t* kinds;
    uint32_t* data;
    uint32_t* prov;
    uint32_t count;
    uint64_t* nums;
    uint32_t num_count;
    OracleIdent* idents;      // by c_direct's IdentId (1-based)
    uint32_t ident_count;
    OracleBind* binds;
    uint32_t bind_count;
    char* text;               // the names' bytes
    OracleEvent* events;
    uint32_t event_count;
    uint8_t* mode;            // the main file's bytes' modes (ref_modes)
    uint32_t* directives;     // ... and its directive lines
    size_t directive_count;
    uint32_t* tok_start;      // each main-text token's first byte and end; PROV_NONE for the others
    uint32_t* tok_end;
    uint32_t text_tokens;
};

// A byte between tokens: a comment's, a blank, or a line splice's backslash.
static inline bool oracle_gap_byte(const Oracle* o, size_t i)
{
    return o->mode[i] == M_COMMENT || (o->mode[i] == M_CODE && (ref_is_blank(o->src[i]) || (o->src[i] == '\\' && o->src[i + 1] == '\n')));
}

static void* oracle_read(const char* dir, const char* name, size_t* size)
{
    char path[1024];
    snprintf(path, sizeof(path), "%s/%s", dir, name);
    const int fd = open(path, O_RDONLY);
    struct stat st;
    if (fd < 0 || fstat(fd, &st) != 0) { fprintf(stderr, "oracle: can't read %s\n", path); exit(2); }
    // 128 bytes past the end, zero: the kernels' loads may go past a text's last byte.
    uint8_t* bytes = (uint8_t*)calloc((size_t)st.st_size + 256u, 1);
    if (read(fd, bytes, (size_t)st.st_size) != st.st_size) { fprintf(stderr, "oracle: short read of %s\n", path); exit(2); }
    close(fd);
    *size = (size_t)st.st_size;
    return bytes;
}

static bool oracle_load(Oracle* o, const char* dir, const char* source)
{
    memset(o, 0, sizeof(*o));
    size_t size = 0;
    {
        const int fd = open(source, O_RDONLY);
        struct stat st;
        if (fd < 0 || fstat(fd, &st) != 0) { fprintf(stderr, "oracle: can't read %s\n", source); return false; }
        // The source with 256 bytes of newlines before and after it.
        uint8_t* bytes = (uint8_t*)malloc((size_t)st.st_size + 512u);
        memset(bytes, '\n', 256);
        if (read(fd, bytes + 256, (size_t)st.st_size) != st.st_size) { return false; }
        memset(bytes + 256 + st.st_size, '\n', 256);
        close(fd);
        o->src = bytes + 256;
        o->src_size = (size_t)st.st_size;
    }
    o->kinds = (uint8_t*)oracle_read(dir, "kinds.bin", &size);
    o->count = (uint32_t)size;
    o->data = (uint32_t*)oracle_read(dir, "data.bin", &size);
    o->prov = (uint32_t*)oracle_read(dir, "prov.bin", &size);
    o->nums = (uint64_t*)oracle_read(dir, "nums.bin", &size);
    o->num_count = (uint32_t)(size / 8u);
    size_t idents_size = 0;
    size_t binds_size = 0;
    char* idents_text = (char*)oracle_read(dir, "idents.txt", &idents_size);
    char* binds_text = (char*)oracle_read(dir, "binds.txt", &binds_size);
    o->text = (char*)malloc(idents_size + binds_size + 16u);
    size_t text_used = 0;

    // idents.txt: "id kw_kind pp_kw macro_bit stop_bit name"
    uint32_t lines = 0;
    for (size_t i = 0; i < idents_size; i += 1) { lines += idents_text[i] == '\n'; }
    o->idents = (OracleIdent*)calloc(lines + 2u, sizeof(OracleIdent));
    o->ident_count = lines;
    {
        char* p = idents_text;
        char* const end = idents_text + idents_size;
        while (p < end)
        {
            char* eol = memchr(p, '\n', (size_t)(end - p));
            if (eol == NULL) { eol = end; }
            unsigned id = 0, kw = 0, pp = 0, mb = 0, sb = 0;
            int used = 0;
            if (sscanf(p, "%u %u %u %u %u %n", &id, &kw, &pp, &mb, &sb, &used) >= 5 && id <= lines)
            {
                const size_t len = (size_t)(eol - (p + used));
                memcpy(o->text + text_used, p + used, len);
                o->idents[id] = (OracleIdent){ .name = (uint32_t)text_used, .length = (uint32_t)len, .kw_kind = (uint8_t)kw, .pp_kw = (uint8_t)pp, .macro_bit = (uint8_t)mb, .stop_bit = (uint8_t)sb };
                text_used += len;
            }
            p = eol + 1;
        }
    }
    // binds.txt: "B directive out_count name mode kind data is_func body_count param_count [replacement]" or "U directive out_count name"
    lines = 0;
    for (size_t i = 0; i < binds_size; i += 1) { lines += binds_text[i] == '\n'; }
    o->binds = (OracleBind*)calloc(lines + 2u, sizeof(OracleBind));
    {
        char* p = binds_text;
        char* const end = binds_text + binds_size;
        while (p < end)
        {
            char* eol = memchr(p, '\n', (size_t)(end - p));
            if (eol == NULL) { eol = end; }
            *eol = '\0';
            OracleBind b = { 0 };
            char name[512];
            char replacement[512] = "";
            unsigned directive = 0, out_count = 0, mode = 0, kind = 0, data = 0, is_func = 0, body = 0, params = 0;
            if (p[0] == 'B' && sscanf(p + 1, "%u %u %511s %u %u %u %u %u %u %511s", &directive, &out_count, name, &mode, &kind, &data, &is_func, &body, &params, replacement) >= 9)
            {
                b.undef = 0;
            }
            else if (p[0] == 'U' && sscanf(p + 1, "%u %u %511s", &directive, &out_count, name) == 3)
            {
                b.undef = 1;
            }
            else { p = eol + 1; continue; }
            b.directive = directive; b.mode = (uint8_t)mode; b.kind = (uint8_t)kind; b.data = data; b.is_func = (uint8_t)(is_func != 0);
            b.name = (uint32_t)text_used; b.name_length = (uint32_t)strlen(name);
            memcpy(o->text + text_used, name, b.name_length); text_used += b.name_length;
            b.replacement = (uint32_t)text_used; b.replacement_length = (uint32_t)strlen(replacement);
            memcpy(o->text + text_used, replacement, b.replacement_length); text_used += b.replacement_length;
            o->binds[o->bind_count++] = b;
            p = eol + 1;
        }
    }

    // The main file's modes and directive lines.
    o->mode = (uint8_t*)malloc(o->src_size + 64u);
    o->directives = (uint32_t*)malloc((o->src_size / 2u + 16u) * 4u);
    size_t unterminated = 0;
    o->directive_count = ref_modes(o->src, o->src_size, o->mode, o->directives, o->src_size / 2u, &unterminated);

    // Each main-text token's extent.
    o->tok_start = (uint32_t*)malloc((size_t)o->count * 4u + 4u);
    o->tok_end = (uint32_t*)malloc((size_t)o->count * 4u + 4u);
    uint32_t mismatched = 0;
    for (uint32_t i = 0; i < o->count; i += 1)
    {
        const uint32_t p = o->prov[i];
        o->tok_start[i] = PROV_NONE;
        o->tok_end[i] = PROV_NONE;
        if (p == PROV_NONE) { continue; }
        size_t start = p >> 1;
        if ((p & 1u) != 0)
        {
            while (start < o->src_size && oracle_gap_byte(o, start)) { start += 1; }
        }
        const RefTok t = ref_lex(o->src, o->src_size, start);
        o->tok_start[i] = t.start;
        o->tok_end[i] = t.end;
        o->text_tokens += 1;
        const uint8_t k = o->kinds[i];
        const bool compatible = (t.kind == K_IDENT) || (t.kind == K_INT && (k == K_INT || k == K_INT_U32 || k == K_INT_I64 || k == K_INT_U64)) ||
                                (t.kind == K_FLOAT && (k == K_FLOAT || k == K_FLOAT32 || k == K_FLOAT80)) || (t.kind == k);
        if (!compatible)
        {
            if (mismatched < 10) { fprintf(stderr, "oracle: token %u at %zu: the stream has kind %u, the text %u (%.*s)\n", i, start, (unsigned)k, t.kind, (int)(t.end - t.start), o->src + t.start); }
            mismatched += 1;
        }
    }
    if (mismatched != 0) { fprintf(stderr, "oracle: %u text tokens' kinds don't fit their text\n", mismatched); }

    // The events: between two text tokens that follow each other in the stream, tokens that aren't the text's, or text
    // that is no blank and no comment.
    o->events = (OracleEvent*)calloc((size_t)o->text_tokens + 4u, sizeof(OracleEvent));
    uint32_t previous_end = 0;       // the text position after the last text token
    uint32_t previous_index = 0;     // the stream index after the last text token
    uint32_t bind_cursor = 0;
    // Bindings made before the main file (the predefines, the command line) are the table's first state.
    while (bind_cursor < o->bind_count && o->binds[bind_cursor].directive == 0) { bind_cursor += 1; }
    for (uint32_t i = 0; i <= o->count; i += 1)
    {
        const bool last = i == o->count;
        if (!last && o->prov[i] == PROV_NONE) { continue; }
        const uint32_t start = last ? (uint32_t)o->src_size : o->tok_start[i];
        // The first byte of the gap that is neither blank nor a comment's.
        uint32_t stop = previous_end;
        while (stop < start && oracle_gap_byte(o, stop)) { stop += 1; }
        if (stop < start || previous_index < i)
        {
            OracleEvent e = { .stop = stop, .resume = start, .out_begin = previous_index, .out_end = i, .bind_begin = bind_cursor, .bind_end = bind_cursor };
            while (bind_cursor < o->bind_count && o->binds[bind_cursor].directive - 1u < start) { bind_cursor += 1; }
            e.bind_end = bind_cursor;
            o->events[o->event_count++] = e;
        }
        if (!last)
        {
            previous_end = o->tok_end[i];
            previous_index = i + 1u;
        }
    }
    if (bind_cursor != o->bind_count) { fprintf(stderr, "oracle: %u bindings after the last event\n", o->bind_count - bind_cursor); }
    return mismatched == 0;
}

#endif
