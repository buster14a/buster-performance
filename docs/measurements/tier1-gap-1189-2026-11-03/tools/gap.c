// gap.c: #1189's breakdown of Tier 1's dynamic instructions against clang -O2's, by instruction type and, for Tier 1's
// code, by each record's origin (the kinds experiment's tags).
//
//   gap count DISASSEMBLY CALLGRIND OBJECT BASE [KINDS] > TSV
//       DISASSEMBLY is `objdump -d --no-show-raw-insn BINARY`, CALLGRIND a `valgrind --tool=callgrind --dump-instr=yes`
//       run of BINARY, OBJECT the name callgrind gives BINARY and BASE what it adds to BINARY's addresses (`???` and
//       0x108000 for Buster's executables, whose symbols valgrind doesn't read; their own path and 0 for clang's and
//       tcc's), KINDS the experiment's "name<TAB>letters" lines. Each line of the output is: function, origin letter, type, dynamic count; plus
//       "#calls" lines (function, dynamic calls into it), "#check" lines (the counts that landed on no instruction,
//       functions whose tags didn't fit) and "#total" (all of BINARY's counted instructions). An instruction without
//       a tag has origin '-' (its function has no tag line, or its tags didn't fit), the padding after a function's
//       records '_'.
//
//   gap table T1.tsv... -- CLANG.tsv...
//       Sums each side's TSVs and prints the tables by cause, type, origin and function. The instructions without a
//       tag are "unattributed", never the node's, with their functions listed by why they have none.
//
// Only instructions in BINARY's own code count: the C library's (memcpy, strlen, ...) are other objects in the run.
#define _GNU_SOURCE
#include <ctype.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Instruction Instruction;
struct Instruction
{
    uint64_t address;
    uint32_t function;
    uint32_t ordinal;
    uint64_t count;
    uint64_t calls_in;
    char kind;
    const char* type;
    char* text;
};

typedef struct Function Function;
struct Function
{
    char* name;
    uint32_t first;
    uint32_t end;
    uint64_t calls;
};

static Instruction* instructions;
static uint32_t instruction_count;
static uint32_t instruction_capacity;
static Function* functions;
static uint32_t function_count;
static uint32_t function_capacity;

static bool starts(const char* s, const char* prefix)
{
    return strncmp(s, prefix, strlen(prefix)) == 0;
}

static bool is_register(const char* operand)
{
    return operand[0] == '%';
}

// AT&T operands split at top-level commas (not those inside parentheses).
static uint32_t split_operands(char* text, char** operands, uint32_t capacity)
{
    uint32_t count = 0;
    int depth = 0;
    char* start = text;
    for (char* p = text; ; p += 1)
    {
        if (*p == '(')
        {
            depth += 1;
        }
        else if (*p == ')')
        {
            depth -= 1;
        }
        else if ((*p == ',' && depth == 0) || *p == 0)
        {
            const bool last = *p == 0;
            *p = 0;
            while (*start == ' ')
            {
                start += 1;
            }
            if (*start != 0 && count < capacity)
            {
                operands[count++] = start;
            }
            start = p + 1;
            if (last)
            {
                break;
            }
        }
    }
    return count;
}

static bool is_memory(const char* operand)
{
    return operand[0] != '%' && operand[0] != '$' && (strchr(operand, '(') != 0 || isxdigit((unsigned char)operand[0]));
}

static bool is_stack(const char* operand)
{
    return strstr(operand, "(%rsp") != 0 || strstr(operand, "(%rbp") != 0;
}

static bool is_any(const char* mnemonic, const char* const* list)
{
    bool found = false;
    for (uint32_t i = 0; list[i] != 0 && !found; i += 1)
    {
        found = strcmp(mnemonic, list[i]) == 0;
    }
    return found;
}

