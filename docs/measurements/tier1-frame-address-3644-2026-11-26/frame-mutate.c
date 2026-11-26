// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #3644 validation stub. The fixture passes writable arrays through
// this const-qualified declaration; altering those arrays after observation
// checks that a later return sees the call's changes.
void observe_bytes(const unsigned char* bytes, unsigned count);

void h_bytes(const unsigned char* input, unsigned count)
{
    observe_bytes(input, count);
    if (count != 0)
    {
        unsigned char* bytes = (unsigned char*)input;
        bytes[0] ^= (unsigned char)(bytes[count - 1] + 0x5au);
        bytes[count - 1] ^= 0xa5u;
    }
}
