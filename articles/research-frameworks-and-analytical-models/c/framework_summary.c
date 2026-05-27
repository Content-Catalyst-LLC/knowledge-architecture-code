#include <stdio.h>

int main(void) {
    int total_elements = 9;
    int documented_elements = 6;
    double coverage = (double) documented_elements / (double) total_elements;

    printf("Research framework element coverage: %.3f\n", coverage);
    return 0;
}
