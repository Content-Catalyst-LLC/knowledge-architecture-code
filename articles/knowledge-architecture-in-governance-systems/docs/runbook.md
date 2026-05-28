# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-governance-systems"
python3 python/governance_knowledge_architecture_audit.py
Rscript r/governance_knowledge_architecture_diagnostics.R
julia julia/governance_architecture_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-governance-systems/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-governance-systems/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-governance-systems/cpp" && c++ -std=c++17 governance_architecture_metrics.cpp -o governance_architecture_metrics && ./governance_architecture_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-governance-systems/fortran" && gfortran governance_architecture_metrics.f90 -o governance_architecture_metrics && ./governance_architecture_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-governance-systems/c" && cc governance_basic_metrics.c -o governance_basic_metrics && ./governance_basic_metrics
```
