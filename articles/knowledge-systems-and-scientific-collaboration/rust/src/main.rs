fn main() {
    let objects = 14.0;
    let relationships = 16.0;

    println!("Scientific collaboration knowledge-system metrics");
    println!("Objects: {}", objects as i32);
    println!("Relationships: {}", relationships as i32);
    println!("Metadata coverage: {:.3}", 13.0 / objects);
    println!("Provenance coverage: {:.3}", 13.0 / objects);
    println!("Review context coverage: {:.3}", 11.0 / objects);
    println!("Relationship traceability: {:.3}", 15.0 / relationships);
    println!("Underspecified relationship risk: {:.3}", 1.0 / relationships);
}
