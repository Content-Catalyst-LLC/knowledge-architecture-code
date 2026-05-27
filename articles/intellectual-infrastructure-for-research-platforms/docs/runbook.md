# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/intellectual-infrastructure-for-research-platforms"
python3 python/intellectual_infrastructure_audit.py
Rscript r/intellectual_infrastructure_diagnostics.R
julia julia/infrastructure_quality_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/intellectual-infrastructure-for-research-platforms/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/intellectual-infrastructure-for-research-platforms/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/intellectual-infrastructure-for-research-platforms/cpp" && c++ -std=c++17 infrastructure_graph_degree.cpp -o infrastructure_graph_degree && ./infrastructure_graph_degree
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/intellectual-infrastructure-for-research-platforms/fortran" && gfortran infrastructure_metrics.f90 -o infrastructure_metrics && ./infrastructure_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/intellectual-infrastructure-for-research-platforms/c" && cc infrastructure_basic_metrics.c -o infrastructure_basic_metrics && ./infrastructure_basic_metrics
```