// The instruction's type, from objdump's AT&T text: "mnemonic operands".
static const char* classify(const char* text)
{
    char buffer[512];
    snprintf(buffer, sizeof(buffer), "%s", text);
    char* hash = strstr(buffer, " #");
    if (hash != 0)
    {
        *hash = 0;
    }
    char* space = strpbrk(buffer, " \t");
    char* rest = space != 0 ? space + 1 : buffer + strlen(buffer);
    if (space != 0)
    {
        *space = 0;
    }
    const char* m = buffer;
    // Prefixes objdump prints as their own word.
    while ((strcmp(m, "rep") == 0 || strcmp(m, "repz") == 0 || strcmp(m, "repnz") == 0 || strcmp(m, "lock") == 0 || strcmp(m, "notrack") == 0 || strcmp(m, "bnd") == 0 || strcmp(m, "data16") == 0 || strcmp(m, "cs") == 0 || strcmp(m, "ds") == 0) && *rest != 0)
    {
        if (strcmp(m, "rep") == 0 || strcmp(m, "repz") == 0 || strcmp(m, "repnz") == 0)
        {
            return "string";
        }
        while (*rest == ' ' || *rest == '\t')
        {
            rest += 1;
        }
        m = rest;
        space = strpbrk(rest, " \t");
        rest = space != 0 ? space + 1 : rest + strlen(rest);
        if (space != 0)
        {
            *space = 0;
        }
    }
    while (*rest == ' ' || *rest == '\t')
    {
        rest += 1;
    }
    char* operands[4] = { 0 };
    const uint32_t n = split_operands(rest, operands, 4);
    bool memory = false;
    bool stack = false;
    bool memory_last = false;
    for (uint32_t i = 0; i < n; i += 1)
    {
        const bool mem = is_memory(operands[i]);
        memory |= mem;
        stack |= mem && is_stack(operands[i]);
        memory_last = mem && i + 1 == n;
    }
    const char* type = "other";
    static const char* const nops[] = { "nop", "nopw", "nopl", "endbr64", "int3", "ud2", "xchg", 0 };
    static const char* const alu[] = { "add", "sub", "and", "or", "xor", "shl", "shr", "sar", "rol", "ror", "imul", "mul", "neg", "not", "inc", "dec", "adc", "sbb", "bswap",
                                       "addl", "addq", "subl", "subq", "andl", "andq", "orl", "orq", "xorl", "xorq", "shll", "shlq", "shrl", "shrq", "sarl", "sarq", "imull",
                                       "imulq", "negl", "negq", "notl", "notq", "incl", "incq", "decl", "decq", "addb", "addw", "subb", "subw", "andb", "andw", "orb", "orw",
                                       "xorb", "xorw", "shlb", "shlw", "shrb", "shrw", "sarb", "sarw", "rolw", "rolb", "roll", "rolq", "rorl", "rorq", "rorw", "rorb", "mull", "mulq",
                                       "bt", "btl", "btq", "bts", "btr", "btsl", "btsq", "btrl", "btrq", "bsf", "bsr", "tzcnt", "lzcnt", "popcnt", "andn", "shlx", "shrx", "sarx",
                                       "rorx", "blsr", "bzhi", "imulw", "negb", "negw", "notb", "notw", "incb", "incw", "decb", "decw", "shld", "shrd", "adcl", "adcq", "sbbl", "sbbq", 0 };
    static const char* const cmp[] = { "cmp", "cmpl", "cmpq", "cmpb", "cmpw", "test", "testl", "testq", "testb", "testw", 0 };
    static const char* const div[] = { "div", "idiv", "divl", "divq", "idivl", "idivq", 0 };
    static const char* const ext[] = { "cltq", "cqto", "cltd", "cwtl", "cbtw", "cqo", "cdqe", "cdq", 0 };
    if (is_any(m, nops))
    {
        type = "nop";
    }
    else if (starts(m, "call"))
    {
        type = "call";
    }
    else if (starts(m, "ret"))
    {
        type = "ret";
    }
    else if (starts(m, "push"))
    {
        type = "push";
    }
    else if (starts(m, "pop"))
    {
        type = "pop";
    }
    else if (strcmp(m, "leave") == 0)
    {
        type = "frame";
    }
    else if (starts(m, "jmp"))
    {
        type = n == 1 && operands[0][0] == '*' ? "jmp_indirect" : "jmp";
    }
    else if (m[0] == 'j')
    {
        type = "jcc";
    }
    else if (starts(m, "set"))
    {
        type = "setcc";
    }
    else if (starts(m, "cmov"))
    {
        type = memory ? (stack ? "cmov_stack" : "cmov_load") : "cmov";
    }
    else if (is_any(m, cmp))
    {
        type = memory ? (stack ? "cmp_stack" : "cmp_load") : "cmp";
    }
    else if (is_any(m, div))
    {
        type = "div";
    }
    else if (is_any(m, ext))
    {
        type = "extend";
    }
    else if (starts(m, "lea"))
    {
        type = n >= 1 && is_stack(operands[0]) ? "lea_stack" : "lea";
    }
    else if (starts(m, "movz") || (starts(m, "movs") && !starts(m, "movsd") && !starts(m, "movss") && strcmp(m, "movsb") != 0 && strcmp(m, "movsq") != 0 && strcmp(m, "movsl") != 0))
    {
        type = memory ? (stack ? "load_stack" : "load") : "extend";
    }
    else if (strcmp(m, "mov") == 0 || strcmp(m, "movl") == 0 || strcmp(m, "movq") == 0 || strcmp(m, "movb") == 0 || strcmp(m, "movw") == 0 || strcmp(m, "movabs") == 0 ||
             strcmp(m, "movd") == 0 || starts(m, "movap") || starts(m, "movup") || starts(m, "movdq") || strcmp(m, "movsd") == 0 || strcmp(m, "movss") == 0 ||
             starts(m, "vmov") || starts(m, "kmov"))
    {
        if (!memory && n == 2 && operands[0][0] == '$')
        {
            type = "constant";
        }
        else if (!memory && n == 2 && is_register(operands[0]) && is_register(operands[1]))
        {
            type = strcmp(operands[0], operands[1]) == 0 ? "self_move" : "move";
        }
        else if (memory_last)
        {
            type = stack ? "store_stack" : "store";
        }
        else if (memory)
        {
            type = stack ? "load_stack" : "load";
        }
    }
    else if (is_any(m, alu))
    {
        const bool zero = (strcmp(m, "xor") == 0 || strcmp(m, "xorl") == 0 || strcmp(m, "xorq") == 0) && n == 2 && strcmp(operands[0], operands[1]) == 0;
        const bool frame = !memory && n == 2 && strcmp(operands[1], "%rsp") == 0;
        type = zero ? "constant" : frame ? "frame" : !memory ? "alu" : memory_last ? (stack ? "alu_rmw_stack" : "alu_rmw") : (stack ? "alu_load_stack" : "alu_load");
    }
    else if (strstr(m, "sd") != 0 || strstr(m, "ss") != 0 || starts(m, "cvt") || starts(m, "ucomi") || starts(m, "comi") || starts(m, "pxor") || starts(m, "xorp") || starts(m, "andp") || starts(m, "orp") || starts(m, "sqrt") || starts(m, "p") || starts(m, "v") || starts(m, "unpck") || starts(m, "shuf"))
    {
        type = memory ? (stack ? "fp_stack" : "fp_load") : "fp";
    }
    return type;
}

