# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/designing-knowledge-systems-for-education"
python3 python/educational_knowledge_system_audit.py
Rscript r/educational_knowledge_system_diagnostics.R
julia julia/educational_knowledge_system_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/designing-knowledge-systems-for-education/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/designing-knowledge-systems-for-education/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/designing-knowledge-systems-for-education/cpp" && c++ -std=c++17 educational_knowledge_system_metrics.cpp -o educational_knowledge_system_metrics && ./educational_knowledge_system_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/designing-knowledge-systems-for-education/fortran" && gfortran educational_knowledge_system_metrics.f90 -o educational_knowledge_system_metrics && ./educational_knowledge_system_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/designing-knowledge-systems-for-education/c" && cc educational_basic_metrics.c -o educational_basic_metrics && ./educational_basic_metrics
```
