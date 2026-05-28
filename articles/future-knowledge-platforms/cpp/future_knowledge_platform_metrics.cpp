#include <iostream>
#include <iomanip>

int main() {
    double objects = 14.0;
    double relationships = 14.0;

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Metadata coverage: " << 13.0 / objects << "\n";
    std::cout << "Provenance coverage: " << 12.0 / objects << "\n";
    std::cout << "Reuse context coverage: " << 11.0 / objects << "\n";
    std::cout << "Review context coverage: " << 11.0 / objects << "\n";
    std::cout << "Relationship traceability: " << 13.0 / relationships << "\n";
    std::cout << "Underspecified relationship risk: " << 1.0 / relationships << "\n";

    return 0;
}