static uint32_t find_instruction(uint64_t address)
{
    uint32_t lo = 0;
    uint32_t hi = instruction_count;
    while (lo < hi)
    {
        const uint32_t mid = lo + (hi - lo) / 2;
        if (instructions[mid].address < address)
        {
            lo = mid + 1;
        }
        else
        {
            hi = mid;
        }
    }
    return lo < instruction_count && instructions[lo].address == address ? lo : UINT32_MAX;
}

static void read_disassembly(const char* path)
{
    FILE* file = fopen(path, "r");
    if (file == 0)
    {
        perror(path);
        exit(1);
    }
    char* line = 0;
    size_t size = 0;
    while (getline(&line, &size, file) > 0)
    {
        uint64_t address = 0;
        char name[4096];
        if (line[0] != ' ' && sscanf(line, "%" SCNx64 " <%4095[^>]>:", &address, name) == 2)
        {
            if (function_count == function_capacity)
            {
                function_capacity = function_capacity == 0 ? 4096 : function_capacity * 2;
                functions = realloc(functions, function_capacity * sizeof(Function));
            }
            functions[function_count] = (Function){ .name = strdup(name), .first = instruction_count, .end = instruction_count };
            function_count += 1;
        }
        else if (line[0] == ' ' && function_count != 0)
        {
            char* colon = strchr(line, ':');
            char* tab = colon != 0 ? strchr(colon, '\t') : 0;
            if (colon != 0 && tab != 0 && sscanf(line, " %" SCNx64 ":", &address) == 1)
            {
                char* text = tab + 1;
                text[strcspn(text, "\n")] = 0;
                if (instruction_count == instruction_capacity)
                {
                    instruction_capacity = instruction_capacity == 0 ? 1 << 20 : instruction_capacity * 2;
                    instructions = realloc(instructions, instruction_capacity * sizeof(Instruction));
                }
                Function* f = &functions[function_count - 1];
                instructions[instruction_count] = (Instruction){ .address = address, .function = function_count - 1, .ordinal = f->end - f->first, .kind = '-', .type = classify(text), .text = getenv("GAP_INSTRUCTIONS") != 0 ? strdup(text) : 0 };
                instruction_count += 1;
                f->end = instruction_count;
            }
        }
    }
    free(line);
    fclose(file);
}

// One compressed position field: "+n", "-n", "*", or absolute (hex with 0x, else decimal).
static uint64_t position(const char** cursor, uint64_t previous)
{
    const char* p = *cursor;
    while (*p == ' ')
    {
        p += 1;
    }
    uint64_t value = previous;
    char* end = (char*)p;
    if (*p == '+')
    {
        value = previous + strtoull(p + 1, &end, 0);
    }
    else if (*p == '-')
    {
        value = previous - strtoull(p + 1, &end, 0);
    }
    else if (*p == '*')
    {
        end = (char*)p + 1;
    }
    else
    {
        value = strtoull(p, &end, 0);
    }
    *cursor = end;
    return value;
}

