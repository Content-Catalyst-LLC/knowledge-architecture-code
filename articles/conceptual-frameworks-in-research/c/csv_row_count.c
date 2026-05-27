#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int count_data_rows(const char *path) {
    FILE *file = fopen(path, "r");
    if (!file) {
        fprintf(stderr, "Could not open %s\n", path);
        return -1;
    }

    char buffer[4096];
    int rows = 0;
    int is_header = 1;

    while (fgets(buffer, sizeof(buffer), file)) {
        if (is_header) {
            is_header = 0;
            continue;
        }

        if (strlen(buffer) > 1) {
            rows++;
        }
    }

    fclose(file);
    return rows;
}

int main(void) {
    const char *files[] = {
        "../data/framework_concepts.csv",
        "../data/framework_relationships.csv",
        "../data/evidence_sources.csv",
        "../data/concept_evidence.csv"
    };

    size_t n = sizeof(files) / sizeof(files[0]);

    printf("Conceptual Framework CSV Row Counts\n");

    for (size_t i = 0; i < n; i++) {
        int count = count_data_rows(files[i]);
        if (count < 0) {
            return 1;
        }
        printf("%s: %d rows\n", files[i], count);
    }

    return 0;
}
