# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-sustainability-science"
python3 python/sustainability_knowledge_architecture_audit.py
Rscript r/sustainability_knowledge_architecture_diagnostics.R
julia julia/sustainability_architecture_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-sustainability-science/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-sustainability-science/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-sustainability-science/cpp" && c++ -std=c++17 sustainability_metrics.cpp -o sustainability_metrics && ./sustainability_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-sustainability-science/fortran" && gfortran sustainability_metrics.f90 -o sustainability_metrics && ./sustainability_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-sustainability-science/c" && cc sustainability_basic_metrics.c -o sustainability_basic_metrics && ./sustainability_basic_metrics
```
