// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Serialize already successful structural proofs without adding semantic
// claims. Object counts/disclosures and every linked function/operand field
// remain visible. All names pass through the bounded JSON string writer.
#define _POSIX_C_SOURCE 200809L
#include "hp_receipt.h"

#include <fcntl.h>
#include <inttypes.h>
#include <string.h>
#include <unistd.h>

#define BUSTER_HP_RECEIPT_ITEM_LIMIT ((size_t)1024 * 1024)

static FILE *hp_receipt_open(const char *path, char error[BUSTER_HP_ERROR_CAPACITY])
{
    int descriptor = path != NULL ? open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    FILE *file = descriptor >= 0 ? fdopen(descriptor, "w") : NULL;
    if (file == NULL)
    {
        if (descriptor >= 0)
        {
            close(descriptor);
        }
        hp_error(error, "cannot create exclusive proof receipt");
    }
    return file;
}

static bool hp_receipt_finish(FILE *file, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = fflush(file) == 0;
    valid = ferror(file) == 0 && valid;
    valid = fclose(file) == 0 && valid;
    if (!valid)
    {
        hp_error(error, "cannot complete proof receipt write/flush/close");
    }
    return valid;
}

static void hp_receipt_literal(FILE *file, const char *text)
{
    HpString value =
    {
        text,
        strlen(text)
    };
    hp_json_string(file, value);
    return;
}

static void hp_receipt_limits(FILE *file)
{
    fputs("  \"limits\": {\n    \"pt_load_validated\": false,\n    \"numeric_resolved_operands_validated\": false,\n    \"runtime_semantics_validated\": false\n  }", file);
    return;
}

static const char *hp_receipt_disclosure(HpDisclosureKind kind)
{
    const char *text = NULL;
    switch (kind)
    {
        case BUSTER_HP_DISCLOSURE_COMMENT:
        {
            text = "nonalloc .comment producer bytes/presence differ";
        } break;
        case BUSTER_HP_DISCLOSURE_FILE_RECORDS:
        {
            text = "unreferenced STT_FILE producer records differ";
        } break;
        case BUSTER_HP_DISCLOSURE_NORMALIZED_ENCODING:
        {
            text = "normalized symbol/string/RELA encoding differs";
        } break;
    }
    return text;
}

static bool hp_receipt_string(HpString text)
{
    return text.size <= BUSTER_HP_FILE_LIMIT && (text.size == 0 || text.data != NULL);
}

bool hp_receipt_object(const char *path, const HpObjectProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    error[0] = 0;
    bool valid = proof != NULL && proof->disclosure_count <= BUSTER_HP_RECEIPT_ITEM_LIMIT && (proof->disclosure_count == 0 || proof->disclosures != NULL);
    for (size_t i = 0; valid && i < proof->disclosure_count; i += 1)
    {
        valid = hp_receipt_disclosure(proof->disclosures[i].kind) != NULL;
    }
    FILE *file = valid ? hp_receipt_open(path, error) : NULL;
    valid = valid && file != NULL;
    if (valid)
    {
        fputs("{\n  \"schema\": \"buster-hot-placement-proof-v1\",\n  \"passed\": true,\n  \"kind\": \"ET_REL hot-section structural translation\",\n", file);
        fprintf(file, "  \"shift\": %" PRIu64 ",\n  \"hot_bytes_before\": %" PRIu64 ",\n  \"hot_alignment\": %" PRIu64 ",\n  \"symbols_compared\": %zu,\n  \"relocations_compared\": %zu,\n  \"disclosure_count\": %zu,\n  \"disclosed_nonsemantic_differences\": [\n", proof->shift, proof->hot_bytes_before, proof->hot_alignment, proof->symbols_compared, proof->relocations_compared, proof->disclosure_count);
        for (size_t i = 0; i < proof->disclosure_count; i += 1)
        {
            const HpDisclosure *disclosure = &proof->disclosures[i];
            fprintf(file, "    {\"kind\": %u, \"meaning\": ", (unsigned)disclosure->kind);
            hp_receipt_literal(file, hp_receipt_disclosure(disclosure->kind));
            fputs(", \"section\": ", file);
            if (disclosure->section == SIZE_MAX)
            {
                fputs("null", file);
            }
            else
            {
                fprintf(file, "%zu", disclosure->section);
            }
            fprintf(file, "}%s\n", i + 1 < proof->disclosure_count ? "," : "");
        }
        fputs("  ],\n  \"scope\": \"structural object translation only; separate linked geometry, producer/input provenance and image identity gates required\",\n", file);
        hp_receipt_limits(file);
        fputs("\n}\n", file);
        valid = hp_receipt_finish(file, error);
    }
    else if (error[0] == 0)
    {
        hp_error(error, "invalid object proof receipt metadata");
    }
    return valid;
}

