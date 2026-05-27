#include <stdio.h>

int main(void) {
    double objects = 10.0;
    printf("Metadata coverage: %.3f\n", 9.0 / objects);
    printf("Subject coverage: %.3f\n", 5.0 / objects);
    printf("Rights coverage: %.3f\n", 7.0 / objects);
    printf("Preservation coverage: %.3f\n", 6.0 / objects);
    return 0;
}