// Name compression: "(id) name" defines id, "(id)" refers to it.
static const char* compressed(char* text, char** table, uint32_t capacity)
{
    const char* result = text;
    if (text[0] == '(')
    {
        char* close = strchr(text, ')');
        const uint32_t id = (uint32_t)strtoul(text + 1, 0, 10);
        if (close != 0 && id < capacity)
        {
            const char* name = close + 1;
            while (*name == ' ')
            {
                name += 1;
            }
            if (*name != 0)
            {
                free(table[id]);
                table[id] = strdup(name);
            }
            result = table[id] != 0 ? table[id] : "";
        }
    }
    return result;
}

static void read_callgrind(const char* path, const char* binary, uint64_t base, uint64_t* unmatched, uint64_t* total)
{
    FILE* file = fopen(path, "r");
    if (file == 0)
    {
        perror(path);
        exit(1);
    }
    enum { CAPACITY = 1 << 20 };
    char** objects = calloc(CAPACITY, sizeof(char*));
    char** names = calloc(CAPACITY, sizeof(char*));
    char* line = 0;
    size_t size = 0;
    uint32_t fields = 1;
    uint64_t previous[2] = { 0, 0 };
    bool ours = false;
    bool call_cost = false;
    bool callee_ours = false;
    uint64_t call_count = 0;
    while (getline(&line, &size, file) > 0)
    {
        line[strcspn(line, "\n")] = 0;
        if (starts(line, "positions:"))
        {
            fields = strstr(line, "line") != 0 ? 2 : 1;
        }
        else if (starts(line, "ob="))
        {
            const char* object = compressed(line + 3, objects, CAPACITY);
            ours = strcmp(object, binary) == 0;
            callee_ours = ours;
        }
        else if (starts(line, "cob="))
        {
            callee_ours = strcmp(compressed(line + 4, objects, CAPACITY), binary) == 0;
        }
        else if (starts(line, "fn="))
        {
            compressed(line + 3, names, CAPACITY);
            callee_ours = ours;
        }
        else if (starts(line, "cfn="))
        {
            compressed(line + 4, names, CAPACITY);
        }
        else if (starts(line, "calls="))
        {
            // calls=COUNT TARGET-POSITION: the next cost line is the call's inclusive cost, at the call's position.
            const char* p = line + 6;
            char* end = 0;
            call_count = strtoull(p, &end, 10);
            p = end;
            const uint64_t target = position(&p, previous[0]);
            if (callee_ours)
            {
                const uint32_t i = find_instruction(target - base);
                if (i != UINT32_MAX)
                {
                    instructions[i].calls_in += call_count;
                }
            }
            call_cost = true;
            callee_ours = ours;
        }
        else if (line[0] == '+' || line[0] == '-' || line[0] == '*' || isdigit((unsigned char)line[0]))
        {
            const char* p = line;
            for (uint32_t f = 0; f < fields; f += 1)
            {
                previous[f] = position(&p, previous[f]);
            }
            char* end = 0;
            const uint64_t cost = strtoull(p, &end, 10);
            if (!call_cost && ours)
            {
                const uint32_t i = find_instruction(previous[0] - base);
                if (i != UINT32_MAX)
                {
                    instructions[i].count += cost;
                }
                else
                {
                    *unmatched += cost;
                }
                *total += cost;
            }
            call_cost = false;
        }
        else if (starts(line, "jump=") || starts(line, "jcnd="))
        {
            call_cost = false;
        }
    }
    free(line);
    fclose(file);
}

static void read_kinds(const char* path)
{
    FILE* file = fopen(path, "r");
    if (file == 0)
    {
        perror(path);
        exit(1);
    }
    char* line = 0;
    size_t size = 0;
    while (getline(&line, &size, file) > 0)
    {
        line[strcspn(line, "\n")] = 0;
        char* tab = strchr(line, '\t');
        if (tab == 0)
        {
            continue;
        }
        *tab = 0;
        const char* kinds = tab + 1;
        const uint32_t length = (uint32_t)strlen(kinds);
        uint32_t fitted = 0;
        for (uint32_t f = 0; f < function_count; f += 1)
        {
            Function* function = &functions[f];
            // A function's code is its records, then the alignment's padding.
            const bool fits = strcmp(function->name, line) == 0 && function->end - function->first >= length && instructions[function->first].kind == '-';
            bool padding = true;
            for (uint32_t i = function->first + length; fits && i < function->end; i += 1)
            {
                padding &= strcmp(instructions[i].type, "nop") == 0;
            }
            if (fits && padding)
            {
                for (uint32_t i = 0; i < length; i += 1)
                {
                    instructions[function->first + i].kind = kinds[i];
                }
                for (uint32_t i = function->first + length; i < function->end; i += 1)
                {
                    instructions[i].kind = '_';
                }
                fitted += 1;
            }
        }
        if (fitted != 1)
        {
            printf("#check\tkinds\t%s\tfitted %" PRIu32 " functions\n", line, fitted);
        }
    }
    free(line);
    fclose(file);
}

