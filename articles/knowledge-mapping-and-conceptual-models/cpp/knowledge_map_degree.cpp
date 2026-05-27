#include <iostream>
#include <map>
#include <string>
#include <vector>

int main() {
    std::vector<std::pair<std::string, std::string>> edges = {
        {"knowledge_mapping", "conceptual_model"},
        {"knowledge_mapping", "taxonomy"},
        {"knowledge_mapping", "ontology"},
        {"knowledge_mapping", "knowledge_graph"},
        {"metadata", "evidence_map"},
        {"repository", "conceptual_model"},
        {"knowledge_graph", "ai_retrieval"},
        {"ontology", "knowledge_graph"},
        {"taxonomy", "metadata"}
    };

    std::map<std::string, int> degree;
    for (const auto& edge : edges) {
        degree[edge.first]++;
        degree[edge.second]++;
    }

    std::cout << "concept,degree\n";
    for (const auto& item : degree) {
        std::cout << item.first << "," << item.second << "\n";
    }

    return 0;
}
