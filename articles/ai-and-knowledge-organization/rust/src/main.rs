fn main() {
    let objects = 14.0;
    let relationships = 15.0;

    println!("AI knowledge organization metrics");
    println!("Objects: {}", objects as i32);
    println!("Relationships: {}", relationships as i32);
    println!("Metadata coverage: {:.3}", 13.0 / objects);
    println!("Provenance coverage: {:.3}", 11.0 / objects);
    println!("Review context coverage: {:.3}", 11.0 / objects);
    println!("Relationship traceability: {:.3}", 14.0 / relationships);
    println!("Retrieval review coverage: {:.3}", 5.0 / 6.0);
    println!("Underspecified relationship risk: {:.3}", 1.0 / relationships);
}
