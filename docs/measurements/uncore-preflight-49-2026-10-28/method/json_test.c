/* Original parser and malformed-input tests, with no external fixture suite.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#include "json.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static unsigned checks;
static unsigned failures;
#define CHECK(condition, name)                                                                     \
    do                                                                                             \
    {                                                                                              \
        checks++;                                                                                  \
        if (!(condition))                                                                          \
        {                                                                                          \
            failures++;                                                                            \
            fprintf(stderr, "FAIL %s at line %d\n", name, __LINE__);                               \
        }                                                                                          \
    } while (0)

static int parse_bytes(JsonDoc *doc, const void *text, size_t length, int sequence, int expected)
{
    char error[128];
    int actual = json_parse(doc, text, length, sequence, error, sizeof(error));
    CHECK(actual == expected, "parse status");
    if (actual != expected)
        fprintf(stderr, "input length %zu, sequence %d: %s\n", length, sequence, error);
    if (!actual)
    {
        CHECK(!doc->source && !doc->strings && !doc->tokens && !doc->roots && !doc->source_length &&
                  !doc->token_count && !doc->root_count,
              "failed parse clears ownership");
        CHECK(error[0] != 0, "failed parse has error");
    }
    else
        CHECK(error[0] == 0, "successful parse has no error");
    return actual;
}
static int parse_text(JsonDoc *doc, const char *text, int sequence, int expected)
{
    return parse_bytes(doc, text, strlen(text), sequence, expected);
}
static void bad(const char *text)
{
    JsonDoc d;
    parse_text(&d, text, 0, 0);
    json_free(&d);
}
static void valid(const char *text)
{
    JsonDoc d;
    parse_text(&d, text, 0, 1);
    json_free(&d);
}
static int validate_file(const char *path, int sequence)
{
    FILE *f = fopen(path, "rb");
    if (!f || fseek(f, 0, SEEK_END) || ftell(f) < 0)
        return 2;
    size_t length = (size_t)ftell(f);
    if (length > JSON_INPUT_LIMIT)
        return 2;
    rewind(f);
    char *data = malloc(length ? length : 1);
    if (!data || fread(data, 1, length, f) != length || fclose(f))
        return 2;
    JsonDoc d;
    char error[128];
    int ok = json_parse(&d, data, length, sequence, error, sizeof(error));
    free(data);
    if (ok)
        printf("json_file\troots\t%zu\ttokens\t%zu\n", d.root_count, d.token_count);
    else
        fprintf(stderr, "%s\n", error);
    json_free(&d);
    return ok ? 0 : 1;
}
int main(int argc, char **argv)
{
    if (argc == 3 && !strcmp(argv[1], "--validate"))
        return validate_file(argv[2], 0);
    if (argc == 3 && !strcmp(argv[1], "--validate-sequence"))
        return validate_file(argv[2], 1);
    if (argc != 1)
        return 2;

    const char *good[] = {"null",
                          "true",
                          "false",
                          "0",
                          "-0",
                          "123",
                          "-42",
                          "0.5",
                          "-0.25",
                          "1e2",
                          "2E-3",
                          "1E+30",
                          "1.7976931348623157e308",
                          "2.2250738585072014e-308",
                          "\"\"",
                          "[]",
                          "{}",
                          " [ true, false, null, -1.5 ] \n\t",
                          "{\"a\":1,\"unknown\":{\"deeper\":[null,{},[]]}}",
                          "{\"\":0,\"a\":1,\"a\\u0000\":2}",
                          "\"\\\"\\\\\\/\\b\\f\\n\\r\\t\"",
                          "\"\\u0000\\u0041\\u00e9\\u20ac\\ud83d\\ude00\"",
                          "\"\xc2\xa2\xe2\x82\xac\xf0\x9f\x98\x80\xf4\x8f\xbf\xbf\""};
    for (size_t i = 0; i < sizeof(good) / sizeof(good[0]); i++)
        valid(good[i]);
    const char *invalid[] = {"",
                             " ",
                             "\n\t",
                             "NaN",
                             "Infinity",
                             "-Infinity",
                             "nan",
                             "NULL",
                             "True",
                             "False",
                             "undefined",
                             "nul",
                             "truefalse",
                             "false0",
                             "nullx",
                             "+1",
                             ".1",
                             "1.",
                             "-",
                             "--1",
                             "01",
                             "-01",
                             "0x1",
                             "1e",
                             "1e+",
                             "1e-",
                             "1e999",
                             "-1e999",
                             "1e-999",
                             "1 2",
                             "[]{}",
                             "{}x",
                             "[] trailing",
                             "[",
                             "{",
                             "[1",
                             "{\"a\"",
                             "{\"a\":",
                             "{\"a\":1",
                             "[1,]",
                             "{\"a\":1,}",
                             "[,1]",
                             "{,}",
                             "[1 2]",
                             "{1:2}",
                             "{'a':1}",
                             "{\"a\" 1}",
                             "{\"a\":1 \"b\":2}",
                             "[}",
                             "{]",
                             "[true false]",
                             "\"unterminated",
                             "\"\\",
                             "\"\\x00\"",
                             "\"\\v\"",
                             "\"\\u12\"",
                             "\"\\u12xz\"",
                             "\"\\ud800\"",
                             "\"\\udc00\"",
                             "\"\\ud800\\u0041\"",
                             "\"\\ud800\\ud800\"",
                             "\"line\nbreak\"",
                             "\"\t\"",
                             "\"\x01\"",
                             "\"\x7f\x80\"",
                             "\"\xc0\xaf\"",
                             "\"\xc1\xbf\"",
                             "\"\xc2\"",
                             "\"\xc2x\"",
                             "\"\xe0\x80\x80\"",
                             "\"\xed\xa0\x80\"",
                             "\"\xf0\x80\x80\x80\"",
                             "\"\xf4\x90\x80\x80\"",
                             "\"\xf5\x80\x80\x80\"",
                             "\xef\xbb\xbf{}",
                             "/*comment*/{}",
                             "{\"a\":1,\"a\":2}",
                             "{\"a\":1,\"\\u0061\":2}",
                             "{\"\\u00e9\":1,\"\xc3\xa9\":2}",
                             "{\"a\\u0000b\":1,\"a\\u0000b\":2}"};
    for (size_t i = 0; i < sizeof(invalid) / sizeof(invalid[0]); i++)
        bad(invalid[i]);

    JsonDoc d;
    const char *source = "{\"unknown\":[{\"nested\":[0,1,2]},false],\"value\":\"85075.956450\","
                         "\"unsupported\":\"<not supported>\",\"uncounted\":\"<not counted>\","
                         "\"nonfinite\":\"NaN\",\"nil\":null,\"integer\":18446744073709551615}";
    if (parse_text(&d, source, 0, 1))
    {
        const JsonToken *root = json_root(&d, 0);
        CHECK(root && root->type == JSON_OBJECT && root->count == 7, "object pair count");
        CHECK(!json_root(&d, 1), "root bounds");
        const JsonToken *value = json_member(&d, root, "value");
        CHECK(json_equal(&d, value, "85075.956450"), "decoded numeric string retained");
        size_t length;
        const char *raw = json_raw(&d, value, &length);
        CHECK(length == 14 && !memcmp(raw, "\"85075.956450\"", length), "raw quoted span retained");
        double number = -777;
        CHECK(json_number(&d, value, &number) && number == 85075.956450,
              "numeric string conversion");
        const char *keys[] = {"unsupported", "uncounted", "nonfinite", "nil", "missing"};
        for (size_t i = 0; i < sizeof(keys) / sizeof(keys[0]); i++)
        {
            number = -777;
            CHECK(!json_number(&d, json_member(&d, root, keys[i]), &number) && number == -777,
                  "special or missing value never becomes zero");
        }
        CHECK(json_member(&d, root, "nil")->type == JSON_NULL, "null stays null");
        uint64_t integer = 0;
        CHECK(json_u64(&d, json_member(&d, root, "integer"), &integer) && integer == UINT64_MAX,
              "exact maximum unsigned integer");
        const JsonToken *unknown = json_member(&d, root, "unknown");
        CHECK(unknown->type == JSON_ARRAY && unknown->count == 2, "unknown arrays traversed");
        CHECK(json_at(&d, unknown, 0)->type == JSON_OBJECT, "first array item");
        CHECK(json_at(&d, unknown, 1)->type == JSON_FALSE, "subtree skipped for second item");
        CHECK(!json_at(&d, unknown, 2), "array index bounds");
        CHECK(json_next(&d, json_at(&d, unknown, 0)) == json_at(&d, unknown, 1),
              "next skips subtree");
    }
    json_free(&d);
    if (parse_text(&d, "{\"a\\u0000b\":\"x\\u0000y\",\"a\":1}", 0, 1))
    {
        const JsonToken *root = json_root(&d, 0);
        CHECK(json_member(&d, root, "a")->type == JSON_NUMBER,
              "embedded NUL key cannot alias prefix");
        const JsonToken *key = json_first(&d, root), *value = key + 1;
        size_t length;
        const char *text = json_string(&d, value, &length);
        CHECK(length == 3 && text[0] == 'x' && text[1] == 0 && text[2] == 'y',
              "decoded NUL retained");
        CHECK(!json_equal(&d, value, "x"), "literal comparison checks full length");
    }
    json_free(&d);
    const char *numeric_strings[] = {"\"NaN\"",    "\"Infinity\"", "\"1e999\"",
                                     "\"1e-999\"", "\"1x\"",       "\" 1\"",
                                     "\"1 \"",     "\"01\"",       "\"1\\u0000\""};
    for (size_t i = 0; i < sizeof(numeric_strings) / sizeof(numeric_strings[0]); i++)
    {
        if (parse_text(&d, numeric_strings[i], 0, 1))
        {
            double number = 123;
            CHECK(!json_number(&d, json_root(&d, 0), &number) && number == 123,
                  "quoted invalid numeric string preserved without coercion");
        }
        json_free(&d);
    }
    const char *unsigned_bad[] = {"-1", "1.0", "1e2", "18446744073709551616", "null", "true"};
    for (size_t i = 0; i < sizeof(unsigned_bad) / sizeof(unsigned_bad[0]); i++)
    {
        if (parse_text(&d, unsigned_bad[i], 0, 1))
        {
            uint64_t number = 123;
            CHECK(!json_u64(&d, json_root(&d, 0), &number) && number == 123,
                  "unsigned conversion is exact");
        }
        json_free(&d);
    }
    const char *sequence = " \n{\"event\":\"one\",\"counter-value\":\"0\"}\r\n\n"
                           "{\"event\":\"two\",\"counter-value\":\"<not counted>\"}\n";
    if (parse_text(&d, sequence, 1, 1))
    {
        CHECK(d.root_count == 2, "NDJSON root count");
        CHECK(json_equal(&d, json_member(&d, json_root(&d, 1), "event"), "two"),
              "NDJSON second root");
        CHECK(json_next(&d, json_root(&d, 0)) == json_root(&d, 1), "NDJSON subtree iteration");
    }
    json_free(&d);
    parse_text(&d, sequence, 0, 0);
    json_free(&d);
    parse_text(&d, "{} {}", 1, 0);
    json_free(&d);
    parse_text(&d, "{}\n{", 1, 0);
    json_free(&d);
    parse_text(&d, "{}\n{}\n", 1, 1);
    json_free(&d);

    const char *complex = "{\"a\":[null,true,{\"unicode\":\"\\ud83d\\ude00\"}],\"b\":-1.5e+2}";
    for (size_t i = 0; i < strlen(complex); i++)
    {
        parse_bytes(&d, complex, i, 0, 0);
        json_free(&d);
    }
    char nested[JSON_DEPTH_LIMIT * 2 + 2];
    for (size_t i = 0; i < JSON_DEPTH_LIMIT; i++)
        nested[i] = '[';
    for (size_t i = 0; i < JSON_DEPTH_LIMIT; i++)
        nested[JSON_DEPTH_LIMIT + i] = ']';
    nested[JSON_DEPTH_LIMIT * 2] = 0;
    valid(nested);
    memmove(nested + 1, nested, JSON_DEPTH_LIMIT * 2);
    nested[0] = '[';
    nested[JSON_DEPTH_LIMIT * 2 + 1] = ']';
    parse_bytes(&d, nested, JSON_DEPTH_LIMIT * 2 + 2, 0, 0);
    json_free(&d);
    char *large = malloc(JSON_STRING_LIMIT + 4);
    if (!large)
        return 2;
    large[0] = '"';
    memset(large + 1, 'a', JSON_STRING_LIMIT + 1);
    large[JSON_STRING_LIMIT + 1] = '"';
    parse_bytes(&d, large, JSON_STRING_LIMIT + 2, 0, 1);
    json_free(&d);
    large[JSON_STRING_LIMIT + 1] = 'a';
    large[JSON_STRING_LIMIT + 2] = '"';
    parse_bytes(&d, large, JSON_STRING_LIMIT + 3, 0, 0);
    json_free(&d);
    free(large);
    parse_bytes(&d, "0", JSON_INPUT_LIMIT + 1u, 0, 0);
    json_free(&d);
    size_t count = JSON_TOKEN_LIMIT - 1u;
    large = malloc(count * 2 + 4);
    if (!large)
        return 2;
    large[0] = '[';
    for (size_t i = 0; i < count; i++)
    {
        large[1 + i * 2] = '0';
        large[2 + i * 2] = ',';
    }
    large[count * 2] = ']';
    parse_bytes(&d, large, count * 2 + 1, 0, 1);
    json_free(&d);
    large[count * 2] = ',';
    large[count * 2 + 1] = '0';
    large[count * 2 + 2] = ']';
    parse_bytes(&d, large, count * 2 + 3, 0, 0);
    json_free(&d);
    free(large);

    unsigned char mutations[] = {0, '"', '\\', '{', '}', '[', ']', ',', ':', 0x80, 0xff};
    size_t length = strlen(complex);
    char *mutated = malloc(length);
    if (!mutated)
        return 2;
    for (size_t i = 0; i < length; i++)
        for (size_t j = 0; j < sizeof(mutations); j++)
        {
            memcpy(mutated, complex, length);
            mutated[i] = (char)mutations[j];
            char error[64];
            int accepted = json_parse(&d, mutated, length, 0, error, sizeof(error));
            if (accepted)
                for (size_t k = 0; k < d.token_count; k++)
                    CHECK(d.tokens[k].next > k && d.tokens[k].next <= d.token_count &&
                              d.tokens[k].raw_start <= length &&
                              d.tokens[k].raw_length <= length - d.tokens[k].raw_start,
                          "mutation preserves token tree and bounded raw span");
            else
                CHECK(!d.tokens && !d.source && !d.roots, "rejected mutation frees document");
            json_free(&d);
        }
    free(mutated);
    printf("json_tests\tchecks\t%u\tfailures\t%u\n", checks, failures);
    return failures ? 1 : 0;
}
