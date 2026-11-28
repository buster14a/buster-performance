# Line splices between C tokens

A counter on compiler revision `cc7d4ffb4` recorded calls to `refine_gap_is_splices` by caller, trigraph mode, result and gap length. It used an atomic increment in a shared mapping so that counts from all driver workers were included. For these six commands every call came from the vector token refiner. The table counts gaps that did or did not consist entirely of line splices.

| Input | Ordinary rejected | Ordinary accepted | Trigraphs rejected | Trigraphs accepted |
| --- | ---: | ---: | ---: | ---: |
| Lua 5.4.8 | 1 | 0 | 0 | 0 |
| SQLite amalgamation | 35 | 1 | 0 | 0 |
| musl C files | 0 | 0 | 4,124 | 0 |
| Spelling fixture | 0 | 240 | 0 | 0 |
| Fixture with trigraphs | 0 | 0 | 0 | 480 |
| Fixture with trigraphs and 64-byte windows | 0 | 0 | 0 | 480 |

SQLite accepted one two-byte splice. Most of the real calls came from musl's preprocessing jobs with trigraphs enabled, and every one of those gaps contained other input. The fixture covers ordinary backslashes, trigraphs, optional whitespace and both orders of the two-byte newline. Its accepted counts agreed between the ordinary and the 64-byte window configurations when both used trigraphs.

[Counter patch, invocations, generated input and raw count arrays](native-reach.tar.xz)
