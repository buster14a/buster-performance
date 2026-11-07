// lsq FILE Y X...: ordinary least squares of column Y on columns X (1-based; column 1 is the unit's name, and a column of
// ones gives a constant), over FILE's whitespace-separated rows, printing the coefficients, each row's prediction and
// residual, and the residuals' root mean square. Rows whose name contains EXCLUDE (environment) are left out, and with
// RANGE=COLUMN:LOW:HIGH those whose COLUMN is outside [LOW, HIGH].
//
//   cc -O2 -o lsq lsq.c -lm && RANGE=9:150:2500 ./lsq phases-2.txt 10 26 14 7 27
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ROWS 512
#define K 8
#define COLUMNS 40

int main(int argc, char** argv)
{
    FILE* file = argc >= 4 && argc - 3 <= K ? fopen(argv[1], "r") : NULL;
    if (file == NULL)
    {
        fprintf(stderr, "usage: lsq FILE Y X... (at most %d)\n", K);
        return 1;
    }
    const int y_column = atoi(argv[2]);
    const int k = argc - 3;
    int x_columns[K];
    for (int i = 0; i < k; i += 1)
    {
        x_columns[i] = atoi(argv[3 + i]);
    }
    const char* exclude = getenv("EXCLUDE");
    int range_column = 0;
    double low = 0, high = 0;
    const int ranged = getenv("RANGE") != NULL && sscanf(getenv("RANGE"), "%d:%lf:%lf", &range_column, &low, &high) == 3;
    static char names[ROWS][96];
    static double x[ROWS][K], y[ROWS];
    int n = 0;
    char line[4096];
    while (n < ROWS && fgets(line, sizeof line, file) != NULL)
    {
        double values[COLUMNS + 1] = { 0 };
        char* save = NULL;
        char* token = strtok_r(line, " \t\n", &save);
        if (token == NULL)
        {
            continue;
        }
        snprintf(names[n], sizeof names[n], "%s", token);
        for (int c = 2; c <= COLUMNS && (token = strtok_r(NULL, " \t\n", &save)) != NULL; c += 1)
        {
            values[c] = strtod(token, NULL);
        }
        const int kept = !(exclude != NULL && strstr(names[n], exclude) != NULL) &&
                         !(ranged && (values[range_column] < low || values[range_column] > high));
        if (kept)
        {
            y[n] = values[y_column];
            for (int i = 0; i < k; i += 1)
            {
                x[n][i] = values[x_columns[i]];
            }
            n += 1;
        }
    }
    // The normal equations, by Gauss-Jordan elimination with partial pivoting.
    double a[K][K + 1] = { { 0 } };
    for (int r = 0; r < n; r += 1)
    {
        for (int i = 0; i < k; i += 1)
        {
            for (int j = 0; j < k; j += 1)
            {
                a[i][j] += x[r][i] * x[r][j];
            }
            a[i][k] += x[r][i] * y[r];
        }
    }
    for (int i = 0; i < k; i += 1)
    {
        int p = i;
        for (int j = i + 1; j < k; j += 1)
        {
            p = fabs(a[j][i]) > fabs(a[p][i]) ? j : p;
        }
        for (int j = 0; j <= k; j += 1)
        {
            const double t = a[i][j];
            a[i][j] = a[p][j];
            a[p][j] = t;
        }
        for (int j = 0; j < k; j += 1)
        {
            if (j != i && a[i][i] != 0)
            {
                const double f = a[j][i] / a[i][i];
                for (int l = 0; l <= k; l += 1)
                {
                    a[j][l] -= f * a[i][l];
                }
            }
        }
    }
    double coefficient[K];
    printf("rows=%d coefficients:", n);
    for (int i = 0; i < k; i += 1)
    {
        coefficient[i] = a[i][i] != 0 ? a[i][k] / a[i][i] : 0;
        printf(" column%d=%.6g", x_columns[i], coefficient[i]);
    }
    printf("\n");
    double sum = 0;
    for (int r = 0; r < n; r += 1)
    {
        double p = 0;
        for (int i = 0; i < k; i += 1)
        {
            p += coefficient[i] * x[r][i];
        }
        sum += (p - y[r]) * (p - y[r]);
        printf("  %-32s observed %+9.1f predicted %+9.1f residual %+8.1f\n", names[r], y[r], p, p - y[r]);
    }
    printf("rms residual %.2f\n", n > 0 ? sqrt(sum / n) : 0);
    return 0;
}
