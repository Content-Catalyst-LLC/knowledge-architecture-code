#include <stdio.h>

int main(void) {
    double objects = 10.0;
    double relationships = 10.0;

    printf("Metadata coverage: %.3f\n", 9.0 / objects);
    printf("Equity context coverage: %.3f\n", 6.0 / objects);
    printf("Causal context coverage: %.3f\n", 6.0 / objects);
    printf("Relationship traceability: %.3f\n", 9.0 / relationships);
    printf("Underspecified relationship risk: %.3f\n", 1.0 / relationships);

    return 0;
}
