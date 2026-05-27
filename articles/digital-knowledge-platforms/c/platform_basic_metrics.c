#include <stdio.h>

/*
 * Minimal low-level metric example for digital knowledge platform coverage.
 * Uses the synthetic counts in this article scaffold.
 */

int main(void) {
    int objects = 12;
    int objects_with_metadata = 10;
    int relationships = 14;
    int relationships_with_provenance = 14;
    int repo_supported_articles = 3;
    int aligned_repositories = 3;

    printf("Digital Knowledge Platform basic synthetic metrics\n");
    printf("Objects: %d\n", objects);
    printf("Relationships: %d\n", relationships);
    printf("Metadata coverage: %.3f\n", (double)objects_with_metadata / objects);
    printf("Relationship traceability: %.3f\n", (double)relationships_with_provenance / relationships);
    printf("Repository alignment: %.3f\n", (double)aligned_repositories / repo_supported_articles);

    return 0;
}
