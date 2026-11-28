// Reference (scalar, plain) scanner and lexer for the front prototype: the oracle's own reading of a C text.
// Token kinds are c_direct_lex.c's FastTokKind numbers.
#ifndef FRONT_REF_H
#define FRONT_REF_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

enum
{
    K_EOF = 0, K_IDENT = 1, K_INT = 2, K_FLOAT = 3, K_CHAR = 4, K_STR = 5,
    K_LPAREN = 6, K_RPAREN = 7, K_LBRACE = 8, K_RBRACE = 9, K_LBRACKET = 10, K_RBRACKET = 11, K_SEMI = 12, K_COMMA = 13,
    K_DOT = 14, K_ARROW = 15, K_ELLIPSIS = 16, K_QUESTION = 17, K_COLON = 18, K_TILDE = 19, K_BANG = 20, K_INC = 21,
    K_DEC = 22, K_PLUS = 23, K_MINUS = 24, K_STAR = 25, K_SLASH = 26, K_PERCENT = 27, K_AMP = 28, K_PIPE = 29,
    K_CARET = 30, K_LSHIFT = 31, K_RSHIFT = 32, K_LT = 33, K_LE = 34, K_GT = 35, K_GE = 36, K_EQ = 37, K_NE = 38,
    K_LAND = 39, K_LOR = 40, K_ASSIGN = 41, K_ADD_ASSIGN = 42, K_SUB_ASSIGN = 43, K_MUL_ASSIGN = 44, K_DIV_ASSIGN = 45,
    K_MOD_ASSIGN = 46, K_AND_ASSIGN = 47, K_OR_ASSIGN = 48, K_XOR_ASSIGN = 49, K_SHL_ASSIGN = 50, K_SHR_ASSIGN = 51,
    K_HASH = 52, K_HASHHASH = 53, K_BAD = 54,
    K_KW_FOR = 77, K_KW_WHILE = 97,
    K_INT_U32 = 122, K_INT_I64 = 123, K_INT_U64 = 124, K_FLOAT32 = 125, K_FLOAT80 = 126, K_PP_OTHER = 127,
};

// A byte's mode: code, a comment's byte (its delimiters too; a line comment's newline is code), a literal's opening
// quote, a literal's later bytes (to its closing quote, or to the byte before the newline that cuts it).
enum { M_CODE = 0, M_COMMENT = 1, M_QUOTE = 2, M_TAIL = 3 };

