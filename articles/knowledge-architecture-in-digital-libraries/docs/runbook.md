# Runbook

From the article folder:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-digital-libraries"
python3 python/digital_library_knowledge_architecture_audit.py
Rscript r/digital_library_knowledge_architecture_diagnostics.R
julia julia/digital_library_quality_metrics.jl
```

Optional compiled examples:

```bash
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-digital-libraries/rust" && cargo run
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-digital-libraries/go" && go run main.go
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-digital-libraries/cpp" && c++ -std=c++17 digital_library_metrics.cpp -o digital_library_metrics && ./digital_library_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-digital-libraries/fortran" && gfortran digital_library_metrics.f90 -o digital_library_metrics && ./digital_library_metrics
cd "/Users/tariqahmad/Downloads/knowledge-architecture-code/articles/knowledge-architecture-in-digital-libraries/c" && cc digital_library_basic_metrics.c -o digital_library_basic_metrics && ./digital_library_basic_metrics
```
