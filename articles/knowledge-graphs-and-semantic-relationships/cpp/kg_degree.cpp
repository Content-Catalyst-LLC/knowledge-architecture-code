#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

std::vector<std::string> split(const std::string& line, char delim) {
    std::vector<std::string> out;
    std::stringstream ss(line);
    std::string item;
    while (std::getline(ss, item, delim)) out.push_back(item);
    return out;
}

int main() {
    std::ifstream file("data/edges.csv");
    if (!file) {
        std::cerr << "Run from the article folder containing data/edges.csv\n";
        return 1;
    }

    std::string line;
    std::getline(file, line); // header
    std::unordered_map<std::string, int> degree;
    int edges = 0;

    while (std::getline(file, line)) {
        auto parts = split(line, ',');
        if (parts.size() < 4) continue;
        degree[parts[1]]++;
        degree[parts[3]]++;
        edges++;
    }

    std::cout << "edges=" << edges << "\n";
    for (const auto& kv : degree) {
        std::cout << kv.first << "," << kv.second << "\n";
    }
    return 0;
}