static inline bool ref_is_ident_start(uint8_t c) { return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || c == '$'; }
static inline bool ref_is_digit(uint8_t c) { return c >= '0' && c <= '9'; }
static inline bool ref_is_ident(uint8_t c) { return ref_is_ident_start(c) || ref_is_digit(c); }
static inline bool ref_is_blank(uint8_t c) { return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\f' || c == '\v'; }

// Every byte's mode, and the offsets of the '#' that start directive lines (the first code byte of their line, blanks
// and comments before them). Returns the directives' count. `unterminated` counts literals a newline cut.
static size_t ref_modes(const uint8_t* s, size_t n, uint8_t* mode, uint32_t* directives, size_t directive_cap, size_t* unterminated)
{
    size_t count = 0;
    size_t i = 0;
    bool bol = true;
    *unterminated = 0;
    while (i < n)
    {
        const uint8_t c = s[i];
        if (c == '/' && i + 1 < n && s[i + 1] == '*')
        {
            size_t j = i + 2;
            while (j + 1 < n && !(s[j] == '*' && s[j + 1] == '/')) { j += 1; }
            j = j + 2 <= n ? j + 2 : n;
            memset(mode + i, M_COMMENT, j - i);
            i = j;
            continue;
        }
        if (c == '/' && i + 1 < n && s[i + 1] == '/')
        {
            size_t j = i + 2;
            // A line splice carries the comment on.
            while (j < n && !(s[j] == '\n' && s[j - 1] != '\\')) { j += 1; }
            memset(mode + i, M_COMMENT, j - i);
            i = j;
            continue;
        }
        if (c == '\n') { mode[i] = M_CODE; bol = true; i += 1; continue; }
        if (c == ' ' || c == '\t' || c == '\r' || c == '\f' || c == '\v') { mode[i] = M_CODE; i += 1; continue; }
        if (c == '"' || c == '\'')
        {
            size_t j = i + 1;
            mode[i] = M_QUOTE;
            while (j < n && s[j] != c && s[j] != '\n')
            {
                if (s[j] == '\\' && j + 1 < n && s[j + 1] != '\n') { mode[j] = M_TAIL; j += 1; }
                mode[j] = M_TAIL;
                j += 1;
            }
            if (j < n && s[j] == c) { mode[j] = M_TAIL; j += 1; }
            else { *unterminated += 1; }
            bol = false;
            i = j;
            continue;
        }
        if (c == '#' && bol && count < directive_cap) { directives[count] = (uint32_t)i; count += 1; }
        bol = false;
        mode[i] = M_CODE;
        i += 1;
    }
    return count;
}

typedef struct RefTok RefTok;
struct RefTok
{
    uint32_t kind;
    uint32_t start;
    uint32_t end;       // one past its last byte
    bool hard;          // a token the block lexer leaves to the scalar one (a float, a three-character punctuator, ...)
};

// The punctuator at p (longest match), 0 for none.
static uint32_t ref_punct(const uint8_t* s, size_t n, size_t p, uint32_t* length)
{
    const uint8_t c = s[p];
    const uint8_t d = p + 1 < n ? s[p + 1] : 0;
    const uint8_t e = p + 2 < n ? s[p + 2] : 0;
    uint32_t kind = 0;
    uint32_t len = 1;
    switch (c)
    {
        case '(': kind = K_LPAREN; break;
        case ')': kind = K_RPAREN; break;
        case '{': kind = K_LBRACE; break;
        case '}': kind = K_RBRACE; break;
        case '[': kind = K_LBRACKET; break;
        case ']': kind = K_RBRACKET; break;
        case ';': kind = K_SEMI; break;
        case ',': kind = K_COMMA; break;
        case '?': kind = K_QUESTION; break;
        case ':': kind = K_COLON; break;
        case '~': kind = K_TILDE; break;
        case '.': if (d == '.' && e == '.') { kind = K_ELLIPSIS; len = 3; } else { kind = K_DOT; } break;
        case '-': if (d == '>') { kind = K_ARROW; len = 2; } else if (d == '-') { kind = K_DEC; len = 2; } else if (d == '=') { kind = K_SUB_ASSIGN; len = 2; } else { kind = K_MINUS; } break;
        case '+': if (d == '+') { kind = K_INC; len = 2; } else if (d == '=') { kind = K_ADD_ASSIGN; len = 2; } else { kind = K_PLUS; } break;
        case '*': if (d == '=') { kind = K_MUL_ASSIGN; len = 2; } else { kind = K_STAR; } break;
        case '/': if (d == '=') { kind = K_DIV_ASSIGN; len = 2; } else { kind = K_SLASH; } break;
        case '%': if (d == '=') { kind = K_MOD_ASSIGN; len = 2; } else { kind = K_PERCENT; } break;
        case '&': if (d == '&') { kind = K_LAND; len = 2; } else if (d == '=') { kind = K_AND_ASSIGN; len = 2; } else { kind = K_AMP; } break;
        case '|': if (d == '|') { kind = K_LOR; len = 2; } else if (d == '=') { kind = K_OR_ASSIGN; len = 2; } else { kind = K_PIPE; } break;
        case '^': if (d == '=') { kind = K_XOR_ASSIGN; len = 2; } else { kind = K_CARET; } break;
        case '<': if (d == '<') { if (e == '=') { kind = K_SHL_ASSIGN; len = 3; } else { kind = K_LSHIFT; len = 2; } } else if (d == '=') { kind = K_LE; len = 2; } else { kind = K_LT; } break;
        case '>': if (d == '>') { if (e == '=') { kind = K_SHR_ASSIGN; len = 3; } else { kind = K_RSHIFT; len = 2; } } else if (d == '=') { kind = K_GE; len = 2; } else { kind = K_GT; } break;
        case '=': if (d == '=') { kind = K_EQ; len = 2; } else { kind = K_ASSIGN; } break;
        case '!': if (d == '=') { kind = K_NE; len = 2; } else { kind = K_BANG; } break;
        case '#': if (d == '#') { kind = K_HASHHASH; len = 2; } else { kind = K_HASH; } break;
        default: break;
    }
    *length = len;
    return kind;
}

// The token at p, a code byte that is no blank. A number's kind is K_INT for a plain run of digits and letters and
// K_FLOAT where it has a '.' or an exponent's sign.
static RefTok ref_lex(const uint8_t* s, size_t n, size_t p)
{
    RefTok t = { .kind = K_BAD, .start = (uint32_t)p, .end = (uint32_t)p + 1u, .hard = false };
    const uint8_t c = s[p];
    if (ref_is_ident_start(c))
    {
        size_t j = p + 1;
        while (j < n && ref_is_ident(s[j])) { j += 1; }
        t.kind = K_IDENT;
        t.end = (uint32_t)j;
        // A literal's prefix is the scalar lexer's.
        if (j < n && (s[j] == '"' || s[j] == '\'') && ((j - p == 1 && (c == 'L' || c == 'u' || c == 'U')) || (j - p == 2 && c == 'u' && s[p + 1] == '8'))) { t.hard = true; }
    }
    else if (ref_is_digit(c) || (c == '.' && p + 1 < n && ref_is_digit(s[p + 1])))
    {
        size_t j = p + 1;
        bool plain = c != '.';
        while (j < n)
        {
            const uint8_t d = s[j];
            if (ref_is_ident(d)) { j += 1; }
            else if (d == '.') { plain = false; j += 1; }
            else if ((d == '+' || d == '-') && (s[j - 1] == 'e' || s[j - 1] == 'E' || s[j - 1] == 'p' || s[j - 1] == 'P')) { plain = false; j += 1; }
            else { break; }
        }
        t.kind = plain ? K_INT : K_FLOAT;
        t.hard = !plain;
        t.end = (uint32_t)j;
    }
    else if (c == '"' || c == '\'')
    {
        size_t j = p + 1;
        while (j < n && s[j] != c && s[j] != '\n')
        {
            if (s[j] == '\\' && j + 1 < n && s[j + 1] != '\n') { j += 1; }
            j += 1;
        }
        if (j < n && s[j] == c) { j += 1; }
        t.kind = c == '"' ? K_STR : K_CHAR;
        t.end = (uint32_t)j;
    }
    else
    {
        uint32_t len = 1;
        const uint32_t kind = ref_punct(s, n, p, &len);
        t.kind = kind != 0 ? kind : K_BAD;
        t.end = (uint32_t)(p + len);
        t.hard = len == 3 || kind == 0;
    }
    return t;
}

#endif
