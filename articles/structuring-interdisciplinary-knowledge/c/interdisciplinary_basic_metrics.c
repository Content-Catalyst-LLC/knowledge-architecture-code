#include <stdio.h>

int main(void) {
    double concepts = 8.0;
    double crosswalks = 6.0;

    printf("Scope note coverage: %.3f\n", 7.0 / concepts);
    printf("Method context coverage: %.3f\n", 7.0 / concepts);
    printf("Relationship traceability: %.3f\n", 5.0 / crosswalks);
    printf("False equivalence risk: %.3f\n", 1.0 / crosswalks);

    return 0;
}
