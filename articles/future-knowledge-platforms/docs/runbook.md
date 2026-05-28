# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/future-knowledge-platforms"
python3 python/future_knowledge_platform_audit.py
Rscript r/future_knowledge_platform_diagnostics.R
julia julia/future_knowledge_platform_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/future-knowledge-platforms/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/future-knowledge-platforms/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/future-knowledge-platforms/cpp" && c++ -std=c++17 future_knowledge_platform_metrics.cpp -o future_knowledge_platform_metrics && ./future_knowledge_platform_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/future-knowledge-platforms/fortran" && gfortran future_knowledge_platform_metrics.f90 -o future_knowledge_platform_metrics && ./future_knowledge_platform_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/future-knowledge-platforms/c" && cc future_knowledge_platform_basic_metrics.c -o future_knowledge_platform_basic_metrics && ./future_knowledge_platform_basic_metrics
```
