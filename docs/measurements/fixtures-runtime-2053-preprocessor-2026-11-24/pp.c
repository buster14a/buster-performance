#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>
#define BUSTER_PP_TEST_SET_ARGUMENTS 4
#define BUSTER_PP_TEST_A64 "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
#define BUSTER_PP_TEST_A512 BUSTER_PP_TEST_A64 BUSTER_PP_TEST_A64 BUSTER_PP_TEST_A64 BUSTER_PP_TEST_A64 BUSTER_PP_TEST_A64 BUSTER_PP_TEST_A64 BUSTER_PP_TEST_A64 BUSTER_PP_TEST_A64
#define BUSTER_PP_TEST_A4096 BUSTER_PP_TEST_A512 BUSTER_PP_TEST_A512 BUSTER_PP_TEST_A512 BUSTER_PP_TEST_A512 BUSTER_PP_TEST_A512 BUSTER_PP_TEST_A512 BUSTER_PP_TEST_A512 BUSTER_PP_TEST_A512
#define BUSTER_PP_DIRECTIVE_TEST_GUARDED "#ifndef G\n#define G\nint g;\n#endif\n"
#define BUSTER_PP_DIRECTIVE_TEST_TWICE "#include \"g.h\"\n#include \"g.h\"\nx\n"
typedef struct PPTestSystemCase PPTestSystemCase;
struct PPTestSystemCase
{
    const char* name;
    const char* source;
    const char* header;
    const char* levels;
    bool inexact;
};
static const PPTestSystemCase pp_test_system_cases[] = {
    // A system header's macros, a paste and a stringification in it, invoked in the main file, and the main file's
    // macro in the header: each token is where its outermost invocation is.
    { "macros across a system header", "#define USERMAC 1\n#include <s.h>\nSYSMAC SYSFN(a) CALLS USERMAC CAT(x, y) STR(q)\n",
      "#define SYSMAC user_token\n#define SYSFN(x) [x]\n#define CALLS USERMAC\n#define CAT(a, b) a ## b\n#define STR(x) #x\n"
      "int header = SYSMAC + USERMAC + CALLS + CAT(1, 2);\n",
      "sssssssssssuuuuuuuu" },
    { "line markers", "#define USER(x) x\n# 1 \"fake-system.h\" 3\n#define SYS(x) (x)\nSYS(1) USER(2)\n# 5 \"main.c\"\nSYS(3) USER(4)\n", "", "ssssuuuu" },
    { "an extern C header's line marker", "# 1 \"c-header.h\" 3 4\n#define E(x) x\nE(1) e\n", "", "ee" },
    { "#pragma GCC system_header", "#define MAINMAC main_value\n#include \"other.h\"\nint c = BEFORE;\n",
      "#define BEFORE before_value\nint a = BEFORE;\n#pragma GCC system_header\nint b = BEFORE + MAINMAC;\n", "uuuuusssssssuuuuu" },
    // A line marker read while the arguments of a system header's F are collected in the user's file: F's body is where
    // the invocation starts, before the marker, and its argument where it is read, after it; the runs would have both
    // after it, and the body's own place is the system header. The second F is all after the marker.
    { "a line marker among an invocation's arguments", "# 1 \"sys.h\" 3\n#define F(x) [x]\n# 5 \"user.c\"\nF(\n# 10 \"s.h\" 3\na) F(b)\n", "",
      "ususss", true },
};
typedef struct PPHistoryCase PPHistoryCase;
struct PPHistoryCase
{
    const char* name;
    const char* source;
    const char* header;
    bool parser;
};
static const PPHistoryCase cases[] = {
        {
            .name = "undefined function-like name",
            .source = "#if IS_IN (libc)\n#endif\n",
        },
        {
            .name = "undefined function-like name in elif",
            .source = "#if 0\n#elif MISSING/**/(1) && 1\n#endif\n",
        },
        {
            .name = "undefined function-like name in short-circuited operands",
            .source = "#if 0 && MISSING(1)\n#endif\n#if 1 || UNKNOWN(2)\n#endif\n",
        },
        {
            .name = "undefined function-like alias",
            .source = "#define ALIAS MISSING\n#if ALIAS(1)\n#endif\n",
        },
        {
            .name = "undefined function-like name in nested expansion",
            .source = "#define INNER MISSING\n#define OUTER INNER\n#define ID(x) x\n#if ID(OUTER)(1)\n#endif\n",
        },
        {
            .name = "undefined function-like self expansion",
            .source = "#define SELF SELF\n#if SELF(1)\n#endif\n",
        },
        {
            .name = "disabled function-like recursive expansion",
            .source = "#define F(x) F\n#if F(1)(2)\n#endif\n",
        },
        {
            .name = "undefined function-like Unicode name",
            .source = "#if caf\\u00e9(1)\n#endif\n",
        },
        {
            .name = "undefined function-like long name is not truncated",
            .source = "#if UNDEFINED_FUNCTION_WITH_A_NAME_LONGER_THAN_SIXTY_FOUR_BYTES_FOR_FULL_DIAGNOSTIC_SPELLING(1)\n#endif\n",
        },
        {
            .name = "undefined function-like name before a splice",
            .source = "#if MISSING\\\n(1)\n#endif\n",
        },
        {
            .name = "undefined function-like included name",
            .source = "#line 40 \"caller.c\"\n#include \"history.h\"\n",
            .header = "#define ALIAS UNKNOWN\n#line 70 \"renamed.h\"\n#if ALIAS(1)\n#endif\n",
        },
        {
            .name = "number before parentheses keeps its operator diagnostic",
            .source = "#define NUMBER 1\n#if NUMBER(2)\n#endif\n",
        },
        {
            .name = "defined before parentheses keeps its operator diagnostic",
            .source = "#if defined(X)(1)\n#endif\n",
        },
        {
            .name = "name after a value keeps its operator diagnostic",
            .source = "#if 1 MISSING(1)\n#endif\n",
        },
        {
            .name = "parenthesized name keeps its operator diagnostic",
            .source = "#if (MISSING)(1)\n#endif\n",
        },
        {
            .name = "object",
            .source = "#define OBJ \"bad\"\n#if OBJ\n#endif\n",
        },
        {
            .name = "function",
            .source = "#define FUN(x) \"bad\"\n#if FUN(1)\n#endif\n",
        },
        {
            .name = "argument",
            .source = "#define ID(x) x\n#if ID(\"bad\")\n#endif\n",
        },
        {
            .name = "nested",
            .source = "#define INNER \"bad\"\n#define OUT INNER\n#if OUT\n#endif\n",
        },
        {
            .name = "argument prescan",
            .source = "#define OBJ \"bad\"\n#define ID(x) x\n#define OUT(x) ID(x)\n#if OUT(OBJ)\n#endif\n",
        },
        {
            .name = "paste",
            .source = "#define CAT(a,b) a##b\n#if CAT(1,.2)\n#endif\n",
        },
        {
            .name = "stringification",
            .source = "#define S(x) #x\n#if S(a b)\n#endif\n",
        },
        {
            .name = "invalid paste",
            .source = "#define P(a,b) a##b\n#define OUT P(+,*)\nOUT\n",
        },
        {
            .name = "arity",
            .source = "#define BAD(x,y) x\n#define OUT BAD(1)\nOUT\n",
        },
        {
            .name = "arity across contexts",
            .source = "#define BAD(x,y) x\n#define NAME BAD\nNAME(1)\n",
        },
        {
            .name = "extra arguments",
            .source = "#define BAD(x) x\n#define OUT BAD(1,2)\nOUT\n",
        },
        {
            .name = "line/include",
            .source = "#line 30 \"caller.c\"\n#include \"history.h\"\n",
            .header = "#define OBJ \"bad\"\n#line 70 \"renamed.h\"\n#if OBJ\n#endif\n",
        },
        {
            .name = "output/redefinition",
            .source = "#define OBJ missing\nint a=OBJ;\n#undef OBJ\n#define OBJ missing\nint b=OBJ;\n",
            .parser = true,
        },
        {
            .name = "output/nested",
            .source = "#define OBJ missing\n#define OUT OBJ\nint a=OUT;\n",
            .parser = true,
        },
        {
            .name = "output/argument",
            .source = "#define ID(x) x\n#define OBJ missing\nint a=ID(OBJ);\n",
            .parser = true,
        },
        {
            .name = "output/paste",
            .source = "#define CAT(a,b) a##b\nint a=CAT(mis,sing);\n",
            .parser = true,
        },
        {
            .name = "empty paste left",
            .source = "#define CAT(a,b) a##b\nint a=CAT(,missing);\n",
            .parser = true,
        },
        {
            .name = "empty paste right",
            .source = "#define CAT(a,b) a##b\nint a=CAT(missing,);\n",
            .parser = true,
        },
        {
            .name = "cross-context invocation",
            .source = "#define ALIAS F\n#define F(x) missing\nint a=ALIAS(1);\n",
            .parser = true,
        },
        {
            .name = "argument macro name",
            .source = "#define CALL(f) f()\n#define F() missing\nint a=CALL(F);\n",
            .parser = true,
        },
        {
            .name = "forwarded function",
            .source = "#define ID(x) x\n#define F(x) missing\nint a=ID(F)(1);\n",
            .parser = true,
        },
        {
            .name = "builtin",
            .source = "#define FILE_NAME __FILE__\n#if FILE_NAME\n#endif\n",
        },
        {
            .name = "empty stringification",
            .source = "#define S(x) #x\n#if S()\n#endif\n",
        },
        {
            .name = "header definition",
            .source = "#include \"history.h\"\nint a=OBJ;\n",
            .header = "#define OBJ missing\n",
            .parser = true,
        },
        {
            .name = "header errors",
            .source = "#include \"history.h\"\n",
            .header = "#define OBJ \"bad\"\n#if OBJ\n#endif\n#if OBJ\n#endif\n",
        },
        {
            .name = "nested include stack",
            .source = "#define STEP\n#include \"history.h\"\n",
            .header = "#ifdef STEP\n#undef STEP\n#include \"history.h\"\n#else\n#define OBJ \"bad\"\n#if OBJ\n#endif\n#endif\n",
        },
        {
            .name = "nested argument name",
            .source = "#define CALL(f) f()\n#define OUT(x) CALL(x)\n#define F() missing\nint a=OUT(F);\n",
            .parser = true,
        },
        {
            .name = "CRLF",
            .source = "#define OBJ \"bad\"\r\n#line 22 \"logical.c\"\r\n#if OBJ\r\n#endif\r\n",
        },
        // #254's review: header names written out that are too long for a path (clang's fatal error about the first
        // path the search tries, and #embed's file not found), the header refused at the depth limit (one error, the
        // includes of it after that left out: the main file includes itself to the limit), and the limit at a name a
        // macro made (at its expansion, with the macro's note).
        {
            .name = "include: an angled name too long for a path",
            .source = "#define " BUSTER_PP_TEST_A4096 " history.h\n#include <" BUSTER_PP_TEST_A4096 ">\n",
            .header = "int found;\n",
        },
        {
            .name = "include: a quoted name too long for a path",
            .source = "#include \"" BUSTER_PP_TEST_A4096 "\"\n",
        },
        // A name with a part longer than a file name may be (NAME_MAX), in a path shorter than PATH_MAX: the open fails
        // (ENAMETOOLONG), and the file cache's probe keeps the error for the search to report. And an absolute name too
        // long for a path, which is the one place searched, not a name in the includer's directory.
        {
            .name = "include: a name with a part longer than NAME_MAX",
            .source = "#include \"" BUSTER_PP_TEST_A512 ".h\"\n",
        },
        {
            .name = "include: an absolute name too long for a path",
            .source = "#include \"/" BUSTER_PP_TEST_A4096 "\"\n",
        },
        {
            .name = "embed: an angled name too long for a path",
            .source = "#define " BUSTER_PP_TEST_A4096 " history.h\n#embed <" BUSTER_PP_TEST_A4096 ">\n",
            .header = "int found;\n",
        },
        // Extra tokens after a name written out are a warning at the first of them.
        {
            .name = "include: extra tokens after a name written out",
            .source = "#include \"history.h\" junk\n#include <history.h> more junk\nint a = missing;\n",
            .header = "int found;\n",
            .parser = true,
        },
        {
            .name = "include: the header refused at the depth limit",
            .source = "#if __INCLUDE_LEVEL__ < 199\n#include \"history.c\"\n#else\n#include \"history.h\"\n#include \"history.h\"\n#endif\n#include \"history.h\"\n",
            .header = "int leaf;\n",
        },
        {
            .name = "include: the depth limit at a name a macro made",
            .source = "#define H \"history.h\"\n#include H\n",
            .header = "#include H\n",
        },
        // -Wunused-macros (#2222), which a pragma enables: the main file's unused definitions at its end, in clang's set's
        // order, an #undef's at it; none for a header's, or for a definition used only in a #if line or by #ifdef.
        {
            .name = "unused macros, preprocessed",
            .source = "#pragma clang diagnostic warning \"-Wunused-macros\"\n#include \"history.h\"\n#define A 1\n#define B A\n"
                      "#define C 3\n#undef C\n#define D 4\n#if D\n#endif\n#define E 5\n#ifdef E\n#endif\n#define F(x) x\nF\n"
                      "#undef HEADER\n#define G 7\n#define H 8\n#error stop\n",
            .header = "#define HEADER 1\n#define HEADER_UNUSED 2\n",
        },
        // -Wgnu-line-marker (#2222), which a pragma enables: at a marker's name, or its line's end, numbered as before its
        // own marker; in a header too.
        {
            .name = "gnu line markers, preprocessed",
            .source = "#pragma clang diagnostic warning \"-Wgnu-line-marker\"\n#include \"history.h\"\n# 5\n# 10 \"history.c\"\n"
                      "# 20 \"other.c\" 1\n#error stop\n",
            .header = "# 7 \"history.h\"\nint h;\n",
        },
        {
            .name = "unused macros: defined, push_macro and pop_macro, preprocessed",
            .source = "#pragma clang diagnostic warning \"-Wunused-macros\"\n#define A 1\n#define B 2\n#if 0 && defined(A)\n#elif defined(B)\n"
                      "#endif\n#define P 1\n#pragma push_macro(\"P\")\n#undef P\n#pragma pop_macro(\"P\")\n#define V 1\n"
                      "#pragma push_macro(\"V\")\n#pragma pop_macro(\"V\")\n#error stop\n",
        },
    };
