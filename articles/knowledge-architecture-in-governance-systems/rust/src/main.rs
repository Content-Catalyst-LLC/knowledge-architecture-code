fn main() {
    let objects = 14.0;
    let relationships = 15.0;

    println!("Governance knowledge-architecture metrics");
    println!("Objects: {}", objects as i32);
    println!("Relationships: {}", relationships as i32);
    println!("Metadata coverage: {:.3}", 13.0 / objects);
    println!("Accountability context coverage: {:.3}", 11.0 / objects);
    println!("Equity context coverage: {:.3}", 9.0 / objects);
    println!("Relationship traceability: {:.3}", 14.0 / relationships);
    println!("Underspecified relationship risk: {:.3}", 1.0 / relationships);
}
