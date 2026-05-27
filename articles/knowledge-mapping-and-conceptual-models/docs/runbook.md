# Runbook

From the article folder:

```bash
python3 python/knowledge_mapping_conceptual_model.py
Rscript r/conceptual_model_coverage_diagnostics.R
julia julia/knowledge_map_matrix_diagnostics.jl
sqlite3 outputs/knowledge_mapping.db < sql/knowledge_mapping_conceptual_model_schema.sql
sqlite3 outputs/knowledge_mapping.db < sql/seed_knowledge_map.sql
```

Optional compiled examples:

```bash
cd cpp && c++ -std=c++17 knowledge_map_degree.cpp -o knowledge_map_degree && ./knowledge_map_degree
cd ../c && cc relationship_count.c -o relationship_count && ./relationship_count
cd ../fortran && gfortran knowledge_map_density.f90 -o knowledge_map_density && ./knowledge_map_density
cd ../go && go run map_integrity_check.go
cd ../rust && cargo run
```
