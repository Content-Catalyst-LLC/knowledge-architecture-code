# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-and-systems-thinking"
python3 python/systems_oriented_knowledge_architecture_audit.py
Rscript r/systems_oriented_knowledge_architecture_diagnostics.R
julia julia/systems_knowledge_architecture_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-and-systems-thinking/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-and-systems-thinking/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-and-systems-thinking/cpp" && c++ -std=c++17 systems_knowledge_architecture_metrics.cpp -o systems_knowledge_architecture_metrics && ./systems_knowledge_architecture_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-and-systems-thinking/fortran" && gfortran systems_knowledge_architecture_metrics.f90 -o systems_knowledge_architecture_metrics && ./systems_knowledge_architecture_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-and-systems-thinking/c" && cc systems_knowledge_basic_metrics.c -o systems_knowledge_basic_metrics && ./systems_knowledge_basic_metrics
```
