"""Instrument the final C window for deterministic lane-initialization mutation tests."""
import pathlib,sys
text_file=pathlib.Path(sys.argv[1])/'src/buster/compiler/c_check_node_machine_window.c'
source=text_file.read_text()
old='_Alignas(64) uint8_t far_bytes[BUSTER_NODE_CONTEXTS_FAR_ROWS][64];'
extra="""
    const char* far_check = getenv("BUSTER_QA_FAR");
    if (far_check != NULL)
    {
        memset(far_bytes, 0xa5, sizeof(far_bytes));
    }
"""
assert source.count(old)==1
source=source.replace(old,old+extra)
for direction in ('up','left'):
    old=f'for (uint64_t pending = far_{direction}; pending != 0; pending &= pending - 1)'
    assert source.count(old)==1
    source=source.replace(old,f'for (uint64_t pending = far_check != NULL && strcmp(far_check, "omit-{direction}") == 0 ? 0 : far_{direction}; pending != 0; pending &= pending - 1)')
text_file.write_text(source)
