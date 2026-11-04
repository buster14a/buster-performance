// Taken branches of a binary's own layout, from BOLT's instrumented edge counts (#1175 measurement harness).
// usage: taken NM.txt FDATA OBJDUMP.txt > EDGES.txt
//   NM.txt:      nm -p --defined-only -S BINARY      (symbol table order, for BOLT's name/N suffixes)
//   FDATA:       the instrumented binary's profile    (1 F OFF 1 G OFF MISPREDS COUNT)
//   OBJDUMP.txt: llvm-objdump -d --no-show-raw-insn --disassemble-symbols=... BINARY
// An intra-function edge whose target isn't the next instruction is a taken branch, and a jump to another function is a
// tail call's. Prints "ADDRESS COUNT KIND FUNCTION" per taken edge (KIND: jcc, jmp, ind, tail) and per conditional
// branch's fall-through (ft), and the totals on stderr. The records it can't place are counted as unmatched: on these
// runs, only calls through the PLT (glibc's functions), whose targets have no symbol.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    char* name;
    uint64_t address;
    uint64_t size;
    bool global;
} Symbol;

typedef struct
{
    uint64_t address;
    uint8_t kind; // 0 other, 1 jcc, 2 jmp, 3 indirect jmp, 4 call, 5 ret
} Instruction;

static Symbol* symbols;
static size_t symbol_count;
static Instruction* instructions;
static size_t instruction_count;

static int compare_symbol_name(const void* a, const void* b)
{
    const Symbol* x = a;
    const Symbol* y = b;
    int result = strcmp(x->name, y->name);
    if (result == 0 && x->global != y->global)
    {
        result = x->global ? -1 : 1;
    }
    else if (result == 0)
    {
        result = x->address < y->address ? -1 : (x->address > y->address ? 1 : 0);
    }
    return result;
}

