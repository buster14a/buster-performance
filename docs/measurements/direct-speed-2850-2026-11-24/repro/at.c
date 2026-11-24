/* A character that is no C token, inside the direct path's 64-byte loop. */
int main(void)
{
    int value = 1 @ ` ;
    return value - 1;
}
/* padding so that the file is longer than the lexer's tail of 80 bytes ......................... */
