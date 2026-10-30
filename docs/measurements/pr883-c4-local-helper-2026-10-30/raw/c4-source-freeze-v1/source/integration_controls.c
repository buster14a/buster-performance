// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// SOURCE DRAFT ONLY: this file has not been compiled or executed.
// Synthetic composition controls for actual method_prove, receipt writers,
// snapshot creation/verification and normalization snapshot membership.
// The included entry points are renamed and never invoked. No producer,
// assembler, linker, image instructions, remote operation or timing is used.
// Only hp_common's fixed /usr/bin/sha256sum child may execute when authorized.
#define main buster_hp_unused_method_main
#include "hp_method.c"
#undef main
#define main buster_hp_unused_linked_controls_main
#include "linked_controls.c"
#undef main

#define BUSTER_INTEGRATION_INPUTS 4U
#define BUSTER_INTEGRATION_READ_LIMIT ((size_t)1024 * 1024)

typedef struct IntegrationSuite IntegrationSuite;
struct IntegrationSuite
{
    size_t checks;
    size_t failures;
    char root[BUSTER_HP_PATH_CAPACITY];
};

typedef struct IntegrationFixture IntegrationFixture;
struct IntegrationFixture
{
    HpMethod method;
    LinkedBuffer inputs[BUSTER_INTEGRATION_INPUTS];
    char paths[BUSTER_INTEGRATION_INPUTS][BUSTER_HP_PATH_CAPACITY];
    struct stat metadata[BUSTER_INTEGRATION_INPUTS];
    char *object_values[2];
    char object_receipt[BUSTER_HP_PATH_CAPACITY];
    char linked_receipt[BUSTER_HP_PATH_CAPACITY];
};

typedef enum IntegrationFault
{
    BUSTER_INTEGRATION_NONE,
    BUSTER_INTEGRATION_OBJECT_BYTE,
    BUSTER_INTEGRATION_LINKED_BYTE,
    BUSTER_INTEGRATION_EXISTING_OBJECT_RECEIPT,
    BUSTER_INTEGRATION_EXISTING_LINKED_RECEIPT
} IntegrationFault;

static const char integration_sentinel[] = "synthetic existing receipt; preserve exactly\n";

static void integration_record(IntegrationSuite *suite, const char *name, bool passed, const char *error)
{
    suite->checks += 1;
    suite->failures += !passed;
    printf("%s %s%s%s\n", passed ? "PASS" : "FAIL", name, passed ? "" : ": ", passed ? "" : error);
    return;
}

static bool integration_absent(const char *path)
{
    struct stat metadata = {0};
    errno = 0;
    bool absent = lstat(path, &metadata) < 0 && errno == ENOENT;
    return absent;
}

static bool integration_contains(const HpBuffer *buffer, const char *text)
{
    size_t size = strlen(text);
    bool found = size <= buffer->size && memmem(buffer->data, buffer->size, text, size) != NULL;
    return found;
}

static bool integration_metadata_equal(const struct stat *a, const struct stat *b)
{
    bool same = a->st_dev == b->st_dev && a->st_ino == b->st_ino && a->st_mode == b->st_mode && a->st_nlink == b->st_nlink && a->st_size == b->st_size;
    same = same && a->st_mtim.tv_sec == b->st_mtim.tv_sec && a->st_mtim.tv_nsec == b->st_mtim.tv_nsec && a->st_ctim.tv_sec == b->st_ctim.tv_sec && a->st_ctim.tv_nsec == b->st_ctim.tv_nsec;
    return same;
}

