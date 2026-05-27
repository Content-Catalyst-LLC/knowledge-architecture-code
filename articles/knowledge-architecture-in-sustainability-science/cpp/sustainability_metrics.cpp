#include <iostream>
#include <iomanip>

int main() {
    double objects = 10.0;
    double relationships = 11.0;

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Metadata coverage: " << 9.0 / objects << "\n";
    std::cout << "Justice context coverage: " << 6.0 / objects << "\n";
    std::cout << "Uncertainty context coverage: " << 8.0 / objects << "\n";
    std::cout << "Relationship traceability: " << 10.0 / relationships << "\n";
    std::cout << "Underspecified relationship risk: " << 1.0 / relationships << "\n";

    return 0;
}
