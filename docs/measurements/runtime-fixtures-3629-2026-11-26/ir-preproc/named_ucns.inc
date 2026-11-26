// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
    static const PPNamedUcnCase named_ucns[] = {
        {
            .name = "a named UCN beside the character's other spellings",
            .source = "int \\N{LATIN SMALL LETTER E WITH ACUTE} = 1;\nint f(void) { return \xC3\xA9; }\nint g(void) { return \\u00e9 + \\U000000E9 + \\u{e9}; }\n",
            .standard = "gnu17",
            .expected = "",
        },
        {
            .name = "named UCNs in tokens, directives and macros",
            .source = "x\\N{GREEK SMALL LETTER ALPHA}y\n"
                      "1\\N{DIGIT ONE}\n"
                      "\\N{GREEK SMALL LETTER ALPHA}\n"
                      "x\\\\\nN{GREEK SMALL LETTER ALPHA}\n"
                      "z\\N{GREEK SMALL\\\n LETTER ALPHA}\n"
                      "#define A \\N{LATIN CAPITAL LETTER A}\n"
                      "A A\n"
                      "#define DROP(x) kept\n"
                      "DROP(\\N{LINE FEED})\n"
                      "#if \\N{GREEK SMALL LETTER ALPHA}\n"
                      "#elif \\N{LATIN SMALL LETTER NOT A THING}\n"
                      "#endif\n"
                      "#if 0\n"
                      "\\N{GREEK SMALL LETTER ALPHA} \\N{NOT A NAME}\n"
                      "#endif\n"
                      "\"\\N{GREEK SMALL LETTER ALPHA}\" '\\N{DIGIT ZERO}' /* \\N{GREEK SMALL LETTER ALPHA} */ // \\N{DIGIT ZERO}\n",
            .standard = "gnu17",
            .expected = "2:2: error: character '1' cannot be specified by a universal character name\n"
                        "8:11: error: character 'A' cannot be specified by a universal character name\n"
                        "11:6: error: universal character name refers to a control character\n"
                        "13:10: error: 'LATIN SMALL LETTER NOT A THING' is not a valid Unicode character name\n"
                        "13:7: error: invalid token at start of a preprocessor expression\n",
        },
        {
            .name = "named UCNs whose backslashes are trigraphs",
            .source = "x?" "?/N{GREEK SMALL LETTER ALPHA} ?" "?/N{DIGIT ZERO} ?" "?/N{greek small letter alpha}\n",
            .standard = "c17",
            .expected = "1:33: error: character '0' cannot be specified by a universal character name\n"
                        "1:55: error: 'greek small letter alpha' is not a valid Unicode character name\n"
                        "1:55: note: character names in Unicode escape sequences are sensitive to case and whitespaces\n",
        },
        {
            .name = "names Unicode doesn't have, and basic and control characters",
            .source = "\\N{LATIN SMALL LETTER NOT A THING}\na\\N{latin small letter a}\nb\\N{latin small letter e with acute}c \\N{LATIN SMALL LETTER E WITH ACUTE}\n"
                      "\\N{SPACE}\\N{NULL}\n",
            .standard = "gnu17",
            .expected = "1:4: error: 'LATIN SMALL LETTER NOT A THING' is not a valid Unicode character name\n"
                        "2:5: error: 'latin small letter a' is not a valid Unicode character name\n"
                        "2:5: note: character names in Unicode escape sequences are sensitive to case and whitespaces\n"
                        "2:2: error: character 'a' cannot be specified by a universal character name\n"
                        "3:5: error: 'latin small letter e with acute' is not a valid Unicode character name\n"
                        "3:5: note: character names in Unicode escape sequences are sensitive to case and whitespaces\n"
                        "4:1: error: character ' ' cannot be specified by a universal character name\n"
                        "4:10: error: universal character name refers to a control character\n",
        },
        {
            // -Wunicode's warnings (#1447): a `\N` clang reads as no UCN, where a token starts or an identifier goes on, its
            // backslash read as itself; a macro's definition's once, and none in a skipped group.
            .name = "a \\N clang reads as no universal character name",
            .source = "f\\N\n\\Nj\ng\\N{}\nh\\N{FOO\n#define X \\N\nX X\n#if 0\nk\\N\n#endif\n",
            .standard = "gnu17",
            .expected = "1:2: warning: incomplete universal character name; treating as '\\' followed by identifier\n"
                        "2:1: warning: incomplete universal character name; treating as '\\' followed by identifier\n"
                        "3:2: warning: empty delimited universal character name; treating as '\\' 'N' '{' '}'\n"
                        "4:2: warning: incomplete delimited universal character name; treating as '\\' 'N' '{' identifier\n"
                        "5:11: warning: incomplete universal character name; treating as '\\' followed by identifier\n",
            .warnings = true,
        },
        {
            // The same of a `\u` or `\U` clang reads as no universal character name (#1447): no hex digit after it, too few, or
            // a delimited one's empty braces or missing brace, each naming its letter; at the line splice before it, and none
            // in a skipped group.
            .name = "a \\u or \\U clang reads as no universal character name",
            .source = "f\\u\n\\Uj\ng\\u{}\nh\\u{12\ni\\u12\nj\\U0000004\nk\\u{zz}\n#if 0\nl\\u\n#endif\nm\\\n\\u\n",
            .standard = "gnu17",
            .expected = "1:2: warning: \\u used with no following hex digits; treating as '\\' followed by identifier\n"
                        "2:1: warning: \\U used with no following hex digits; treating as '\\' followed by identifier\n"
                        "3:2: warning: empty delimited universal character name; treating as '\\' 'u' '{' '}'\n"
                        "4:2: warning: incomplete delimited universal character name; treating as '\\' 'u' '{' identifier\n"
                        "5:2: warning: incomplete universal character name; treating as '\\' followed by identifier\n"
                        "6:2: warning: incomplete universal character name; treating as '\\' followed by identifier\n"
                        "7:2: warning: incomplete delimited universal character name; treating as '\\' 'u' '{' identifier\n"
                        "11:2: warning: \\u used with no following hex digits; treating as '\\' followed by identifier\n",
            .warnings = true,
        },
        {
            // A `\u` or `\U` clang reads whole that starts a token, of a character below U+00A0 or a surrogate (#1447): its
            // error at the backslash, whatever its digits' form; none of one past U+00A0 or past U+10FFFF.
            .name = "a \\u or \\U of a basic or control character, or a surrogate",
            .source = "\\u0041x g\\uD800 \\u0024a \\u0001b \\u{41}d e\\u0041 \\u{D800}h \\u007Fi \\u00e9j \\U00110000\n",
            .standard = "gnu17",
            .expected = "1:1: error: character 'A' cannot be specified by a universal character name\n"
                        "1:10: error: invalid universal character\n"
                        "1:17: error: character '$' cannot be specified by a universal character name\n"
                        "1:25: error: universal character name refers to a control character\n"
                        "1:33: error: character 'A' cannot be specified by a universal character name\n"
                        "1:42: error: character 'A' cannot be specified by a universal character name\n"
                        "1:49: error: invalid universal character\n"
                        "1:59: error: universal character name refers to a control character\n",
        },
        {
            // -pedantic's warning that a named UCN is clang's extension (#1447): one that starts a token, its name exactly
            // Unicode's, at its backslash and before its character's error; none within an identifier, of a name that isn't
            // Unicode's, in a skipped group, or in a macro's expansion (its definition's once).
            .name = "named UCNs under -pedantic",
            .source = "\\N{GREEK SMALL LETTER ALPHA}x a\\N{GREEK SMALL LETTER ALPHA} \\N{LATIN CAPITAL LETTER A} \\N{FOO}\n"
                      "#define Y \\N{GREEK SMALL LETTER ALPHA}\nY Y\n#if 0\n\\N{GREEK SMALL LETTER ALPHA}\n#endif\n\\N{greek small letter alpha}\n",
            .standard = "gnu17",
            .expected = "1:1: warning: named escape sequences are a Clang extension\n"
                        "1:61: warning: named escape sequences are a Clang extension\n"
                        "1:61: error: character 'A' cannot be specified by a universal character name\n"
                        "1:91: error: 'FOO' is not a valid Unicode character name\n"
                        "2:11: warning: named escape sequences are a Clang extension\n"
                        "7:4: error: 'greek small letter alpha' is not a valid Unicode character name\n"
                        "7:4: note: character names in Unicode escape sequences are sensitive to case and whitespaces\n",
            .options = "-pedantic",
            .warnings = true,
        },
        {
            .name = "named UCNs under -pedantic-errors",
            .source = "\\N{GREEK SMALL LETTER ALPHA}x\n",
            .standard = "gnu17",
            .expected = "1:1: error: named escape sequences are a Clang extension\n",
            .options = "-pedantic-errors",
            .warnings = true,
        },
        {
            .name = "named UCNs under -pedantic without the extension's warning",
            .source = "\\N{GREEK SMALL LETTER ALPHA}x\n",
            .standard = "gnu17",
            .expected = "",
            .options = "-pedantic -Wno-delimited-escape-sequence-extension",
            .warnings = true,
        },
        {
            // -Wunicode's options, -w and pragmas (#1934): off, promoted, silenced, and mapped from the pragma on.
            .name = "-Wno-unicode",
            .source = "f\\N\n",
            .standard = "gnu17",
            .expected = "",
            .options = "-Wno-unicode",
            .warnings = true,
        },
        {
            .name = "-Werror=unicode",
            .source = "f\\N\n",
            .standard = "gnu17",
            .expected = "1:2: error: incomplete universal character name; treating as '\\' followed by identifier\n",
            .options = "-Werror=unicode",
            .warnings = true,
        },
        {
            .name = "-w over -Werror",
            .source = "f\\N\n",
            .standard = "gnu17",
            .expected = "",
            .options = "-w -Werror",
            .warnings = true,
        },
        {
            .name = "-Wunicode's pragmas",
            .source = "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wunicode\"\nf\\N\n#pragma clang diagnostic pop\ng\\N\n"
                      "#pragma clang diagnostic error \"-Wunicode\"\nh\\N\n",
            .standard = "gnu17",
            .expected = "5:2: warning: incomplete universal character name; treating as '\\' followed by identifier\n"
                        "7:2: error: incomplete universal character name; treating as '\\' followed by identifier\n",
            .warnings = true,
        },
        {
            .name = "-pedantic's warning under a pragma",
            .source = "#pragma clang diagnostic ignored \"-Wpedantic\"\n\\N{GREEK SMALL LETTER ALPHA}x\n",
            .standard = "gnu17",
            .expected = "",
            .options = "-pedantic",
            .warnings = true,
        },
    };