static void integration_duplicate_outside(LinkedBuffer *buffer)
{
    Elf64_Ehdr header;
    Elf64_Shdr sections[BUSTER_LINK_SECTIONS];
    memcpy(&header, buffer->data, sizeof(header));
    assert(header.e_type == ET_EXEC && header.e_shnum == BUSTER_LINK_SECTIONS);
    assert(header.e_shoff <= buffer->size && sizeof(sections) <= buffer->size - header.e_shoff);
    memcpy(sections, buffer->data + header.e_shoff, sizeof(sections));
    const Elf64_Shdr *table = sections + BUSTER_LINK_SYMTAB;
    const Elf64_Shdr *strings = sections + BUSTER_LINK_STRTAB;
    const Elf64_Shdr *outside = sections + BUSTER_LINK_OTHER;
    assert(table->sh_size % sizeof(Elf64_Sym) == 0 && table->sh_offset <= buffer->size && table->sh_size <= buffer->size - table->sh_offset);
    assert(strings->sh_offset <= buffer->size && strings->sh_size <= buffer->size - strings->sh_offset);
    size_t matches = 0;
    for (size_t i = 0; i < table->sh_size / sizeof(Elf64_Sym); i += 1)
    {
        Elf64_Sym symbol;
        size_t offset = (size_t)table->sh_offset + i * sizeof(symbol);
        memcpy(&symbol, buffer->data + offset, sizeof(symbol));
        assert(symbol.st_name < strings->sh_size);
        const char *name = (const char *)buffer->data + strings->sh_offset + symbol.st_name;
        assert(memchr(name, 0, (size_t)strings->sh_size - symbol.st_name) != NULL);
        if (strcmp(name, linked_mandatory[0]) == 0)
        {
            matches += 1;
            if (matches == 2)
            {
                assert(symbol.st_size == 16 && outside->sh_size >= symbol.st_size);
                symbol.st_value = outside->sh_addr;
                symbol.st_shndx = BUSTER_LINK_OTHER;
                memcpy(buffer->data + offset, &symbol, sizeof(symbol));
            }
        }
    }
    assert(matches == 2);
    return;
}

static void integration_flip_hot(LinkedBuffer *buffer, size_t relative)
{
    Elf64_Ehdr header;
    Elf64_Shdr hot;
    memcpy(&header, buffer->data, sizeof(header));
    assert(header.e_shoff <= buffer->size && (BUSTER_LINK_HOT + 1) * sizeof(hot) <= buffer->size - header.e_shoff);
    memcpy(&hot, buffer->data + header.e_shoff + BUSTER_LINK_HOT * sizeof(hot), sizeof(hot));
    assert(relative < hot.sh_size && hot.sh_offset <= buffer->size && hot.sh_size <= buffer->size - hot.sh_offset);
    buffer->data[(size_t)hot.sh_offset + relative] ^= 1;
    return;
}

static bool integration_setup(IntegrationSuite *suite, IntegrationFixture *fixture, const char *leaf, bool fragment_required, bool fragment_present, IntegrationFault fault, char error[BUSTER_HP_ERROR_CAPACITY])
{
    static const char *const names[BUSTER_INTEGRATION_INPUTS] = {"direct-checker.o", "zero-checker.o", "direct-normal", "zero-image.elf"};
    bool valid = hp_join_path(fixture->method.root, suite->root, leaf, error) && hp_mkdir_new(fixture->method.root, error);
    fixture->method.fragment = fragment_required;
    fixture->method.plan.checker_index = 0;
    for (size_t i = 0; valid && i < BUSTER_INTEGRATION_INPUTS; i += 1)
    {
        // The inherited image constructor deliberately uses unequal resolved
        // relocation bytes. This is structural composition, not image identity.
        LinkedOptions options = {.extra = fragment_present, .original = i != 3, .fault = i >= 2 ? BUSTER_LINK_FINAL_AMBIGUOUS : BUSTER_LINK_NONE};
        linked_fixture(i < 2, options, fixture->inputs + i);
        if (i >= 2)
        {
            integration_duplicate_outside(fixture->inputs + i);
        }
        if ((i == 1 && fault == BUSTER_INTEGRATION_OBJECT_BYTE) || (i == 3 && fault == BUSTER_INTEGRATION_LINKED_BYTE))
        {
            integration_flip_hot(fixture->inputs + i, 16);
        }
        HpBytes bytes = {fixture->inputs[i].data, fixture->inputs[i].size};
        valid = hp_join_path(fixture->paths[i], fixture->method.root, names[i], error) && hp_write_file(fixture->paths[i], bytes, error) && lstat(fixture->paths[i], fixture->metadata + i) == 0 && S_ISREG(fixture->metadata[i].st_mode) && fixture->metadata[i].st_nlink == 1;
    }
    fixture->object_values[0] = fixture->paths[0];
    fixture->method.objects.values = fixture->object_values;
    fixture->method.objects.count = 1;
    valid = valid && hp_join_path(fixture->object_receipt, fixture->method.root, "object-proof.json", error) && hp_join_path(fixture->linked_receipt, fixture->method.root, "linked-proof.json", error);
    if (valid && (fault == BUSTER_INTEGRATION_EXISTING_OBJECT_RECEIPT || fault == BUSTER_INTEGRATION_EXISTING_LINKED_RECEIPT))
    {
        const char *path = fault == BUSTER_INTEGRATION_EXISTING_OBJECT_RECEIPT ? fixture->object_receipt : fixture->linked_receipt;
        valid = hp_write_file(path, (HpBytes){(const unsigned char *)integration_sentinel, sizeof(integration_sentinel) - 1}, error);
    }
    return valid;
}

