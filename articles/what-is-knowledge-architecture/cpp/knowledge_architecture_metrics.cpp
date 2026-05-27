#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

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
        if (header) {
            header = false;
            continue;
        }

        std::stringstream ss(line);
        std::string source, target, relationship_type, evidence_note;

        std::getline(ss, source, ',');
        std::getline(ss, target, ',');
        std::getline(ss, relationship_type, ',');
        std::getline(ss, evidence_note);

        if (!source.empty()) degree[source]++;
        if (!target.empty()) degree[target]++;
    }

    std::cout << "concept,degree\n";
    for (const auto& row : degree) {
        std::cout << row.first << "," << row.second << "\n";
    }

    return 0;
}
