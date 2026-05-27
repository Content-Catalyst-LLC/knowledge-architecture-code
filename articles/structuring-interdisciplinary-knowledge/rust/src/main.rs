fn main() {
    let concept_count = 8.0;
    let crosswalk_count = 6.0;
    let scope_note_coverage = 7.0 / concept_count;
    let method_context_coverage = 7.0 / concept_count;
    let relationship_traceability = 5.0 / crosswalk_count;
    let false_equivalence_risk = 1.0 / crosswalk_count;

    println!("Interdisciplinary concept count: {}", concept_count as i32);
    println!("Crosswalk count: {}", crosswalk_count as i32);
    println!("Scope note coverage: {:.3}", scope_note_coverage);
    println!("Method context coverage: {:.3}", method_context_coverage);
    println!("Relationship traceability: {:.3}", relationship_traceability);
    println!("False equivalence risk: {:.3}", false_equivalence_risk);
}
