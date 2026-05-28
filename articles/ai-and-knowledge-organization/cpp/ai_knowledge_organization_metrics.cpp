#include <iostream>
#include <iomanip>

int main() {
    double objects = 14.0;
    double relationships = 15.0;

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Metadata coverage: " << 13.0 / objects << "\n";
    std::cout << "Provenance coverage: " << 11.0 / objects << "\n";
    std::cout << "Review context coverage: " << 11.0 / objects << "\n";
    std::cout << "Relationship traceability: " << 14.0 / relationships << "\n";
    std::cout << "Retrieval review coverage: " << 5.0 / 6.0 << "\n";
    std::cout << "Underspecified relationship risk: " << 1.0 / relationships << "\n";

    return 0;
}
