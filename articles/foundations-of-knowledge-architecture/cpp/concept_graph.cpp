#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> split_csv_line(const std::string& line) {
    std::vector<std::string> fields;
    std::stringstream ss(line);
    std::string field;
    while (std::getline(ss, field, ',')) {
        fields.push_back(field);
    }
    return fields;
}

int main() {
    std::ifstream file("../data/relationships.csv");
    if (!file.is_open()) {
        std::cerr << "Could not open ../data/relationships.csv\n";
        return 1;
    }

    std::map<std::string, int> degree;
    std::string line;
    bool header = true;

    while (std::getline(file, line)) {
        if (header) { header = false; continue; }
        auto fields = split_csv_line(line);
        if (fields.size() < 2) continue;
        degree[fields[0]]++;
        degree[fields[1]]++;
    }

    std::cout << "concept,degree\n";
    for (const auto& [concept, value] : degree) {
        std::cout << concept << "," << value << "\n";
    }

    return 0;
}
