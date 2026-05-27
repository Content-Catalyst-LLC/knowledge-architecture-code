#include <iostream>
#include <iomanip>

int main() {
    double objects = 10.0;
    std::cout << std::fixed << std::setprecision(3);
    std::cout << "Metadata coverage: " << 9.0 / objects << "\n";
    std::cout << "Subject coverage: " << 5.0 / objects << "\n";
    std::cout << "Rights coverage: " << 7.0 / objects << "\n";
    std::cout << "Preservation coverage: " << 6.0 / objects << "\n";
    return 0;
}