static bool integration_inputs_unchanged(const IntegrationFixture *fixture, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool unchanged = true;
    for (size_t i = 0; unchanged && i < BUSTER_INTEGRATION_INPUTS; i += 1)
    {
        struct stat after = {0};
        unchanged = method_file_buffer_equal(fixture->paths[i], (HpBytes){fixture->inputs[i].data, fixture->inputs[i].size}, error) && lstat(fixture->paths[i], &after) == 0 && integration_metadata_equal(fixture->metadata + i, &after);
    }
    return unchanged;
}

static bool integration_no_readiness(const IntegrationFixture *fixture, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char prepared[BUSTER_HP_PATH_CAPACITY] = {0};
    char ready[BUSTER_HP_PATH_CAPACITY] = {0};
    bool absent = method_path(prepared, &fixture->method, "prepared.json", error) && method_path(ready, &fixture->method, "ready.nul", error) && integration_absent(prepared) && integration_absent(ready);
    return absent;
}

static bool integration_object_receipt(const IntegrationFixture *fixture, bool fragment, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBuffer object = {0};
    bool valid = hp_read_file(fixture->object_receipt, BUSTER_INTEGRATION_READ_LIMIT, &object, error);
    valid = valid && integration_contains(&object, "\"passed\": true,") && integration_contains(&object, "\"kind\": \"ET_REL hot-section structural translation\"") && integration_contains(&object, "\"hot_bytes_before\": 96,") && integration_contains(&object, fragment ? "\"symbols_compared\": 6," : "\"symbols_compared\": 5,") && integration_contains(&object, "\"relocations_compared\": 1,") && integration_contains(&object, "\"disclosure_count\": 0,");
    valid = valid && integration_contains(&object, "\"pt_load_validated\": false") && integration_contains(&object, "\"numeric_resolved_operands_validated\": false") && integration_contains(&object, "\"runtime_semantics_validated\": false");
    hp_buffer_free(&object);
    return valid;
}

static bool integration_receipts(const IntegrationFixture *fixture, bool fragment, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBuffer linked = {0};
    bool valid = integration_object_receipt(fixture, fragment, error) && hp_read_file(fixture->linked_receipt, BUSTER_INTEGRATION_READ_LIMIT, &linked, error);
    valid = valid && integration_contains(&linked, "\"kind\": \"object-qualified linked hot geometry and nonrelocation bytes\"") && integration_contains(&linked, "\"hot_input_base\": 4194304") && integration_contains(&linked, fragment ? "\"function_count\": 4," : "\"function_count\": 3,");
    valid = valid && integration_contains(&linked, "\"name\": \"check_program_emit\", \"object_symbol\": 1, \"object_offset\": 0, \"size\": 16, \"normal_address\": 4194304, \"variant_address\": 4194304, \"delta\": 0,") && !integration_contains(&linked, "\"normal_address\": 6291456");
    valid = valid && integration_contains(&linked, "\"operand_count\": 1,") && integration_contains(&linked, "\"masked_operand_bytes\": 4,") && integration_contains(&linked, "\"pt_load_validated\": false") && integration_contains(&linked, "\"numeric_resolved_operands_validated\": false") && integration_contains(&linked, "\"runtime_semantics_validated\": false");
    valid = valid && integration_contains(&linked, "\"name\": \"check_lower_fragment\"") == fragment;
    hp_buffer_free(&linked);
    return valid;
}

