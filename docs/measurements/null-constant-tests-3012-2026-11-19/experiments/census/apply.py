#!/usr/bin/env python3
# apply.py TREE: the storages' census, an experiment's counters in node_machine_put_value (never merged): how often T's
# writer is given a value of each constant kind with each of its three storages no zero, printed at exit as
# `XFIELDS kind=K integer=I offset=O floating=F rare=R count=N` lines on stderr.
import sys
p = sys.argv[1] + '/src/buster/compiler/c_check_node_machine_type.c'
t = open(p).read()
a = "static void node_machine_put_value(NodeMachine* machine, uint32_t r, const CheckValue* value)\n{\n"
assert t.count(a) == 1
t = t.replace(a, '''// EXPERIMENT (#3014's census): what node_machine_put_value is given, by its constant kind and by which of its storages
// are no zero.
static uint64_t node_x_fields[8][2][2][2][2];
__attribute__((destructor)) static void node_x_fields_print(void)
{
    for (uint32_t kind = 0; kind < 8; kind += 1)
    {
        for (uint32_t rare = 0; rare < 2; rare += 1)
        {
            for (uint32_t floating = 0; floating < 2; floating += 1)
            {
                for (uint32_t offset = 0; offset < 2; offset += 1)
                {
                    for (uint32_t integer = 0; integer < 2; integer += 1)
                    {
                        const uint64_t count = node_x_fields[kind][rare][floating][offset][integer];
                        if (count != 0)
                        {
                            fprintf(stderr, "XFIELDS kind=%u integer=%u offset=%u floating=%u rare=%u count=%llu\\n", kind, integer, offset, floating, rare, (unsigned long long)count);
                        }
                    }
                }
            }
        }
    }
}

''' + a)
b = "    const bool whole = !rare && node_machine_whole(kind, low, offset, floating);\n"
assert t.count(b) == 1
t = t.replace(b, "    node_x_fields[(uint32_t)kind & 7u][rare ? 1 : 0][floating ? 1 : 0][offset != 0 ? 1 : 0][low != 0 ? 1 : 0] += 1;\n" + b)
open(p, 'w').write(t)
