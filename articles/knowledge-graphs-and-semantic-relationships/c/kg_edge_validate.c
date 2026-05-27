#include <stdio.h>

int main(void) {
    FILE *file = fopen("data/edges.csv", "r");
    if (!file) {
        fprintf(stderr, "Run from the article folder containing data/edges.csv\n");
        return 1;
    }

    int lines = 0;
    int ch;
    while ((ch = fgetc(file)) != EOF) {
        if (ch == '\n') lines++;
    }
    fclose(file);

    printf("edge_csv_lines=%d\n", lines);
    return 0;
}
