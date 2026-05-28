# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-decision-making"
python3 python/decision_knowledge_system_audit.py
Rscript r/decision_knowledge_system_diagnostics.R
julia julia/decision_knowledge_system_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-decision-making/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-decision-making/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-decision-making/cpp" && c++ -std=c++17 decision_knowledge_system_metrics.cpp -o decision_knowledge_system_metrics && ./decision_knowledge_system_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-decision-making/fortran" && gfortran decision_knowledge_system_metrics.f90 -o decision_knowledge_system_metrics && ./decision_knowledge_system_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-decision-making/c" && cc decision_knowledge_basic_metrics.c -o decision_knowledge_basic_metrics && ./decision_knowledge_basic_metrics
```
