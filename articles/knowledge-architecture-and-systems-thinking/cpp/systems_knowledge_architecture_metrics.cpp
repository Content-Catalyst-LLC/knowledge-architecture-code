#include <iostream>
#include <iomanip>

int main() {
    double objects = 12.0;
    double relationships = 14.0;

    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Metadata coverage: " << 11.0 / objects << "\n";
    std::cout << "Feedback role coverage: " << 8.0 / objects << "\n";
    std::cout << "Relationship traceability: " << 13.0 / relationships << "\n";
    std::cout << "Feedback edge share: " << 6.0 / relationships << "\n";
    std::cout << "Underspecified relationship risk: " << 1.0 / relationships << "\n";

    return 0;
}
