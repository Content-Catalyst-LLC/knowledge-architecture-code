# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-scientific-collaboration"
python3 python/scientific_collaboration_knowledge_system_audit.py
Rscript r/scientific_collaboration_knowledge_system_diagnostics.R
julia julia/scientific_collaboration_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-scientific-collaboration/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-scientific-collaboration/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-scientific-collaboration/cpp" && c++ -std=c++17 scientific_collaboration_metrics.cpp -o scientific_collaboration_metrics && ./scientific_collaboration_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-scientific-collaboration/fortran" && gfortran scientific_collaboration_metrics.f90 -o scientific_collaboration_metrics && ./scientific_collaboration_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-systems-and-scientific-collaboration/c" && cc scientific_collaboration_basic_metrics.c -o scientific_collaboration_basic_metrics && ./scientific_collaboration_basic_metrics
```
