#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 1024
#define MAX_CONCEPTS 256
#define MAX_NAME 128

typedef struct {
    char name[MAX_NAME];
    int degree;
} ConceptDegree;

int find_or_add(ConceptDegree concepts[], int *count, const char *name) {
    for (int i = 0; i < *count; i++) {
        if (strcmp(concepts[i].name, name) == 0) {
            return i;
        }
    }

    strncpy(concepts[*count].name, name, MAX_NAME - 1);
    concepts[*count].name[MAX_NAME - 1] = '\0';
    concepts[*count].degree = 0;
    (*count)++;
    return (*count) - 1;
}

int main(void) {
    FILE *file = fopen("../data/relationships.csv", "r");
    if (!file) {
        fprintf(stderr, "Could not open ../data/relationships.csv\n");
        return 1;
    }

    ConceptDegree concepts[MAX_CONCEPTS];
    int count = 0;
    char line[MAX_LINE];

    /* Skip header */
    fgets(line, sizeof(line), file);

    while (fgets(line, sizeof(line), file)) {
        char *source = strtok(line, ",");
        char *target = strtok(NULL, ",");

        if (source && target) {
            int s = find_or_add(concepts, &count, source);
            int t = find_or_add(concepts, &count, target);
            concepts[s].degree++;
            concepts[t].degree++;
        }
    }

    fclose(file);

    printf("concept,degree\n");
    for (int i = 0; i < count; i++) {
        printf("%s,%d\n", concepts[i].name, concepts[i].degree);
    }

    return 0;
}
