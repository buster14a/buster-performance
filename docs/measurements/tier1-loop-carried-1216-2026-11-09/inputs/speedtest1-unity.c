/* speedtest1 as one translation unit, for the C driver's direct path, which takes one file: SQLite's amalgamation,
   then test/speedtest1.c, whose static randomFunc would redefine sqlite3.c's static function of that name. */
#include "sqlite3.c"
#define randomFunc speedtest1_randomFunc
#include "speedtest1.c"
