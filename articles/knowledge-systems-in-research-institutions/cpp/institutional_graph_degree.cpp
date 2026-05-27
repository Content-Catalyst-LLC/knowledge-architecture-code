#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::vector<std::string>> read_csv(const std::string& path) {
    std::ifstream file(path);
    std::vector<std::vector<std::string>> rows;
    std::string line;
    bool header = true;

    while (std::getline(file, line)) {
        if (header) {
            header = false;
            continue;
        }

        std::stringstream ss(line);
        std::string cell;
        std::vector<std::string> row;

        while (std::getline(ss, cell, ',')) {
            row.push_back(cell);
        }

        if (!row.empty()) rows.push_back(row);
    }

    return rows;
}

int main() {
    auto objects = read_csv("../data/research_objects.csv");
    auto relationships = read_csv("../data/object_relationships.csv");

    std::map<std::string, int> degree;

    for (const auto& row : relationships) {
        degree[row[0]]++;
        degree[row[2]]++;
    }

    int orphan_count = 0;
    int metadata_missing = 0;

    for (const auto& row : objects) {
        const std::string& object_id = row[0];
        if (degree[object_id] == 0) {
            orphan_count++;
            std::cout << "Orphan research object: " << object_id << "\n";
        }
        if (row[3] != "true") {
            metadata_missing++;
        }
    }

    std::cout << "Research objects: " << objects.size() << "\n";
    std::cout << "Relationships: " << relationships.size() << "\n";
    std::cout << "Orphan count: " << orphan_count << "\n";
    std::cout << "Metadata missing: " << metadata_missing << "\n";

    return 0;
}
