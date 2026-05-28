#include <stdio.h>

int main(void) {
    double objects = 12.0;
    double relationships = 14.0;

    printf("Metadata coverage: %.3f\n", 11.0 / objects);
    printf("Feedback role coverage: %.3f\n", 8.0 / objects);
    printf("Relationship traceability: %.3f\n", 13.0 / relationships);
    printf("Feedback edge share: %.3f\n", 6.0 / relationships);
    printf("Underspecified relationship risk: %.3f\n", 1.0 / relationships);

    return 0;
}
