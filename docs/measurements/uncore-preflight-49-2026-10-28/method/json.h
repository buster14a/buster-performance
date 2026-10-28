/* Original bounded JSON reader for Buster measurement evidence.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#ifndef BUSTER_PREFLIGHT_JSON_H
#define BUSTER_PREFLIGHT_JSON_H
#include <stddef.h>
#include <stdint.h>

#define JSON_INPUT_LIMIT (16u * 1024u * 1024u)
#define JSON_TOKEN_LIMIT 262144u
#define JSON_STRING_LIMIT (1024u * 1024u)
#define JSON_DEPTH_LIMIT 64u
#define JSON_NUMBER_LIMIT 1024u

typedef enum
{
    JSON_OBJECT,
    JSON_ARRAY,
    JSON_STRING,
    JSON_NUMBER,
    JSON_TRUE,
    JSON_FALSE,
    JSON_NULL
} JsonType;

typedef struct
{
    JsonType type;
    size_t raw_start;
    size_t raw_length;
    size_t string_start;
    size_t string_length;
    size_t count; /* Array values or object key/value pairs. */
    size_t next;  /* Index immediately after this entire value subtree. */
} JsonToken;

typedef struct
{
    char *source; /* Owned copy; raw spans remain available until json_free. */
    size_t source_length;
    char *strings;
    JsonToken *tokens;
    size_t *roots;
    size_t token_count;
    size_t root_count;
} JsonDoc;

/* Integer-returning APIs use 1 for success/match and 0 for failure/no match. */
/* Whole-document mode accepts exactly one JSON value. Sequence mode accepts
 * one or more complete JSON values separated by whitespace containing LF.
 * This admits perf's NDJSON without accepting adjacent unseparated values.
 * Duplicate decoded keys, malformed UTF-8 and unpaired surrogates reject.
 * Numeric tokens must be representable as finite doubles without underflow;
 * raw spans still retain the original decimal spelling. Quoted values remain
 * strings regardless of their numeric representability. Free an existing doc
 * before reusing it. On failure doc is empty and error includes a byte offset. */
int json_parse(JsonDoc *doc, const void *data, size_t length, int sequence, char *error,
               size_t error_capacity);
void json_free(JsonDoc *doc);
const JsonToken *json_root(const JsonDoc *doc, size_t index);
const JsonToken *json_first(const JsonDoc *doc, const JsonToken *container);
const JsonToken *json_next(const JsonDoc *doc, const JsonToken *value);
const JsonToken *json_member(const JsonDoc *doc, const JsonToken *object, const char *key);
const JsonToken *json_at(const JsonDoc *doc, const JsonToken *array, size_t index);
/* Strings can contain decoded U+0000: use the returned length or json_equal,
 * not strcmp. A non-string returns NULL. Raw string spans include quotes. */
const char *json_string(const JsonDoc *doc, const JsonToken *token, size_t *length);
int json_equal(const JsonDoc *doc, const JsonToken *token, const char *literal);
const char *json_raw(const JsonDoc *doc, const JsonToken *token, size_t *length);
/* Conversion accepts NUMBER or a numeric STRING; it never coerces null,
 * booleans, '<not supported>', '<not counted>', 'NaN', overflow or underflow
 * to zero. Decimal conversion uses the C locale and requires a finite result.
 * Unsigned conversion requires an exact decimal integer, without exponent. */
int json_number(const JsonDoc *doc, const JsonToken *token, double *value);
int json_u64(const JsonDoc *doc, const JsonToken *token, uint64_t *value);
#endif
