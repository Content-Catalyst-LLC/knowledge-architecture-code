#include <iostream>
#include <iomanip>

int main() {
    double components = 10.0;
    double relationships = 12.0;

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Metadata coverage: " << 8.0 / components << "\n";
    std::cout << "Uncertainty context coverage: " << 8.0 / components << "\n";
    std::cout << "Relationship traceability: " << 10.0 / relationships << "\n";
    std::cout << "Feedback edge share: " << 8.0 / relationships << "\n";
    std::cout << "Underspecified relationship risk: " << 1.0 / relationships << "\n";

    return 0;
}
