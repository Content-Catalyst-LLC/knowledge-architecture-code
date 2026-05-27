#include <stdio.h>

/*
 * Minimal low-level metric example for intellectual infrastructure coverage.
 * Uses the synthetic counts in this article scaffold.
 */

int main(void) {
    int objects = 11;
    int objects_with_metadata = 10;
    int objects_with_governance = 9;
    int relationships = 12;
    int relationships_with_provenance = 12;
    int repository_required = 1;
    int repository_aligned = 1;

    printf("Intellectual Infrastructure basic synthetic metrics\n");
    printf("Objects: %d\n", objects);
    printf("Relationships: %d\n", relationships);
    printf("Metadata coverage: %.3f\n", (double)objects_with_metadata / objects);
    printf("Governance coverage: %.3f\n", (double)objects_with_governance / objects);
    printf("Relationship traceability: %.3f\n", (double)relationships_with_provenance / relationships);
    printf("Repository alignment: %.3f\n", (double)repository_aligned / repository_required);

    return 0;
}
