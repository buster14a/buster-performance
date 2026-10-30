// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Fresh C controls exercise hp_pad_hot on constructed byte slices only.
// No producer, assembler, compiler image, target fixture or remote is invoked.
#include "hp_pad.h"

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct PadCase PadCase;
struct PadCase
{
    const char *name;
    const char *text;
    bool accepted;
    size_t anchor;
};

static const char base[] =
    "\t.text\n"
    "\t.p2align\t12\n"
    "cold:\n"
    "\tnop\n"
    "#APP\n"
    "\t.section\t.text.buster_checker,\"ax\",@progbits\n"
    "\t.p2align 12\n"
    "\t.text\n"
    "#NO_APP\n"
    "\t.section\t.text.buster_checker,\"ax\",@progbits\n"
    "\t.p2align\t4, 0x90\n"
    "hot:\n"
    "\tretq\n";

static bool exercise(HpBytes input, uint64_t shift, bool accepted, size_t anchor, const char *name)
{
    unsigned char *output = NULL;
    size_t output_size = 0;
    size_t output_anchor = 0;
    char error[BUSTER_HP_ERROR_CAPACITY];
    bool actual = hp_pad_hot(input, shift, &output, &output_size, &output_anchor, error);
    bool passed = actual == accepted;
    if (actual)
    {
        char insertion[64];
        int insertion_size = shift != 0 ? snprintf(insertion, sizeof(insertion), "\t.skip\t%" PRIu64 "\n", shift) : 0;
        size_t after = 0;
        size_t lines = 0;
        while (after < input.size && lines < anchor)
        {
            lines += input.data[after] == '\n';
            after += 1;
        }
        passed = passed && insertion_size >= 0 && (size_t)insertion_size < sizeof(insertion) && output_anchor == anchor && lines == anchor;
        passed = passed && output_size == input.size + (size_t)insertion_size && memcmp(output, input.data, after) == 0;
        if (passed && insertion_size != 0)
        {
            passed = memcmp(output + after, insertion, (size_t)insertion_size) == 0;
        }
        passed = passed && memcmp(output + after + (size_t)insertion_size, input.data + after, input.size - after) == 0;
        if (shift == 0)
        {
            passed = passed && output_size == input.size && memcmp(output, input.data, input.size) == 0;
        }
    }
    else
    {
        passed = passed && output == NULL && output_size == 0 && output_anchor == 0 && error[0] != 0;
    }
    printf("%s %s\n", passed ? "PASS" : "FAIL", name);
    free(output);
    return passed;
}

