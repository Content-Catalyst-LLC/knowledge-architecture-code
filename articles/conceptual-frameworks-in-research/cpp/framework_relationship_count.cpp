#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> split_csv_line(const std::string& line) {
    std::vector<std::string> cells;
    std::stringstream ss(line);
    std::string cell;

    while (std::getline(ss, cell, ',')) {
        cells.push_back(cell);
    }

    return cells;
}

int main() {
    std::ifstream file("../data/framework_relationships.csv");

    if (!file) {
        std::cerr << "Could not open ../data/framework_relationships.csv\n";
        return 1;
    }

    std::string line;
    std::getline(file, line); // header

    std::map<std::string, int> counts;
    int rows = 0;

    while (std::getline(file, line)) {
        if (line.empty()) continue;
        auto cells = split_csv_line(line);
        if (cells.size() >= 3) {
            counts[cells[2]]++;
            rows++;
        }
    }

    std::cout << "Relationship rows: " << rows << "\n";
    std::cout << "Relationship types:\n";

    for (const auto& pair : counts) {
        std::cout << " - " << pair.first << ": " << pair.second << "\n";
    }

    return 0;
}