// The table mode: the TSVs of `count`, Tier 1's runs then clang's, summed per side.
typedef struct Row Row;
struct Row
{
    char* function;
    char kind;
    char* type;
    uint64_t count;
};

typedef struct Side Side;
struct Side
{
    Row* rows;
    uint32_t count;
    uint32_t capacity;
    uint64_t total;
};

static const char* const causes[][2] = {
    { "move", "moves" }, { "self_move", "moves" },
    { "store_stack", "stack" }, { "load_stack", "stack" }, { "cmp_stack", "stack" }, { "alu_load_stack", "stack" }, { "alu_rmw_stack", "stack" }, { "cmov_stack", "stack" }, { "fp_stack", "stack" },
    { "load", "memory" }, { "store", "memory" }, { "cmp_load", "memory" }, { "alu_load", "memory" }, { "alu_rmw", "memory" }, { "cmov_load", "memory" }, { "fp_load", "memory" }, { "string", "memory" },
    { "lea", "address" }, { "lea_stack", "address" },
    { "extend", "extend" },
    { "cmp", "branch" }, { "jcc", "branch" }, { "jmp", "branch" }, { "jmp_indirect", "branch" }, { "setcc", "branch" }, { "cmov", "branch" },
    { "call", "call" }, { "ret", "call" }, { "push", "call" }, { "pop", "call" }, { "frame", "call" },
    { "constant", "constant" },
    { "alu", "alu" }, { "div", "alu" }, { "fp", "alu" }, { "other", "alu" }, { "nop", "alu" },
};
static const char* const cause_names[] = { "moves", "stack", "memory", "address", "extend", "branch", "call", "constant", "alu" };
static const char* const cause_titles[] = {
    "register moves", "stack loads and stores", "other loads and stores", "address arithmetic (lea)", "zero and sign extensions",
    "compares and branches", "calls, returns and frames", "constants", "arithmetic and the rest",
};
enum { CAUSES = 9 };
static const char origin_letters[] = "SLTUCReapfrjn";
static const char* const origin_names[] = { "spill", "reload", "edge spill", "edge reload", "call save", "call restore", "edge move", "call sequence", "entry", "frame", "recomputed", "branch", "node", "unattributed" };
enum { ORIGINS = 14 };

static uint32_t cause_of(const char* type)
{
    uint32_t cause = CAUSES - 1;
    for (uint32_t i = 0; i < sizeof(causes) / sizeof(causes[0]); i += 1)
    {
        if (strcmp(causes[i][0], type) == 0)
        {
            for (uint32_t c = 0; c < CAUSES; c += 1)
            {
                cause = strcmp(cause_names[c], causes[i][1]) == 0 ? c : cause;
            }
        }
    }
    return cause;
}

// A letter outside the tags ('-', '_') is the last origin, "unattributed".
static uint32_t origin_of(char kind)
{
    const char* p = strchr(origin_letters, kind);
    return kind != 0 && p != 0 ? (uint32_t)(p - origin_letters) : ORIGINS - 1;
}

// The functions whose tags didn't fit, from Tier 1's "#check kinds" lines.
static char* unfitted[256];
static uint32_t unfitted_count;

static bool is_unfitted(const char* function)
{
    bool found = false;
    for (uint32_t i = 0; i < unfitted_count; i += 1)
    {
        found |= strcmp(unfitted[i], function) == 0;
    }
    return found;
}

