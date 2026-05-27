# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/information-architecture-vs-knowledge-architecture"
python3 python/ia_vs_ka_structure_audit.py
Rscript r/ia_ka_coverage_audit.R
julia julia/ia_ka_alignment_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/information-architecture-vs-knowledge-architecture/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/information-architecture-vs-knowledge-architecture/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/information-architecture-vs-knowledge-architecture/cpp" && c++ -std=c++17 ia_ka_degree_audit.cpp -o ia_ka_degree_audit && ./ia_ka_degree_audit
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/information-architecture-vs-knowledge-architecture/fortran" && gfortran ia_ka_metrics.f90 -o ia_ka_metrics && ./ia_ka_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/information-architecture-vs-knowledge-architecture/c" && cc ia_ka_basic_count.c -o ia_ka_basic_count && ./ia_ka_basic_count
```
