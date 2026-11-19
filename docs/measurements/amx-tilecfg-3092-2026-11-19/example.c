/* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception */
typedef int Tile __attribute__((vector_size(1024), aligned(64)));

__attribute__((target("amx-tile")))
void zero_tile(Tile *out, unsigned short rows, unsigned short colsb)
{
    *out = __builtin_ia32_tilezero_internal(rows, colsb);
}