static void read_side(Side* side, const char* path, Side* calls)
{
    FILE* file = fopen(path, "r");
    if (file == 0)
    {
        perror(path);
        exit(1);
    }
    char* line = 0;
    size_t size = 0;
    while (getline(&line, &size, file) > 0)
    {
        line[strcspn(line, "\n")] = 0;
        char* fields[4] = { 0 };
        uint32_t n = 0;
        for (char* p = strtok(line, "\t"); p != 0 && n < 4; p = strtok(0, "\t"))
        {
            fields[n++] = p;
        }
        if (n == 4 && strcmp(fields[0], "#check") == 0 && strcmp(fields[1], "kinds") == 0 && !is_unfitted(fields[2]) && unfitted_count < 256)
        {
            unfitted[unfitted_count++] = strdup(fields[2]);
        }
        Side* target = n == 3 && strcmp(fields[0], "#calls") == 0 ? calls : n == 4 && fields[0][0] != '#' ? side : 0;
        if (target != 0)
        {
            if (target->count == target->capacity)
            {
                target->capacity = target->capacity == 0 ? 1 << 16 : target->capacity * 2;
                target->rows = realloc(target->rows, target->capacity * sizeof(Row));
            }
            const bool call = target == calls;
            target->rows[target->count++] = (Row){
                .function = strdup(fields[1 - !call]),
                .kind = call ? 0 : fields[1][0],
                .type = call ? 0 : strdup(fields[2]),
                .count = strtoull(fields[call ? 2 : 3], 0, 10),
            };
            target->total += strtoull(fields[call ? 2 : 3], 0, 10);
        }
    }
    free(line);
    fclose(file);
}

typedef struct Total Total;
struct Total
{
    char* function;
    uint64_t tier1;
    uint64_t clang;
    uint64_t tier1_calls;
    uint64_t clang_calls;
    uint64_t origins[ORIGINS];
    uint64_t causes[2][CAUSES];
};

static Total* totals;
static uint32_t total_count;
static uint32_t total_capacity;

static Total* total_of(const char* function)
{
    Total* found = 0;
    for (uint32_t i = 0; i < total_count && found == 0; i += 1)
    {
        found = strcmp(totals[i].function, function) == 0 ? &totals[i] : 0;
    }
    if (found == 0)
    {
        if (total_count == total_capacity)
        {
            total_capacity = total_capacity == 0 ? 4096 : total_capacity * 2;
            totals = realloc(totals, total_capacity * sizeof(Total));
        }
        totals[total_count] = (Total){ .function = strdup(function) };
        found = &totals[total_count++];
    }
    return found;
}

static int by_tier1(const void* a, const void* b)
{
    const Total* x = a;
    const Total* y = b;
    return x->tier1 < y->tier1 ? 1 : x->tier1 > y->tier1 ? -1 : 0;
}

static int by_inlined(const void* a, const void* b)
{
    const Total* x = a;
    const Total* y = b;
    const uint64_t u = x->tier1_calls > x->clang_calls ? x->tier1_calls - x->clang_calls : 0;
    const uint64_t v = y->tier1_calls > y->clang_calls ? y->tier1_calls - y->clang_calls : 0;
    return u < v ? 1 : u > v ? -1 : 0;
}

static int by_unattributed(const void* a, const void* b)
{
    const Total* x = a;
    const Total* y = b;
    const uint64_t u = x->origins[ORIGINS - 1];
    const uint64_t v = y->origins[ORIGINS - 1];
    return u < v ? 1 : u > v ? -1 : strcmp(x->function, y->function);
}

static double millions(uint64_t value)
{
    return (double)value / 1e6;
}

