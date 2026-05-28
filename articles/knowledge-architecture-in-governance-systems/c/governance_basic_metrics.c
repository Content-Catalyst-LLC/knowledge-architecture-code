#include <stdio.h>

int main(void) {
    double objects = 14.0;
    double relationships = 15.0;

    printf("Metadata coverage: %.3f\n", 13.0 / objects);
    printf("Accountability context coverage: %.3f\n", 11.0 / objects);
    printf("Equity context coverage: %.3f\n", 9.0 / objects);
    printf("Relationship traceability: %.3f\n", 14.0 / relationships);
    printf("Underspecified relationship risk: %.3f\n", 1.0 / relationships);

    return 0;
}
