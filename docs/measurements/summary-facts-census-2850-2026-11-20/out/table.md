| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the window takes whole; their records | 49,845; 278,892 | 10,248; 70,873 | 40,444; 204,846 | 41,890; 238,831 |
| by their control: a statement's; a condition's; a return's; an initialization's; a switch's; none | 30,180; 11,905; 3,832; 3,807; 70; 51 | 5,765; 1,537; 1,182; 1,666; 85; 13 | 14,690; 7,206; 12,206; 5,329; 115; 898 | 18,062; 8,218; 1,940; 13,625; 27; 18 |
| **the references the program's walk makes of them** | **14,506** | **4,920** | **9,396** | **13,365** |
| expressions with none; one; two; three or more | 36,878; 11,618; 1,204; 145 | 6,365; 3,044; 717; 122 | 32,311; 7,231; 750; 152 | 31,897; 7,532; 1,812; 649 |
| leaves with an object; of them with a static object or a name's symbol; of those not evaluated | 91,365; 14,638; 12,775 | 21,452; 4,961; 4,052 | 76,316; 10,254; 8,425 | 85,842; 13,559; 10,027 |
| **expressions whose references are those leaves' objects; references missing; extra** | **49,845**; 0; 0 | **10,248**; 0; 0 | **40,444**; 0; 0 | **41,890**; 0; 0 |
| the same by a name's symbol alone: missing (a string literal's object) | 1,115 | 761 | 292 | 2,545 |
| the same by the static flag alone: missing | 0 | 0 | 0 | 124 |
| calls; through a value (no declared function's name) | 12,724; 252 | 4,022; 15 | 7,943; 65 | 9,637; 9 |
| expressions with a call of a function declared noreturn | 0 | 112 | 21 | 30 |
| the root's return fact: none; a stop; an unknown; both | 49,595; 0; 250; 0 | 10,121; 112; 15; 0 | 40,362; 18; 61; 3 | 41,845; 30; 15; 0 |
| **expressions whose fact the flow's rule gives on the window's records** | **49,845** | **10,248** | **40,444** | **41,890** |
| the same by "an unknown where a call is through a value" alone | 49,845 | 10,136 | 40,422 | 41,854 |
| conditions; with a known truth; of them by a constant value; by one operand of an `&&` or an `\|\|` alone | 11,905; 53; 53; 0 | 1,537; 0; 0; 0 | 7,206; 239; 237; 2 | 8,218; 1; 1; 0 |
| roots with a constant integer value and no effect; of them with a comma | 3,028; 0 | 550; 0 | 1,643; 0 | 5,631; 0 |
| switch selectors; of them of an enumeration's type | 70; 0 | 85; 20 | 115; 3 | 27; 6 |
