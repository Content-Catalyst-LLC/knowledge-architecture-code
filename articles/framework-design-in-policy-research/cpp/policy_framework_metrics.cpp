#include <iostream>
#include <iomanip>

int main() {
    double objects = 10.0;
    double relationships = 10.0;

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Metadata coverage: " << 9.0 / objects << "\n";
    std::cout << "Equity context coverage: " << 6.0 / objects << "\n";
    std::cout << "Causal context coverage: " << 6.0 / objects << "\n";
    std::cout << "Relationship traceability: " << 9.0 / relationships << "\n";
    std::cout << "Underspecified relationship risk: " << 1.0 / relationships << "\n";

    return 0;
}
