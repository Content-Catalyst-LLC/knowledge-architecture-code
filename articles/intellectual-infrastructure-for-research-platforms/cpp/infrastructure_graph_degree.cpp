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
    auto objects = read_csv("../data/infrastructure_objects.csv");
    auto relationships = read_csv("../data/infrastructure_relationships.csv");

    std::map<std::string, int> degree;

    for (const auto& row : relationships) {
        degree[row[0]]++;
        degree[row[2]]++;
    }

    int orphan_count = 0;
    int review_needed = 0;

    for (const auto& row : objects) {
        const std::string& object_id = row[0];
        bool has_metadata = row[3] == "true";
        bool has_governance = row[4] == "true";
        bool is_orphan = degree[object_id] == 0;

        if (is_orphan) {
            orphan_count++;
            std::cout << "Orphan infrastructure object: " << object_id << "\n";
        }

        if (!has_metadata || !has_governance || is_orphan) {
            review_needed++;
        }
    }

    std::cout << "Infrastructure objects: " << objects.size() << "\n";
    std::cout << "Relationships: " << relationships.size() << "\n";
    std::cout << "Orphan count: " << orphan_count << "\n";
    std::cout << "Review needed: " << review_needed << "\n";

    return 0;
}