static bool integration_prove_case(IntegrationSuite *suite, IntegrationFixture *fixture, const char *name, bool fragment_required, bool fragment_present, IntegrationFault fault, bool expected)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool setup = integration_setup(suite, fixture, name, fragment_required, fragment_present, fault, error);
    integration_record(suite, "fresh private synthetic fixture", setup, error);
    bool accepted = setup && method_prove(&fixture->method, fixture->paths[1], fixture->paths[3], 0, fixture->object_receipt, fixture->linked_receipt, error);
    const char *diagnostic = fault == BUSTER_INTEGRATION_OBJECT_BYTE ? "hot section bytes changed after prefix removal" : fault == BUSTER_INTEGRATION_LINKED_BYTE ? "linked hot suffix changed outside relocation operands" : fault == BUSTER_INTEGRATION_EXISTING_OBJECT_RECEIPT || fault == BUSTER_INTEGRATION_EXISTING_LINKED_RECEIPT ? "cannot create exclusive proof receipt" : "required function is not owned by selected hot section";
    bool valid = setup && accepted == expected && (accepted || strstr(error, diagnostic) != NULL);
    integration_record(suite, name, valid, error);
    if (setup)
    {
        bool shape = false;
        if (accepted)
        {
            shape = integration_receipts(fixture, fragment_present, error);
        }
        else if (fault == BUSTER_INTEGRATION_OBJECT_BYTE)
        {
            shape = integration_absent(fixture->object_receipt) && integration_absent(fixture->linked_receipt);
        }
        else if (fault == BUSTER_INTEGRATION_EXISTING_OBJECT_RECEIPT)
        {
            shape = method_file_buffer_equal(fixture->object_receipt, (HpBytes){(const unsigned char *)integration_sentinel, sizeof(integration_sentinel) - 1}, error) && integration_absent(fixture->linked_receipt);
        }
        else if (fault == BUSTER_INTEGRATION_EXISTING_LINKED_RECEIPT)
        {
            shape = integration_object_receipt(fixture, fragment_present, error) && method_file_buffer_equal(fixture->linked_receipt, (HpBytes){(const unsigned char *)integration_sentinel, sizeof(integration_sentinel) - 1}, error);
        }
        else
        {
            shape = integration_object_receipt(fixture, fragment_present, error) && integration_absent(fixture->linked_receipt);
        }
        integration_record(suite, "actual receipt publication/withholding and exclusivity", shape, error);
        integration_record(suite, "all synthetic input bytes and metadata preserved", integration_inputs_unchanged(fixture, error), error);
        integration_record(suite, "proof seam creates no prepared or ready record", integration_no_readiness(fixture, error), error);
    }
    return valid && accepted;
}

static bool integration_replace(const char *path, HpBytes bytes, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = unlink(path) == 0 && hp_write_file(path, bytes, error);
    return valid;
}

