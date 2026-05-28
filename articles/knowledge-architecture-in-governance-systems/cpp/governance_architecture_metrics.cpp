#include <iostream>
#include <iomanip>

int main() {
    double objects = 14.0;
    double relationships = 15.0;

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Metadata coverage: " << 13.0 / objects << "\n";
    std::cout << "Accountability context coverage: " << 11.0 / objects << "\n";
    std::cout << "Equity context coverage: " << 9.0 / objects << "\n";
    std::cout << "Relationship traceability: " << 14.0 / relationships << "\n";
    std::cout << "Underspecified relationship risk: " << 1.0 / relationships << "\n";

    return 0;
}
