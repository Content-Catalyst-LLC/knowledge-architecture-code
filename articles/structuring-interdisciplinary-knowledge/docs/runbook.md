# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/structuring-interdisciplinary-knowledge"
python3 python/interdisciplinary_knowledge_structure_audit.py
Rscript r/interdisciplinary_knowledge_structure_diagnostics.R
julia julia/interdisciplinary_structure_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/structuring-interdisciplinary-knowledge/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/structuring-interdisciplinary-knowledge/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/structuring-interdisciplinary-knowledge/cpp" && c++ -std=c++17 interdisciplinary_metrics.cpp -o interdisciplinary_metrics && ./interdisciplinary_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/structuring-interdisciplinary-knowledge/fortran" && gfortran interdisciplinary_metrics.f90 -o interdisciplinary_metrics && ./interdisciplinary_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/structuring-interdisciplinary-knowledge/c" && cc interdisciplinary_basic_metrics.c -o interdisciplinary_basic_metrics && ./interdisciplinary_basic_metrics
```
