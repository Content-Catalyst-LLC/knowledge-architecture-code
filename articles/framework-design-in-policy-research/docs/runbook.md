# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/framework-design-in-policy-research"
python3 python/policy_research_framework_audit.py
Rscript r/policy_research_framework_diagnostics.R
julia julia/policy_framework_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/framework-design-in-policy-research/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/framework-design-in-policy-research/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/framework-design-in-policy-research/cpp" && c++ -std=c++17 policy_framework_metrics.cpp -o policy_framework_metrics && ./policy_framework_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/framework-design-in-policy-research/fortran" && gfortran policy_framework_metrics.f90 -o policy_framework_metrics && ./policy_framework_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/framework-design-in-policy-research/c" && cc policy_framework_basic_metrics.c -o policy_framework_basic_metrics && ./policy_framework_basic_metrics
```
