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
    auto navigation = read_csv("../data/navigation_links.csv");
    auto semantic = read_csv("../data/semantic_relationships.csv");

    std::map<std::string, int> nav_degree;
    std::map<std::string, int> semantic_degree;

    for (const auto& row : navigation) {
        nav_degree[row[0]]++;
        nav_degree[row[1]]++;
    }

    for (const auto& row : semantic) {
        semantic_degree[row[0]]++;
        semantic_degree[row[2]]++;
    }

    std::cout << "Navigation-connected objects: " << nav_degree.size() << "\n";
    std::cout << "Semantic-connected objects: " << semantic_degree.size() << "\n";

    for (const auto& item : nav_degree) {
        if (semantic_degree.find(item.first) == semantic_degree.end()) {
            std::cout << "Navigable but semantically underdeveloped: "
                      << item.first << "\n";
        }
    }

    return 0;
}
