# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/ai-and-knowledge-organization"
python3 python/ai_knowledge_organization_audit.py
Rscript r/ai_knowledge_organization_diagnostics.R
julia julia/ai_knowledge_organization_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/ai-and-knowledge-organization/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/ai-and-knowledge-organization/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/ai-and-knowledge-organization/cpp" && c++ -std=c++17 ai_knowledge_organization_metrics.cpp -o ai_knowledge_organization_metrics && ./ai_knowledge_organization_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/ai-and-knowledge-organization/fortran" && gfortran ai_knowledge_organization_metrics.f90 -o ai_knowledge_organization_metrics && ./ai_knowledge_organization_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/ai-and-knowledge-organization/c" && cc ai_knowledge_basic_metrics.c -o ai_knowledge_basic_metrics && ./ai_knowledge_basic_metrics
```
