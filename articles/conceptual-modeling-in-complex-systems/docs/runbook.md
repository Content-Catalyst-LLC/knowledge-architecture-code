# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/conceptual-modeling-in-complex-systems"
python3 python/complex_systems_conceptual_model_audit.py
Rscript r/complex_systems_conceptual_model_diagnostics.R
julia julia/complex_system_model_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/conceptual-modeling-in-complex-systems/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/conceptual-modeling-in-complex-systems/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/conceptual-modeling-in-complex-systems/cpp" && c++ -std=c++17 complex_system_model_metrics.cpp -o complex_system_model_metrics && ./complex_system_model_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/conceptual-modeling-in-complex-systems/fortran" && gfortran complex_system_model_metrics.f90 -o complex_system_model_metrics && ./complex_system_model_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/conceptual-modeling-in-complex-systems/c" && cc complex_system_basic_metrics.c -o complex_system_basic_metrics && ./complex_system_basic_metrics
```