static int table(int argc, char** argv)
{
    Side sides[2] = { { 0 } };
    Side calls[2] = { { 0 } };
    uint32_t side = 0;
    for (int i = 2; i < argc; i += 1)
    {
        if (strcmp(argv[i], "--") == 0)
        {
            side = 1;
        }
        else
        {
            read_side(&sides[side], argv[i], &calls[side]);
        }
    }
    uint64_t by_cause[2][CAUSES] = { { 0 } };
    uint64_t by_origin[CAUSES][ORIGINS] = { { 0 } };
    for (uint32_t s = 0; s < 2; s += 1)
    {
        for (uint32_t r = 0; r < sides[s].count; r += 1)
        {
            const Row* row = &sides[s].rows[r];
            const uint32_t c = cause_of(row->type);
            by_cause[s][c] += row->count;
            Total* t = total_of(row->function);
            t->causes[s][c] += row->count;
            if (s == 0)
            {
                by_origin[c][origin_of(row->kind)] += row->count;
                t->tier1 += row->count;
                t->origins[origin_of(row->kind)] += row->count;
            }
            else
            {
                t->clang += row->count;
            }
        }
        for (uint32_t r = 0; r < calls[s].count; r += 1)
        {
            Total* t = total_of(calls[s].rows[r].function);
            *(s == 0 ? &t->tier1_calls : &t->clang_calls) += calls[s].rows[r].count;
        }
    }
    const double gap = (double)sides[0].total - (double)sides[1].total;
    printf("Program code (the C library's left out): Tier 1 %.1f M, clang -O2 %.1f M, gap %.1f M (%.2fx)\n\n", millions(sides[0].total), millions(sides[1].total), gap / 1e6,
           (double)sides[0].total / (double)sides[1].total);
    printf("| Cause | `--tier1`, M | clang -O2, M | Gap, M | Share of the gap | `--tier1`'s by origin, M |\n| --- | ---: | ---: | ---: | ---: | --- |\n");
    for (uint32_t c = 0; c < CAUSES; c += 1)
    {
        const double delta = (double)by_cause[0][c] - (double)by_cause[1][c];
        printf("| %s | %.1f | %.1f | %.1f | %.1f%% |", cause_titles[c], millions(by_cause[0][c]), millions(by_cause[1][c]), delta / 1e6, 100.0 * delta / gap);
        const char* separator = " ";
        for (uint32_t o = 0; o < ORIGINS; o += 1)
        {
            if (by_origin[c][o] >= 1000000)
            {
                printf("%s%s %.1f", separator, origin_names[o], millions(by_origin[c][o]));
                separator = ", ";
            }
        }
        printf(" |\n");
    }
    // The types inside each cause.
    printf("\n| Type | `--tier1`, M | clang -O2, M | Gap, M |\n| --- | ---: | ---: | ---: |\n");
    for (uint32_t i = 0; i < sizeof(causes) / sizeof(causes[0]); i += 1)
    {
        uint64_t sum[2] = { 0, 0 };
        for (uint32_t s = 0; s < 2; s += 1)
        {
            for (uint32_t r = 0; r < sides[s].count; r += 1)
            {
                sum[s] += strcmp(sides[s].rows[r].type, causes[i][0]) == 0 ? sides[s].rows[r].count : 0;
            }
        }
        if (sum[0] + sum[1] >= 1000000)
        {
            printf("| %s (%s) | %.1f | %.1f | %.1f |\n", causes[i][0], causes[i][1], millions(sum[0]), millions(sum[1]), ((double)sum[0] - (double)sum[1]) / 1e6);
        }
    }
    uint64_t origin_total[ORIGINS] = { 0 };
    for (uint32_t c = 0; c < CAUSES; c += 1)
    {
        for (uint32_t o = 0; o < ORIGINS; o += 1)
        {
            origin_total[o] += by_origin[c][o];
        }
    }
    printf("\n| `--tier1`'s origin | M | Share of `--tier1`'s instructions |\n| --- | ---: | ---: |\n");
    for (uint32_t o = 0; o < ORIGINS; o += 1)
    {
        printf("| %s | %.1f | %.1f%% |\n", origin_names[o], millions(origin_total[o]), 100.0 * (double)origin_total[o] / (double)sides[0].total);
    }
    // The unattributed instructions' functions: the PLT's stubs together, then each other function by its count.
    uint64_t plt = 0;
    uint32_t plt_count = 0;
    for (uint32_t i = 0; i < total_count; i += 1)
    {
        const bool stub = strstr(totals[i].function, "@plt") != 0 && totals[i].origins[ORIGINS - 1] != 0;
        plt += stub ? totals[i].origins[ORIGINS - 1] : 0;
        plt_count += stub;
    }
    qsort(totals, total_count, sizeof(Total), by_unattributed);
    printf("\n| `--tier1`'s unattributed instructions | Count | Why they have no tag |\n| --- | ---: | --- |\n| %" PRIu32 " PLT stubs | %" PRIu64 " | the linker's code |\n", plt_count, plt);
    for (uint32_t i = 0; i < total_count && totals[i].origins[ORIGINS - 1] != 0; i += 1)
    {
        const Total* t = &totals[i];
        if (strstr(t->function, "@plt") == 0)
        {
            printf("| `%s` | %" PRIu64 " | %s |\n", t->function, t->origins[ORIGINS - 1], is_unfitted(t->function) ? "its tags didn't fit" : "no tag line");
        }
    }
    uint64_t call_totals[2] = { calls[0].total, calls[1].total };
    printf("\nDynamic calls into the program's functions: Tier 1 %.2f M, clang -O2 %.2f M\n", millions(call_totals[0]), millions(call_totals[1]));
    qsort(totals, total_count, sizeof(Total), by_tier1);
    printf("\n| Function | `--tier1`, M | clang -O2, M | Gap, M | calls, `--tier1` / -O2 | moves | stack | memory | address | extend | branch | call | `--tier1`: spills+reloads, call saves, edge moves |\n| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |\n");
    for (uint32_t i = 0; i < total_count && i < 25; i += 1)
    {
        const Total* t = &totals[i];
        printf("| `%s` | %.1f | %.1f | %.1f | %.2f M / %.2f M |", t->function, millions(t->tier1), millions(t->clang), ((double)t->tier1 - (double)t->clang) / 1e6, millions(t->tier1_calls), millions(t->clang_calls));
        for (uint32_t c = 0; c < 7; c += 1)
        {
            printf(" %.1f |", ((double)t->causes[0][c] - (double)t->causes[1][c]) / 1e6);
        }
        printf(" %.1f, %.1f, %.1f |\n", millions(t->origins[0] + t->origins[1] + t->origins[2] + t->origins[3]), millions(t->origins[4] + t->origins[5]), millions(t->origins[6]));
    }
    qsort(totals, total_count, sizeof(Total), by_inlined);
    uint64_t inlined_calls = 0;
    uint64_t inlined_instructions = 0;
    for (uint32_t i = 0; i < total_count; i += 1)
    {
        const Total* t = &totals[i];
        if (t->tier1_calls > t->clang_calls && t->tier1_calls != 0)
        {
            inlined_calls += t->tier1_calls - t->clang_calls;
            inlined_instructions += (uint64_t)((double)t->tier1 * (double)(t->tier1_calls - t->clang_calls) / (double)t->tier1_calls);
        }
    }
    printf("\nCalls clang -O2 doesn't make (a callee's calls by Tier 1 less its calls by clang): %.2f M, whose callees' bodies run %.1f M of Tier 1's instructions\n\n",
           millions(inlined_calls), millions(inlined_instructions));
    printf("| Callee | `--tier1` calls, M | -O2 calls, M | `--tier1` instructions, M | per call | frame + call saves + entry, M |\n| --- | ---: | ---: | ---: | ---: | ---: |\n");
    for (uint32_t i = 0; i < total_count && i < 15; i += 1)
    {
        const Total* t = &totals[i];
        printf("| `%s` | %.2f | %.2f | %.1f | %.1f | %.1f |\n", t->function, millions(t->tier1_calls), millions(t->clang_calls), millions(t->tier1), t->tier1_calls != 0 ? (double)t->tier1 / (double)t->tier1_calls : 0.0,
               millions(t->origins[9] + t->origins[8]));
    }
    return 0;
}

