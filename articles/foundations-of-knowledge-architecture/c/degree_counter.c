#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 512

int main(void) {
    FILE *file = fopen("../data/relationships.csv", "r");
    if (!file) {
        fprintf(stderr, "Could not open ../data/relationships.csv\n");
        return 1;
    }

    char line[MAX_LINE];
    int rows = 0;

    /* Skip header. */
    fgets(line, sizeof(line), file);

    while (fgets(line, sizeof(line), file)) {
        if (strlen(line) > 1) {
            rows++;
        }
    }

    fclose(file);
    printf("relationship_count,%d\n", rows);
    return 0;
}