static void read_symbols(const char* path)
{
    FILE* file = fopen(path, "r");
    char line[4096];
    size_t capacity = 1 << 16;
    symbols = malloc(capacity * sizeof(Symbol));
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char a[64];
        char b[64];
        char c[64];
        char name[4000];
        int fields = sscanf(line, "%63s %63s %63s %3999s", a, b, c, name);
        if (fields == 4 && (c[0] == 't' || c[0] == 'T' || c[0] == 'W' || c[0] == 'w'))
        {
            if (symbol_count == capacity)
            {
                capacity *= 2;
                symbols = realloc(symbols, capacity * sizeof(Symbol));
            }
            symbols[symbol_count] = (Symbol){ .name = strdup(name), .address = strtoull(a, NULL, 16), .size = strtoull(b, NULL, 16), .global = c[0] != 't' };
            symbol_count += 1;
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    // By name, a global (or weak) symbol before the local ones, and the local ones by address.
    qsort(symbols, symbol_count, sizeof(Symbol), compare_symbol_name);
}

// BOLT's name: "name/K" for the K-th local symbol of that name by address (BOLT numbers every local function so), else
// "name" for the global or weak symbol of that name, or the only local one where there is none.
static const Symbol* find_symbol(const char* bolt_name)
{
    char base[4096];
    size_t length = strlen(bolt_name);
    long k = 1;
    const char* slash = strrchr(bolt_name, '/');
    if (slash != NULL && slash[1] >= '0' && slash[1] <= '9')
    {
        length = (size_t)(slash - bolt_name);
        k = strtol(slash + 1, NULL, 10);
    }
    memcpy(base, bolt_name, length);
    base[length] = 0;
    size_t low = 0;
    size_t high = symbol_count;
    while (low < high)
    {
        size_t middle = (low + high) / 2;
        if (strcmp(symbols[middle].name, base) < 0)
        {
            low = middle + 1;
        }
        else
        {
            high = middle;
        }
    }
    const Symbol* result = NULL;
    const bool numbered = slash != NULL && slash[1] >= '0' && slash[1] <= '9';
    size_t index = low;
    if (numbered)
    {
        // Past the name's global symbol, if it has one, to its K-th local one.
        index += (size_t)(low < symbol_count && strcmp(symbols[low].name, base) == 0 && symbols[low].global) + (size_t)(k - 1);
    }
    if (index < symbol_count && strcmp(symbols[index].name, base) == 0 && (!numbered || !symbols[index].global))
    {
        result = &symbols[index];
    }
    return result;
}

static uint8_t classify(const char* mnemonic, const char* operands)
{
    uint8_t kind = 0;
    if (strncmp(mnemonic, "jmp", 3) == 0)
    {
        kind = operands[0] == '*' ? 3 : 2;
    }
    else if (mnemonic[0] == 'j')
    {
        kind = 1;
    }
    else if (strncmp(mnemonic, "call", 4) == 0)
    {
        kind = 4;
    }
    else if (strncmp(mnemonic, "ret", 3) == 0)
    {
        kind = 5;
    }
    return kind;
}

static void read_instructions(const char* path)
{
    FILE* file = fopen(path, "r");
    char line[8192];
    size_t capacity = 1 << 20;
    instructions = malloc(capacity * sizeof(Instruction));
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char* colon = strchr(line, ':');
        char* end = NULL;
        uint64_t address = strtoull(line, &end, 16);
        // An instruction line: leading spaces, a hex address, ':', blanks, the mnemonic.
        if (line[0] == ' ' && colon != NULL && end == colon && (colon[1] == '\t' || colon[1] == ' '))
        {
            char mnemonic[64] = { 0 };
            char operands[256] = { 0 };
            sscanf(colon + 1, "%63s %255s", mnemonic, operands);
            if (instruction_count == capacity)
            {
                capacity *= 2;
                instructions = realloc(instructions, capacity * sizeof(Instruction));
            }
            instructions[instruction_count] = (Instruction){ .address = address, .kind = classify(mnemonic, operands) };
            instruction_count += 1;
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
}

static int compare_instruction(const void* a, const void* b)
{
    const Instruction* x = a;
    const Instruction* y = b;
    return x->address < y->address ? -1 : (x->address > y->address ? 1 : 0);
}

static long find_instruction(uint64_t address)
{
    size_t low = 0;
    size_t high = instruction_count;
    while (low < high)
    {
        size_t middle = (low + high) / 2;
        if (instructions[middle].address < address)
        {
            low = middle + 1;
        }
        else
        {
            high = middle;
        }
    }
    return low < instruction_count && instructions[low].address == address ? (long)low : -1;
}

int main(int argc, char** argv)
{
    int status = 0;
    if (argc != 4)
    {
        fprintf(stderr, "usage: taken NM.txt FDATA OBJDUMP.txt\n");
        status = 2;
    }
    else
    {
        read_symbols(argv[1]);
        read_instructions(argv[3]);
        qsort(instructions, instruction_count, sizeof(Instruction), compare_instruction);
        FILE* file = fopen(argv[2], "r");
        char line[8192];
        uint64_t taken[4] = { 0 };
        uint64_t fallthrough = 0;
        uint64_t tail_calls = 0;
        uint64_t calls = 0;
        uint64_t unmatched = 0;
        uint64_t unmatched_records = 0;
        while (file != NULL && fgets(line, sizeof(line), file) != NULL)
        {
            int from_symbolic = 0;
            int to_symbolic = 0;
            char from_name[4000];
            char to_name[4000];
            char from_offset[32];
            char to_offset[32];
            unsigned long long mispredicts = 0;
            unsigned long long count = 0;
            if (sscanf(line, "%d %3999s %31s %d %3999s %31s %llu %llu", &from_symbolic, from_name, from_offset, &to_symbolic, to_name, to_offset, &mispredicts, &count) != 8)
            {
                continue;
            }
            if (from_symbolic != 1 || to_symbolic != 1)
            {
                continue;
            }
            const Symbol* from_symbol = find_symbol(from_name);
            const Symbol* to_symbol = find_symbol(to_name);
            if (from_symbol == NULL || to_symbol == NULL)
            {
                unmatched += count;
                unmatched_records += 1;
                continue;
            }
            const uint64_t from = from_symbol->address + strtoull(from_offset, NULL, 16);
            const uint64_t to = to_symbol->address + strtoull(to_offset, NULL, 16);
            const long index = find_instruction(from);
            if (index < 0)
            {
                unmatched += count;
                unmatched_records += 1;
                continue;
            }
            const Instruction* instruction = &instructions[index];
            if (instruction->kind == 4)
            {
                calls += count;
                continue;
            }
            const uint64_t next = (size_t)index + 1 < instruction_count ? instructions[index + 1].address : from_symbol->address + from_symbol->size;
            if (from_symbol != to_symbol)
            {
                // A tail call's jump to another function, taken; BOLT's dyno stats count it among the calls.
                tail_calls += count;
                printf("%llx %llu %s %s\n", (unsigned long long)from, count, "tail", from_symbol->name);
            }
            else if (to == next && instruction->kind != 2 && instruction->kind != 3)
            {
                fallthrough += count;
                if (instruction->kind == 1)
                {
                    fprintf(stdout, "%llx %llu ft %s\n", (unsigned long long)from, count, from_symbol->name);
                }
            }
            else
            {
                const int kind = instruction->kind >= 1 && instruction->kind <= 3 ? instruction->kind : 0;
                taken[kind] += count;
                static const char* names[] = { "other", "jcc", "jmp", "ind" };
                printf("%llx %llu %s %s\n", (unsigned long long)from, count, names[kind], from_symbol->name);
            }
        }
        if (file != NULL)
        {
            fclose(file);
        }
        fprintf(stderr, "taken conditional %llu\ntaken unconditional %llu\ntaken indirect %llu\ntaken tail calls %llu\ntaken other %llu\ntaken total %llu\nfallthrough %llu\ncalls %llu\nunmatched %llu (%llu records)\n",
                (unsigned long long)taken[1], (unsigned long long)taken[2], (unsigned long long)taken[3], (unsigned long long)tail_calls,
                (unsigned long long)taken[0], (unsigned long long)(taken[0] + taken[1] + taken[2] + taken[3] + tail_calls), (unsigned long long)fallthrough,
                (unsigned long long)calls, (unsigned long long)unmatched, (unsigned long long)unmatched_records);
    }
    return status;
}
