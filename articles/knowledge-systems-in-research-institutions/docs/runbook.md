# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-in-research-institutions"
python3 python/institutional_knowledge_system_audit.py
Rscript r/institutional_knowledge_system_diagnostics.R
julia julia/institutional_stewardship_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-in-research-institutions/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-in-research-institutions/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-in-research-institutions/cpp" && c++ -std=c++17 institutional_graph_degree.cpp -o institutional_graph_degree && ./institutional_graph_degree
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-in-research-institutions/fortran" && gfortran institutional_metrics.f90 -o institutional_metrics && ./institutional_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-in-research-institutions/c" && cc institutional_basic_metrics.c -o institutional_basic_metrics && ./institutional_basic_metrics
```
