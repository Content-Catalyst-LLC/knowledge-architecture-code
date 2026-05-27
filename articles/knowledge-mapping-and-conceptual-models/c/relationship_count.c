#include <stdio.h>

int main(void) {
    const int concept_count = 9;
    const int relationship_count = 9;
    double density = (double)relationship_count / (double)(concept_count * (concept_count - 1));

    printf("metric,value\n");
    printf("concept_count,%d\n", concept_count);
    printf("relationship_count,%d\n", relationship_count);
    printf("directed_density,%.4f\n", density);

    return 0;
}
