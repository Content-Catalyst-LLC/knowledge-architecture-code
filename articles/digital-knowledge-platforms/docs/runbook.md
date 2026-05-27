# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/digital-knowledge-platforms"
python3 python/digital_knowledge_platform_audit.py
Rscript r/digital_knowledge_platform_diagnostics.R
julia julia/platform_quality_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/digital-knowledge-platforms/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/digital-knowledge-platforms/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/digital-knowledge-platforms/cpp" && c++ -std=c++17 platform_graph_degree.cpp -o platform_graph_degree && ./platform_graph_degree
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/digital-knowledge-platforms/fortran" && gfortran platform_metrics.f90 -o platform_metrics && ./platform_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/digital-knowledge-platforms/c" && cc platform_basic_metrics.c -o platform_basic_metrics && ./platform_basic_metrics
```