int main(void)
{
    unsigned failures = 0;
    unsigned count = 0;
    const uint64_t shifts[] =
    {
        0,
        16,
        64,
        256,
        1024,
        2048
    };
    for (size_t index = 0; index < sizeof(shifts) / sizeof(shifts[0]); index += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "approved-shift-%" PRIu64, shifts[index]);
        HpBytes input =
        {
            .data = (const unsigned char *)base,
            .size = sizeof(base) - 1
        };
        failures += !exercise(input, shifts[index], true, 7, name);
        count += 1;
    }
    const PadCase cases[] =
    {
        {
            .name = "quoted-hot-and-unquoted-hyphen-section",
            .text = ".section .note.GNU-stack,\"\",@progbits\n.section \".text.buster_checker\",\"ax\",@progbits\n.p2align\t12 # anchor\nhot:\nretq\n",
            .accepted = true,
            .anchor = 3
        },
        {
            .name = "quoted-other-section-with-spaces",
            .text = ".section \"cold section-name\",\"ax\",@progbits\n.p2align 12\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nhot:\nretq\n",
            .accepted = true,
            .anchor = 4
        },
        {
            .name = "quoted-comment-and-semicolon-are-data",
            .text = ".section \".data#name\",\"a\",@progbits\n.asciz \"#; .section .text.buster_checker\"\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nhot:\nretq\n",
            .accepted = true,
            .anchor = 4
        },
        {
            .name = "comment-decoys-ignored",
            .text = "# .section .text.buster_checker\n# .p2align 12\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nhot:\nretq\n",
            .accepted = true,
            .anchor = 4
        },
        {
            .name = "ordinary-multiple-instructions-supported",
            .text = ".section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nhot:\nnop; retq\n",
            .accepted = true,
            .anchor = 2
        },
        {
            .name = "ordinary-zero-subsection-supported",
            .text = ".text 0\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nhot:\nretq\n",
            .accepted = true,
            .anchor = 3
        },
        {
            .name = "missing-hot-section",
            .text = ".text\n.p2align 12\nretq\n"
        },
        {
            .name = "fake-quoted-hot-name",
            .text = ".section \".text.buster_checker#fake\",\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "missing-page-alignment",
            .text = ".section .text.buster_checker,\"ax\",@progbits\n.p2align 11\nretq\n"
        },
        {
            .name = "duplicate-page-alignment",
            .text = ".section .text.buster_checker,\"ax\",@progbits\n.p2align 12\n.p2align 12\nretq\n"
        },
        {
            .name = "content-before-page-alignment",
            .text = ".section .text.buster_checker,\"ax\",@progbits\nhot:\n.p2align 12\nretq\n"
        },
        {
            .name = "late-second-page-alignment",
            .text = ".section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nhot:\n.p2align 12\nretq\n"
        },
        {
            .name = "wrong-active-section",
            .text = ".section .text.buster_checker,\"ax\",@progbits\n.text\n.p2align 12\nretq\n"
        },
        {
            .name = "last-anchor-without-newline",
            .text = ".section .text.buster_checker,\"ax\",@progbits\n.p2align 12"
        },
        {
            .name = "filled-anchor-not-guessed",
            .text = ".section .text.buster_checker,\"ax\",@progbits\n.p2align 12,0x90\nretq\n"
        },
        {
            .name = "malformed-section-tail",
            .text = ".section .text.buster_checker extra\n.p2align 12\nretq\n"
        },
        {
            .name = "escaped-section-name-not-guessed",
            .text = ".section \".text.buster_checker\\x\",\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "nonzero-ordinary-subsection",
            .text = ".text 1\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "pushsection-refused",
            .text = ".pushsection .text\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "popsection-refused",
            .text = ".popsection\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "previous-refused",
            .text = ".previous\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "subsection-refused",
            .text = ".subsection 0\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "macro-refused",
            .text = ".macro name\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\n.endm\n"
        },
        {
            .name = "conditional-refused",
            .text = ".if 0\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\n.endif\n"
        },
        {
            .name = "elseif-refused",
            .text = ".elseif 0\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "include-refused",
            .text = ".include \"outside.s\"\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "incbin-refused",
            .text = ".incbin \"outside.bin\"\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "semicolon-selector-refused",
            .text = "nop; .section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "semicolon-conditional-refused",
            .text = "nop; .if 0\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "labelled-conditional-refused",
            .text = "hidden: .if 0\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "multiple-labelled-selector-refused",
            .text = "1:label:.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "spaced-labelled-conditional-refused",
            .text = "hidden \t: .if 0\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        },
        {
            .name = "block-comment-anchor-not-guessed",
            .text = "/*\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\n*/\nretq\n"
        },
        {
            .name = "unterminated-quote-refused",
            .text = ".asciz \"unterminated\n.section .text.buster_checker,\"ax\",@progbits\n.p2align 12\nretq\n"
        }
    };
    for (size_t index = 0; index < sizeof(cases) / sizeof(cases[0]); index += 1)
    {
        HpBytes input =
        {
            .data = (const unsigned char *)cases[index].text,
            .size = strlen(cases[index].text)
        };
        failures += !exercise(input, 16, cases[index].accepted, cases[index].anchor, cases[index].name);
        count += 1;
    }
    const uint64_t bad_shifts[] =
    {
        1,
        32,
        4096,
        UINT64_MAX
    };
    for (size_t index = 0; index < sizeof(bad_shifts) / sizeof(bad_shifts[0]); index += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "unapproved-shift-%" PRIu64, bad_shifts[index]);
        HpBytes input =
        {
            .data = (const unsigned char *)base,
            .size = sizeof(base) - 1
        };
        failures += !exercise(input, bad_shifts[index], false, 0, name);
        count += 1;
    }
    const unsigned char nul_comment[] = ".section .text.buster_checker,\"ax\",@progbits\n.p2align 12\n# comment\0hidden\n";
    HpBytes nul_input =
    {
        .data = nul_comment,
        .size = sizeof(nul_comment) - 1
    };
    failures += !exercise(nul_input, 16, false, 0, "embedded-NUL-in-comment-refused");
    count += 1;
    HpBytes empty = { 0 };
    failures += !exercise(empty, 0, false, 0, "empty-input-refused");
    count += 1;
    HpBytes null_input =
    {
        .data = NULL,
        .size = 1
    };
    failures += !exercise(null_input, 16, false, 0, "null-input-refused");
    count += 1;
    HpBytes overflow =
    {
        .data = (const unsigned char *)base,
        .size = SIZE_MAX
    };
    failures += !exercise(overflow, 16, false, 0, "declared-output-overflow-refused");
    count += 1;
    printf("C pad controls: %u cases, %u failures; byte transformation only, no producer or remote execution.\n", count, failures);
    return failures != 0;
}
