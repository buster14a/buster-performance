# Temporary counters for the ordinary interpret-ir --print import path.
from pathlib import Path
import sys

parser = Path("src/buster/compiler/ir_parse.c")
source = parser.read_text()
start = source.index("static uint8_t ir_parse_named(")
end = source.index("// An instruction's type", start)
region = source[start:end]
counters = """
static uint64_t ir_name_tokens;
static uint64_t ir_name_checks;
__attribute__((destructor)) static void ir_name_counts(void)
{
    if (ir_name_tokens != 0)
    {
        fprintf(stderr, "IR name counts: tokens=%llu checks=%llu\\n",
                (unsigned long long)ir_name_tokens, (unsigned long long)ir_name_checks);
    }
}
"""
region = region.replace("    ir_parse_space(state);", "    ir_name_tokens += 1;\n    ir_parse_space(state);", 1)
assert sys.argv[1] == "base"
target = "        if (strlen(names[index])"
assert region.count(target) == 1
region = region.replace(target, "        ir_name_checks += 1;\n" + target)
parser.write_text(source[:start] + counters + region + source[end:])
