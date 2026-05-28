fn main() {
    let objects = 12.0;
    let relationships = 14.0;

    println!("Systems-oriented knowledge architecture metrics");
    println!("Objects: {}", objects as i32);
    println!("Relationships: {}", relationships as i32);
    println!("Metadata coverage: {:.3}", 11.0 / objects);
    println!("Feedback role coverage: {:.3}", 8.0 / objects);
    println!("Relationship traceability: {:.3}", 13.0 / relationships);
    println!("Feedback edge share: {:.3}", 6.0 / relationships);
    println!("Underspecified relationship risk: {:.3}", 1.0 / relationships);
}