int main(int argc, char** argv)
{
    if (argc >= 2 && strcmp(argv[1], "table") == 0)
    {
        return table(argc, argv);
    }
    if (argc < 6 || strcmp(argv[1], "count") != 0)
    {
        fprintf(stderr, "usage: gap count DISASSEMBLY CALLGRIND OBJECT BASE [KINDS]\n       gap table T1.tsv... -- CLANG.tsv...\n");
        return 2;
    }
    read_disassembly(argv[2]);
    uint64_t unmatched = 0;
    uint64_t total = 0;
    read_callgrind(argv[3], argv[4], strtoull(argv[5], 0, 0), &unmatched, &total);
    if (argc > 6)
    {
        read_kinds(argv[6]);
    }
    printf("#total\t%" PRIu64 "\n#check\tunmatched\t%" PRIu64 "\n", total, unmatched);
    for (uint32_t f = 0; f < function_count; f += 1)
    {
        const Function* function = &functions[f];
        uint64_t calls = function->first < function->end ? instructions[function->first].calls_in : 0;
        if (calls != 0)
        {
            printf("#calls\t%s\t%" PRIu64 "\n", function->name, calls);
        }
        // Each (kind, type) pair's count, by a small linear table: a function has few distinct pairs.
        char kinds[256];
        const char* types[256];
        uint64_t counts[256];
        uint32_t pairs = 0;
        for (uint32_t i = function->first; i < function->end; i += 1)
        {
            if (instructions[i].count == 0)
            {
                continue;
            }
            uint32_t p = 0;
            while (p < pairs && !(kinds[p] == instructions[i].kind && types[p] == instructions[i].type))
            {
                p += 1;
            }
            if (p == pairs && pairs < 256)
            {
                kinds[p] = instructions[i].kind;
                types[p] = instructions[i].type;
                counts[p] = 0;
                pairs += 1;
            }
            if (p < pairs)
            {
                counts[p] += instructions[i].count;
            }
        }
        for (uint32_t p = 0; p < pairs; p += 1)
        {
            printf("%s\t%c\t%s\t%" PRIu64 "\n", function->name, kinds[p], types[p], counts[p]);
        }
        for (uint32_t i = function->first; getenv("GAP_INSTRUCTIONS") != 0 && i < function->end; i += 1)
        {
            if (instructions[i].count != 0)
            {
                printf("#ins\t%s\t%" PRIx64 "\t%c\t%s\t%" PRIu64 "\t%s\n", function->name, instructions[i].address, instructions[i].kind, instructions[i].type, instructions[i].count, instructions[i].text);
            }
        }
    }
    return 0;
}
