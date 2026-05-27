#include <stdio.h>

int main(void) {
    FILE *file = fopen("../data/taxonomy_terms.csv", "r");
    if (!file) {
        perror("taxonomy_terms.csv");
        return 1;
    }

    int ch;
    int lines = 0;
    while ((ch = fgetc(file)) != EOF) {
        if (ch == '\n') lines++;
    }
    fclose(file);

    if (lines > 0) lines -= 1; // subtract header
    printf("taxonomy_term_count=%d\n", lines);
    return 0;
}
