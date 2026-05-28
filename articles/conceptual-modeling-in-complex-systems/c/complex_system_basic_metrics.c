#include <stdio.h>

int main(void) {
    double components = 10.0;
    double relationships = 12.0;

    printf("Metadata coverage: %.3f\n", 8.0 / components);
    printf("Uncertainty context coverage: %.3f\n", 8.0 / components);
    printf("Relationship traceability: %.3f\n", 10.0 / relationships);
    printf("Feedback edge share: %.3f\n", 8.0 / relationships);
    printf("Underspecified relationship risk: %.3f\n", 1.0 / relationships);

    return 0;
}
