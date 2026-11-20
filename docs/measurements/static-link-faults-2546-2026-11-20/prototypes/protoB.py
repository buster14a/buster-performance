import sys
p = '/home/user/wt-2546/src/buster/compiler/bind.c'
s = open(p).read()
old = """        const uint8_t* bytes = runtime_atom_bytes(runtime, atom);
        uint8_t* placed = bytes != 0 ? arena_push(bind->bytes, from->atoms.size[atom], (uint64_t)1 << from->atoms.alignment_log2[atom]) : 0;
        if (bytes != 0)
        {
            memcpy(placed, bytes, from->atoms.size[atom]);
        }
        atoms->bytes[atom_first + i] = placed;"""
new = """        const uint8_t* bytes = runtime_atom_bytes(runtime, atom);
        uint8_t* placed = bytes != 0 && runtime->snapshot == 0 ? arena_push(bind->bytes, from->atoms.size[atom], (uint64_t)1 << from->atoms.alignment_log2[atom]) : (uint8_t*)bytes;
        if (bytes != 0 && runtime->snapshot == 0)
        {
            memcpy(placed, bytes, from->atoms.size[atom]);
        }
        atoms->bytes[atom_first + i] = placed;"""
assert s.count(old) == 1
s = s.replace(old, new)
open(p, 'w').write(s)
p = '/home/user/wt-2546/src/buster/compiler/c_checker_driver.c'
s = open(p).read()
old = """                    .exact = BUSTER_SCALAR_PATH(scalar),
                },
            };
            // Several units' executable is written on their lanes"""
new = """                    .exact = BUSTER_SCALAR_PATH(scalar),
                    .stage = getenv("PROTO_STAGE") != NULL,
                },
            };
            // Several units' executable is written on their lanes"""
assert s.count(old) == 1
s = s.replace(old, new)
open(p, 'w').write(s)
