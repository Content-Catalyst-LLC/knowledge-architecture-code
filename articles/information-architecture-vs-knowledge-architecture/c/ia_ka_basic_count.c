#include <stdio.h>

/*
 * Minimal low-level metric example for IA vs KA coverage.
 * This intentionally avoids external parsing dependencies and records
 * the expected synthetic-dataset totals used in the article scaffold.
 */

int main(void) {
    int objects = 9;
    int navigation_connected = 8;
    int semantic_connected = 8;
    int metadata_context = 8;

    printf("IA/KA basic synthetic coverage\n");
    printf("Objects: %d\n", objects);
    printf("Navigation coverage: %.3f\n", (double)navigation_connected / objects);
    printf("Semantic coverage: %.3f\n", (double)semantic_connected / objects);
    printf("Metadata context coverage: %.3f\n", (double)metadata_context / objects);

    return 0;
}
