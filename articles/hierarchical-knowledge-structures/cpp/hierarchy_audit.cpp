#include <iostream>
#include <map>
#include <set>
#include <string>
#include <vector>

int main() {
    std::vector<std::pair<std::string, std::string>> edges = {
        {"ka", "foundations"},
        {"ka", "semantic"},
        {"ka", "platforms"},
        {"semantic", "taxonomy"},
        {"semantic", "hierarchy"},
        {"semantic", "ontology"},
        {"semantic", "graphs"},
        {"platforms", "metadata"},
        {"platforms", "libraries"}
    };

    std::set<std::string> nodes;
    std::set<std::string> childNodes;
    std::map<std::string, int> childCounts;

    for (const auto& edge : edges) {
        nodes.insert(edge.first);
        nodes.insert(edge.second);
        childNodes.insert(edge.second);
        childCounts[edge.first]++;
    }

    int rootCount = 0;
    for (const auto& node : nodes) {
        if (childNodes.find(node) == childNodes.end()) {
            rootCount++;
        }
    }

    std::cout << "C++ hierarchy audit scaffold\n";
    std::cout << "Node count: " << nodes.size() << "\n";
    std::cout << "Root count: " << rootCount << "\n";
    std::cout << "Parent count: " << childCounts.size() << "\n";

    return 0;
}
