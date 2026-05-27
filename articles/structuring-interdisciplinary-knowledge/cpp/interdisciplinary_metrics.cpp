#include <iostream>
#include <iomanip>

int main() {
    double concepts = 8.0;
    double crosswalks = 6.0;

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Scope note coverage: " << 7.0 / concepts << "\n";
    std::cout << "Method context coverage: " << 7.0 / concepts << "\n";
    std::cout << "Relationship traceability: " << 5.0 / crosswalks << "\n";
    std::cout << "False equivalence risk: " << 1.0 / crosswalks << "\n";

    return 0;
}