static void integration_snapshot_cases(IntegrationSuite *suite, IntegrationFixture *fixture)
{
    // These three files attest membership/immutability only. They deliberately
    // contain synthetic placeholders, not a normalization or source proof.
    static const char *const names[] = {"checker.raw.s", "checker.s", "normalization.json"};
    static const char *const contents[] = {"synthetic raw assembly membership fixture\n", "synthetic canonical assembly membership fixture\n", "{\"synthetic_membership_fixture\":true}\n"};
    char paths[3][BUSTER_HP_PATH_CAPACITY] = {{0}};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    char snapshot_path[BUSTER_HP_PATH_CAPACITY] = {0};
    HpBuffer snapshot = {0};
    bool valid = true;
    for (size_t i = 0; valid && i < 3; i += 1)
    {
        valid = method_path(paths[i], &fixture->method, names[i], error) && hp_write_file(paths[i], (HpBytes){(const unsigned char *)contents[i], strlen(contents[i])}, error);
    }
    valid = valid && method_snapshot(&fixture->method, error) && method_path(snapshot_path, &fixture->method, "snapshot.sha256", error) && hp_read_file(snapshot_path, BUSTER_INTEGRATION_READ_LIMIT, &snapshot, error) && hp_verify_sources(fixture->method.root, snapshot_path, error) && method_normalization_snapshot(&fixture->method, snapshot_path, error);
    integration_record(suite, "actual snapshot binds successful synthetic proof receipts and normalization members", valid, error);
    if (valid)
    {
        integration_record(suite, "snapshot explicitly includes both actual proof receipt files", integration_contains(&snapshot, "  object-proof.json\n") && integration_contains(&snapshot, "  linked-proof.json\n"), error);
        error[0] = 0;
        bool refused = !method_snapshot(&fixture->method, error) && method_file_buffer_equal(snapshot_path, (HpBytes){snapshot.data, snapshot.size}, error);
        integration_record(suite, "existing snapshot refuses overwrite and preserves exact bytes", refused, error);
        for (size_t i = 0; i < 3; i += 1)
        {
            error[0] = 0;
            bool missing = unlink(paths[i]) == 0 && !method_normalization_snapshot(&fixture->method, snapshot_path, error) && !hp_verify_sources(fixture->method.root, snapshot_path, error);
            bool restored = hp_write_file(paths[i], (HpBytes){(const unsigned char *)contents[i], strlen(contents[i])}, error);
            integration_record(suite, "missing normalization member refuses membership and full snapshot", missing && restored, error);
            static const unsigned char tampered[] = "synthetic tampered membership bytes\n";
            error[0] = 0;
            bool changed = integration_replace(paths[i], (HpBytes){tampered, sizeof(tampered) - 1}, error) && !hp_verify_sources(fixture->method.root, snapshot_path, error);
            restored = integration_replace(paths[i], (HpBytes){(const unsigned char *)contents[i], strlen(contents[i])}, error);
            integration_record(suite, "tampered normalization member refuses full snapshot", changed && restored, error);
        }
        const char *proof_paths[] = {fixture->object_receipt, fixture->linked_receipt};
        for (size_t i = 0; i < BUSTER_ARRAY_COUNT(proof_paths); i += 1)
        {
            HpBuffer original = {0};
            static const unsigned char tampered[] = "synthetic tampered proof receipt\n";
            error[0] = 0;
            bool changed = hp_read_file(proof_paths[i], BUSTER_INTEGRATION_READ_LIMIT, &original, error) && integration_replace(proof_paths[i], (HpBytes){tampered, sizeof(tampered) - 1}, error) && !hp_verify_sources(fixture->method.root, snapshot_path, error);
            bool restored = original.data != NULL && integration_replace(proof_paths[i], (HpBytes){original.data, original.size}, error);
            integration_record(suite, "tampered actual proof receipt refuses full snapshot", changed && restored, error);
            hp_buffer_free(&original);
        }
        char omitted[BUSTER_HP_PATH_CAPACITY] = {0};
        char digest[65] = {0};
        char row[128] = {0};
        error[0] = 0;
        bool omission = hp_sha256_file(paths[1], digest, error);
        int length = omission ? snprintf(row, sizeof(row), "%s  checker.s\n", digest) : -1;
        omission = omission && length > 0 && (size_t)length < sizeof(row) && method_path(omitted, &fixture->method, "synthetic-omitted-members.sha256", error) && hp_write_file(omitted, (HpBytes){(const unsigned char *)row, (size_t)length}, error) && !method_normalization_snapshot(&fixture->method, omitted, error);
        integration_record(suite, "present raw and receipt omitted from manifest refuse membership", omission, error);
        error[0] = 0;
        integration_record(suite, "restored exact inputs verify original immutable snapshot", hp_verify_sources(fixture->method.root, snapshot_path, error) && method_normalization_snapshot(&fixture->method, snapshot_path, error) && method_file_buffer_equal(snapshot_path, (HpBytes){snapshot.data, snapshot.size}, error), error);
        char ready_path[BUSTER_HP_PATH_CAPACITY] = {0};
        char producer_path[BUSTER_HP_PATH_CAPACITY] = {0};
        // Deliberately obsolete schema and non-digest text: never create a v3
        // ready record or assert a qualified source/normal identity.
        const char *obsolete[] = {"buster-hot-placement-c-v2", "synthetic-not-qualified", "synthetic-not-qualified", "synthetic-not-qualified", NULL};
        error[0] = 0;
        bool old = method_path(ready_path, &fixture->method, "ready.nul", error) && hp_record_arguments(ready_path, obsolete, error) && !method_resume(&fixture->method, 16, error) && error[0] != 0 && method_path(producer_path, &fixture->method, "inside-16", error) && integration_absent(producer_path);
        integration_record(suite, "obsolete synthetic ready schema refuses before any producer path", old, error);
    }
    hp_buffer_free(&snapshot);
    return;
}