typedef struct PPDirectiveTestStructure PPDirectiveTestStructure;
struct PPDirectiveTestStructure
{
    const char* name;
    const char* source;
    const char* header;
    const char* standard;
    // Optional exact diagnostic after the main file's path, including the newline. Empty expects no diagnostic.
    const char* diagnostic;
};
static const PPDirectiveTestStructure pp_directive_test_raw_errors[] = {
    { "invalid delimiter character", "R\"bad space\"\n", 0, "gnu17" },
    { "delimiter lookahead past the salvaged token", "R\"a\"b c\n", 0, "gnu17" },
    { "delimiter newline", "LR\"bad\n\"\n", 0, "gnu17" },
    { "delimiter too long", "u8R\"abcdefghijklmnopq\"\n", 0, "gnu17" },
    { "unterminated", "R\"tag(body\n", 0, "gnu17" },
    { "spliced prefix", "L\\\nR\"bad space\"\n", 0, "gnu17" },
    { "macro definitions diagnose once", "#define BAD R\"bad space\"\nBAD BAD\n", 0, "gnu17" },
    { "discarded macro argument", "#define DROP(x) kept\nDROP(R\"bad space\")\n", 0, "gnu17" },
    { "condition after expansion", "#define DROP(x) 1\n#if DROP(R\"bad space\")\nkept\n#endif\n", 0, "gnu17" },
    { "skipped body", "#if 0\nR\"bad space\"\n#endif\n", 0, "gnu17" },
    { "untaken elif is still lexed", "#if 1\nkept\n#elif R\"bad space\"\n#endif\n", 0, "gnu17" },
    { "opaque diagnostic", "#warning R\"bad space\"\n", 0, "gnu17" },
    { "opaque query", "#define HI __has_include\n#if HI(<R\"bad\"x>)\n#endif\n", 0, "gnu17" },
    { "included file", "#include \"structure.h\"\n#include \"structure.h\"\n", "R\"bad space\"\n", "gnu17" },
};
static const PPDirectiveTestStructure pp_directive_test_structures[] = {
    // #1254: exact error text and source character, even without the optional Clang oracle.
    {
        .name = "invalid octal digit",
        .source = "#if 08\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:6: error: invalid digit '8' in octal constant\n",
    },
    {
        .name = "invalid explicit octal digit",
        .source = "#if 0o18\n#endif\n",
        .standard = "c23",
        .diagnostic = ":1:8: error: invalid digit '8' in octal constant\n",
    },
    {
        .name = "invalid binary digit",
        .source = "#if 0b102\n#endif\n",
        .standard = "c23",
        .diagnostic = ":1:9: error: invalid digit '2' in binary constant\n",
    },
    {
        .name = "invalid integer suffix",
        .source = "#if 1lul\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:6: error: invalid suffix 'lul' on integer constant\n",
    },
    {
        .name = "missing hexadecimal digits",
        .source = "#if 0x\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:6: error: invalid suffix 'x' on integer constant\n",
    },
    {
        .name = "missing exponent digits",
        .source = "#if 1e\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:6: error: exponent has no digits\n",
    },
    {
        .name = "missing signed exponent digits",
        .source = "#if 1e+\n#endif\n",
        .standard = "c23",
        .diagnostic = ":1:6: error: exponent has no digits\n",
    },
    {
        .name = "missing hexadecimal exponent digits",
        .source = "#if 0x1p\n#endif\n",
        .standard = "c23",
        .diagnostic = ":1:8: error: exponent has no digits\n",
    },
    {
        .name = "missing hexadecimal exponent",
        .source = "#if 0x1.\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:9: error: hexadecimal floating constant requires an exponent\n",
    },
    {
        .name = "missing hexadecimal significand",
        .source = "#if 0x.p1\n#endif\n",
        .standard = "c23",
        .diagnostic = ":1:8: error: hexadecimal floating constant requires a significand\n",
    },
    {
        .name = "invalid floating suffix",
        .source = "#if 1.0fblah\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:8: error: invalid suffix 'fblah' on floating constant\n",
    },
    {
        .name = "separator at exponent start",
        .source = "#if 1e'2\n#endif\n",
        .standard = "c23",
        .diagnostic = ":1:7: error: digit separator cannot appear at start of digit sequence\n",
    },
    {
        .name = "separator at mantissa end",
        .source = "#if 1'e2\n#endif\n",
        .standard = "c23",
        .diagnostic = ":1:6: error: digit separator cannot appear at end of digit sequence\n",
    },
    {
        .name = "well-formed decimal floating constant",
        .source = "#if 1.5\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:5: error: floating point literal in preprocessor expression\n",
    },
    {
        .name = "well-formed hexadecimal floating constant",
        .source = "#if 0x1p2\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:5: error: floating point literal in preprocessor expression\n",
    },
    {
        .name = "integer overflow unchanged",
        .source = "#if 99999999999999999999999\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:5: error: integer literal is too large to be represented in any integer type\n",
    },
    {
        .name = "invalid digit after LF splice",
        .source = "#if 0\\\n8\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":2:1: error: invalid digit '8' in octal constant\n",
    },
    {
        .name = "invalid digit after CRLF splice",
        .source = "#if 0\\\r\n8\r\n#endif\r\n",
        .standard = "gnu17",
        .diagnostic = ":2:1: error: invalid digit '8' in octal constant\n",
    },
    {
        .name = "invalid suffix after repeated splices",
        .source = "#if 1\\\n\\\nlul\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":3:1: error: invalid suffix 'lul' on integer constant\n",
    },
    {
        .name = "missing exponent after splice",
        .source = "#if 1\\\ne\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":2:1: error: exponent has no digits\n",
    },
    {
        .name = "malformed selected elif",
        .source = "#if 0\n#elif 08\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":2:8: error: invalid digit '8' in octal constant\n",
    },
    {
        .name = "short circuit still checks literal syntax",
        .source = "#if 0 && 08\n#endif\n",
        .standard = "gnu17",
        .diagnostic = ":1:11: error: invalid digit '8' in octal constant\n",
    },
    {
        .name = "skipped group does not check literal syntax",
        .source = "#if 0\n#if 08\n#endif\n#endif\n",
        .standard = "gnu17",
        .diagnostic = "",
    },
    {
        .name = "untaken elif does not check literal syntax",
        .source = "#if 1\n#elif 08\n#endif\n",
        .standard = "gnu17",
        .diagnostic = "",
    },
    {
        .name = "valid integer forms unchanged",
        .source = "#if 0xffu == 255 && 077LL == 63 && 0b10 == 2 && 1ULL == 1\nkept\n#endif\n",
        .standard = "c23",
        .diagnostic = "",
    },
    { "#else after #else", "#if 1\n#else\n#else\n#endif\n", 0, 0 },
    { "#elif after #else", "#if 0\n#else\n#elif 1\n#endif\n#if 1\n#else\n#elif 1\n#endif\n", 0, 0 },
    { "#elifdef and #elifndef after #else", "#if 0\n#else\n#elifdef X\n#endif\n#if 0\n#else\n#elifndef X\n#endif\n", 0, 0 },
    { "the same in C23", "#if 0\n#else\n#elifdef X\n#endif\n#if 1\n#elifndef Y\n#endif\n", 0, "c23" },
    { "without #if", "a\n#endif\nb\n#else\n#elif 1\n#elifdef X\n#elifndef Y\n", 0, 0 },
    { "unterminated", "#if 1\n#if 0\nx\n", 0, 0 },
    { "inside a skipped group", "#if 0\n#if 1\n#else\n#else\n#elif 1\n#endif\n#endif\n", 0, 0 },
    { "deep inside skipped groups",
      "#if 0\n#ifdef A\n#if 2\n#else\n#elifdef B\n#else\n#endif\n#else\n#else\n#endif\n#elif 1\n#else\n#else\n#endif\n", 0, 0 },
    { "after a taken group", "#if 1\n#elif 1\n#if 0\n#else\n#else\n#endif\n#else\n#elif 0\n#endif\n", 0, 0 },
    { "unterminated inside skipped groups", "#if 1\n#if 0\n#if 1\n#ifdef X\n#else\n#else\n", 0, 0 },
    { "unterminated in an include", "#if 1\n#include \"structure.h\"\n#endif\n#endif\n", "#if 1\n#if 0\n#if 1\n", 0 },
    { "a comment that swallows the group", "#if 0\n/* never closed\n#else\n#endif\nx\n", 0, 0 },
    { "an active comment that swallows the group", "#if 1\n/* never closed\n#else\n#endif\nx\n", 0, 0 },
    { "a comment on the opening directive", "#if 0 /* never closed\n#else\n#endif\nx\n", 0, 0 },
    { "a spliced comment on the opening directive", "#if 0\\\n /* never closed\n#else\n#endif\nx\n", 0, 0 },
    { "a comment after a skipped group", "#if 0\n#else /* never closed\n#endif\nx\n", 0, 0 },
    { "a comment after a taken group", "#if 1\n#else /* never closed\n#endif\nx\n", 0, 0 },
    { "a comment on a selected #elif", "#if 0\n#elif 1 /* never closed\n#endif\nx\n", 0, 0 },
    { "a comment on an excluded #elif", "#if 1\n#elif 1 /* never closed\n#endif\nx\n", 0, 0 },
    { "a comment on a skipped group's end", "#if 0\n#endif /* never closed\nx\n", 0, 0 },
    { "a comment in a repeated include", "#include \"structure.h\"\n#include \"structure.h\"\n", "/* never closed\n", 0 },
    { "extra tokens", "#if 1 // c\n#else junk\n#endif junk\n#if 0\n#else junk\n#endif junk\n#ifdef A B\n#endif\n#if 0\n#if 1\n#else x\n#endif y\n#endif\n",
      0, 0 },
    { "extra tokens around the structure", "#else junk\n#endif junk\n#if 0\n#else\n#else junk\n#endif\n#if 1\n#else\n#else junk\n#endif\n#if 1\n#elif 1\n#else junk\n#endif\n",
      0, 0 },
    { "extra tokens on #elifdef", "#if 0\n#elifdef X Y\n#elifndef Z W\n#endif\n", 0, "c23" },
    { "after #line", "#line 100\n#else\n#if 0\n#else\n#else\n#endif\n#line 7 \"renamed.c\"\n#elif 1\n#if 1\n", 0, 0 },
    { "digraphs and splices", "%:if 0\n%:  if 1\n#el\\\nse\n%:else\n%:endif\n#endif\n#\\\nendif\n", 0, 0 },
};
static const PPDirectiveTestStructure pp_directive_test_messages[] = {
    { "an active warning's comment text", "#warning /* never closed\ntail\n", 0, 0 },
    { "an active error's comment text", "#error /* never closed\ntail\n", 0, 0 },
    { "comments, quotes and trailing blanks", "#warning /* comment */ x   \t\n#error '\n", 0, 0 },
    { "a spliced name and message", "#war\\\nning /* op\\\nen\ntail\n", 0, 0 },
    { "an excluded warning's comment", "#if 0\n#warning /* never closed\n#endif\ntail\n", 0, 0 },
    { "an excluded error's comment", "#if 0\n#error /* never closed\n#endif\ntail\n", 0, 0 },
    { "repeated inclusions", "#include \"structure.h\"\n#include \"structure.h\"\n", "#warning /* never closed\ntail\n", 0 },
};
static const PPDirectiveTestStructure pp_directive_test_definitions[] = {
    { "'#' without a parameter", "#define F(x) #y\n#define G() #\n#define H(a) a #\n#define O #y\n#define P(x) #x x ## ##\n", 0, 0 },
    { "'##' at either end", "#define F(x) ## x\n#define G(x) x ##\n#define H ## x\n#define I x ##\n", 0, 0 },
    { "__VA_OPT__",
      "#define F(x) __VA_OPT__(x)\n#define G __VA_OPT__\n#define H(...) __VA_OPT__(__VA_OPT__())\n#define I(...) __VA_OPT__ x\n#define J(...) __VA_OPT__\n"
      "#define K(...) __VA_OPT__(## a)\n#define L(...) __VA_OPT__((a ##))\n#define M(...) __VA_OPT__(a ##)\n#define N(...) #__VA_ARGS__ __VA_OPT__(a ## b)\n",
      0, 0 },
    { "an unterminated __VA_OPT__",
      "#define F(...) __VA_OPT__(\n#define G(...) __VA_OPT__(a\n#define H(...) __VA_OPT__(a (b)\n#define I(...) __VA_OPT__(int\n#define J(...) __VA_OPT__(1\n"
      "#define K(...) __VA_OPT__(<:\n#define L(...) __VA_OPT__(L\"s\"\n#define M(...) __VA_OPT__(@\n",
      0, 0 },
    { "parameter lists",
      "#define A(x, x) x\n#define B(x\n#define C(x,) x\n#define D(\n#define E(1) x\n#define F(...x) x\n#define G(x...y) x\n#define H(x,...,y) x\n"
      "#define I(x y) x\n#define J(a,b,a) a\n#define K(__VA_ARGS__) 1\n#define L(x...) x\n#define M(for, int) for int\n",
      0, 0 },
    { "names", "#define\n#define 123\n#define defined 1\n#undef\n#undef 1\n#undef X Y\n#ifdef\n#endif\n#ifdef 1\n#endif\n#ifndef /* c */ \n#endif\n#if 0\n#elifdef\n#endif\n",
      0, "c23" },
    { "builtins",
      "#define __LINE__ 1\n#undef __FILE__\n#define __STDC__ 2\n#define __has_include 1\n#undef __STDC_VERSION__\n#undef __COUNTER__\n#undef _Pragma\n"
      "#undef __x86_64__\n#define __STDC_HOSTED__ 0\n#undef __LINE__\n",
      0, 0 },
    { "whitespace after the name", "#define A+1\n#define B\"s\"\n#define C\\\n+1\n#define D\\\n 1\n#define E/**/+1\n#define F@\n", 0, 0 },
    { "whitespace after the name in C89", "#define A+1\n#define B@\n#define C`\n#define D\"s\"\n", 0, "c89" },
    { "redefinitions",
      "#define A 1\n#define A 2\n#define B(x) x\n#define B(y) y\n#define C 1\n#define C  1\n#define D a/**/b\n#define D a b\n#define E <:\n#define E [\n"
      "#define G 1 // c\n#define G 1\n#define H /* a */\n#define H\n#define I(x) x\n#undef I\n#define I(y) y\n#define J(...) __VA_OPT__(a)\n#define J(...) __VA_OPT__(a )\n"
      "#define K(x) #x\n#define K(x) # x\n#define L 01\n#define L 1\n",
      0, 0 },
};
typedef struct PPDirectiveTestGuard PPDirectiveTestGuard;
struct PPDirectiveTestGuard
{
    const char* name;
    const char* source;
    const char* files[4][2];
    uint32_t guards;
    uint32_t once;
};
static const PPDirectiveTestGuard pp_directive_test_guard_fixtures[] = {
    { "a guarded file included twice", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", BUSTER_PP_DIRECTIVE_TEST_GUARDED } }, 1, 0 },
    { "#undef between the inclusions", "#include \"g.h\"\n#undef G\n#include \"g.h\"\n#include \"g.h\"\n", { { "g.h", BUSTER_PP_DIRECTIVE_TEST_GUARDED } }, 1, 0 },
    { "#if !defined G", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#if !defined G\n#define G\nint g;\n#endif\n" } }, 1, 0 },
    { "#if !defined(G)", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#if !defined(G)\n#define G\nint g;\n#endif\n" } }, 1, 0 },
    { "parentheses and three '!'", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#if ( !!!( defined ( G ) ) )\n#define G\nint g;\n#endif\n" } }, 1, 0 },
    { "two '!'", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#if !!defined G\n#else\n#define G\nint g;\n#endif\n" } }, 0, 0 },
    { "!defined G || 0", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#if !defined G || 0\n#define G\nint g;\n#endif\n" } }, 0, 0 },
    { "a guard with #else", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#ifndef G\n#define G\nfirst\n#else\nsecond\n#endif\n" } }, 0, 0 },
    { "a guard with #elif", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#ifndef G\n#define G\nfirst\n#elif 1\nsecond\n#endif\n" } }, 0, 0 },
    { "a token before the #ifndef", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "int before;\n#ifndef G\n#define G\n#endif\n" } }, 0, 0 },
    { "a token after the #endif", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#ifndef G\n#define G\n#endif\nint after;\n" } }, 0, 0 },
    { "a directive before the #ifndef", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#define X\n#ifndef G\n#define G\nint g;\n#endif\n" } }, 0, 0 },
    { "a directive after the #endif", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#ifndef G\n#define G\nint g;\n#endif\n#define Y\n" } }, 0, 0 },
    { "comments and null directives around the group", BUSTER_PP_DIRECTIVE_TEST_TWICE,
      { { "g.h", "/* a */\n#\n%:\n#ifndef G // b\n#define G\nint g;\n#endif /* c */\n#\n// d\n" } }, 1, 0 },
    { "extra tokens", BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", "#ifndef G junk\n#define G\nint g;\n#endif junk\n" } }, 1, 0 },
    { "the macro defined before the first inclusion", "#define G\n" BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", BUSTER_PP_DIRECTIVE_TEST_GUARDED } }, 0, 0 },
    { "an inclusion from inside the file", "#include \"n.h\"\n#include \"n.h\"\n", { { "n.h", "#ifndef N\n#define N\n#include \"n.h\"\nint n;\n#endif\n" } }, 1, 0 },
    { "an inclusion in a skipped group", "#if 0\n#include \"g.h\"\n#endif\n" BUSTER_PP_DIRECTIVE_TEST_TWICE, { { "g.h", BUSTER_PP_DIRECTIVE_TEST_GUARDED } }, 1, 0 },
    { "#pragma once through a symbolic link and a hard link", "#include \"o.h\"\n#include \"link.h\"\n#include \"hard.h\"\n#include \"o.h\"\n",
      { { "o.h", "#pragma once\nint o;\n" }, { "link.h", "->o.h" }, { "hard.h", "=>o.h" } }, 0, 3 },
    { "#import", "#import \"i.h\"\n#include \"i.h\"\n#import \"i.h\"\n", { { "i.h", "int i;\n" } }, 0, 2 },
};
typedef struct PPTestOptionSet PPTestOptionSet;
struct PPTestOptionSet
{
    const char* arguments[BUSTER_PP_TEST_SET_ARGUMENTS];
    const char* refused;
};
static const PPTestOptionSet pp_test_option_sets[] = {
    // Refused: each family buster doesn't follow, where its last option turns it on; -fzvector whatever follows it (clang's
    // driver ignores -fno-zvector); and the options without a -fno- form.
    { { "-fms-extensions" }, "-fms-extensions" },
    { { "-fno-ms-extensions", "-fms-extensions" }, "-fms-extensions" },
    { { "-fms-compatibility" }, "-fms-compatibility" },
    { { "-fborland-extensions" }, "-fborland-extensions" },
    { { "-fno-declspec", "-fdeclspec" }, "-fdeclspec" },
    { { "-fzvector" }, "-fzvector" },
    { { "-fzvector", "-fno-zvector" }, "-fzvector" },
    // clang's -mzvector is -fzvector (predefines_alias), and -mno-zvector is -fno-zvector.
    { { "-mzvector" }, "-fzvector" },
    { { "-mzvector", "-mno-zvector" }, "-fzvector" },
    { { "-fno-zos-extensions", "-fzos-extensions" }, "-fzos-extensions" },
    { { "-ffixed-point" }, "-ffixed-point" },
    { { "-fdefer-ts" }, "-fdefer-ts" },
    { { "-fno-directives-only", "-fdirectives-only" }, "-fdirectives-only" },
    { { "-fkeep-system-includes" }, "-fkeep-system-includes" },
    { { "-fminimize-whitespace" }, "-fminimize-whitespace" },
    { { "-fuse-line-directives" }, "-fuse-line-directives" },
    { { "-frewrite-includes" }, "-frewrite-includes" },
    { { "-frewrite-imports" }, "-frewrite-imports" },
    // clang fails without the module it would otherwise build into its cache, so that nothing is written.
    { { "-fno-implicit-modules", "-fno-modules", "-fmodules" }, "-fmodules" },
    { { "-fimplicit-module-maps" }, "-fimplicit-module-maps" },
    { { "-fbuiltin-module-map" }, "-fbuiltin-module-map" },
    { { "-fmodule-name=probe" }, "-fmodule-name=probe" },
    { { "-fmodule-map-file=%d/missing.modulemap" }, "-fmodule-map-file=" },
    { { "-fdriver-only" }, "-fdriver-only" },
    { { "-fproc-stat-report" }, "-fproc-stat-report" },
    { { "-fmacro-prefix-map=%d=/remapped" }, "-fmacro-prefix-map=" },
    { { "-ffile-prefix-map=%d=/remapped" }, "-ffile-prefix-map=" },
    { { "-fexec-charset=UTF-8", "-fexec-charset=latin1" }, "-fexec-charset=latin1" },
    { { "-finput-charset=UTF8" }, "-finput-charset=UTF8" },
    // Taken: the modeled families, each refused family turned off again, -fzvector in assembly, digraphs on and off in
    // any mode (c89 with them is C94, and C94 without them c89: #288), and raw strings off (buster lexes none), each in
    // c17, where clang's lexes none either (a GNU mode's would differ); and UTF-8 charsets in any case.
    { { "-std=c17", "-fgnu-keywords" }, 0 },
    { { "-std=c17", "-fno-raw-string-literals", "-fraw-string-literals" }, 0 },
    { { "-std=gnu89", "-fraw-string-literals" }, 0 },
    { { "-std=gnu99", "-fraw-string-literals", "-fno-raw-string-literals", "-fraw-string-literals" }, 0 },
    { { "-std=gnu23", "-fno-raw-string-literals" }, 0 },
    { { "-x", "assembler-with-cpp", "-fno-raw-string-literals" }, 0 },
    { { "-std=gnu17", "-fno-raw-string-literals", "-fno-asm" }, 0 },
    { { "-std=c17", "-fno-dollars-in-identifiers" }, 0 },
    { { "-std=c17", "-fno-signed-char" }, 0 },
    { { "-std=c17", "-funsigned-char", "-fno-unsigned-char" }, 0 },
    { { "-std=c17", "-fms-extensions", "-fno-ms-extensions" }, 0 },
    { { "-std=c17", "-fms-compatibility", "-fno-ms-compatibility" }, 0 },
    { { "-std=c17", "-fborland-extensions", "-fno-borland-extensions" }, 0 },
    { { "-std=c17", "-fdeclspec", "-fno-declspec" }, 0 },
    { { "-std=c17", "-fno-zvector" }, 0 },
    { { "-std=c17", "-mno-zvector" }, 0 },
    { { "-std=c17", "-x", "assembler-with-cpp", "-fzvector" }, 0 },
    { { "-std=c17", "-fzos-extensions", "-fno-zos-extensions" }, 0 },
    { { "-std=c17", "-ffixed-point", "-fno-fixed-point" }, 0 },
    { { "-std=c17", "-fdefer-ts", "-fno-defer-ts" }, 0 },
    { { "-std=c17", "-fno-digraphs", "-fdigraphs" }, 0 },
    { { "-std=gnu89", "-fno-raw-string-literals", "-fdigraphs" }, 0 },
    { { "-std=c17", "-fdigraphs", "-fno-digraphs" }, 0 },
    { { "-std=c89", "-fdigraphs" }, 0 },
    { { "-std=iso9899:199409", "-fno-digraphs" }, 0 },
    { { "-std=iso9899:199409" }, 0 },
    { { "-std=c89" }, 0 },
    { { "-std=gnu17", "-fraw-string-literals", "-fno-raw-string-literals" }, 0 },
    { { "-std=c17", "-fshort-wchar", "-fno-short-wchar" }, 0 },
    // -fshort-wchar is predefines_option's, which #if's wide character constants follow.
    { { "-std=c17", "-fno-short-wchar", "-fshort-wchar" }, 0 },
    { { "-std=c17", "-fdirectives-only", "-fno-directives-only" }, 0 },
    { { "-std=c17", "-fkeep-system-includes", "-fno-keep-system-includes" }, 0 },
    { { "-std=c17", "-fminimize-whitespace", "-fno-minimize-whitespace" }, 0 },
    { { "-std=c17", "-fuse-line-directives", "-fno-use-line-directives" }, 0 },
    { { "-std=c17", "-frewrite-includes", "-fno-rewrite-includes" }, 0 },
    { { "-std=c17", "-frewrite-imports", "-fno-rewrite-imports" }, 0 },
    { { "-std=c17", "-fmodules", "-fno-modules" }, 0 },
    { { "-std=c17", "-fimplicit-module-maps", "-fno-implicit-module-maps" }, 0 },
    { { "-std=c17", "-fmodules-driver" }, 0 },
    { { "-std=c17", "-fexec-charset=latin1", "-fexec-charset=UTF-8" }, 0 },
    { { "-std=c17", "-finput-charset=Utf-8" }, 0 },
};
static const char pp_test_option_probe[] =
    "#include <stddef.h>\n"
    "__is_identifier(__int64) __is_identifier(_pascal) __is_identifier(__declspec) __is_identifier(__vector) __is_identifier(__ptr32)\n"
    "__is_identifier(_Accum) __is_identifier(_Defer) __is_identifier(asm) __is_identifier(typeof)\n"
    "#define bb BB\naa$bb 1$bb\n"
    "%:define DIGRAPH __STDC_VERSION__\nDIGRAPH <: :> <%= a //* c */ b x // y\n"
    "#define R RR\n#define LR LRR\n#define uR uRR\n#define UR URR\n#define u8R u8RR\n"
    "R\"x(raw)x\" LR\"(l)\" uR\"(u)\" UR\"(U)\" u8R\"(8)\"\n"
    "#if (L'\\0' - 1) < 0\nwide_signed\n#endif\n"
    "#if '\\xff' < 0\nchar_signed\n#endif\n"
    "__FILE__ __MODULE__\n";
static void num(uint32_t n){assert(fwrite(&n,4,1,stdout));}
static void str(const char*p){num(p?strlen(p):UINT32_MAX);if(p)assert(fwrite(p,1,strlen(p),stdout)==strlen(p));}
int main(void){
assert(strlen(" history.h\n#embed <") == sizeof(" history.h\n#embed <")-1);
assert(strlen(" history.h\n#include <") == sizeof(" history.h\n#include <")-1);
assert(strlen("!defined G || 0") == sizeof("!defined G || 0")-1);
assert(strlen("") == sizeof("")-1);
assert(strlen("# 1 \"c-header.h\" 3 4\n#define E(x) x\nE(1) e\n") == sizeof("# 1 \"c-header.h\" 3 4\n#define E(x) x\nE(1) e\n")-1);
assert(strlen("# 1 \"sys.h\" 3\n#define F(x) [x]\n# 5 \"user.c\"\nF(\n# 10 \"s.h\" 3\na) F(b)\n") == sizeof("# 1 \"sys.h\" 3\n#define F(x) [x]\n# 5 \"user.c\"\nF(\n# 10 \"s.h\" 3\na) F(b)\n")-1);
assert(strlen("# 20 \"other.c\" 1\n#error stop\n") == sizeof("# 20 \"other.c\" 1\n#error stop\n")-1);
assert(strlen("# 7 \"history.h\"\nint h;\n") == sizeof("# 7 \"history.h\"\nint h;\n")-1);
assert(strlen("#define ") == sizeof("#define ")-1);
assert(strlen("#define A 1\n#define A 2\n#define B(x) x\n#define B(y) y\n#define C 1\n#define C  1\n#define D a/**/b\n#define D a b\n#define E <:\n#define E [\n") == sizeof("#define A 1\n#define A 2\n#define B(x) x\n#define B(y) y\n#define C 1\n#define C  1\n#define D a/**/b\n#define D a b\n#define E <:\n#define E [\n")-1);
assert(strlen("#define A(x, x) x\n#define B(x\n#define C(x,) x\n#define D(\n#define E(1) x\n#define F(...x) x\n#define G(x...y) x\n#define H(x,...,y) x\n") == sizeof("#define A(x, x) x\n#define B(x\n#define C(x,) x\n#define D(\n#define E(1) x\n#define F(...x) x\n#define G(x...y) x\n#define H(x,...,y) x\n")-1);
assert(strlen("#define A+1\n#define B@\n#define C`\n#define D\"s\"\n") == sizeof("#define A+1\n#define B@\n#define C`\n#define D\"s\"\n")-1);
assert(strlen("#define A+1\n#define B\"s\"\n#define C\\\n+1\n#define D\\\n 1\n#define E/**/+1\n#define F@\n") == sizeof("#define A+1\n#define B\"s\"\n#define C\\\n+1\n#define D\\\n 1\n#define E/**/+1\n#define F@\n")-1);
assert(strlen("#define ALIAS F\n#define F(x) missing\nint a=ALIAS(1);\n") == sizeof("#define ALIAS F\n#define F(x) missing\nint a=ALIAS(1);\n")-1);
assert(strlen("#define ALIAS MISSING\n#if ALIAS(1)\n#endif\n") == sizeof("#define ALIAS MISSING\n#if ALIAS(1)\n#endif\n")-1);
assert(strlen("#define ALIAS UNKNOWN\n#line 70 \"renamed.h\"\n#if ALIAS(1)\n#endif\n") == sizeof("#define ALIAS UNKNOWN\n#line 70 \"renamed.h\"\n#if ALIAS(1)\n#endif\n")-1);
assert(strlen("#define BAD R\"bad space\"\nBAD BAD\n") == sizeof("#define BAD R\"bad space\"\nBAD BAD\n")-1);
assert(strlen("#define BAD(x) x\n#define OUT BAD(1,2)\nOUT\n") == sizeof("#define BAD(x) x\n#define OUT BAD(1,2)\nOUT\n")-1);
assert(strlen("#define BAD(x,y) x\n#define NAME BAD\nNAME(1)\n") == sizeof("#define BAD(x,y) x\n#define NAME BAD\nNAME(1)\n")-1);
assert(strlen("#define BAD(x,y) x\n#define OUT BAD(1)\nOUT\n") == sizeof("#define BAD(x,y) x\n#define OUT BAD(1)\nOUT\n")-1);
assert(strlen("#define BEFORE before_value\nint a = BEFORE;\n#pragma GCC system_header\nint b = BEFORE + MAINMAC;\n") == sizeof("#define BEFORE before_value\nint a = BEFORE;\n#pragma GCC system_header\nint b = BEFORE + MAINMAC;\n")-1);
assert(strlen("#define C 3\n#undef C\n#define D 4\n#if D\n#endif\n#define E 5\n#ifdef E\n#endif\n#define F(x) x\nF\n") == sizeof("#define C 3\n#undef C\n#define D 4\n#if D\n#endif\n#define E 5\n#ifdef E\n#endif\n#define F(x) x\nF\n")-1);
assert(strlen("#define CALL(f) f()\n#define F() missing\nint a=CALL(F);\n") == sizeof("#define CALL(f) f()\n#define F() missing\nint a=CALL(F);\n")-1);
assert(strlen("#define CALL(f) f()\n#define OUT(x) CALL(x)\n#define F() missing\nint a=OUT(F);\n") == sizeof("#define CALL(f) f()\n#define OUT(x) CALL(x)\n#define F() missing\nint a=OUT(F);\n")-1);
assert(strlen("#define CAT(a,b) a##b\n#if CAT(1,.2)\n#endif\n") == sizeof("#define CAT(a,b) a##b\n#if CAT(1,.2)\n#endif\n")-1);
assert(strlen("#define CAT(a,b) a##b\nint a=CAT(,missing);\n") == sizeof("#define CAT(a,b) a##b\nint a=CAT(,missing);\n")-1);
assert(strlen("#define CAT(a,b) a##b\nint a=CAT(mis,sing);\n") == sizeof("#define CAT(a,b) a##b\nint a=CAT(mis,sing);\n")-1);
assert(strlen("#define CAT(a,b) a##b\nint a=CAT(missing,);\n") == sizeof("#define CAT(a,b) a##b\nint a=CAT(missing,);\n")-1);
assert(strlen("#define DROP(x) 1\n#if DROP(R\"bad space\")\nkept\n#endif\n") == sizeof("#define DROP(x) 1\n#if DROP(R\"bad space\")\nkept\n#endif\n")-1);
assert(strlen("#define DROP(x) kept\nDROP(R\"bad space\")\n") == sizeof("#define DROP(x) kept\nDROP(R\"bad space\")\n")-1);
assert(strlen("#define F(...) __VA_OPT__(\n#define G(...) __VA_OPT__(a\n#define H(...) __VA_OPT__(a (b)\n#define I(...) __VA_OPT__(int\n#define J(...) __VA_OPT__(1\n") == sizeof("#define F(...) __VA_OPT__(\n#define G(...) __VA_OPT__(a\n#define H(...) __VA_OPT__(a (b)\n#define I(...) __VA_OPT__(int\n#define J(...) __VA_OPT__(1\n")-1);
assert(strlen("#define F(x) ## x\n#define G(x) x ##\n#define H ## x\n#define I x ##\n") == sizeof("#define F(x) ## x\n#define G(x) x ##\n#define H ## x\n#define I x ##\n")-1);
assert(strlen("#define F(x) #y\n#define G() #\n#define H(a) a #\n#define O #y\n#define P(x) #x x ## ##\n") == sizeof("#define F(x) #y\n#define G() #\n#define H(a) a #\n#define O #y\n#define P(x) #x x ## ##\n")-1);
assert(strlen("#define F(x) F\n#if F(1)(2)\n#endif\n") == sizeof("#define F(x) F\n#if F(1)(2)\n#endif\n")-1);
assert(strlen("#define F(x) __VA_OPT__(x)\n#define G __VA_OPT__\n#define H(...) __VA_OPT__(__VA_OPT__())\n#define I(...) __VA_OPT__ x\n#define J(...) __VA_OPT__\n") == sizeof("#define F(x) __VA_OPT__(x)\n#define G __VA_OPT__\n#define H(...) __VA_OPT__(__VA_OPT__())\n#define I(...) __VA_OPT__ x\n#define J(...) __VA_OPT__\n")-1);
assert(strlen("#define FILE_NAME __FILE__\n#if FILE_NAME\n#endif\n") == sizeof("#define FILE_NAME __FILE__\n#if FILE_NAME\n#endif\n")-1);
assert(strlen("#define FUN(x) \"bad\"\n#if FUN(1)\n#endif\n") == sizeof("#define FUN(x) \"bad\"\n#if FUN(1)\n#endif\n")-1);
assert(strlen("#define G 1 // c\n#define G 1\n#define H /* a */\n#define H\n#define I(x) x\n#undef I\n#define I(y) y\n#define J(...) __VA_OPT__(a)\n#define J(...) __VA_OPT__(a )\n") == sizeof("#define G 1 // c\n#define G 1\n#define H /* a */\n#define H\n#define I(x) x\n#undef I\n#define I(y) y\n#define J(...) __VA_OPT__(a)\n#define J(...) __VA_OPT__(a )\n")-1);
assert(strlen("#define G\n") == sizeof("#define G\n")-1);
assert(strlen("#define H \"history.h\"\n#include H\n") == sizeof("#define H \"history.h\"\n#include H\n")-1);
assert(strlen("#define HEADER 1\n#define HEADER_UNUSED 2\n") == sizeof("#define HEADER 1\n#define HEADER_UNUSED 2\n")-1);
assert(strlen("#define HI __has_include\n#if HI(<R\"bad\"x>)\n#endif\n") == sizeof("#define HI __has_include\n#if HI(<R\"bad\"x>)\n#endif\n")-1);
assert(strlen("#define I(x y) x\n#define J(a,b,a) a\n#define K(__VA_ARGS__) 1\n#define L(x...) x\n#define M(for, int) for int\n") == sizeof("#define I(x y) x\n#define J(a,b,a) a\n#define K(__VA_ARGS__) 1\n#define L(x...) x\n#define M(for, int) for int\n")-1);
assert(strlen("#define ID(x) x\n#define F(x) missing\nint a=ID(F)(1);\n") == sizeof("#define ID(x) x\n#define F(x) missing\nint a=ID(F)(1);\n")-1);
assert(strlen("#define ID(x) x\n#define OBJ missing\nint a=ID(OBJ);\n") == sizeof("#define ID(x) x\n#define OBJ missing\nint a=ID(OBJ);\n")-1);
assert(strlen("#define ID(x) x\n#if ID(\"bad\")\n#endif\n") == sizeof("#define ID(x) x\n#if ID(\"bad\")\n#endif\n")-1);
assert(strlen("#define INNER MISSING\n#define OUTER INNER\n#define ID(x) x\n#if ID(OUTER)(1)\n#endif\n") == sizeof("#define INNER MISSING\n#define OUTER INNER\n#define ID(x) x\n#if ID(OUTER)(1)\n#endif\n")-1);
assert(strlen("#define INNER \"bad\"\n#define OUT INNER\n#if OUT\n#endif\n") == sizeof("#define INNER \"bad\"\n#define OUT INNER\n#if OUT\n#endif\n")-1);
assert(strlen("#define K(...) __VA_OPT__(## a)\n#define L(...) __VA_OPT__((a ##))\n#define M(...) __VA_OPT__(a ##)\n#define N(...) #__VA_ARGS__ __VA_OPT__(a ## b)\n") == sizeof("#define K(...) __VA_OPT__(## a)\n#define L(...) __VA_OPT__((a ##))\n#define M(...) __VA_OPT__(a ##)\n#define N(...) #__VA_ARGS__ __VA_OPT__(a ## b)\n")-1);
assert(strlen("#define K(...) __VA_OPT__(<:\n#define L(...) __VA_OPT__(L\"s\"\n#define M(...) __VA_OPT__(@\n") == sizeof("#define K(...) __VA_OPT__(<:\n#define L(...) __VA_OPT__(L\"s\"\n#define M(...) __VA_OPT__(@\n")-1);
assert(strlen("#define K(x) #x\n#define K(x) # x\n#define L 01\n#define L 1\n") == sizeof("#define K(x) #x\n#define K(x) # x\n#define L 01\n#define L 1\n")-1);
assert(strlen("#define MAINMAC main_value\n#include \"other.h\"\nint c = BEFORE;\n") == sizeof("#define MAINMAC main_value\n#include \"other.h\"\nint c = BEFORE;\n")-1);
assert(strlen("#define NUMBER 1\n#if NUMBER(2)\n#endif\n") == sizeof("#define NUMBER 1\n#if NUMBER(2)\n#endif\n")-1);
assert(strlen("#define OBJ \"bad\"\n#define ID(x) x\n#define OUT(x) ID(x)\n#if OUT(OBJ)\n#endif\n") == sizeof("#define OBJ \"bad\"\n#define ID(x) x\n#define OUT(x) ID(x)\n#if OUT(OBJ)\n#endif\n")-1);
assert(strlen("#define OBJ \"bad\"\n#if OBJ\n#endif\n") == sizeof("#define OBJ \"bad\"\n#if OBJ\n#endif\n")-1);
assert(strlen("#define OBJ \"bad\"\n#if OBJ\n#endif\n#if OBJ\n#endif\n") == sizeof("#define OBJ \"bad\"\n#if OBJ\n#endif\n#if OBJ\n#endif\n")-1);
assert(strlen("#define OBJ \"bad\"\n#line 70 \"renamed.h\"\n#if OBJ\n#endif\n") == sizeof("#define OBJ \"bad\"\n#line 70 \"renamed.h\"\n#if OBJ\n#endif\n")-1);
assert(strlen("#define OBJ \"bad\"\r\n#line 22 \"logical.c\"\r\n#if OBJ\r\n#endif\r\n") == sizeof("#define OBJ \"bad\"\r\n#line 22 \"logical.c\"\r\n#if OBJ\r\n#endif\r\n")-1);
assert(strlen("#define OBJ missing\n") == sizeof("#define OBJ missing\n")-1);
assert(strlen("#define OBJ missing\n#define OUT OBJ\nint a=OUT;\n") == sizeof("#define OBJ missing\n#define OUT OBJ\nint a=OUT;\n")-1);
assert(strlen("#define OBJ missing\nint a=OBJ;\n#undef OBJ\n#define OBJ missing\nint b=OBJ;\n") == sizeof("#define OBJ missing\nint a=OBJ;\n#undef OBJ\n#define OBJ missing\nint b=OBJ;\n")-1);
assert(strlen("#define P(a,b) a##b\n#define OUT P(+,*)\nOUT\n") == sizeof("#define P(a,b) a##b\n#define OUT P(+,*)\nOUT\n")-1);
assert(strlen("#define S(x) #x\n#if S()\n#endif\n") == sizeof("#define S(x) #x\n#if S()\n#endif\n")-1);
assert(strlen("#define S(x) #x\n#if S(a b)\n#endif\n") == sizeof("#define S(x) #x\n#if S(a b)\n#endif\n")-1);
assert(strlen("#define SELF SELF\n#if SELF(1)\n#endif\n") == sizeof("#define SELF SELF\n#if SELF(1)\n#endif\n")-1);
assert(strlen("#define STEP\n#include \"history.h\"\n") == sizeof("#define STEP\n#include \"history.h\"\n")-1);
assert(strlen("#define SYSMAC user_token\n#define SYSFN(x) [x]\n#define CALLS USERMAC\n#define CAT(a, b) a ## b\n#define STR(x) #x\n") == sizeof("#define SYSMAC user_token\n#define SYSFN(x) [x]\n#define CALLS USERMAC\n#define CAT(a, b) a ## b\n#define STR(x) #x\n")-1);
assert(strlen("#define USER(x) x\n# 1 \"fake-system.h\" 3\n#define SYS(x) (x)\nSYS(1) USER(2)\n# 5 \"main.c\"\nSYS(3) USER(4)\n") == sizeof("#define USER(x) x\n# 1 \"fake-system.h\" 3\n#define SYS(x) (x)\nSYS(1) USER(2)\n# 5 \"main.c\"\nSYS(3) USER(4)\n")-1);
assert(strlen("#define USERMAC 1\n#include <s.h>\nSYSMAC SYSFN(a) CALLS USERMAC CAT(x, y) STR(q)\n") == sizeof("#define USERMAC 1\n#include <s.h>\nSYSMAC SYSFN(a) CALLS USERMAC CAT(x, y) STR(q)\n")-1);
assert(strlen("#define X\n#ifndef G\n#define G\nint g;\n#endif\n") == sizeof("#define X\n#ifndef G\n#define G\nint g;\n#endif\n")-1);
assert(strlen("#define __LINE__ 1\n#undef __FILE__\n#define __STDC__ 2\n#define __has_include 1\n#undef __STDC_VERSION__\n#undef __COUNTER__\n#undef _Pragma\n") == sizeof("#define __LINE__ 1\n#undef __FILE__\n#define __STDC__ 2\n#define __has_include 1\n#undef __STDC_VERSION__\n#undef __COUNTER__\n#undef _Pragma\n")-1);
assert(strlen("#define\n#define 123\n#define defined 1\n#undef\n#undef 1\n#undef X Y\n#ifdef\n#endif\n#ifdef 1\n#endif\n#ifndef /* c */ \n#endif\n#if 0\n#elifdef\n#endif\n") == sizeof("#define\n#define 123\n#define defined 1\n#undef\n#undef 1\n#undef X Y\n#ifdef\n#endif\n#ifdef 1\n#endif\n#ifndef /* c */ \n#endif\n#if 0\n#elifdef\n#endif\n")-1);
assert(strlen("#elif after #else") == sizeof("#elif after #else")-1);
assert(strlen("#elifdef and #elifndef after #else") == sizeof("#elifdef and #elifndef after #else")-1);
assert(strlen("#else after #else") == sizeof("#else after #else")-1);
assert(strlen("#else junk\n#endif junk\n#if 0\n#else\n#else junk\n#endif\n#if 1\n#else\n#else junk\n#endif\n#if 1\n#elif 1\n#else junk\n#endif\n") == sizeof("#else junk\n#endif junk\n#if 0\n#else\n#else junk\n#endif\n#if 1\n#else\n#else junk\n#endif\n#if 1\n#elif 1\n#else junk\n#endif\n")-1);
assert(strlen("#endif\n#define P 1\n#pragma push_macro(\"P\")\n#undef P\n#pragma pop_macro(\"P\")\n#define V 1\n") == sizeof("#endif\n#define P 1\n#pragma push_macro(\"P\")\n#undef P\n#pragma pop_macro(\"P\")\n#define V 1\n")-1);
assert(strlen("#error /* never closed\ntail\n") == sizeof("#error /* never closed\ntail\n")-1);
assert(strlen("#if !!defined G\n#else\n#define G\nint g;\n#endif\n") == sizeof("#if !!defined G\n#else\n#define G\nint g;\n#endif\n")-1);
assert(strlen("#if !defined G || 0\n#define G\nint g;\n#endif\n") == sizeof("#if !defined G || 0\n#define G\nint g;\n#endif\n")-1);
assert(strlen("#if !defined G") == sizeof("#if !defined G")-1);
assert(strlen("#if !defined G\n#define G\nint g;\n#endif\n") == sizeof("#if !defined G\n#define G\nint g;\n#endif\n")-1);
assert(strlen("#if !defined(G)") == sizeof("#if !defined(G)")-1);
assert(strlen("#if !defined(G)\n#define G\nint g;\n#endif\n") == sizeof("#if !defined(G)\n#define G\nint g;\n#endif\n")-1);
assert(strlen("#if ( !!!( defined ( G ) ) )\n#define G\nint g;\n#endif\n") == sizeof("#if ( !!!( defined ( G ) ) )\n#define G\nint g;\n#endif\n")-1);
assert(strlen("#if (MISSING)(1)\n#endif\n") == sizeof("#if (MISSING)(1)\n#endif\n")-1);
assert(strlen("#if 0 && 08\n#endif\n") == sizeof("#if 0 && 08\n#endif\n")-1);
assert(strlen("#if 0 && MISSING(1)\n#endif\n#if 1 || UNKNOWN(2)\n#endif\n") == sizeof("#if 0 && MISSING(1)\n#endif\n#if 1 || UNKNOWN(2)\n#endif\n")-1);
assert(strlen("#if 0 /* never closed\n#else\n#endif\nx\n") == sizeof("#if 0 /* never closed\n#else\n#endif\nx\n")-1);
assert(strlen("#if 08\n#endif\n") == sizeof("#if 08\n#endif\n")-1);
assert(strlen("#if 0\\\n /* never closed\n#else\n#endif\nx\n") == sizeof("#if 0\\\n /* never closed\n#else\n#endif\nx\n")-1);
assert(strlen("#if 0\\\n8\n#endif\n") == sizeof("#if 0\\\n8\n#endif\n")-1);
assert(strlen("#if 0\\\r\n8\r\n#endif\r\n") == sizeof("#if 0\\\r\n8\r\n#endif\r\n")-1);
assert(strlen("#if 0\n#elif 08\n#endif\n") == sizeof("#if 0\n#elif 08\n#endif\n")-1);
assert(strlen("#if 0\n#elif 1 /* never closed\n#endif\nx\n") == sizeof("#if 0\n#elif 1 /* never closed\n#endif\nx\n")-1);
assert(strlen("#if 0\n#elif MISSING/**/(1) && 1\n#endif\n") == sizeof("#if 0\n#elif MISSING/**/(1) && 1\n#endif\n")-1);
assert(strlen("#if 0\n#elifdef X Y\n#elifndef Z W\n#endif\n") == sizeof("#if 0\n#elifdef X Y\n#elifndef Z W\n#endif\n")-1);
assert(strlen("#if 0\n#else /* never closed\n#endif\nx\n") == sizeof("#if 0\n#else /* never closed\n#endif\nx\n")-1);
assert(strlen("#if 0\n#else\n#elif 1\n#endif\n#if 1\n#else\n#elif 1\n#endif\n") == sizeof("#if 0\n#else\n#elif 1\n#endif\n#if 1\n#else\n#elif 1\n#endif\n")-1);
assert(strlen("#if 0\n#else\n#elifdef X\n#endif\n#if 0\n#else\n#elifndef X\n#endif\n") == sizeof("#if 0\n#else\n#elifdef X\n#endif\n#if 0\n#else\n#elifndef X\n#endif\n")-1);
assert(strlen("#if 0\n#else\n#elifdef X\n#endif\n#if 1\n#elifndef Y\n#endif\n") == sizeof("#if 0\n#else\n#elifdef X\n#endif\n#if 1\n#elifndef Y\n#endif\n")-1);
assert(strlen("#if 0\n#endif /* never closed\nx\n") == sizeof("#if 0\n#endif /* never closed\nx\n")-1);
assert(strlen("#if 0\n#error /* never closed\n#endif\ntail\n") == sizeof("#if 0\n#error /* never closed\n#endif\ntail\n")-1);
assert(strlen("#if 0\n#if 08\n#endif\n#endif\n") == sizeof("#if 0\n#if 08\n#endif\n#endif\n")-1);
assert(strlen("#if 0\n#if 1\n#else\n#else\n#elif 1\n#endif\n#endif\n") == sizeof("#if 0\n#if 1\n#else\n#else\n#elif 1\n#endif\n#endif\n")-1);
assert(strlen("#if 0\n#ifdef A\n#if 2\n#else\n#elifdef B\n#else\n#endif\n#else\n#else\n#endif\n#elif 1\n#else\n#else\n#endif\n") == sizeof("#if 0\n#ifdef A\n#if 2\n#else\n#elifdef B\n#else\n#endif\n#else\n#else\n#endif\n#elif 1\n#else\n#else\n#endif\n")-1);
assert(strlen("#if 0\n#include \"g.h\"\n#endif\n") == sizeof("#if 0\n#include \"g.h\"\n#endif\n")-1);
assert(strlen("#if 0\n#warning /* never closed\n#endif\ntail\n") == sizeof("#if 0\n#warning /* never closed\n#endif\ntail\n")-1);
assert(strlen("#if 0\n/* never closed\n#else\n#endif\nx\n") == sizeof("#if 0\n/* never closed\n#else\n#endif\nx\n")-1);
assert(strlen("#if 0\nR\"bad space\"\n#endif\n") == sizeof("#if 0\nR\"bad space\"\n#endif\n")-1);
assert(strlen("#if 0b102\n#endif\n") == sizeof("#if 0b102\n#endif\n")-1);
assert(strlen("#if 0o18\n#endif\n") == sizeof("#if 0o18\n#endif\n")-1);
assert(strlen("#if 0x.p1\n#endif\n") == sizeof("#if 0x.p1\n#endif\n")-1);
assert(strlen("#if 0x1.\n#endif\n") == sizeof("#if 0x1.\n#endif\n")-1);
assert(strlen("#if 0x1p2\n#endif\n") == sizeof("#if 0x1p2\n#endif\n")-1);
assert(strlen("#if 0x1p\n#endif\n") == sizeof("#if 0x1p\n#endif\n")-1);
assert(strlen("#if 0x\n#endif\n") == sizeof("#if 0x\n#endif\n")-1);
assert(strlen("#if 0xffu == 255 && 077LL == 63 && 0b10 == 2 && 1ULL == 1\nkept\n#endif\n") == sizeof("#if 0xffu == 255 && 077LL == 63 && 0b10 == 2 && 1ULL == 1\nkept\n#endif\n")-1);
assert(strlen("#if 1 // c\n#else junk\n#endif junk\n#if 0\n#else junk\n#endif junk\n#ifdef A B\n#endif\n#if 0\n#if 1\n#else x\n#endif y\n#endif\n") == sizeof("#if 1 // c\n#else junk\n#endif junk\n#if 0\n#else junk\n#endif junk\n#ifdef A B\n#endif\n#if 0\n#if 1\n#else x\n#endif y\n#endif\n")-1);
assert(strlen("#if 1 MISSING(1)\n#endif\n") == sizeof("#if 1 MISSING(1)\n#endif\n")-1);
assert(strlen("#if 1'e2\n#endif\n") == sizeof("#if 1'e2\n#endif\n")-1);
assert(strlen("#if 1.0fblah\n#endif\n") == sizeof("#if 1.0fblah\n#endif\n")-1);
assert(strlen("#if 1.5\n#endif\n") == sizeof("#if 1.5\n#endif\n")-1);
assert(strlen("#if 1\\\n\\\nlul\n#endif\n") == sizeof("#if 1\\\n\\\nlul\n#endif\n")-1);
assert(strlen("#if 1\\\ne\n#endif\n") == sizeof("#if 1\\\ne\n#endif\n")-1);
assert(strlen("#if 1\n#elif 08\n#endif\n") == sizeof("#if 1\n#elif 08\n#endif\n")-1);
assert(strlen("#if 1\n#elif 1 /* never closed\n#endif\nx\n") == sizeof("#if 1\n#elif 1 /* never closed\n#endif\nx\n")-1);
assert(strlen("#if 1\n#elif 1\n#if 0\n#else\n#else\n#endif\n#else\n#elif 0\n#endif\n") == sizeof("#if 1\n#elif 1\n#if 0\n#else\n#else\n#endif\n#else\n#elif 0\n#endif\n")-1);
assert(strlen("#if 1\n#else /* never closed\n#endif\nx\n") == sizeof("#if 1\n#else /* never closed\n#endif\nx\n")-1);
assert(strlen("#if 1\n#else\n#else\n#endif\n") == sizeof("#if 1\n#else\n#else\n#endif\n")-1);
assert(strlen("#if 1\n#if 0\n#if 1\n") == sizeof("#if 1\n#if 0\n#if 1\n")-1);
assert(strlen("#if 1\n#if 0\n#if 1\n#ifdef X\n#else\n#else\n") == sizeof("#if 1\n#if 0\n#if 1\n#ifdef X\n#else\n#else\n")-1);
assert(strlen("#if 1\n#if 0\nx\n") == sizeof("#if 1\n#if 0\nx\n")-1);
assert(strlen("#if 1\n#include \"structure.h\"\n#endif\n#endif\n") == sizeof("#if 1\n#include \"structure.h\"\n#endif\n#endif\n")-1);
assert(strlen("#if 1\n/* never closed\n#else\n#endif\nx\n") == sizeof("#if 1\n/* never closed\n#else\n#endif\nx\n")-1);
assert(strlen("#if 1\nkept\n#elif R\"bad space\"\n#endif\n") == sizeof("#if 1\nkept\n#elif R\"bad space\"\n#endif\n")-1);
assert(strlen("#if 1e'2\n#endif\n") == sizeof("#if 1e'2\n#endif\n")-1);
assert(strlen("#if 1e+\n#endif\n") == sizeof("#if 1e+\n#endif\n")-1);
assert(strlen("#if 1e\n#endif\n") == sizeof("#if 1e\n#endif\n")-1);
assert(strlen("#if 1lul\n#endif\n") == sizeof("#if 1lul\n#endif\n")-1);
assert(strlen("#if 99999999999999999999999\n#endif\n") == sizeof("#if 99999999999999999999999\n#endif\n")-1);
assert(strlen("#if IS_IN (libc)\n#endif\n") == sizeof("#if IS_IN (libc)\n#endif\n")-1);
assert(strlen("#if MISSING\\\n(1)\n#endif\n") == sizeof("#if MISSING\\\n(1)\n#endif\n")-1);
assert(strlen("#if UNDEFINED_FUNCTION_WITH_A_NAME_LONGER_THAN_SIXTY_FOUR_BYTES_FOR_FULL_DIAGNOSTIC_SPELLING(1)\n#endif\n") == sizeof("#if UNDEFINED_FUNCTION_WITH_A_NAME_LONGER_THAN_SIXTY_FOUR_BYTES_FOR_FULL_DIAGNOSTIC_SPELLING(1)\n#endif\n")-1);
assert(strlen("#if __INCLUDE_LEVEL__ < 199\n#include \"history.c\"\n#else\n#include \"history.h\"\n#include \"history.h\"\n#endif\n#include \"history.h\"\n") == sizeof("#if __INCLUDE_LEVEL__ < 199\n#include \"history.c\"\n#else\n#include \"history.h\"\n#include \"history.h\"\n#endif\n#include \"history.h\"\n")-1);
assert(strlen("#if caf\\u00e9(1)\n#endif\n") == sizeof("#if caf\\u00e9(1)\n#endif\n")-1);
assert(strlen("#if defined(X)(1)\n#endif\n") == sizeof("#if defined(X)(1)\n#endif\n")-1);
assert(strlen("#ifdef STEP\n#undef STEP\n#include \"history.h\"\n#else\n#define OBJ \"bad\"\n#if OBJ\n#endif\n#endif\n") == sizeof("#ifdef STEP\n#undef STEP\n#include \"history.h\"\n#else\n#define OBJ \"bad\"\n#if OBJ\n#endif\n#endif\n")-1);
assert(strlen("#ifndef G junk\n#define G\nint g;\n#endif junk\n") == sizeof("#ifndef G junk\n#define G\nint g;\n#endif junk\n")-1);
assert(strlen("#ifndef G\n#define G\n#endif\nint after;\n") == sizeof("#ifndef G\n#define G\n#endif\nint after;\n")-1);
assert(strlen("#ifndef G\n#define G\nfirst\n#elif 1\nsecond\n#endif\n") == sizeof("#ifndef G\n#define G\nfirst\n#elif 1\nsecond\n#endif\n")-1);
assert(strlen("#ifndef G\n#define G\nfirst\n#else\nsecond\n#endif\n") == sizeof("#ifndef G\n#define G\nfirst\n#else\nsecond\n#endif\n")-1);
assert(strlen("#ifndef G\n#define G\nint g;\n#endif\n#define Y\n") == sizeof("#ifndef G\n#define G\nint g;\n#endif\n#define Y\n")-1);
assert(strlen("#ifndef N\n#define N\n#include \"n.h\"\nint n;\n#endif\n") == sizeof("#ifndef N\n#define N\n#include \"n.h\"\nint n;\n#endif\n")-1);
assert(strlen("#import \"i.h\"\n#include \"i.h\"\n#import \"i.h\"\n") == sizeof("#import \"i.h\"\n#include \"i.h\"\n#import \"i.h\"\n")-1);
assert(strlen("#import") == sizeof("#import")-1);
assert(strlen("#include H\n") == sizeof("#include H\n")-1);
assert(strlen("#include \"") == sizeof("#include \"")-1);
assert(strlen("#include \"/") == sizeof("#include \"/")-1);
assert(strlen("#include \"g.h\"\n#undef G\n#include \"g.h\"\n#include \"g.h\"\n") == sizeof("#include \"g.h\"\n#undef G\n#include \"g.h\"\n#include \"g.h\"\n")-1);
assert(strlen("#include \"history.h\" junk\n#include <history.h> more junk\nint a = missing;\n") == sizeof("#include \"history.h\" junk\n#include <history.h> more junk\nint a = missing;\n")-1);
assert(strlen("#include \"history.h\"\n") == sizeof("#include \"history.h\"\n")-1);
assert(strlen("#include \"history.h\"\nint a=OBJ;\n") == sizeof("#include \"history.h\"\nint a=OBJ;\n")-1);
assert(strlen("#include \"n.h\"\n#include \"n.h\"\n") == sizeof("#include \"n.h\"\n#include \"n.h\"\n")-1);
assert(strlen("#include \"o.h\"\n#include \"link.h\"\n#include \"hard.h\"\n#include \"o.h\"\n") == sizeof("#include \"o.h\"\n#include \"link.h\"\n#include \"hard.h\"\n#include \"o.h\"\n")-1);
assert(strlen("#include \"structure.h\"\n#include \"structure.h\"\n") == sizeof("#include \"structure.h\"\n#include \"structure.h\"\n")-1);
assert(strlen("#line 100\n#else\n#if 0\n#else\n#else\n#endif\n#line 7 \"renamed.c\"\n#elif 1\n#if 1\n") == sizeof("#line 100\n#else\n#if 0\n#else\n#else\n#endif\n#line 7 \"renamed.c\"\n#elif 1\n#if 1\n")-1);
assert(strlen("#line 30 \"caller.c\"\n#include \"history.h\"\n") == sizeof("#line 30 \"caller.c\"\n#include \"history.h\"\n")-1);
assert(strlen("#line 40 \"caller.c\"\n#include \"history.h\"\n") == sizeof("#line 40 \"caller.c\"\n#include \"history.h\"\n")-1);
assert(strlen("#pragma GCC system_header") == sizeof("#pragma GCC system_header")-1);
assert(strlen("#pragma clang diagnostic warning \"-Wgnu-line-marker\"\n#include \"history.h\"\n# 5\n# 10 \"history.c\"\n") == sizeof("#pragma clang diagnostic warning \"-Wgnu-line-marker\"\n#include \"history.h\"\n# 5\n# 10 \"history.c\"\n")-1);
assert(strlen("#pragma clang diagnostic warning \"-Wunused-macros\"\n#define A 1\n#define B 2\n#if 0 && defined(A)\n#elif defined(B)\n") == sizeof("#pragma clang diagnostic warning \"-Wunused-macros\"\n#define A 1\n#define B 2\n#if 0 && defined(A)\n#elif defined(B)\n")-1);
assert(strlen("#pragma clang diagnostic warning \"-Wunused-macros\"\n#include \"history.h\"\n#define A 1\n#define B A\n") == sizeof("#pragma clang diagnostic warning \"-Wunused-macros\"\n#include \"history.h\"\n#define A 1\n#define B A\n")-1);
assert(strlen("#pragma once through a symbolic link and a hard link") == sizeof("#pragma once through a symbolic link and a hard link")-1);
assert(strlen("#pragma once\nint o;\n") == sizeof("#pragma once\nint o;\n")-1);
assert(strlen("#pragma push_macro(\"V\")\n#pragma pop_macro(\"V\")\n#error stop\n") == sizeof("#pragma push_macro(\"V\")\n#pragma pop_macro(\"V\")\n#error stop\n")-1);
assert(strlen("#undef HEADER\n#define G 7\n#define H 8\n#error stop\n") == sizeof("#undef HEADER\n#define G 7\n#define H 8\n#error stop\n")-1);
assert(strlen("#undef __x86_64__\n#define __STDC_HOSTED__ 0\n#undef __LINE__\n") == sizeof("#undef __x86_64__\n#define __STDC_HOSTED__ 0\n#undef __LINE__\n")-1);
assert(strlen("#undef between the inclusions") == sizeof("#undef between the inclusions")-1);
assert(strlen("#war\\\nning /* op\\\nen\ntail\n") == sizeof("#war\\\nning /* op\\\nen\ntail\n")-1);
assert(strlen("#warning /* comment */ x   \t\n#error '\n") == sizeof("#warning /* comment */ x   \t\n#error '\n")-1);
assert(strlen("#warning /* never closed\ntail\n") == sizeof("#warning /* never closed\ntail\n")-1);
assert(strlen("#warning R\"bad space\"\n") == sizeof("#warning R\"bad space\"\n")-1);
assert(strlen("%:if 0\n%:  if 1\n#el\\\nse\n%:else\n%:endif\n#endif\n#\\\nendif\n") == sizeof("%:if 0\n%:  if 1\n#el\\\nse\n%:else\n%:endif\n#endif\n#\\\nendif\n")-1);
assert(strlen("'##' at either end") == sizeof("'##' at either end")-1);
assert(strlen("'#' without a parameter") == sizeof("'#' without a parameter")-1);
assert(strlen("->o.h") == sizeof("->o.h")-1);
assert(strlen("-fborland-extensions") == sizeof("-fborland-extensions")-1);
assert(strlen("-fbuiltin-module-map") == sizeof("-fbuiltin-module-map")-1);
assert(strlen("-fdeclspec") == sizeof("-fdeclspec")-1);
assert(strlen("-fdefer-ts") == sizeof("-fdefer-ts")-1);
assert(strlen("-fdigraphs") == sizeof("-fdigraphs")-1);
assert(strlen("-fdirectives-only") == sizeof("-fdirectives-only")-1);
assert(strlen("-fdriver-only") == sizeof("-fdriver-only")-1);
assert(strlen("-fexec-charset=UTF-8") == sizeof("-fexec-charset=UTF-8")-1);
assert(strlen("-fexec-charset=latin1") == sizeof("-fexec-charset=latin1")-1);
assert(strlen("-ffile-prefix-map=") == sizeof("-ffile-prefix-map=")-1);
assert(strlen("-ffile-prefix-map=%d=/remapped") == sizeof("-ffile-prefix-map=%d=/remapped")-1);
assert(strlen("-ffixed-point") == sizeof("-ffixed-point")-1);
assert(strlen("-fgnu-keywords") == sizeof("-fgnu-keywords")-1);
assert(strlen("-fimplicit-module-maps") == sizeof("-fimplicit-module-maps")-1);
assert(strlen("-finput-charset=UTF8") == sizeof("-finput-charset=UTF8")-1);
assert(strlen("-finput-charset=Utf-8") == sizeof("-finput-charset=Utf-8")-1);
assert(strlen("-fkeep-system-includes") == sizeof("-fkeep-system-includes")-1);
assert(strlen("-fmacro-prefix-map=") == sizeof("-fmacro-prefix-map=")-1);
assert(strlen("-fmacro-prefix-map=%d=/remapped") == sizeof("-fmacro-prefix-map=%d=/remapped")-1);
assert(strlen("-fminimize-whitespace") == sizeof("-fminimize-whitespace")-1);
assert(strlen("-fmodule-map-file=") == sizeof("-fmodule-map-file=")-1);
assert(strlen("-fmodule-map-file=%d/missing.modulemap") == sizeof("-fmodule-map-file=%d/missing.modulemap")-1);
assert(strlen("-fmodule-name=probe") == sizeof("-fmodule-name=probe")-1);
assert(strlen("-fmodules") == sizeof("-fmodules")-1);
assert(strlen("-fmodules-driver") == sizeof("-fmodules-driver")-1);
assert(strlen("-fms-compatibility") == sizeof("-fms-compatibility")-1);
assert(strlen("-fms-extensions") == sizeof("-fms-extensions")-1);
assert(strlen("-fno-asm") == sizeof("-fno-asm")-1);
assert(strlen("-fno-borland-extensions") == sizeof("-fno-borland-extensions")-1);
assert(strlen("-fno-declspec") == sizeof("-fno-declspec")-1);
assert(strlen("-fno-defer-ts") == sizeof("-fno-defer-ts")-1);
assert(strlen("-fno-digraphs") == sizeof("-fno-digraphs")-1);
assert(strlen("-fno-directives-only") == sizeof("-fno-directives-only")-1);
assert(strlen("-fno-dollars-in-identifiers") == sizeof("-fno-dollars-in-identifiers")-1);
assert(strlen("-fno-fixed-point") == sizeof("-fno-fixed-point")-1);
assert(strlen("-fno-implicit-module-maps") == sizeof("-fno-implicit-module-maps")-1);
assert(strlen("-fno-implicit-modules") == sizeof("-fno-implicit-modules")-1);
assert(strlen("-fno-keep-system-includes") == sizeof("-fno-keep-system-includes")-1);
assert(strlen("-fno-minimize-whitespace") == sizeof("-fno-minimize-whitespace")-1);
assert(strlen("-fno-modules") == sizeof("-fno-modules")-1);
assert(strlen("-fno-ms-compatibility") == sizeof("-fno-ms-compatibility")-1);
assert(strlen("-fno-ms-extensions") == sizeof("-fno-ms-extensions")-1);
assert(strlen("-fno-raw-string-literals") == sizeof("-fno-raw-string-literals")-1);
assert(strlen("-fno-rewrite-imports") == sizeof("-fno-rewrite-imports")-1);
assert(strlen("-fno-rewrite-includes") == sizeof("-fno-rewrite-includes")-1);
assert(strlen("-fno-short-wchar") == sizeof("-fno-short-wchar")-1);
assert(strlen("-fno-signed-char") == sizeof("-fno-signed-char")-1);
assert(strlen("-fno-unsigned-char") == sizeof("-fno-unsigned-char")-1);
assert(strlen("-fno-use-line-directives") == sizeof("-fno-use-line-directives")-1);
assert(strlen("-fno-zos-extensions") == sizeof("-fno-zos-extensions")-1);
assert(strlen("-fno-zvector") == sizeof("-fno-zvector")-1);
assert(strlen("-fproc-stat-report") == sizeof("-fproc-stat-report")-1);
assert(strlen("-fraw-string-literals") == sizeof("-fraw-string-literals")-1);
assert(strlen("-frewrite-imports") == sizeof("-frewrite-imports")-1);
assert(strlen("-frewrite-includes") == sizeof("-frewrite-includes")-1);
assert(strlen("-fshort-wchar") == sizeof("-fshort-wchar")-1);
assert(strlen("-funsigned-char") == sizeof("-funsigned-char")-1);
assert(strlen("-fuse-line-directives") == sizeof("-fuse-line-directives")-1);
assert(strlen("-fzos-extensions") == sizeof("-fzos-extensions")-1);
assert(strlen("-fzvector") == sizeof("-fzvector")-1);
assert(strlen("-mno-zvector") == sizeof("-mno-zvector")-1);
assert(strlen("-mzvector") == sizeof("-mzvector")-1);
assert(strlen("-std=c17") == sizeof("-std=c17")-1);
assert(strlen("-std=c89") == sizeof("-std=c89")-1);
assert(strlen("-std=gnu17") == sizeof("-std=gnu17")-1);
assert(strlen("-std=gnu23") == sizeof("-std=gnu23")-1);
assert(strlen("-std=gnu89") == sizeof("-std=gnu89")-1);
assert(strlen("-std=gnu99") == sizeof("-std=gnu99")-1);
assert(strlen("-std=iso9899:199409") == sizeof("-std=iso9899:199409")-1);
assert(strlen("-x") == sizeof("-x")-1);
assert(strlen(".h\"\n") == sizeof(".h\"\n")-1);
assert(strlen("/* a */\n#\n%:\n#ifndef G // b\n#define G\nint g;\n#endif /* c */\n#\n// d\n") == sizeof("/* a */\n#\n%:\n#ifndef G // b\n#define G\nint g;\n#endif /* c */\n#\n// d\n")-1);
assert(strlen("/* never closed\n") == sizeof("/* never closed\n")-1);
assert(strlen(":1:11: error: invalid digit '8' in octal constant\n") == sizeof(":1:11: error: invalid digit '8' in octal constant\n")-1);
assert(strlen(":1:5: error: floating point literal in preprocessor expression\n") == sizeof(":1:5: error: floating point literal in preprocessor expression\n")-1);
assert(strlen(":1:5: error: integer literal is too large to be represented in any integer type\n") == sizeof(":1:5: error: integer literal is too large to be represented in any integer type\n")-1);
assert(strlen(":1:6: error: digit separator cannot appear at end of digit sequence\n") == sizeof(":1:6: error: digit separator cannot appear at end of digit sequence\n")-1);
assert(strlen(":1:6: error: exponent has no digits\n") == sizeof(":1:6: error: exponent has no digits\n")-1);
assert(strlen(":1:6: error: invalid digit '8' in octal constant\n") == sizeof(":1:6: error: invalid digit '8' in octal constant\n")-1);
assert(strlen(":1:6: error: invalid suffix 'lul' on integer constant\n") == sizeof(":1:6: error: invalid suffix 'lul' on integer constant\n")-1);
assert(strlen(":1:6: error: invalid suffix 'x' on integer constant\n") == sizeof(":1:6: error: invalid suffix 'x' on integer constant\n")-1);
assert(strlen(":1:7: error: digit separator cannot appear at start of digit sequence\n") == sizeof(":1:7: error: digit separator cannot appear at start of digit sequence\n")-1);
assert(strlen(":1:8: error: exponent has no digits\n") == sizeof(":1:8: error: exponent has no digits\n")-1);
assert(strlen(":1:8: error: hexadecimal floating constant requires a significand\n") == sizeof(":1:8: error: hexadecimal floating constant requires a significand\n")-1);
assert(strlen(":1:8: error: invalid digit '8' in octal constant\n") == sizeof(":1:8: error: invalid digit '8' in octal constant\n")-1);
assert(strlen(":1:8: error: invalid suffix 'fblah' on floating constant\n") == sizeof(":1:8: error: invalid suffix 'fblah' on floating constant\n")-1);
assert(strlen(":1:9: error: hexadecimal floating constant requires an exponent\n") == sizeof(":1:9: error: hexadecimal floating constant requires an exponent\n")-1);
assert(strlen(":1:9: error: invalid digit '2' in binary constant\n") == sizeof(":1:9: error: invalid digit '2' in binary constant\n")-1);
assert(strlen(":2:1: error: exponent has no digits\n") == sizeof(":2:1: error: exponent has no digits\n")-1);
assert(strlen(":2:1: error: invalid digit '8' in octal constant\n") == sizeof(":2:1: error: invalid digit '8' in octal constant\n")-1);
assert(strlen(":2:8: error: invalid digit '8' in octal constant\n") == sizeof(":2:8: error: invalid digit '8' in octal constant\n")-1);
assert(strlen(":3:1: error: invalid suffix 'lul' on integer constant\n") == sizeof(":3:1: error: invalid suffix 'lul' on integer constant\n")-1);
assert(strlen("=>o.h") == sizeof("=>o.h")-1);
assert(strlen(">\n") == sizeof(">\n")-1);
assert(strlen("CRLF") == sizeof("CRLF")-1);
assert(strlen("LR\"bad\n\"\n") == sizeof("LR\"bad\n\"\n")-1);
assert(strlen("L\\\nR\"bad space\"\n") == sizeof("L\\\nR\"bad space\"\n")-1);
assert(strlen("R\"a\"b c\n") == sizeof("R\"a\"b c\n")-1);
assert(strlen("R\"bad space\"\n") == sizeof("R\"bad space\"\n")-1);
assert(strlen("R\"tag(body\n") == sizeof("R\"tag(body\n")-1);
assert(strlen("\"\n") == sizeof("\"\n")-1);
assert(strlen("__VA_OPT__") == sizeof("__VA_OPT__")-1);
assert(strlen("a comment after a skipped group") == sizeof("a comment after a skipped group")-1);
assert(strlen("a comment after a taken group") == sizeof("a comment after a taken group")-1);
assert(strlen("a comment in a repeated include") == sizeof("a comment in a repeated include")-1);
assert(strlen("a comment on a selected #elif") == sizeof("a comment on a selected #elif")-1);
assert(strlen("a comment on a skipped group's end") == sizeof("a comment on a skipped group's end")-1);
assert(strlen("a comment on an excluded #elif") == sizeof("a comment on an excluded #elif")-1);
assert(strlen("a comment on the opening directive") == sizeof("a comment on the opening directive")-1);
assert(strlen("a comment that swallows the group") == sizeof("a comment that swallows the group")-1);
assert(strlen("a directive after the #endif") == sizeof("a directive after the #endif")-1);
assert(strlen("a directive before the #ifndef") == sizeof("a directive before the #ifndef")-1);
assert(strlen("a guard with #elif") == sizeof("a guard with #elif")-1);
assert(strlen("a guard with #else") == sizeof("a guard with #else")-1);
assert(strlen("a guarded file included twice") == sizeof("a guarded file included twice")-1);
assert(strlen("a line marker among an invocation's arguments") == sizeof("a line marker among an invocation's arguments")-1);
assert(strlen("a spliced comment on the opening directive") == sizeof("a spliced comment on the opening directive")-1);
assert(strlen("a spliced name and message") == sizeof("a spliced name and message")-1);
assert(strlen("a token after the #endif") == sizeof("a token after the #endif")-1);
assert(strlen("a token before the #ifndef") == sizeof("a token before the #ifndef")-1);
assert(strlen("a\n#endif\nb\n#else\n#elif 1\n#elifdef X\n#elifndef Y\n") == sizeof("a\n#endif\nb\n#else\n#elif 1\n#elifdef X\n#elifndef Y\n")-1);
assert(strlen("after #line") == sizeof("after #line")-1);
assert(strlen("after a taken group") == sizeof("after a taken group")-1);
assert(strlen("an active comment that swallows the group") == sizeof("an active comment that swallows the group")-1);
assert(strlen("an active error's comment text") == sizeof("an active error's comment text")-1);
assert(strlen("an active warning's comment text") == sizeof("an active warning's comment text")-1);
assert(strlen("an excluded error's comment") == sizeof("an excluded error's comment")-1);
assert(strlen("an excluded warning's comment") == sizeof("an excluded warning's comment")-1);
assert(strlen("an extern C header's line marker") == sizeof("an extern C header's line marker")-1);
assert(strlen("an inclusion from inside the file") == sizeof("an inclusion from inside the file")-1);
assert(strlen("an inclusion in a skipped group") == sizeof("an inclusion in a skipped group")-1);
assert(strlen("an unterminated __VA_OPT__") == sizeof("an unterminated __VA_OPT__")-1);
assert(strlen("argument macro name") == sizeof("argument macro name")-1);
assert(strlen("argument prescan") == sizeof("argument prescan")-1);
assert(strlen("argument") == sizeof("argument")-1);
assert(strlen("arity across contexts") == sizeof("arity across contexts")-1);
assert(strlen("arity") == sizeof("arity")-1);
assert(strlen("assembler-with-cpp") == sizeof("assembler-with-cpp")-1);
assert(strlen("builtin") == sizeof("builtin")-1);
assert(strlen("builtins") == sizeof("builtins")-1);
assert(strlen("c23") == sizeof("c23")-1);
assert(strlen("c89") == sizeof("c89")-1);
assert(strlen("comments and null directives around the group") == sizeof("comments and null directives around the group")-1);
assert(strlen("comments, quotes and trailing blanks") == sizeof("comments, quotes and trailing blanks")-1);
assert(strlen("condition after expansion") == sizeof("condition after expansion")-1);
assert(strlen("cross-context invocation") == sizeof("cross-context invocation")-1);
assert(strlen("deep inside skipped groups") == sizeof("deep inside skipped groups")-1);
assert(strlen("defined before parentheses keeps its operator diagnostic") == sizeof("defined before parentheses keeps its operator diagnostic")-1);
assert(strlen("delimiter lookahead past the salvaged token") == sizeof("delimiter lookahead past the salvaged token")-1);
assert(strlen("delimiter newline") == sizeof("delimiter newline")-1);
assert(strlen("delimiter too long") == sizeof("delimiter too long")-1);
assert(strlen("digraphs and splices") == sizeof("digraphs and splices")-1);
assert(strlen("disabled function-like recursive expansion") == sizeof("disabled function-like recursive expansion")-1);
assert(strlen("discarded macro argument") == sizeof("discarded macro argument")-1);
assert(strlen("ee") == sizeof("ee")-1);
assert(strlen("embed: an angled name too long for a path") == sizeof("embed: an angled name too long for a path")-1);
assert(strlen("empty paste left") == sizeof("empty paste left")-1);
assert(strlen("empty paste right") == sizeof("empty paste right")-1);
assert(strlen("empty stringification") == sizeof("empty stringification")-1);
assert(strlen("extra arguments") == sizeof("extra arguments")-1);
assert(strlen("extra tokens around the structure") == sizeof("extra tokens around the structure")-1);
assert(strlen("extra tokens on #elifdef") == sizeof("extra tokens on #elifdef")-1);
assert(strlen("extra tokens") == sizeof("extra tokens")-1);
assert(strlen("forwarded function") == sizeof("forwarded function")-1);
assert(strlen("function") == sizeof("function")-1);
assert(strlen("g.h") == sizeof("g.h")-1);
assert(strlen("gnu line markers, preprocessed") == sizeof("gnu line markers, preprocessed")-1);
assert(strlen("gnu17") == sizeof("gnu17")-1);
assert(strlen("hard.h") == sizeof("hard.h")-1);
assert(strlen("header definition") == sizeof("header definition")-1);
assert(strlen("header errors") == sizeof("header errors")-1);
assert(strlen("i.h") == sizeof("i.h")-1);
assert(strlen("include: a name with a part longer than NAME_MAX") == sizeof("include: a name with a part longer than NAME_MAX")-1);
assert(strlen("include: a quoted name too long for a path") == sizeof("include: a quoted name too long for a path")-1);
assert(strlen("include: an absolute name too long for a path") == sizeof("include: an absolute name too long for a path")-1);
assert(strlen("include: an angled name too long for a path") == sizeof("include: an angled name too long for a path")-1);
assert(strlen("include: extra tokens after a name written out") == sizeof("include: extra tokens after a name written out")-1);
assert(strlen("include: the depth limit at a name a macro made") == sizeof("include: the depth limit at a name a macro made")-1);
assert(strlen("include: the header refused at the depth limit") == sizeof("include: the header refused at the depth limit")-1);
assert(strlen("included file") == sizeof("included file")-1);
assert(strlen("inside a skipped group") == sizeof("inside a skipped group")-1);
assert(strlen("int before;\n#ifndef G\n#define G\n#endif\n") == sizeof("int before;\n#ifndef G\n#define G\n#endif\n")-1);
assert(strlen("int found;\n") == sizeof("int found;\n")-1);
assert(strlen("int header = SYSMAC + USERMAC + CALLS + CAT(1, 2);\n") == sizeof("int header = SYSMAC + USERMAC + CALLS + CAT(1, 2);\n")-1);
assert(strlen("int i;\n") == sizeof("int i;\n")-1);
assert(strlen("int leaf;\n") == sizeof("int leaf;\n")-1);
assert(strlen("integer overflow unchanged") == sizeof("integer overflow unchanged")-1);
assert(strlen("invalid binary digit") == sizeof("invalid binary digit")-1);
assert(strlen("invalid delimiter character") == sizeof("invalid delimiter character")-1);
assert(strlen("invalid digit after CRLF splice") == sizeof("invalid digit after CRLF splice")-1);
assert(strlen("invalid digit after LF splice") == sizeof("invalid digit after LF splice")-1);
assert(strlen("invalid explicit octal digit") == sizeof("invalid explicit octal digit")-1);
assert(strlen("invalid floating suffix") == sizeof("invalid floating suffix")-1);
assert(strlen("invalid integer suffix") == sizeof("invalid integer suffix")-1);
assert(strlen("invalid octal digit") == sizeof("invalid octal digit")-1);
assert(strlen("invalid paste") == sizeof("invalid paste")-1);
assert(strlen("invalid suffix after repeated splices") == sizeof("invalid suffix after repeated splices")-1);
assert(strlen("line markers") == sizeof("line markers")-1);
assert(strlen("line/include") == sizeof("line/include")-1);
assert(strlen("link.h") == sizeof("link.h")-1);
assert(strlen("macro definitions diagnose once") == sizeof("macro definitions diagnose once")-1);
assert(strlen("macros across a system header") == sizeof("macros across a system header")-1);
assert(strlen("malformed selected elif") == sizeof("malformed selected elif")-1);
assert(strlen("missing exponent after splice") == sizeof("missing exponent after splice")-1);
assert(strlen("missing exponent digits") == sizeof("missing exponent digits")-1);
assert(strlen("missing hexadecimal digits") == sizeof("missing hexadecimal digits")-1);
assert(strlen("missing hexadecimal exponent digits") == sizeof("missing hexadecimal exponent digits")-1);
assert(strlen("missing hexadecimal exponent") == sizeof("missing hexadecimal exponent")-1);
assert(strlen("missing hexadecimal significand") == sizeof("missing hexadecimal significand")-1);
assert(strlen("missing signed exponent digits") == sizeof("missing signed exponent digits")-1);
assert(strlen("n.h") == sizeof("n.h")-1);
assert(strlen("name after a value keeps its operator diagnostic") == sizeof("name after a value keeps its operator diagnostic")-1);
assert(strlen("names") == sizeof("names")-1);
assert(strlen("nested argument name") == sizeof("nested argument name")-1);
assert(strlen("nested include stack") == sizeof("nested include stack")-1);
assert(strlen("nested") == sizeof("nested")-1);
assert(strlen("number before parentheses keeps its operator diagnostic") == sizeof("number before parentheses keeps its operator diagnostic")-1);
assert(strlen("o.h") == sizeof("o.h")-1);
assert(strlen("object") == sizeof("object")-1);
assert(strlen("opaque diagnostic") == sizeof("opaque diagnostic")-1);
assert(strlen("opaque query") == sizeof("opaque query")-1);
assert(strlen("output/argument") == sizeof("output/argument")-1);
assert(strlen("output/nested") == sizeof("output/nested")-1);
assert(strlen("output/paste") == sizeof("output/paste")-1);
assert(strlen("output/redefinition") == sizeof("output/redefinition")-1);
assert(strlen("parameter lists") == sizeof("parameter lists")-1);
assert(strlen("parentheses and three '!'") == sizeof("parentheses and three '!'")-1);
assert(strlen("parenthesized name keeps its operator diagnostic") == sizeof("parenthesized name keeps its operator diagnostic")-1);
assert(strlen("paste") == sizeof("paste")-1);
assert(strlen("redefinitions") == sizeof("redefinitions")-1);
assert(strlen("repeated inclusions") == sizeof("repeated inclusions")-1);
assert(strlen("separator at exponent start") == sizeof("separator at exponent start")-1);
assert(strlen("separator at mantissa end") == sizeof("separator at mantissa end")-1);
assert(strlen("short circuit still checks literal syntax") == sizeof("short circuit still checks literal syntax")-1);
assert(strlen("skipped body") == sizeof("skipped body")-1);
assert(strlen("skipped group does not check literal syntax") == sizeof("skipped group does not check literal syntax")-1);
assert(strlen("spliced prefix") == sizeof("spliced prefix")-1);
assert(strlen("sssssssssssuuuuuuuu") == sizeof("sssssssssssuuuuuuuu")-1);
assert(strlen("ssssuuuu") == sizeof("ssssuuuu")-1);
assert(strlen("stringification") == sizeof("stringification")-1);
assert(strlen("the macro defined before the first inclusion") == sizeof("the macro defined before the first inclusion")-1);
assert(strlen("the same in C23") == sizeof("the same in C23")-1);
assert(strlen("two '!'") == sizeof("two '!'")-1);
assert(strlen("u8R\"abcdefghijklmnopq\"\n") == sizeof("u8R\"abcdefghijklmnopq\"\n")-1);
assert(strlen("undefined function-like Unicode name") == sizeof("undefined function-like Unicode name")-1);
assert(strlen("undefined function-like alias") == sizeof("undefined function-like alias")-1);
assert(strlen("undefined function-like included name") == sizeof("undefined function-like included name")-1);
assert(strlen("undefined function-like long name is not truncated") == sizeof("undefined function-like long name is not truncated")-1);
assert(strlen("undefined function-like name before a splice") == sizeof("undefined function-like name before a splice")-1);
assert(strlen("undefined function-like name in elif") == sizeof("undefined function-like name in elif")-1);
assert(strlen("undefined function-like name in nested expansion") == sizeof("undefined function-like name in nested expansion")-1);
assert(strlen("undefined function-like name in short-circuited operands") == sizeof("undefined function-like name in short-circuited operands")-1);
assert(strlen("undefined function-like name") == sizeof("undefined function-like name")-1);
assert(strlen("undefined function-like self expansion") == sizeof("undefined function-like self expansion")-1);
assert(strlen("untaken elif does not check literal syntax") == sizeof("untaken elif does not check literal syntax")-1);
assert(strlen("untaken elif is still lexed") == sizeof("untaken elif is still lexed")-1);
assert(strlen("unterminated in an include") == sizeof("unterminated in an include")-1);
assert(strlen("unterminated inside skipped groups") == sizeof("unterminated inside skipped groups")-1);
assert(strlen("unterminated") == sizeof("unterminated")-1);
assert(strlen("unused macros, preprocessed") == sizeof("unused macros, preprocessed")-1);
assert(strlen("unused macros: defined, push_macro and pop_macro, preprocessed") == sizeof("unused macros: defined, push_macro and pop_macro, preprocessed")-1);
assert(strlen("ususss") == sizeof("ususss")-1);
assert(strlen("uuuuusssssssuuuuu") == sizeof("uuuuusssssssuuuuu")-1);
assert(strlen("valid integer forms unchanged") == sizeof("valid integer forms unchanged")-1);
assert(strlen("well-formed decimal floating constant") == sizeof("well-formed decimal floating constant")-1);
assert(strlen("well-formed hexadecimal floating constant") == sizeof("well-formed hexadecimal floating constant")-1);
assert(strlen("whitespace after the name in C89") == sizeof("whitespace after the name in C89")-1);
assert(strlen("whitespace after the name") == sizeof("whitespace after the name")-1);
assert(strlen("without #if") == sizeof("without #if")-1);
num(sizeof pp_test_system_cases/sizeof *pp_test_system_cases);for (size_t i=0;i<sizeof pp_test_system_cases/sizeof *pp_test_system_cases;i++){const PPTestSystemCase *r=pp_test_system_cases+i;
str(r->name);str(r->source);
str(r->header);
str(r->levels);num(r->inexact);
}
num(sizeof cases/sizeof *cases);for (size_t i=0;i<sizeof cases/sizeof *cases;i++){const PPHistoryCase *r=cases+i;
str(r->name);str(r->source);
str(r->header);
num(r->parser);
}
num(sizeof pp_directive_test_raw_errors/sizeof *pp_directive_test_raw_errors);for (size_t i=0;i<sizeof pp_directive_test_raw_errors/sizeof *pp_directive_test_raw_errors;i++){const PPDirectiveTestStructure *r=pp_directive_test_raw_errors+i;
str(r->name);str(r->source);
str(r->header);
str(r->standard);str(r->diagnostic);
}
num(sizeof pp_directive_test_structures/sizeof *pp_directive_test_structures);for (size_t i=0;i<sizeof pp_directive_test_structures/sizeof *pp_directive_test_structures;i++){const PPDirectiveTestStructure *r=pp_directive_test_structures+i;
str(r->name);str(r->source);
str(r->header);
str(r->standard);str(r->diagnostic);
}
num(sizeof pp_directive_test_messages/sizeof *pp_directive_test_messages);for (size_t i=0;i<sizeof pp_directive_test_messages/sizeof *pp_directive_test_messages;i++){const PPDirectiveTestStructure *r=pp_directive_test_messages+i;
str(r->name);str(r->source);
str(r->header);
str(r->standard);str(r->diagnostic);
}
num(sizeof pp_directive_test_definitions/sizeof *pp_directive_test_definitions);for (size_t i=0;i<sizeof pp_directive_test_definitions/sizeof *pp_directive_test_definitions;i++){const PPDirectiveTestStructure *r=pp_directive_test_definitions+i;
str(r->name);str(r->source);
str(r->header);
str(r->standard);str(r->diagnostic);
}
num(sizeof pp_directive_test_guard_fixtures/sizeof *pp_directive_test_guard_fixtures);for (size_t i=0;i<sizeof pp_directive_test_guard_fixtures/sizeof *pp_directive_test_guard_fixtures;i++){const PPDirectiveTestGuard *r=pp_directive_test_guard_fixtures+i;
str(r->name);str(r->source);
num(r->guards);num(r->once);for(int j=0;j<4;j++){str(r->files[j][0]);str(r->files[j][1]);}
}
num(sizeof pp_test_option_sets/sizeof *pp_test_option_sets);for (size_t i=0;i<sizeof pp_test_option_sets/sizeof *pp_test_option_sets;i++){const PPTestOptionSet *r=pp_test_option_sets+i;
str(r->refused);for(int j=0;j<4;j++)str(r->arguments[j]);
}
num(sizeof pp_test_option_probe-1);assert(fwrite(pp_test_option_probe,1,sizeof pp_test_option_probe-1,stdout)==sizeof pp_test_option_probe-1);
}