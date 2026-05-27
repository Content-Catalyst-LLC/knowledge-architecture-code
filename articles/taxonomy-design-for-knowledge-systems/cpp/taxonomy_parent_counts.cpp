#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> split(const std::string& line, char delim) {
    std::vector<std::string> parts;
    std::stringstream ss(line);
    std::string item;
    while (std::getline(ss, item, delim)) parts.push_back(item);
    return parts;
}

int main() {
    std::ifstream file("../data/taxonomy_terms.csv");
    if (!file.is_open()) {
        std::cerr << "Could not open taxonomy_terms.csv\n";
        return 1;
    }

    std::string line;
    std::getline(file, line); // header
    std::map<std::string, int> child_counts;

    while (std::getline(file, line)) {
        auto fields = split(line, ',');
        if (fields.size() > 2 && !fields[2].empty()) {
            child_counts[fields[2]]++;
        }
    }

    for (const auto& kv : child_counts) {
        std::cout << kv.first << "," << kv.second << "\n";
    }
    return 0;
}
