# Moving lexer lookahead classification into the next chunk

Three separately ordered rounds per series compare Buster 220f299c6 with its unmodified parent 232da75f9 on locked Ryzen 7 9700X CPU 2. Each pair uses the same frozen SQLite inputs. The [ordinary compiler](ordinary/README.md) saved a median 646,993 user instructions, and the independent [preprocess-only driver](preprocessing/README.md) saved 647,606. Each retired fewer instructions in every round. Both independent wall and total-cycle series included increases and decreases. The [complete source patch](implementation.patch) identifies the two code paths whose timing is compared.

The separate [built-in lexer kernel](kernel/README.md) decreased vectorized cycles/byte by 0.0110, instructions/byte by 0.0330 and kernel wall time by 0.0180 ms at the paired median. All seven vectorized kernel rounds improved. The scalar control retained the same retired instructions/byte.

The [correctness campaign](correctness/) matched 10,054,953 raw tokens and 58,272,230 bytes of preprocessor transcripts across 90 translation units. The 196 native driver comparisons also retained output, diagnostic and rejection behavior.
