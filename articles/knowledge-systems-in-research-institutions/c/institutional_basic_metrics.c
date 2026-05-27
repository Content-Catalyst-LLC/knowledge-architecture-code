#include <stdio.h>

/*
 * Minimal low-level metric example for institutional knowledge-system coverage.
 * Uses the synthetic counts in this article scaffold.
 */

int main(void) {
    int objects = 12;
    int objects_with_metadata = 10;
    int relationships = 12;
    int relationships_with_provenance = 11;
    int governance_records = 6;
    int governance_current = 4;

    printf("Institutional Knowledge System basic synthetic metrics\n");
    printf("Objects: %d\n", objects);
    printf("Relationships: %d\n", relationships);
    printf("Metadata coverage: %.3f\n", (double)objects_with_metadata / objects);
    printf("Relationship traceability: %.3f\n", (double)relationships_with_provenance / relationships);
    printf("Governance current share: %.3f\n", (double)governance_current / governance_records);

    return 0;
}