int main(int argc, char **argv)
{
    IntegrationSuite suite = {0};
    char parent[BUSTER_HP_PATH_CAPACITY] = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    const uint16_t endian = 1;
    bool valid = argc == 2 && *(const unsigned char *)&endian == 1 && method_canonical(argv[1], parent, error);
    struct stat metadata = {0};
    valid = valid && lstat(parent, &metadata) == 0 && S_ISDIR(metadata.st_mode);
    int length = valid ? snprintf(suite.root, sizeof(suite.root), "%s/synthetic-c4-integration-XXXXXX", parent) : -1;
    valid = valid && length > 0 && (size_t)length < sizeof(suite.root) && mkdtemp(suite.root) != NULL;
    if (!valid && error[0] == 0)
    {
        hp_error(error, "requires one existing absolute fixture parent, little-endian fixture ABI, and a fresh private child");
    }
    integration_record(&suite, "fresh private synthetic parent and supported fixture byte order", valid, error);
    if (valid)
    {
        IntegrationFixture baseline = {0};
        bool baseline_passed = integration_prove_case(&suite, &baseline, "baseline-qualified-duplicate-key-success", false, false, BUSTER_INTEGRATION_NONE, true);
        if (baseline_passed)
        {
            integration_snapshot_cases(&suite, &baseline);
        }
        memset(&baseline, 0, sizeof(baseline));
        integration_prove_case(&suite, &baseline, "fragment-required-qualified-duplicate-key-success", true, true, BUSTER_INTEGRATION_NONE, true);
        memset(&baseline, 0, sizeof(baseline));
        integration_prove_case(&suite, &baseline, "fragment-required-name-missing-refusal", true, false, BUSTER_INTEGRATION_NONE, false);
        memset(&baseline, 0, sizeof(baseline));
        integration_prove_case(&suite, &baseline, "object-byte-refusal-withholds-both-proof-receipts", false, false, BUSTER_INTEGRATION_OBJECT_BYTE, false);
        memset(&baseline, 0, sizeof(baseline));
        integration_prove_case(&suite, &baseline, "linked-byte-refusal-retains-only-object-receipt", false, false, BUSTER_INTEGRATION_LINKED_BYTE, false);
        memset(&baseline, 0, sizeof(baseline));
        integration_prove_case(&suite, &baseline, "existing-object-receipt-refuses-and-preserves-sentinel", false, false, BUSTER_INTEGRATION_EXISTING_OBJECT_RECEIPT, false);
        memset(&baseline, 0, sizeof(baseline));
        integration_prove_case(&suite, &baseline, "existing-linked-receipt-refuses-and-preserves-sentinel", false, false, BUSTER_INTEGRATION_EXISTING_LINKED_RECEIPT, false);
    }
    printf("Synthetic C4 method/receipt/snapshot composition: %zu checks, %zu failures; no producer, image execution, qualified ready, runtime or performance claim.\n", suite.checks, suite.failures);
    int status = suite.failures == 0 ? 0 : 1;
    return status;
}
