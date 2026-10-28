/* Original bounded JSON reader; no imported parser or implementation code.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#define _GNU_SOURCE
#include "json.h"
#include <errno.h>
#include <locale.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    JsonDoc *doc;
    size_t at;
    size_t strings_used;
    size_t token_capacity;
    size_t root_capacity;
    char *error;
    size_t error_capacity;
} Parser;

static int reject(Parser *p, const char *reason)
{
    if (p->error && p->error_capacity)
        snprintf(p->error, p->error_capacity, "%s at byte %zu", reason, p->at);
    return 0;
}
static int white(unsigned char c)
{
    return c == ' ' || c == '\t' || c == '\n' || c == '\r';
}
static void space(Parser *p)
{
    while (p->at < p->doc->source_length && white((unsigned char)p->doc->source[p->at]))
        p->at++;
}
static int token(Parser *p, JsonType type, size_t *index)
{
    JsonDoc *d = p->doc;
    if (d->token_count == JSON_TOKEN_LIMIT)
        return reject(p, "token limit");
    if (d->token_count == p->token_capacity)
    {
        size_t capacity = p->token_capacity ? p->token_capacity * 2 : 128;
        if (capacity > JSON_TOKEN_LIMIT)
            capacity = JSON_TOKEN_LIMIT;
        JsonToken *items = realloc(d->tokens, capacity * sizeof(*items));
        if (!items)
            return reject(p, "allocation failed");
        d->tokens = items;
        p->token_capacity = capacity;
    }
    *index = d->token_count++;
    d->tokens[*index] = (JsonToken){.type = type, .raw_start = p->at};
    return 1;
}
static int emit(Parser *p, unsigned char c, size_t begin)
{
    if (p->strings_used - begin >= JSON_STRING_LIMIT || p->strings_used >= p->doc->source_length)
        return reject(p, "decoded string limit");
    p->doc->strings[p->strings_used++] = (char)c;
    return 1;
}
static int codepoint(Parser *p, uint32_t cp, size_t begin)
{
    if (cp < 0x80)
        return emit(p, (unsigned char)cp, begin);
    if (cp < 0x800)
        return emit(p, (unsigned char)(0xc0 | (cp >> 6)), begin) &&
               emit(p, (unsigned char)(0x80 | (cp & 63)), begin);
    if (cp < 0x10000)
        return emit(p, (unsigned char)(0xe0 | (cp >> 12)), begin) &&
               emit(p, (unsigned char)(0x80 | ((cp >> 6) & 63)), begin) &&
               emit(p, (unsigned char)(0x80 | (cp & 63)), begin);
    return emit(p, (unsigned char)(0xf0 | (cp >> 18)), begin) &&
           emit(p, (unsigned char)(0x80 | ((cp >> 12) & 63)), begin) &&
           emit(p, (unsigned char)(0x80 | ((cp >> 6) & 63)), begin) &&
           emit(p, (unsigned char)(0x80 | (cp & 63)), begin);
}
static int hex4(Parser *p, uint32_t *value)
{
    if (p->doc->source_length - p->at < 4)
        return reject(p, "truncated unicode escape");
    uint32_t v = 0;
    for (unsigned i = 0; i < 4; i++)
    {
        unsigned char c = (unsigned char)p->doc->source[p->at++];
        unsigned digit;
        if (c >= '0' && c <= '9')
            digit = c - '0';
        else if (c >= 'a' && c <= 'f')
            digit = c - 'a' + 10;
        else if (c >= 'A' && c <= 'F')
            digit = c - 'A' + 10;
        else
            return reject(p, "invalid unicode escape");
        v = (v << 4) | digit;
    }
    *value = v;
    return 1;
}
static int utf8(Parser *p, unsigned char first, size_t begin)
{
    unsigned following;
    uint32_t cp, minimum;
    if (first >= 0xc2 && first <= 0xdf)
        following = 1, cp = first & 31, minimum = 0x80;
    else if (first >= 0xe0 && first <= 0xef)
        following = 2, cp = first & 15, minimum = 0x800;
    else if (first >= 0xf0 && first <= 0xf4)
        following = 3, cp = first & 7, minimum = 0x10000;
    else
        return reject(p, "invalid UTF-8 lead byte");
    if (p->doc->source_length - p->at < following)
        return reject(p, "truncated UTF-8");
    for (unsigned i = 0; i < following; i++)
    {
        unsigned char c = (unsigned char)p->doc->source[p->at++];
        if ((c & 0xc0) != 0x80)
            return reject(p, "invalid UTF-8 continuation");
        cp = (cp << 6) | (c & 63);
    }
    if (cp < minimum || cp > 0x10ffff || (cp >= 0xd800 && cp <= 0xdfff))
        return reject(p, "invalid UTF-8 code point");
    return codepoint(p, cp, begin);
}
static int string(Parser *p, size_t *index)
{
    if (!token(p, JSON_STRING, index))
        return 0;
    JsonDoc *d = p->doc;
    size_t begin = p->strings_used;
    p->at++; /* Opening quote, checked by caller. */
    while (p->at < d->source_length)
    {
        unsigned char c = (unsigned char)d->source[p->at++];
        if (c == '"')
        {
            JsonToken *t = d->tokens + *index;
            t->raw_length = p->at - t->raw_start;
            t->string_start = begin;
            t->string_length = p->strings_used - begin;
            t->next = d->token_count;
            d->strings[p->strings_used++] = 0;
            return 1;
        }
        if (c < 0x20)
            return reject(p, "unescaped control character");
        if (c >= 0x80)
        {
            if (!utf8(p, c, begin))
                return 0;
            continue;
        }
        if (c != '\\')
        {
            if (!emit(p, c, begin))
                return 0;
            continue;
        }
        if (p->at == d->source_length)
            return reject(p, "truncated escape");
        c = (unsigned char)d->source[p->at++];
        if (c == 'u')
        {
            uint32_t cp;
            if (!hex4(p, &cp))
                return 0;
            if (cp >= 0xd800 && cp <= 0xdbff)
            {
                if (d->source_length - p->at < 2 || d->source[p->at] != '\\' ||
                    d->source[p->at + 1] != 'u')
                    return reject(p, "missing low surrogate");
                p->at += 2;
                uint32_t low;
                if (!hex4(p, &low))
                    return 0;
                if (low < 0xdc00 || low > 0xdfff)
                    return reject(p, "invalid low surrogate");
                cp = 0x10000 + ((cp - 0xd800) << 10) + low - 0xdc00;
            }
            else if (cp >= 0xdc00 && cp <= 0xdfff)
                return reject(p, "unpaired low surrogate");
            if (!codepoint(p, cp, begin))
                return 0;
            continue;
        }
        unsigned char decoded;
        switch (c)
        {
        case '"':
        case '\\':
        case '/':
            decoded = c;
            break;
        case 'b':
            decoded = '\b';
            break;
        case 'f':
            decoded = '\f';
            break;
        case 'n':
            decoded = '\n';
            break;
        case 'r':
            decoded = '\r';
            break;
        case 't':
            decoded = '\t';
            break;
        default:
            return reject(p, "invalid escape");
        }
        if (!emit(p, decoded, begin))
            return 0;
    }
    return reject(p, "unterminated string");
}
static int digit(unsigned char c)
{
    return c >= '0' && c <= '9';
}
static int number_span(const char *s, size_t length, size_t *end)
{
    size_t i = 0;
    if (i < length && s[i] == '-')
        i++;
    if (i == length)
        return 0;
    if (s[i] == '0')
        i++;
    else if (s[i] >= '1' && s[i] <= '9')
        do
        {
            i++;
        } while (i < length && digit((unsigned char)s[i]));
    else
        return 0;
    if (i < length && s[i] == '.')
    {
        i++;
        size_t first = i;
        while (i < length && digit((unsigned char)s[i]))
            i++;
        if (i == first)
            return 0;
    }
    if (i < length && (s[i] == 'e' || s[i] == 'E'))
    {
        i++;
        if (i < length && (s[i] == '+' || s[i] == '-'))
            i++;
        size_t first = i;
        while (i < length && digit((unsigned char)s[i]))
            i++;
        if (i == first)
            return 0;
    }
    *end = i;
    return 1;
}
static int finite_decimal(const char *s, size_t length, double *value)
{
    size_t parsed;
    if (!length || length > JSON_NUMBER_LIMIT || !number_span(s, length, &parsed) ||
        parsed != length)
        return 0;
    locale_t locale = newlocale(LC_NUMERIC_MASK, "C", (locale_t)0);
    if (!locale)
        return 0;
    char *end;
    errno = 0;
    double result = strtod_l(s, &end, locale);
    int valid = end == s + length && errno != ERANGE && isfinite(result);
    freelocale(locale);
    if (valid && value)
        *value = result;
    return valid;
}
static int key_compare(const void *left, const void *right, void *context)
{
    JsonDoc *d = context;
    const JsonToken *a = d->tokens + *(const size_t *)left;
    const JsonToken *b = d->tokens + *(const size_t *)right;
    size_t common = a->string_length < b->string_length ? a->string_length : b->string_length;
    int order = memcmp(d->strings + a->string_start, d->strings + b->string_start, common);
    return order ? order
                 : (a->string_length > b->string_length) - (a->string_length < b->string_length);
}
static int unique_keys(Parser *p, size_t object)
{
    JsonDoc *d = p->doc;
    size_t count = d->tokens[object].count;
    if (count < 2)
        return 1;
    size_t *keys = malloc(count * sizeof(*keys));
    if (!keys)
        return reject(p, "allocation failed");
    size_t at = object + 1;
    for (size_t i = 0; i < count; i++)
    {
        keys[i] = at;
        at = d->tokens[at + 1].next;
    }
    qsort_r(keys, count, sizeof(*keys), key_compare, d);
    int unique = 1;
    for (size_t i = 1; i < count; i++)
        if (!key_compare(keys + i - 1, keys + i, d))
        {
            unique = reject(p, "duplicate object key");
            break;
        }
    free(keys);
    return unique;
}
static int value(Parser *p, unsigned depth, size_t *index)
{
    if (depth > JSON_DEPTH_LIMIT)
        return reject(p, "nesting depth limit");
    JsonDoc *d = p->doc;
    space(p);
    if (p->at == d->source_length)
        return reject(p, "missing value");
    unsigned char c = (unsigned char)d->source[p->at];
    if (c == '"')
        return string(p, index);
    if (c == '{' || c == '[')
    {
        JsonType type = c == '{' ? JSON_OBJECT : JSON_ARRAY;
        char close = c == '{' ? '}' : ']';
        if (!token(p, type, index))
            return 0;
        p->at++;
        space(p);
        if (p->at < d->source_length && d->source[p->at] == close)
            p->at++;
        else
        {
            for (;;)
            {
                size_t child;
                if (type == JSON_OBJECT)
                {
                    if (p->at == d->source_length || d->source[p->at] != '"')
                        return reject(p, "object key is not a string");
                    if (!string(p, &child))
                        return 0;
                    space(p);
                    if (p->at == d->source_length || d->source[p->at++] != ':')
                        return reject(p, "missing object colon");
                }
                if (!value(p, depth + 1, &child))
                    return 0;
                d->tokens[*index].count++;
                space(p);
                if (p->at == d->source_length)
                    return reject(p, "unterminated container");
                char separator = d->source[p->at++];
                if (separator == close)
                    break;
                if (separator != ',')
                    return reject(p, "missing container comma");
                space(p);
            }
        }
        d->tokens[*index].next = d->token_count;
        d->tokens[*index].raw_length = p->at - d->tokens[*index].raw_start;
        return type != JSON_OBJECT || unique_keys(p, *index);
    }
    if (c == '-' || digit(c))
    {
        size_t length;
        if (!number_span(d->source + p->at, d->source_length - p->at, &length))
            return reject(p, "invalid number");
        if (!finite_decimal(d->source + p->at, length, NULL))
            return reject(p, "unrepresentable numeric token");
        if (!token(p, JSON_NUMBER, index))
            return 0;
        d->tokens[*index].raw_length = length;
        d->tokens[*index].next = d->token_count;
        p->at += length;
        return 1;
    }
    const char *literal;
    JsonType type;
    if (c == 't')
        literal = "true", type = JSON_TRUE;
    else if (c == 'f')
        literal = "false", type = JSON_FALSE;
    else if (c == 'n')
        literal = "null", type = JSON_NULL;
    else
        return reject(p, "invalid value");
    size_t length = strlen(literal);
    if (d->source_length - p->at < length || memcmp(d->source + p->at, literal, length))
        return reject(p, "invalid literal");
    if (!token(p, type, index))
        return 0;
    d->tokens[*index].raw_length = length;
    d->tokens[*index].next = d->token_count;
    p->at += length;
    return 1;
}
void json_free(JsonDoc *doc)
{
    if (!doc)
        return;
    free(doc->source);
    free(doc->strings);
    free(doc->tokens);
    free(doc->roots);
    memset(doc, 0, sizeof(*doc));
}
int json_parse(JsonDoc *doc, const void *data, size_t length, int sequence, char *error,
               size_t error_capacity)
{
    if (!doc)
        return 0;
    memset(doc, 0, sizeof(*doc));
    if (error && error_capacity)
        error[0] = 0;
    Parser p = {.doc = doc, .error = error, .error_capacity = error_capacity};
    if (!data || !length || length > JSON_INPUT_LIMIT)
        return reject(&p, "invalid input size");
    doc->source = malloc(length + 1);
    doc->strings = malloc(length + 1);
    if (!doc->source || !doc->strings)
    {
        reject(&p, "allocation failed");
        json_free(doc);
        return 0;
    }
    memcpy(doc->source, data, length);
    doc->source[length] = 0;
    doc->source_length = length;
    for (;;)
    {
        size_t root;
        if (!value(&p, 1, &root))
            break;
        if (doc->root_count == p.root_capacity)
        {
            size_t capacity = p.root_capacity ? p.root_capacity * 2 : 16;
            if (capacity > JSON_TOKEN_LIMIT)
                capacity = JSON_TOKEN_LIMIT;
            size_t *roots = realloc(doc->roots, capacity * sizeof(*roots));
            if (!roots)
            {
                reject(&p, "allocation failed");
                break;
            }
            doc->roots = roots;
            p.root_capacity = capacity;
        }
        doc->roots[doc->root_count++] = root;
        size_t separator = p.at;
        space(&p);
        if (p.at == length)
            return 1;
        if (!sequence)
        {
            reject(&p, "trailing data");
            break;
        }
        if (!memchr(doc->source + separator, '\n', p.at - separator))
        {
            reject(&p, "sequence values require newline separation");
            break;
        }
    }
    json_free(doc);
    return 0;
}
const JsonToken *json_root(const JsonDoc *doc, size_t index)
{
    return doc && index < doc->root_count ? doc->tokens + doc->roots[index] : NULL;
}
const JsonToken *json_first(const JsonDoc *doc, const JsonToken *container)
{
    if (!doc || !container || (container->type != JSON_ARRAY && container->type != JSON_OBJECT) ||
        !container->count)
        return NULL;
    return container + 1;
}
const JsonToken *json_next(const JsonDoc *doc, const JsonToken *node)
{
    return doc && node && node->next < doc->token_count ? doc->tokens + node->next : NULL;
}
const char *json_string(const JsonDoc *doc, const JsonToken *node, size_t *length)
{
    if (!doc || !node || node->type != JSON_STRING)
        return NULL;
    if (length)
        *length = node->string_length;
    return doc->strings + node->string_start;
}
const char *json_raw(const JsonDoc *doc, const JsonToken *node, size_t *length)
{
    if (!doc || !node)
        return NULL;
    if (length)
        *length = node->raw_length;
    return doc->source + node->raw_start;
}
int json_equal(const JsonDoc *doc, const JsonToken *node, const char *literal)
{
    size_t length;
    const char *text = json_string(doc, node, &length);
    return text && literal && strlen(literal) == length && !memcmp(text, literal, length);
}
const JsonToken *json_member(const JsonDoc *doc, const JsonToken *object, const char *key)
{
    if (!doc || !object || object->type != JSON_OBJECT || !key)
        return NULL;
    const JsonToken *at = json_first(doc, object);
    for (size_t i = 0; i < object->count; i++)
    {
        if (json_equal(doc, at, key))
            return at + 1;
        at = json_next(doc, at + 1);
    }
    return NULL;
}
const JsonToken *json_at(const JsonDoc *doc, const JsonToken *array, size_t index)
{
    if (!doc || !array || array->type != JSON_ARRAY || index >= array->count)
        return NULL;
    const JsonToken *at = json_first(doc, array);
    while (index--)
        at = json_next(doc, at);
    return at;
}
static const char *numeric_text(const JsonDoc *doc, const JsonToken *node, size_t *length)
{
    if (!node)
        return NULL;
    if (node->type == JSON_STRING)
        return json_string(doc, node, length);
    return node->type == JSON_NUMBER ? json_raw(doc, node, length) : NULL;
}
int json_number(const JsonDoc *doc, const JsonToken *node, double *value)
{
    size_t length;
    const char *text = numeric_text(doc, node, &length);
    return text && value && finite_decimal(text, length, value);
}
int json_u64(const JsonDoc *doc, const JsonToken *node, uint64_t *value)
{
    size_t length;
    const char *text = numeric_text(doc, node, &length);
    if (!text || !value || !length || length > 20)
        return 0;
    uint64_t result = 0;
    for (size_t i = 0; i < length; i++)
    {
        unsigned char c = (unsigned char)text[i];
        if (!digit(c) || result > (UINT64_MAX - (c - '0')) / 10)
            return 0;
        result = result * 10 + c - '0';
    }
    *value = result;
    return 1;
}