bool hp_receipt_linked(const char *path, const HpLinkedProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    error[0] = 0;
    bool valid = proof != NULL && proof->function_count <= BUSTER_HP_RECEIPT_ITEM_LIMIT && proof->operand_count <= BUSTER_HP_RECEIPT_ITEM_LIMIT && (proof->function_count == 0 || proof->functions != NULL) && (proof->operand_count == 0 || proof->operands != NULL) && hp_receipt_string(proof->normal_output_section) && hp_receipt_string(proof->variant_output_section);
    for (size_t i = 0; valid && i < proof->function_count; i += 1)
    {
        valid = hp_receipt_string(proof->functions[i].name);
    }
    FILE *file = valid ? hp_receipt_open(path, error) : NULL;
    valid = valid && file != NULL;
    if (valid)
    {
        fputs("{\n  \"schema\": \"buster-hot-placement-proof-v1\",\n  \"passed\": true,\n  \"kind\": \"object-qualified linked hot geometry and nonrelocation bytes\",\n", file);
        fprintf(file, "  \"shift\": %" PRIu64 ",\n  \"hot_input_base\": %" PRIu64 ",\n  \"hot_bytes\": %" PRIu64 ",\n  \"hot_alignment\": %" PRIu64 ",\n  \"normal_output_section\": ", proof->shift, proof->hot_input_base, proof->hot_bytes, proof->hot_alignment);
        hp_json_string(file, proof->normal_output_section);
        fputs(",\n  \"variant_output_section\": ", file);
        hp_json_string(file, proof->variant_output_section);
        fprintf(file, ",\n  \"function_count\": %zu,\n  \"functions\": [\n", proof->function_count);
        for (size_t i = 0; i < proof->function_count; i += 1)
        {
            const HpLinkedFunction *function = &proof->functions[i];
            fputs("    {\"name\": ", file);
            hp_json_string(file, function->name);
            fprintf(file, ", \"object_symbol\": %zu, \"object_offset\": %" PRIu64 ", \"size\": %" PRIu64 ", \"normal_address\": %" PRIu64 ", \"variant_address\": %" PRIu64 ", \"delta\": %" PRIu64 ", \"normal_residue_4096\": %" PRIu64 ", \"variant_residue_4096\": %" PRIu64 "}%s\n", function->object_symbol, function->object_offset, function->size, function->normal_address, function->variant_address, function->delta, function->normal_residue_4096, function->variant_residue_4096, i + 1 < proof->function_count ? "," : "");
        }
        fprintf(file, "  ],\n  \"operand_count\": %zu,\n  \"masked_operand_bytes\": %" PRIu64 ",\n  \"masked_relocation_operands\": [\n", proof->operand_count, proof->masked_operand_bytes);
        for (size_t i = 0; i < proof->operand_count; i += 1)
        {
            const HpLinkedOperand *operand = &proof->operands[i];
            fprintf(file, "    {\"object_relocation\": %zu, \"offset\": %" PRIu64 ", \"type\": %" PRIu32 ", \"width\": %u}%s\n", operand->object_relocation, operand->offset, operand->type, operand->width, i + 1 < proof->operand_count ? "," : "");
        }
        fputs("  ],\n  \"scope\": \"section-header geometry and linked bytes outside proved relocation operands only\",\n  \"requires\": [\n    \"separate full object relocation translation proof\",\n    \"pinned producer/linker and exact ordered link inputs\",\n    \"normal/zero full image SHA256 identity\",\n    \"per-image output preservation controls before timing\"\n  ],\n", file);
        hp_receipt_limits(file);
        fputs("\n}\n", file);
        valid = hp_receipt_finish(file, error);
    }
    else if (error[0] == 0)
    {
        hp_error(error, "invalid linked proof receipt metadata");
    }
    return valid;
}

bool hp_receipt_identity(const char *path, const char *image, const char *digest, const char *scope, char error[BUSTER_HP_ERROR_CAPACITY])
{
    error[0] = 0;
    bool valid = image != NULL && digest != NULL && scope != NULL;
    size_t image_size = valid ? strnlen(image, BUSTER_HP_PATH_CAPACITY) : 0;
    size_t scope_size = valid ? strnlen(scope, BUSTER_HP_PATH_CAPACITY) : 0;
    size_t digest_size = valid ? strnlen(digest, 65) : 0;
    valid = valid && image_size > 0 && image_size < BUSTER_HP_PATH_CAPACITY && scope_size > 0 && scope_size < BUSTER_HP_PATH_CAPACITY && digest_size == 64;
    for (size_t i = 0; valid && i < 64; i += 1)
    {
        valid = (digest[i] >= '0' && digest[i] <= '9') || (digest[i] >= 'a' && digest[i] <= 'f');
    }
    FILE *file = valid ? hp_receipt_open(path, error) : NULL;
    valid = valid && file != NULL;
    if (valid)
    {
        fputs("{\n  \"schema\": \"buster-hot-placement-proof-v1\",\n  \"passed\": true,\n  \"kind\": \"file SHA256 identity\",\n  \"image\": ", file);
        HpString name =
        {
            image,
            image_size
        };
        hp_json_string(file, name);
        fputs(",\n  \"sha256\": ", file);
        hp_receipt_literal(file, digest);
        fputs(",\n  \"scope\": ", file);
        name.data = scope;
        name.size = scope_size;
        hp_json_string(file, name);
        fputs(",\n", file);
        hp_receipt_limits(file);
        fputs("\n}\n", file);
        valid = hp_receipt_finish(file, error);
    }
    else if (error[0] == 0)
    {
        hp_error(error, "invalid file identity receipt metadata");
    }
    return valid;
}
