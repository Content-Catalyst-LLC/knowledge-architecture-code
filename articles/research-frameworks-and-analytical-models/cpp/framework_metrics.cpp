#include <fstream>
#include <iostream>
#include <string>

int main() {
    std::ifstream file("../data/model_relationships.csv");
    if (!file.is_open()) {
        std::cerr << "Could not open model_relationships.csv\n";
        return 1;
    }

    std::string line;
    int rows = -1; // subtract header
    while (std::getline(file, line)) {
        rows++;
    }

    std::cout << "Relationship records: " << rows << "\n";
    return rows >= 0 ? 0 : 1;
}
