The processes the committed rows of x86_zen5_rows.c come from (Buster #181), each measure-x86-zen5 on the Ryzen 7
9700X, CPU 2, under the host's lock, 7 passes of 10,000 iterations, built BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
by clang 23.1.1. Each printed the whole rows file after "# table", the rows it measured and the others as they were.

table-849.log
    --table: the 849 rows of the first commit (e9c2e280). Its tree was the branch's working tree before that commit,
    whose patch wasn't kept; logs-e9c2e280/ is that commit's own campaign (802 of 849 rows the same in a fresh
    --table process).
    SHA-256 111a2255c3b71026865effbf7b8d8bafde8e904d148398d3fb3c2680fd5f8f23

table-masked.log
    --missing --table: the 44 masked rows (MASKED, and VMOVDQU32_ZM512_Z's MASKED_MEMORY) of 4a2039b1.
    Tree: main with source-masked.patch (SHA-256 6364c27e090cbd6b7ea4ad5263770809d9cd093c819ff206d02548cff643626c).
    SHA-256 f987985f426c00cf9044591436e50ce89f2da039dcce9fc38e28437abc4a2ef6

table-families.log
    --missing --table: the 455 rows of the families (every width and operand kind of the integer ALU operations, the
    tests, the unary operations, the shifts, the moves and extensions and imul; the broadcasts, vpmovm2*, vpternlog
    and vpxor widths Tier 0's vector code emits).
    Tree: main 1c966613 with source-families.patch, a diff against 872cb8fe whose files 1c966613 doesn't change
    (SHA-256 09c44e1cb15c0f31751964fe09a47ae978a82a21a4eecef68c3f22c66306a8c9).
    SHA-256 d1be31ffe18e38f2b49ad1536a9580f344f482abcd6da0f0835336d1deb39d2b

table-masked-load.log
    --missing --table: VMOVDQU8_Z_ZM512's MASKED_MEMORY row (a zeroing masked load).
    Tree: 4a2039b1 with source-masked-load.patch, the harness asking the effects with their opmasks
    (SHA-256 3c36c652d71658e49e120560ef14a3c76f389fc6c00cd5160f79015fba6da7e2).
    SHA-256 8f868586ef0ada332251f959851cee8a2f265db06cbbd72c25a84158c26348d2

The head's own campaign (logs/) measures every row again with the head's harness (--table) and checks every committed
row twice (--check).
